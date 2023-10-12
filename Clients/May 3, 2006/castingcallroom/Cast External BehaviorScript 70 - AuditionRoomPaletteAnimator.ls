property sPaletteBase, sImageBase, iSprite, sCastLib, aMembers, aPalettes, aActivePrograms, iActiveProgramIndex, aAmbientPrograms, iAmbientProgramIndex, aCurrentPrograms, iCurrentProgramIndex, iIndex, iState, iTimer, iTimeLength, iProgramTimer, iProgramTimeLength, iProgramTimeRandomizerMax, iProgramTimeRandomizer, bDebug

on new me, _iSprite
  me.bDebug = 0
  me.debug("new() palette animator")
  me.iSprite = _iSprite
  me.Init()
  return me
end

on endSprite me
  me.setFrame("000")
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
  me.sPaletteBase = me.getPaletteBase()
  me.sImageBase = me.getImageBase()
  me.aPalettes = me.getMembers(me.sPaletteBase, me.sCastLib, #palette)
  me.aMembers = me.getMembers(me.sImageBase, me.sCastLib, #bitmap)
  me.aActivePrograms = me.getPrograms(#Active, me.aMembers.count)
  me.aAmbientPrograms = me.getPrograms(#ambient, me.aMembers.count)
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

on getPrograms me, whichSet, memCount
  thePrograms = []
  if whichSet = #Active then
    thePrograms.add(me.getIndependentRandomProgram(memCount))
    thePrograms.add(me.getSyncBlinkProgram(memCount))
    thePrograms.add(me.getBlinky123Program(memCount))
    thePrograms.add(me.getOuterInnerProgram(memCount))
    thePrograms.add(me.getCrazyTrainProgram(memCount))
    thePrograms.add(me.getLocoStroboProgram(memCount))
  else
    if whichSet = #ambient then
      thePrograms.add(me.getBlankoProgram(memCount))
      thePrograms.add(me.getSlowTrainProgram(memCount))
    end if
  end if
  return thePrograms
end

on getIndependentRandomProgram me, memCount
  myName = "independent_random"
  myRate = 250
  mySequence = []
  newConfig = EMPTY
  repeat with i = 1 to memCount
    newConfig = newConfig & "r"
  end repeat
  mySequence = [newConfig]
  myProgram = [#name: myName, #rate: myRate, #sequence: mySequence]
  put myProgram
  return myProgram
end

on getSyncBlinkProgram me, memCount
  myName = "sync_blink"
  myRate = 500
  mySequence = []
  all_us = EMPTY
  all_0s = EMPTY
  repeat with i = 1 to memCount
    all_us = all_us & "u"
    all_0s = all_0s & "0"
  end repeat
  mySequence = [all_us, all_0s]
  myProgram = [#name: myName, #rate: myRate, #sequence: mySequence]
  put myProgram
  return myProgram
end

on getBlinky123Program me, memCount
  myName = "blinky_123"
  myRate = 250
  mySequence = []
  all_0s = EMPTY
  repeat with i = 1 to memCount
    all_0s = all_0s & "0"
  end repeat
  repeat with i = 1 to memCount
    newConfig = EMPTY
    repeat with j = 1 to memCount
      if j <= i then
        newConfig = newConfig & "u"
        next repeat
      end if
      newConfig = newConfig & "0"
    end repeat
    mySequence.add(newConfig)
    mySequence.add(all_0s)
  end repeat
  repeat with i = 2 to memCount
    newConfig = EMPTY
    repeat with j = 1 to memCount
      if j >= i then
        newConfig = newConfig & "u"
        next repeat
      end if
      newConfig = newConfig & "0"
    end repeat
    mySequence.add(newConfig)
    mySequence.add(all_0s)
  end repeat
  myProgram = [#name: myName, #rate: myRate, #sequence: mySequence]
  put myProgram
  return myProgram
end

on getOuterInnerProgram me, memCount
  myName = "outer_inner"
  myRate = 500
  mySequence = []
  theOuter = EMPTY
  theInner = EMPTY
  repeat with i = 1 to memCount
    if (i mod 2) = 1 then
      theOuter = theOuter & "u"
      theInner = theInner & "0"
      next repeat
    end if
    theOuter = theOuter & "0"
    theInner = theInner & "u"
  end repeat
  mySequence = [theOuter, theInner]
  myProgram = [#name: myName, #rate: myRate, #sequence: mySequence]
  put myProgram
  return myProgram
end

on getCrazyTrainProgram me, memCount
  myName = "crazy_train"
  myRate = 125
  mySequence = []
  repeat with i = 1 to memCount
    newConfig = EMPTY
    repeat with j = 1 to memCount
      if j = i then
        newConfig = newConfig & "u"
        next repeat
      end if
      newConfig = newConfig & "0"
    end repeat
    mySequence.add(newConfig)
  end repeat
  repeat with i = memCount - 1 down to 2
    newConfig = EMPTY
    repeat with j = 1 to memCount
      if j = i then
        newConfig = newConfig & "u"
        next repeat
      end if
      newConfig = newConfig & "0"
    end repeat
    mySequence.add(newConfig)
  end repeat
  myProgram = [#name: myName, #rate: myRate, #sequence: mySequence]
  put myProgram
  return myProgram
end

on getLocoStroboProgram me, memCount
  myName = "loco_strobo"
  myRate = 100
  mySequence = []
  repeat with i = 1 to memCount
    newConfig = EMPTY
    repeat with j = 1 to memCount
      if j = i then
        newConfig = newConfig & "1"
        next repeat
      end if
      newConfig = newConfig & "0"
    end repeat
    mySequence.add(newConfig)
  end repeat
  myProgram = [#name: myName, #rate: myRate, #sequence: mySequence]
  put myProgram
  return myProgram
end

on getBlankoProgram me, memCount
  myName = "blanko"
  myRate = 2000
  mySequence = []
  all_1s = EMPTY
  all_0s = EMPTY
  repeat with i = 1 to memCount
    all_1s = all_1s & "1"
    all_0s = all_0s & "0"
  end repeat
  mySequence = [all_0s, all_1s, all_0s, all_0s]
  myProgram = [#name: myName, #rate: myRate, #sequence: mySequence]
  put myProgram
  return myProgram
end

on getSlowTrainProgram me, memCount
  myName = "slow_train"
  myRate = 2000
  mySequence = []
  repeat with i = 1 to memCount
    newConfig = EMPTY
    repeat with j = 1 to memCount
      if j = i then
        newConfig = newConfig & "1"
        next repeat
      end if
      newConfig = newConfig & "0"
    end repeat
    mySequence.add(newConfig)
  end repeat
  myProgram = [#name: myName, #rate: myRate, #sequence: mySequence]
  put myProgram
  return myProgram
end
