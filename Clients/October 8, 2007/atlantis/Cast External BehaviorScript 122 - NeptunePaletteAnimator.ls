property sPaletteBase, sImageBase, iSprite, sCastLib, aMembers, aPalettes, aActivePrograms, iActiveProgramIndex, aAmbientPrograms, iAmbientProgramIndex, aCurrentPrograms, iCurrentProgramIndex, iIndex, iState, iTimer, iTimeLength, iProgramTimer, iProgramTimeLength, iProgramTimeRandomizerMax, iProgramTimeRandomizer, bDebug

on new me, _iSprite
  me.bDebug = 0
  me.debug("new() palette animator")
  me.iSprite = _iSprite
  me.init()
  return me
end

on endSprite me
  me.setFrame("000")
end

on beginSprite me
  me.debug("beginSprite() palette animator")
  me.iSprite = me.spriteNum
  me.init()
end

on init me
  if voidp(me.iSprite) then
    return 
  end if
  me.sCastLib = castLib(sprite(me.iSprite).member.castLibNum).name
  me.sPaletteBase = me.getPaletteBase()
  me.sImageBase = me.getImageBase()
  me.aPalettes = me.getMembers(me.sPaletteBase, me.sCastLib, #palette)
  me.aMembers = me.getMembers(me.sImageBase, me.sCastLib, #bitmap)
  me.aActivePrograms = me.getPrograms(#Active)
  me.aAmbientPrograms = me.getPrograms(#ambient)
  me.aCurrentPrograms = me.aAmbientPrograms
  me.iCurrentProgramIndex = 1
  me.iIndex = 0
  me.iState = 0
  me.iTimer = the milliSeconds
  me.iTimeLength = 1000
  me.iProgramTimer = the milliSeconds
  me.iProgramTimeLength = 9000
  me.iProgramTimeRandomizerMax = 1
  me.iProgramTimeRandomizer = random(me.iProgramTimeRandomizerMax)
  me.debug("finished init palette animator")
end

on setRandomProgramIndex me
  me.iIndex = 0
  me.iCurrentProgramIndex = random(me.aCurrentPrograms.count)
  me.debug("program: " & me.aCurrentPrograms[me.iCurrentProgramIndex].name)
end

on exitFrame me
  if me.iState = 1 then
  else
  end if
  iPElapsedTime = the milliSeconds - me.iProgramTimer
  if iPElapsedTime >= (me.iProgramTimeLength + me.iProgramTimeRandomizer) then
    me.iProgramTimeRandomizer = random(me.iProgramTimeRandomizerMax)
    me.iProgramTimer = the milliSeconds
    me.setRandomProgramIndex()
  end if
  iElapsedTime = the milliSeconds - me.iTimer
  if iElapsedTime >= me.aCurrentPrograms[me.iCurrentProgramIndex].rate then
    me.nextFrame(1)
    me.iTimer = the milliSeconds
  end if
end

on setFrame me, sFrameCode
  iUniversalRandom = random(me.aPalettes.count - 1) + 1
  repeat with i = 1 to me.aMembers.count
    case sFrameCode.char[i] of
      "u":
        palIndex = iUniversalRandom
      "r":
        palIndex = random(me.aPalettes.count)
      "s":
        palIndex = random(me.aPalettes.count - 1) + 1
      otherwise:
        palIndex = value(sFrameCode.char[i]) + 1
    end case
    sMember = me.aPalettes[palIndex]
    member(me.aMembers[i]).paletteRef = member(sMember, me.sCastLib)
  end repeat
end

on destroy me
  put "*********** DESTROY SPRITE PALETTE ANIMATRIX **********"
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "London Lights: " & sMessage
  end if
end

on getPaletteBase me
  sName = sprite(me.iSprite).member.paletteRef.name
  iFirstChar = 1
  iLastChar = sName.length
  sPaletteBase = sName.char[iFirstChar..iLastChar - 1]
  return sPaletteBase
end

on getImageBase me
  sName = sprite(me.iSprite).member.name
  iFirstChar = 1
  iLastChar = sName.length
  sNameBase = sName.char[iFirstChar..iLastChar - 1]
  return sNameBase
end

on startPerformance me
  me.iTimer = the milliSeconds
  me.iState = 1
  me.iProgramTimer = the milliSeconds
  me.aCurrentPrograms = me.aActivePrograms
  me.iProgramTimeLength = 3000
  me.iProgramTimeRandomizerMax = 3000
  me.iProgramTimeRandomizer = random(me.iProgramTimeRandomizerMax)
  me.setRandomProgramIndex()
end

on stopPerformance me
  me.iState = 0
  me.setFrame("000")
  me.aCurrentPrograms = me.aAmbientPrograms
  me.iProgramTimer = the milliSeconds
  me.iProgramTimeLength = 7000
  me.iProgramTimeRandomizerMax = 1
  me.iProgramTimeRandomizer = random(me.iProgramTimeRandomizerMax)
  me.setRandomProgramIndex()
end

on nextFrame me, iDir
  iNextIndex = me.iIndex + iDir
  if iNextIndex > me.aCurrentPrograms[me.iCurrentProgramIndex].sequence.count then
    iNextIndex = 1
  end if
  if iNextIndex < 1 then
    iNextIndex = me.aCurrentPrograms[me.iCurrentProgramIndex].sequence.count
  end if
  me.iIndex = iNextIndex
  me.setFrame(me.aCurrentPrograms[me.iCurrentProgramIndex].sequence[me.iIndex])
end

on getMembers me, _sImageBase, _sCastLib, memberType
  _aMembers = []
  iLength = the number of castMembers of castLib _sCastLib
  repeat with i = 1 to iLength
    oMember = member(i, _sCastLib)
    sType = oMember.type
    if sType = memberType then
      sName = oMember.name
      if sName contains _sImageBase then
        _aMembers.add(sName)
      end if
    end if
  end repeat
  return _aMembers
end

on getPrograms me, whichSet
  thePrograms = []
  if whichSet = #Active then
    thePrograms.add([#name: "independent_random", #rate: 200, #sequence: ["rrr"]])
    thePrograms.add([#name: "sync_blink", #rate: 500, #sequence: ["uuu", "000"]])
    thePrograms.add([#name: "blinky_123", #rate: 250, #sequence: ["u00", "000", "uu0", "000", "uuu", "000", "0uu", "000", "00u", "000"]])
    thePrograms.add([#name: "outer_inner", #rate: 500, #sequence: ["u0u", "0u0"]])
    thePrograms.add([#name: "crazy_train", #rate: 100, #sequence: ["u00", "0u0", "00u", "0u0"]])
    thePrograms.add([#name: "loco_strobo", #rate: 100, #sequence: ["100", "010", "001", "100", "010", "001", "100", "010", "010", "001"]])
  else
    if whichSet = #ambient then
      thePrograms.add([#name: "blanko", #rate: 2000, #sequence: ["000", "111", "000", "000"]])
      thePrograms.add([#name: "slow_train", #rate: 2000, #sequence: ["100", "010", "001", "010"]])
    end if
  end if
  return thePrograms
end
