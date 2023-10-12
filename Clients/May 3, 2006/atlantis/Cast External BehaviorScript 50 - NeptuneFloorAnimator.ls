property iSprite, sCastLib, aMembers, iIndex, iState, iTimer, iTimeLength, iPatternTimer, iPatternTimeLength, aPatternNames, aPatternMembers, iPatternIndex, bDebug

on new me, _iSprite
  me.bDebug = 0
  me.debug("new() tokyo palette animator")
  me.iSprite = _iSprite
  me.init()
  return me
end

on endSprite me
  sprite(me.spriteNum).member.paletteRef = member("neptune_discofloor_peaceful_0")
end

on beginSprite me
  me.debug("beginSprite() tokyo palette animator")
  me.iSprite = me.spriteNum
  me.init()
end

on init me
  if voidp(me.iSprite) then
    return 
  end if
  me.aPatternNames = ["neptune_discofloor_peaceful_", "neptune_discofloor_action_"]
  me.aPatternMembers = []
  me.sCastLib = castLib(sprite(me.iSprite).member.castLibNum).name
  repeat with i = 1 to me.aPatternNames.count
    me.aPatternMembers.add(me.getMembers(me.aPatternNames[i], me.sCastLib))
  end repeat
  me.iPatternIndex = 1
  me.iIndex = 1
  me.iState = 0
  me.iTimer = the milliSeconds
  me.iTimeLength = 150
  me.iPatternTimer = the milliSeconds
  me.iPatternTimeLength = 4000
  me.debug("finished init tokyo palette animator")
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
  put "*********** DESTROY SPRITE PALETTE ANIMATRIX **********"
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
  me.iPatternTimer = the milliSeconds
  me.iPatternIndex = 2
  me.iState = 1
end

on stopPerformance me
  me.iState = 0
  me.iPatternIndex = 1
  sprite(me.spriteNum).member.paletteRef = member("neptune_discofloor_peaceful_0")
end

on nextPattern me, iDir
  iNextIndex = me.iPatternIndex + iDir
  if iNextIndex > me.aPatternMembers.count then
    iNextIndex = 2
  end if
  if iNextIndex < 2 then
    iNextIndex = me.aPatternMembers.count
  end if
  me.iPatternIndex = iNextIndex
end

on nextFrame me, iDir
  iNextIndex = me.iIndex + iDir
  if iNextIndex > me.aPatternMembers[me.iPatternIndex].count then
    iNextIndex = 1
  end if
  if iNextIndex < 1 then
    iNextIndex = me.aPatternMembers[me.iPatternIndex].count
  end if
  me.iIndex = iNextIndex
  sMember = me.aPatternMembers[me.iPatternIndex][me.iIndex]
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
