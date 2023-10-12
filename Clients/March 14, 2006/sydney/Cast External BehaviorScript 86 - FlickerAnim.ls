property sImageBase, sCastLib, aMembers, iIndex, iState, iTimer, iTimeLength, iSprite, bDebug

on new me, _iSprite
  me.bDebug = 0
  me.debug("new()")
  me.iSprite = _iSprite
  me.init()
  return me
end

on beginSprite me
  me.debug("beginSprite()")
  me.iSprite = me.spriteNum
  me.init()
end

on destroy me
  put "*********** DESTROY SPRITE CYCLE **********"
end

on init me
  if voidp(me.iSprite) then
    return 
  end if
  me.sCastLib = castLib(sprite(me.iSprite).member.castLibNum).name
  me.sImageBase = me.getImageBase()
  me.aMembers = me.getMembers(me.sImageBase, me.sCastLib)
  me.iIndex = 1
  me.iState = 1
  me.iTimer = the milliSeconds
  me.iTimeLength = 5000
end

on exitFrame me
  if me.iState = 1 then
    iElapsedTime = the milliSeconds - me.iTimer
    if iElapsedTime >= random(me.iTimeLength) then
      me.nextFrame(1)
      me.iTimer = the milliSeconds
    end if
  end if
end

on startAnim me
  me.iTimer = the milliSeconds
  me.iState = 1
end

on stopAnim me
  me.iState = 0
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

on getImageBase me
  sName = sprite(me.iSprite).member.name
  iFirstChar = 1
  iLastChar = sName.length
  sImageBase = sName.char[iFirstChar..iLastChar - 1]
  return sImageBase
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "CycleAnim: " & sMessage
  end if
end
