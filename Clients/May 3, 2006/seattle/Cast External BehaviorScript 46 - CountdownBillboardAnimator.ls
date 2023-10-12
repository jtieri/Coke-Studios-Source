property sImageName, rImageRect, iSprite, sCastLib, aMembers, iIndex, iPrevIndex, iState, iTimer, iTimeLength, iWaitTimer, iWaitTimeLength, iWaitRandomTimeMax, iWaitRandomTimeLength, iSwitchIndex, iSwitchSteps, aInkBlendBgTrans, aInkBgTrans, iWhiteScreen, iBlankScreen, bDebug

on new me, _iSprite
  me.bDebug = 1
  me.debug("new() billboard animator")
  me.iSprite = _iSprite
  me.init()
  return me
end

on beginSprite me
  me.debug("beginSprite() billboard animator")
  me.iSprite = me.spriteNum
  me.init()
end

on endSprite me
  put "endsprite called"
  put me.sImageName & "0"
  sprite(me.iSprite).member.image.copyPixels(member(me.sImageName & "0", me.sCastLib).image, me.rImageRect, me.rImageRect)
end

on init me
  if voidp(me.iSprite) then
    return 
  end if
  me.sCastLib = castLib(sprite(me.iSprite).member.castLibNum).name
  me.sImageName = me.getImageBase()
  me.aMembers = me.getMembers(me.sImageName, me.sCastLib)
  me.iIndex = 2
  me.iPrevIndex = 1
  me.iSwitchIndex = 1
  me.iSwitchSteps = 6
  me.iState = 0
  me.iTimer = the milliSeconds
  me.iTimeLength = 100
  me.iWaitRandomTimeMax = 1
  me.iWaitRandomTimeLength = random(me.iWaitRandomTimeMax)
  me.iWaitTimer = the milliSeconds
  me.iWaitTimeLength = 2000
  me.debug("finished init billboard animator")
  me.rImageRect = sprite(me.iSprite).member.rect
  me.debug(me.rImageRect)
  me.iWhiteScreen = member(me.sImageName & "0", me.sCastLib).image.duplicate()
  me.iWhiteScreen.fill(me.rImageRect, [#color: rgb(255, 255, 255), #bgColor: rgb(255, 255, 255), #lineSize: 0, #shapeType: #rect])
  me.iBlankScreen = me.iWhiteScreen.duplicate()
  me.aInkBlendBgTrans = [#blend: 20, #ink: 36]
  me.aInkBgTrans = [#ink: 36]
  sprite(me.iSprite).member.image.copyPixels(member(me.sImageName & "0", me.sCastLib).image, me.rImageRect, me.rImageRect)
  sprite(me.iSprite).member.image.copyPixels(member("billboard_louver" & me.iSwitchIndex, me.sCastLib).image, me.rImageRect, me.rImageRect, me.aInkBlendBgTrans)
end

on exitFrame me
  iElapsedWait = the milliSeconds - me.iWaitTimer
  if iElapsedWait >= (me.iWaitTimeLength + me.iWaitRandomTimeLength) then
    me.iState = 1
  end if
  if me.iState = 1 then
    iElapsedTime = the milliSeconds - me.iTimer
    if iElapsedTime >= me.iTimeLength then
      me.switchFrame(1)
      me.iTimer = the milliSeconds
      if me.iSwitchIndex = 6 then
        me.iState = 0
        me.iWaitTimer = the milliSeconds
        me.iWaitRandomTimeLength = random(me.iWaitRandomTimeMax)
        me.nextFrame(1)
      end if
    end if
  end if
end

on destroy me
  put "*********** DESTROY SPRITE SUBWAY ANIMATRIX **********"
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "BillboardAnim: " & sMessage
  end if
end

on getImageBase me
  sName = sprite(me.iSprite).member.name
  iFirstChar = 1
  iLastChar = sName.length
  sNameBase = sName
  return sNameBase
end

on switchFrame me, iDir
  iNextIndex = me.iSwitchIndex + iDir
  if iNextIndex > me.iSwitchSteps then
    iNextIndex = 1
  end if
  if iNextIndex < 1 then
    iNextIndex = me.iSwitchSteps
  end if
  me.iSwitchIndex = iNextIndex
  sMember = me.aMembers[me.iIndex]
  sPrevMember = me.aMembers[me.iPrevIndex]
  me.iBlankScreen.copyPixels(me.iWhiteScreen, me.rImageRect, me.rImageRect)
  me.iBlankScreen.copyPixels(member("billboard_louver" & me.iSwitchIndex, me.sCastLib).image, me.rImageRect, me.rImageRect, me.aInkBgTrans)
  me.iBlankScreen.copyPixels(member(sMember, me.sCastLib).image, me.rImageRect, me.rImageRect, [#ink: 37])
  sprite(me.iSprite).member.image.copyPixels(member(sPrevMember, me.sCastLib).image, me.rImageRect, me.rImageRect)
  sprite(me.iSprite).member.image.copyPixels(me.iBlankScreen, me.rImageRect, me.rImageRect, me.aInkBgTrans)
  me.iBlankScreen.copyPixels(me.iWhiteScreen, me.rImageRect, me.rImageRect)
  if me.iSwitchIndex < me.iSwitchSteps then
    me.iBlankScreen.copyPixels(member("billboard_louver" & me.iSwitchIndex, me.sCastLib).image, me.rImageRect, me.rImageRect, me.aInkBgTrans)
    me.iBlankScreen.copyPixels(member("billboard_louver" & me.iSwitchIndex + 1, me.sCastLib).image, me.rImageRect, me.rImageRect, [#ink: 2])
  else
    me.iBlankScreen.copyPixels(member("billboard_louver1", me.sCastLib).image, me.rImageRect, me.rImageRect, me.aInkBgTrans)
  end if
  sprite(me.iSprite).member.image.copyPixels(me.iBlankScreen, me.rImageRect, me.rImageRect, me.aInkBlendBgTrans)
end

on nextFrame me, iDir
  me.iPrevIndex = me.iIndex
  iNextIndex = me.iIndex + iDir
  if iNextIndex > me.aMembers.count then
    iNextIndex = 1
  end if
  if iNextIndex < 1 then
    iNextIndex = me.aMembers.count
  end if
  me.iIndex = iNextIndex
  sMember = me.aMembers[me.iIndex]
  me.debug("setting next frame: " & me.aMembers[me.iIndex])
end

on getMembers me, _sImageBase, _sCastLib
  _aMembers = []
  iLength = the number of castMembers of castLib _sCastLib
  repeat with i = 1 to iLength
    oMember = member(i, _sCastLib)
    sType = oMember.type
    if sType = #bitmap then
      sName = oMember.name
      if (sName contains _sImageBase) and (sName <> _sImageBase) then
        _aMembers.add(sName)
      end if
    end if
  end repeat
  me.debug(_aMembers)
  return _aMembers
end
