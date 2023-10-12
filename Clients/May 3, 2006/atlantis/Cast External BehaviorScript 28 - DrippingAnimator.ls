property sImageName, rImageRect, iSprite, sCastLib, aMembers, iIndex, iState, iTimer, iTimeLength, iWaitTimer, iWaitTimeLength, iWaitRandomTimeMax, iWaitRandomTimeLength, bDebug

on new me, _iSprite
  me.bDebug = 0
  me.debug("new() drippingcrack animator")
  me.iSprite = _iSprite
  me.init()
  return me
end

on beginSprite me
  me.debug("beginSprite() drippingcrack animator")
  me.iSprite = me.spriteNum
  me.init()
end

on endSprite me
  put "endsprite called"
  put me.sImageName
  sprite(me.iSprite).member = member(me.sImageName, me.sCastLib)
end

on init me
  if voidp(me.iSprite) then
    return 
  end if
  me.sCastLib = castLib(sprite(me.iSprite).member.castLibNum).name
  me.sImageName = me.getImageBase()
  me.aMembers = me.getMembers(me.sImageName, me.sCastLib)
  me.iIndex = 1
  me.iState = 0
  me.iTimer = the milliSeconds
  me.iTimeLength = 75
  me.iWaitRandomTimeMax = 2000
  me.iWaitRandomTimeLength = random(me.iWaitRandomTimeMax)
  me.iWaitTimer = the milliSeconds
  me.iWaitTimeLength = 1000
  me.debug("finished init drippingcrack animator")
  me.rImageRect = sprite(me.iSprite).member.rect
  sprite(me.iSprite).member = member(me.sImageName, me.sCastLib)
  me.debug("the cast members: " & me.aMembers)
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
  put "*********** DESTROY SPRITE drippingcrack ANIMATRIX **********"
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "drippingcrackAnim: " & sMessage
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
  sprite(me.iSprite).member = member(me.sImageName, me.sCastLib)
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
  sprite(me.iSprite).member = member(sMember, me.sCastLib)
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
  return _aMembers
end
