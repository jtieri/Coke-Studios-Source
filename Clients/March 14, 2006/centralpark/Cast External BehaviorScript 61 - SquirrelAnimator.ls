property sImageName, rImageRect, iSprite, sCastLib, aMembers, iIndex, iState, iTimer, iTimeLength, iWaitTimer, iWaitTimeLength, iWaitRandomTimeMax, iWaitRandomTimeLength, iTrainLength, bDebug

on new me, _iSprite
  me.bDebug = 0
  me.debug("new() squirrel animator")
  me.iSprite = _iSprite
  me.init()
  return me
end

on beginSprite me
  me.debug("beginSprite() squirrel animator")
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
  me.iTrainLength = 10
  me.sCastLib = castLib(sprite(me.iSprite).member.castLibNum).name
  me.sImageName = me.getImageBase()
  me.aMembers = me.getMembers(me.sImageName, me.sCastLib)
  me.iIndex = 1
  me.iState = 0
  me.iTimer = the milliSeconds
  me.iTimeLength = 75
  me.iWaitRandomTimeMax = 10000
  me.iWaitRandomTimeLength = random(me.iWaitRandomTimeMax)
  me.iWaitTimer = the milliSeconds
  me.iWaitTimeLength = 10000
  me.debug("finished init squirrel animator")
  me.rImageRect = sprite(me.iSprite).member.rect
  sprite(me.iSprite).member.image.copyPixels(member(me.sImageName & "0", me.sCastLib).image, me.rImageRect, me.rImageRect)
end

on exitFrame me
  iElapsedWait = the milliSeconds - me.iWaitTimer
  if iElapsedWait >= (me.iWaitTimeLength + me.iWaitRandomTimeLength) then
    me.iState = 1
  end if
  if me.iState = 1 then
    iElapsedTime = the milliSeconds - me.iTimer
    if iElapsedTime >= me.iTimeLength then
      me.nextFrame(1)
      me.iTimer = the milliSeconds
      if me.iIndex = 1 then
        me.iState = 0
        me.iWaitTimer = the milliSeconds
        me.iWaitRandomTimeLength = random(me.iWaitRandomTimeMax)
      end if
    end if
  end if
end

on destroy me
  put "*********** DESTROY SPRITE squirrel ANIMATRIX **********"
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "squirrelAnim: " & sMessage
  end if
end

on getImageBase me
  sName = sprite(me.iSprite).member.name
  iFirstChar = 1
  iLastChar = sName.length
  sNameBase = sName
  return sNameBase
end

on startPerformance me
  me.iTimer = the milliSeconds
  me.iState = 1
end

on stopPerformance me
  me.iState = 0
  sprite(me.iSprite).member.image.copyPixels(member(me.sImageName & "0", me.sCastLib).image, me.rImageRect, me.rImageRect)
end

on nextFrame me, iDir
  iNextIndex = me.iIndex + iDir
  if iNextIndex > me.aMembers.count then
    iNextIndex = 1
  end if
  if iNextIndex < 1 then
    iNextIndex = me.aMembers.count
  end if
  me.iIndex = iNextIndex
  sMember = me.aMembers[me.iIndex]
  sprite(me.iSprite).member.image.copyPixels(member(sMember, me.sCastLib).image, me.rImageRect, me.rImageRect)
end

on getMembers me, _sImageBase, _sCastLib
  _aMembers = []
  iLength = the number of castMembers of castLib _sCastLib
  repeat with i = 1 to iLength
    oMember = member(i, _sCastLib)
    sType = oMember.type
    if sType = #bitmap then
      sName = oMember.name
      if sName contains _sImageBase then
        _aMembers.add(sName)
      end if
    end if
  end repeat
  _aMembers2 = []
  repeat with i = 1 to 4
    _aMembers2.add(_aMembers[i])
  end repeat
  repeat with i = 1 to me.iTrainLength + random(me.iTrainLength)
    _aMembers2.add(_aMembers[5])
    _aMembers2.add(_aMembers[6])
  end repeat
  repeat with i = 7 to 9
    _aMembers2.add(_aMembers[i])
  end repeat
  _aMembers2.add(_aMembers[2])
  me.debug("the squirrel image array: " & _aMembers2)
  return _aMembers2
end
