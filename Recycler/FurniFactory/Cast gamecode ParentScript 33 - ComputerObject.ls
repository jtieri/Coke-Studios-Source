property bDebug, iTimeDefaultDuration, iTime, bCountdown, iMilliseconds, oTimer, iScore, iToolScore, iFinishScoreBonus, iLifeScoreBonus, iLives, aToolList_Default, aToolList_Random, aToolList_User, sTool_Target, iToolHilite, iToolChannelOffset, aToolLocs, bInteractingWithUser, aToolList_Names, bICheated, iBgSoundChannel, bToolSubmissable
global oComputer, oDisplay, oAvatar, oTextConstants, sInputString, sAvatarString, sScreenName, sTimeString, iLatestScore, oSpriteManager

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "oComputer:" && sMessage
  end if
end

on cheatToolList me
  repeat with i = me.getCountOfToolsLeft() down to 2
    me.pickUpTool(me.aToolList_Random[i])
    me.incrementScore(10 + random(10))
    me.aToolList_Random.deleteAt(i)
  end repeat
end

on new me
  init(me)
  me.debug("new()")
  if oComputer <> VOID then
    (the actorList).deleteOne(oComputer.oTimer)
    oComputer.oTimer = VOID
    (the actorList).deleteOne(oComputer)
    oComputer = VOID
  end if
  oComputer = me
  return me
end

on init me
  me.bDebug = 0
  me.oTimer = script("ComputerTimer").new()
  me.iScore = script("hotdog").pickle.Encrypt("0")
  me.iToolScore = script("hotdog").pickle.Encrypt("1000")
  me.iFinishScoreBonus = script("hotdog").pickle.Encrypt("5000")
  me.iLifeScoreBonus = script("hotdog").pickle.Encrypt("1000")
  me.iLives = script("hotdog").pickle.Encrypt("5")
  me.aToolList_Names = oTextConstants.aToolList
  me.aToolList_Default = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  me.aToolList_Random = randomizeToolList(me)
  getComputerTool(me)
  me.iToolHilite = 61
  me.iToolChannelOffset = 50
  me.aToolLocs = []
  repeat with i = 1 to 10
    me.aToolLocs.add(sprite(me.iToolChannelOffset + i).loc)
  end repeat
  me.bInteractingWithUser = 0
  oDisplay.sendDisplay("Tool_Target", EMPTY)
  me.bToolSubmissable = 1
end

on getToolSubmissable me
  return me.bToolSubmissable
end

on setToolSubmissable me, bVal
  me.debug("setting bToolSubmissable:" && ["false", "true"][bVal + 1], 1)
  me.bToolSubmissable = bVal
end

on disableToolSubmission me
  if me.bToolSubmissable then
    me.setToolSubmissable(0)
    script("_TIMER_").new(15000, #setToolSubmissable, me, 1)
  end if
end

on getCountOfToolsLeft me
  return me.aToolList_Random.count
end

on getCountOfTools me
  return me.aToolList_Default.count
end

on getInteractingWithUser me
  return me.bInteractingWithUser
end

on setInteractingWithUser me, bValue
  me.bInteractingWithUser = bValue
end

on gameReset me
  me.debug("gameReset():iTime:" && me.iTimeDefaultDuration && "iScore:" && "0")
  me.init()
  me.bICheated = 0
  go("begin")
end

on gameBegin me
  alertString = oTextConstants.getGameBeginMessage(me.getComputerToolName())
  me.playBeepSound()
  sendAllSprites(#showAlert, alertString)
  script("_TIMER_").new(2000, #resetPositionToStart, oAvatar)
  script("_TIMER_").new(2000, #startToolCarry, me, 1)
  me.bICheated = 0
end

on gameWon me
  me.oTimer.stopTiming()
  oAvatar.destroy()
  me.deleteFromActorList()
  me.setInteractingWithUser(1)
  go("end")
  iAddLifeScoreBonus = me.getLives() * integer(script("hotdog").pickle.Decrypt(me.iLifeScoreBonus))
  iAddFinishScoreBonus = integer(script("hotdog").pickle.Decrypt(me.iFinishScoreBonus))
  iTotalBonus = iAddLifeScoreBonus + iAddFinishScoreBonus
  me.incrementScore(iTotalBonus)
  alertString = oTextConstants.getGameWonMessage(me.getLives(), iAddLifeScoreBonus, iAddFinishScoreBonus, me.getScore())
  me.playWonSound()
  sendAllSprites(#showAlert, alertString)
  oDisplay.sendDisplay("Score", integer(script("hotdog").pickle.Decrypt(me.iScore)))
  me.oTimer.destroy()
  me.oTimer = VOID
  sendAllSprites(#pauseMachine, 1)
  script("ToolReplacer").new()
  iLatestScore = script("hotdog").pickle.Encrypt(string(me.getScore()))
  oDisplay.sendDisplay("Score", script("hotdog").pickle.Decrypt(iLatestScore))
  script("_TIMER_").new(7000, #sendScore, me)
end

on gameOver me
  if oAvatar.getToolCarried() > 0 then
    me.dropOffTool(oAvatar.getToolCarried())
  end if
  oAvatar.dropTool()
  me.decrementLives(1)
  me.oTimer.stopTiming()
  me.oTimer.destroy()
  me.oTimer = VOID
  oAvatar.destroy()
  me.deleteFromActorList()
  me.setInteractingWithUser(1)
  go("end")
  alertString = oTextConstants.getGameOverMessage(me.getScore())
  me.playLoseSound()
  sendAllSprites(#showAlert, alertString)
  script("ToolReplacer").new()
  iLatestScore = script("hotdog").pickle.Encrypt(string(me.getScore()))
  oDisplay.sendDisplay("Score", script("hotdog").pickle.Decrypt(iLatestScore))
  script("_TIMER_").new(4000, #sendScore, me)
end

on sendScore me
  sendAllSprites(#show)
  script("HiScoreSubmit").new()
end

on gameTimerZeroed me
  if not me.getInteractingWithUser() then
    me.setInteractingWithUser(1)
    script("_TIMER_").new(2000, #gameHideMessage, me)
    if me.getLives() > 1 then
      oAvatar.pauseMachine(1)
      sendAllSprites(#pauseMachine, 1)
      me.decrementLives(1)
      sMessage = oTextConstants.getGameTimerZeroedMessage(oComputer.getLives())
      me.playTimeOutSound()
      sendAllSprites(#showAlert, sMessage)
      script("_TIMER_").new(3000, #callForToolAfterCollision, me)
    else
      me.gameOver()
    end if
  end if
end

on gameHideMessage me
  sendAllSprites(#hideAlert)
end

on callForTool me
  me.setInteractingWithUser(1)
  alertString = oTextConstants.getCallForToolMessage(me.getComputerToolName())
  me.playBeepSound()
  sendAllSprites(#showAlert, alertString)
  script("_TIMER_").new(2000, #startToolCarry, me, 1)
end

on callForToolAgain me
  me.setInteractingWithUser(1)
  alertString = oTextConstants.getCallForToolAgainMessage(me.getComputerToolName())
  me.playBeepSound()
  sendAllSprites(#showAlert, alertString)
  script("_TIMER_").new(2000, #startToolCarry, me, 0)
end

on callForToolAfterCollision me
  if oAvatar.getToolCarried() > 0 then
    me.dropOffTool(oAvatar.getToolCarried())
  end if
  oAvatar.dropTool()
  me.setInteractingWithUser(1)
  alertString = oTextConstants.getCallForToolAfterCollisionMessage(me.getComputerToolName())
  me.playBeepSound()
  sendAllSprites(#showAlert, alertString)
  script("_TIMER_").new(2000, #resetPositionToStart, oAvatar)
  script("_TIMER_").new(2000, #startToolCarry, me, 0)
  me.oTimer.reset()
end

on callForNewTool me
  me.setInteractingWithUser(1)
  me.oTimer.reset()
  me.getNextTool()
  if me.getComputerTool() > 0 then
    me.callForTool()
  else
    me.gameWon()
  end if
end

on startToolCarry me, bSuccess
  me.oTimer.startTiming()
  sendAllSprites(#pauseMachine, 0)
  oAvatar.pauseMachine(0)
  sendAllSprites(#hideAlert)
  me.setInteractingWithUser(0)
  oAvatar.startFlash(2000, bSuccess)
end

on setScore me, _iScore
  me.debug("setScore():" && _iScore)
  me.iScore = script("hotdog").pickle.Encrypt(string(_iScore))
end

on getScore me
  return integer(script("hotdog").pickle.Decrypt(me.iScore))
end

on incrementScore me, iValue
  me.debug("incrementScore():" && iValue)
  me.iScore = script("hotdog").pickle.Encrypt(string(integer(script("hotdog").pickle.Decrypt(me.iScore)) + iValue))
end

on setLives me, _iLives
  me.debug("setLives():" && _iLives)
  me.iLives = script("hotdog").pickle.Encrypt(string(_iLives))
end

on getLives me
  return integer(script("hotdog").pickle.Decrypt(me.iLives))
end

on decrementLives me, iValue
  me.debug("decrementLives():" && iValue)
  me.iLives = script("hotdog").pickle.Encrypt(string(integer(script("hotdog").pickle.Decrypt(me.iLives)) - iValue))
end

on randomizeToolList me
  aToolList = me.aToolList_Default.duplicate()
  aRandomToolList = []
  repeat with i = 1 to me.aToolList_Default.count
    sRandomTool = aToolList[random(aToolList.count)]
    aRandomToolList.add(sRandomTool)
    aToolList.deleteOne(sRandomTool)
  end repeat
  return aRandomToolList
end

on getNextTool me
  if me.getCountOfToolsLeft() > 1 then
    me.aToolList_Random.deleteAt(1)
    return me.aToolList_Random[1]
  else
    me.aToolList_Random = []
    return 0
  end if
end

on getComputerTool me
  if me.getCountOfToolsLeft() > 0 then
    return me.aToolList_Random[1]
  else
    return -1
  end if
end

on getComputerToolName me
  if me.getComputerTool() > 0 then
    return me.aToolList_Names[me.getComputerTool()]
  else
    return EMPTY
  end if
end

on getToolNameByIndex me, iIndex
  if iIndex > 0 then
    return me.aToolList_Names[iIndex]
  else
    return "No Tool"
  end if
end

on getToolOnTable me, iToolNum
  return (me.aToolList_Random.getPos(iToolNum) > 0) and (iToolNum <> oAvatar.getToolCarried())
end

on hiliteTool me, iToolNum
  prevLoc = sprite(me.iToolHilite).loc
  if iToolNum <> 0 then
    sprite(me.iToolHilite).loc = point(sprite(me.iToolChannelOffset + iToolNum).rect[1], sprite(me.iToolChannelOffset + iToolNum).rect[2])
    sprite(me.iToolHilite).locZ = 10000
    if prevLoc <> sprite(me.iToolHilite).loc then
      me.playHiliteSound()
    end if
  else
    sprite(me.iToolHilite).loc = point(-500, -500)
  end if
end

on pickUpTool me, iToolNum
  sprite(me.iToolHilite).loc = point(-500, -500)
  sprite(me.iToolChannelOffset + iToolNum).loc = point(-500, -500)
  me.playPickUpSound()
end

on dropOffTool me, iToolNum
  sprite(me.iToolChannelOffset + iToolNum).loc = me.aToolLocs[iToolNum]
  me.playPickUpSound()
end

on matchTool me
  me.debug("matchTool()")
  if me.bToolSubmissable then
    me.disableToolSubmission()
    oAvatar.pauseMachine(1)
    me.setInteractingWithUser(1)
    if me.getComputerTool() = oAvatar.getToolCarried() then
      me.oTimer.stopTiming()
      iToolAddScore = integer(script("hotdog").pickle.Decrypt(me.iToolScore))
      iTimeLeft = me.oTimer.getTime()
      if not me.bICheated then
        iTimeBonus = integer(iTimeLeft * 100)
      else
        iTimeBonus = integer(iTimeLeft)
      end if
      iTotal = iToolAddScore + iTimeBonus
      sound(oSpriteManager.iComputerSound).volume = 150
      sound(oSpriteManager.iComputerSound).pan = 0
      sound(oSpriteManager.iComputerSound).play(member("SONAR"))
      theMessage = oTextConstants.getMatchToolMessageTrue(me.getComputerToolName(), iToolAddScore, iTimeBonus, iTotal)
      me.incrementScore(iTotal)
      oAvatar.dropTool()
      sendAllSprites(#showAlert, theMessage)
      script("_TIMER_").new(5000, #callForNewTool, me)
      return 1
    else
      if oAvatar.getToolCarried() > 0 then
        sound(oSpriteManager.iComputerSound).volume = 180
        sound(oSpriteManager.iComputerSound).pan = 0
        sound(oSpriteManager.iComputerSound).play(member("Alarm-08"))
        theMessage = oTextConstants.getMatchToolMessageFalse(me.getToolNameByIndex(oAvatar.getToolCarried()))
        sendAllSprites(#showAlert, theMessage)
        script("_TIMER_").new(2000, #callForToolAgain, me)
        return 0
      else
        sound(oSpriteManager.iComputerSound).volume = 180
        sound(oSpriteManager.iComputerSound).pan = 0
        sound(oSpriteManager.iComputerSound).play(member("Alarm-08"))
        theMessage = oTextConstants.getMatchToolMessageEmpty()
        sendAllSprites(#showAlert, theMessage)
        script("_TIMER_").new(2000, #callForToolAgain, me)
        return 0
      end if
    end if
  else
  end if
end

on playBeepSound me
  sound(oSpriteManager.iComputerSound).volume = 255
  sound(oSpriteManager.iComputerSound).pan = 0
  sound(oSpriteManager.iComputerSound).play(member("fx000"))
end

on playWonSound me
  sound(oSpriteManager.iComputerSound).volume = 255
  sound(oSpriteManager.iComputerSound).pan = 0
  sound(oSpriteManager.iComputerSound).play(member("fanfare_pitched"))
end

on playLoseSound me
  sound(oSpriteManager.iComputerSound).volume = 255
  sound(oSpriteManager.iComputerSound).pan = 0
  sound(oSpriteManager.iComputerSound).play(member("shipwhistle2"))
end

on playTimeOutSound me
  sound(oSpriteManager.iComputerSound).volume = 255
  sound(oSpriteManager.iComputerSound).pan = 0
  sound(oSpriteManager.iComputerSound).play(member("fx002"))
end

on playPickUpSound me
  sound(oSpriteManager.iEffectSound).volume = 255
  sound(oSpriteManager.iEffectSound).pan = 0
  sound(oSpriteManager.iEffectSound).play(member("fx004"))
end

on playHiliteSound me
  sound(oSpriteManager.iComputerSound).volume = 255
  sound(oSpriteManager.iComputerSound).pan = 0
  sound(oSpriteManager.iComputerSound).play(member("Clicklibrary"))
end

on addToActorList me
  me.debug("addToActorList()")
  me.iBgSoundChannel = oSpriteManager.checkOutSound()
  sound(me.iBgSoundChannel).volume = 180
  sound(me.iBgSoundChannel).pan = 0
  sound(me.iBgSoundChannel).play(member("TRFICJAM"))
  (the actorList).add(me)
end

on deleteFromActorList me
  me.debug("deleteFromActorList()")
  sound(me.iBgSoundChannel).stop()
  oSpriteManager.checkInSound(me.iBgSoundChannel)
  (the actorList).deleteOne(me)
end

on stepFrame me
  oDisplay.sendDisplay("Score", script("hotdog").pickle.Decrypt(me.iScore))
  oDisplay.sendDisplay("Lives", me.getLives())
  if oAvatar.getToolCarried() > -1 then
    oDisplay.sendDisplay("Tool", me.getToolNameByIndex(oAvatar.getToolCarried()))
  else
    oDisplay.sendDisplay("Tool", "No tool carried")
  end if
  oDisplay.sendDisplay("Tool_Target", me.getComputerToolName())
  oDisplay.sendDisplay("TotalTools", me.getCountOfToolsLeft() & " of " & me.aToolList_Default.count)
end
