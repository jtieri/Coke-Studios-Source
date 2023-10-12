property sPaletteName, iSprite, sCastLib, aMembers, iIndex, iState, iTimer, iTimeLength, bDebug

on new me, _iSprite
  me.bDebug = 0
  me.debug("new() palette animator")
  me.iSprite = _iSprite
  me.Init()
  return me
end

on beginSprite me
  me.debug("beginSprite() palette animator")
  me.iSprite = me.spriteNum
  me.Init()
end

on Init me
  if voidp(me.iSprite) then
    return 
  end if
  me.sCastLib = castLib(sprite(me.iSprite).member.castLibNum).name
  me.sPaletteName = me.getPaletteBase()
  me.aMembers = me.getMembers(me.sPaletteName, me.sCastLib)
  me.iIndex = 1
  me.iState = 0
  me.iTimer = the milliSeconds
  me.iTimeLength = 1000
  me.debug("finished init palette animator")
end

on exitFrame me
  if me.iState = 1 then
    iElapsedTime = the milliSeconds - me.iTimer
    if iElapsedTime >= me.iTimeLength then
      me.nextFrame(1)
      me.iTimer = the milliSeconds
    end if
  end if
end

on destroy me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "PaletteAnim: " & sMessage
  end if
end

on getPaletteBase me
  sName = sprite(me.iSprite).member.paletteRef.name
  iFirstChar = 1
  iLastChar = sName.length
  sPaletteBase = sName.char[iFirstChar..iLastChar - 1]
  return sPaletteBase
end

on startPerformance me
  me.iTimer = the milliSeconds
  me.iState = 1
end

on stopPerformance me
  me.iState = 0
  sprite(me.spriteNum).member.paletteRef = member(me.sPaletteName & "0")
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
  sprite(me.spriteNum).member.paletteRef = member(sMember, me.sCastLib)
end

on getMembers me, _sImageBase, _sCastLib
  _aMembers = []
  iLength = the number of castMembers of castLib _sCastLib
  repeat with i = 1 to iLength
    oMember = member(i, _sCastLib)
    sType = oMember.type
    if sType = #palette then
      sName = oMember.name
      if sName contains _sImageBase then
        _aMembers.add(sName)
      end if
    end if
  end repeat
  return _aMembers
end
