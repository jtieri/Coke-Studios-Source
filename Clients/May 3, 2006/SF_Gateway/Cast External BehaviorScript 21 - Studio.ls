property bDebug, foRoom, sOwner, sStudioName, sStudioID, fo_level0, foSongPlaying, sIJsongplayer
global oDenizenManager, oSession, oStudio, ElementMgr, oIsoScene, oStudioMap, ochat, oPossessionManager, gFeatureSet, gSoundLevel

on beginSprite me
  me.bDebug = 0
  oStudio = me
end

on setRoomObject me, _foRoom
  me.debug("setRoomObject() " & _foRoom)
  me.foRoom = _foRoom
  me.setCallbacks()
end

on setCallbacks me
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveStudioEntered", #receiveStudioEntered, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveDisplayStudio", #receiveDisplayStudio, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveAvatarEnter", #receiveAvatarEnter, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveAvatarExit", #receiveAvatarExit, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveAvatarUpdate", #receiveAvatarUpdate, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveMoveAvatar", #receiveMoveAvatar, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveRemoveAvatar", #receiveRemoveAvatar, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveStudioChat", #receiveStudioChat, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveFindPath", #receiveFindPath, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveCdRequestAccepted", #receiveCdRequestAccepted, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveNoCds", #receiveNoCds, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveCdWaitTurn", #receiveCdWaitTurn, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveCdPlay", #receiveCdPlay, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveEligibleVoters", #receiveEligibleVoters, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveCdStop", #receiveCdStop, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveCdLock", #receiveCdLock, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveThumbsUp", #receiveThumbsUp, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveThumbsDown", #receiveThumbsDown, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveVotesResults", #receiveVotesResults, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receivePlayVotesResultsSound", #receivePlayVotesResultsSound, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveDisplayTrade", #receiveDisplayTrade, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveCancelTrade", #receiveCancelTrade, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveTradeStatus", #receiveTradeStatus, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveTradeComplete", #receiveTradeComplete, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveUpdateBackpack", #receiveUpdateBackpack, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveDrinkCoke", #receiveDrinkCoke, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveModMessage", #receiveModMessage, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveDisplayBackpack", #receiveDisplayBackpack, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveTrivia", #receiveTrivia, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveJukeboxRequestAccepted", #receiveJukeboxRequestAccepted, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receivePlaylistEmpty", #receivePlaylistEmpty, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveJukeboxWaitTurn", #receiveJukeboxWaitTurn, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveJukeboxPlay", #receiveJukeboxPlay, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveJukeboxStop", #receiveJukeboxStop, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveJukeboxLock", #receiveJukeboxLock, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveNotEnoughTokens", #receiveNotEnoughTokens, me)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "SF_Gateway::Studio: " & sMessage
  end if
end

on isOwner me, sScreenName
  return me.getOwner() = sScreenName
end

on getOwner me
  return me.sOwner
end

on getStudioName me
  return me.sStudioName
end

on getStudioID me
  return me.sStudioID
end

on sendEnterStudio me
  global gDrinking
  me.debug("sendEnterStudio()")
  if oSession.bTestMode then
    return 
  end if
  me.getcdplayer().reset()
  sAction = EMPTY
  if gDrinking then
    sAction = "drk"
  end if
  me.foRoom.sendEnterStudio(sAction)
end

on sendExitStudio me
  me.debug("sendExitStudio()")
  if oSession.bTestMode then
    return 
  end if
  oSequencer = ElementMgr.getSequencer()
  if not voidp(oSequencer) then
    oSequencer.stop()
  end if
  me.getcdplayer().reset()
  me.foRoom.sendExitStudio()
end

on sendExitStudioViaDoor me
  me.debug("sendExitStudioViaDoor()")
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendExitStudioViaDoor()
end

on sendMoveAvatar me, iXPos, iYPos, iZPos
  me.debug("sendMoveAvatar()")
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendMoveAvatar(iXPos, iYPos, iZPos)
end

on sendUpdateAvatar me, iXPos, iYPos, iZPos, iDirection, sAction
  me.debug("sendUpdateAvatar() iXPos: " & iXPos & ", iYPos: " & iYPos & ", iZPos: " & iZPos & ", iDirection: " & iDirection & ", sAction: " & sAction)
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendUpdateAvatar(iXPos, iYPos, iZPos, iDirection, sAction)
end

on sendStudioChat me, sMessage, sSpeechMode
  me.debug("sendStudioChat()")
  if sSpeechMode <> "sing" then
    if the shiftDown then
      sSpeechMode = #shout
    end if
  end if
  me.foRoom.sendStudioChat(sMessage, string(sSpeechMode))
end

on sendFindPath me, iXPos, iYPos, iZPos
  me.debug("sendFindPath() " & iXPos && iYPos && iZPos)
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendFindPath(iXPos, iYPos, iZPos)
  me.debug("sendFindPath() call complete")
end

on sendCdRequest me, iCdPlayerPosId
  me.debug("sendCdRequest() " & iCdPlayerPosId)
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendCdRequest(iCdPlayerPosId)
end

on sendCdPlay me, iPosId
  me.debug("sendCdPlay() " & iPosId)
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendCdPlay(iPosId)
end

on sendCdStop me
  me.debug("sendCdStop()")
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendCdStop()
end

on sendCdEnd me
  me.debug("sendCdEnd()")
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendCdEnd()
end

on sendThumbsUp me
  me.debug("sendThumbsUp()")
  if not gFeatureSet.isEnabled(#VOTING) then
    ElementMgr.alert("FEATURE_DISABLED")
    return 
  end if
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendThumbsUp()
end

on sendThumbsDown me
  me.debug("sendThumbsDown()")
  if not gFeatureSet.isEnabled(#VOTING) then
    ElementMgr.alert("FEATURE_DISABLED")
    return 
  end if
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendThumbsDown()
end

on sendDrinkCoke me
  me.debug("sendDrinkCoke()")
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendDrinkCoke()
end

on sendKickAvatar me, sScreenName
  me.debug("sendKickAvatar() " & sScreenName)
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendKickAvatar(sScreenName)
end

on sendCallForHelp me, sMessage
  me.debug("sendCallForHelp() " & sMessage, 1)
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendCallForHelp(sMessage)
end

on sendStartTrade me, sTradeeScreenName, bTest
  me.debug("sendStartTrade() " & sTradeeScreenName)
  if not gFeatureSet.isEnabled(#TRADING) then
    return 
  end if
  if bTest then
    aTestTrade = me.getTestTrade(sTradeeScreenName)
    ElementMgr.displayTrade(aTestTrade)
    return 
  end if
  me.foRoom.sendStartTrade(sTradeeScreenName)
end

on sendAddToTrade me, iPosId, bTest
  me.debug("sendAddToTrade() " & iPosId)
  if not gFeatureSet.isEnabled(#TRADING) then
    return 
  end if
  if bTest then
    aTestTrade = me.getTestTrade("Somebody")
    ElementMgr.displayTrade(aTestTrade)
    return 
  end if
  me.foRoom.sendAddToTrade(iPosId)
  oBackPack = oDenizenManager.getBackpack()
  if voidp(oBackPack) then
    put ">>> SEND ADD TO TRADE: oBACKPACK is VOID"
  end if
  if not voidp(oBackPack) then
    oPos = oBackPack.getPossessionById(integer(iPosId))
    oBackPack.addPossessionToTrade(oPos)
    me.removePossessionFromBackpack(integer(iPosId))
  end if
end

on sendAgreeTrade me, bTest
  me.debug("sendAgreeTrade()")
  if not gFeatureSet.isEnabled(#TRADING) then
    return 
  end if
  if bTest then
    aTestTrade = me.getTestTrade("Somebody")
    ElementMgr.displayTrade(aTestTrade)
    return 
  end if
  me.foRoom.sendAgreeTrade()
end

on sendDisagreeTrade me, bTest
  me.debug("sendDisagreeTrade()")
  if not gFeatureSet.isEnabled(#TRADING) then
    return 
  end if
  if bTest then
    aTestTrade = me.getTestTrade("Somebody")
    ElementMgr.displayTrade(aTestTrade)
    return 
  end if
  me.foRoom.sendDisagreeTrade()
end

on sendCancelTrade me, bTest
  me.debug("sendCancelTrade()")
  if bTest then
    ElementMgr.cancelTrade()
    return 
  end if
  me.foRoom.sendCancelTrade()
end

on receiveDisplayTrade me, oCaller, oTrade
  me.debug("receiveDisplayTrade() " & oTrade.toString())
  if not gFeatureSet.isEnabled(#TRADING) then
    return 
  end if
  aTrade = [:]
  aTrade[#trader] = oTrade.getTrader()
  aTrade[#tradee] = oTrade.getTradee()
  aTrade[#traderAgrees] = oTrade.getTraderAgrees()
  aTrade[#tradeeAgrees] = oTrade.getTradeeAgrees()
  aTrade[#traderItems] = me.convertFlashArrayToDirectorList(oTrade.getTraderItems())
  aTrade[#tradeeItems] = me.convertFlashArrayToDirectorList(oTrade.getTradeeItems())
  ElementMgr.displayTrade(aTrade)
end

on receiveCancelTrade me, oCaller
  me.debug("receiveCancelTrade()")
  ElementMgr.cancelTrade()
  oBackPack = oDenizenManager.getBackpack()
  if not voidp(oBackPack) then
    aTradePossessionList = oBackPack.getTradePossessionList()
    repeat with i = 0 to aTradePossessionList.length - 1
      oPos = aTradePossessionList[i]
      oBackPack.addPossession(oPos, 1)
    end repeat
    oBackPack.clearTradePossessionList()
  end if
  oPossessionManager.getPossessionsInBackpack(oDenizenManager.getScreenName(), 1, 25)
end

on receiveTradeComplete me, oCaller, aPossessions
  me.debug("receiveTradeComplete() " & aPossessions)
  ElementMgr.cancelTrade()
  if voidp(aPossessions) then
    return 
  end if
  oBackPack = oDenizenManager.getBackpack()
  if voidp(oBackPack) then
    return 
  end if
  oBackPack.clearTradePossessionList()
  iLength = aPossessions.length
  if iLength <= 0 then
    return 
  end if
  repeat with i = 0 to iLength - 1
    oPos = aPossessions[i]
    iID = oPos.getId()
    iCatId = oPos.getCatalogItem()
    sProperties = oPos.getPropertiesString()
    oBackPack.addPossessionByItem(iID, iCatId, sProperties, 1)
  end repeat
  oPossessionManager.getPossessionsInBackpack(oDenizenManager.getScreenName(), 1, 25)
end

on receiveTradeStatus me, oCaller, sTrader, sTradee, bStatus
  me.debug("receiveTradeStatus() " & sTrader && sTradee && bStatus)
  if voidp(oIsoScene) then
    return 
  end if
  oTraderAvatar = oIsoScene.oAvatars.getAvatar(sTrader)
  if not voidp(oTraderAvatar) then
    oTraderAvatar.setTrading(bStatus)
  end if
  oTradeeAvatar = oIsoScene.oAvatars.getAvatar(sTradee)
  if not voidp(oTradeeAvatar) then
    oTradeeAvatar.setTrading(bStatus)
  end if
end

on convertFlashArrayToDirectorList me, foArray
  aList = []
  iLength = foArray.length
  if iLength = 0 then
    return aList
  end if
  repeat with i = 0 to iLength - 1
    aList.add(foArray[i])
  end repeat
  return aList
end

on getTestTrade me, sTradeeScreenName
  aTrade = [:]
  aTrade[#trader] = oDenizenManager.getScreenName()
  aTrade[#tradee] = sTradeeScreenName
  aTrade[#traderAgrees] = [1, 0][random(2)]
  aTrade[#tradeeAgrees] = [1, 0][random(2)]
  aTrade[#traderItems] = [3, 4, 5, 6, 7]
  aTrade[#tradeeItems] = [11, 12, 13, 14, 15]
  return aTrade
end

on sendMessage me, sFromScreenName, aToScreenNameList, sMessage
  me.debug("sendMessage() " & sFromScreenName && aToScreenNameList, 1)
  faToScreenNameList = me.foRoom.getArray()
  repeat with _sScreenName in aToScreenNameList
    faToScreenNameList.push(_sScreenName)
  end repeat
  me.foRoom.sendSendMessage(sMessage, faToScreenNameList)
end

on removeMessage me, sSender, sRecipient, sMessageHash
  me.debug("removeMessage() " & sSender && sRecipient && sMessageHash, 1)
  me.foRoom.sendRemoveMessage(sSender, sMessageHash)
end

on rejectInvitation me, sInviter, sInvitee
  me.debug("rejectInvitation() " & sInviter && sInvitee, 1)
  me.foRoom.sendRejectInvitation(sInviter)
end

on acceptInvitation me, sInviter, sInvitee
  me.debug("acceptInvitation() " & sInviter && sInvitee, 1)
  me.foRoom.sendAcceptInvitation(sInvitee)
end

on inviteFriend me, sInviter, sInvitee
  me.debug("inviteFriend() " & sInviter && sInvitee, 1)
  if sInviter = sInvitee then
    return 
  end if
  if sInvitee = oDenizenManager.getScreenName() then
    alert("CAN'T INVITE INVITEE")
    return 
  end if
  me.foRoom.sendInviteFriend(sInvitee)
end

on removeFriends me, sScreenName, aRemoveList
  me.debug("removeFriends() " & sScreenName && aRemoveList, 1)
  faRemoveList = me.foRoom.getArray()
  repeat with sFriendScreenName in aRemoveList
    faRemoveList.push(sFriendScreenName)
  end repeat
  me.foRoom.sendRemoveFriends(faRemoveList)
end

on receiveStudioEntered me, oCaller, _sStudioId, _sStudioName, _sOwner, iLocation, iLayout, iSequenceRate
  me.debug("receiveStudioEntered() " & _sStudioId && _sStudioName && _sOwner && iLocation && iLayout && iSequenceRate)
  me.sStudioID = _sStudioId
  me.sStudioName = _sStudioName
  me.sOwner = _sOwner
  sendAllSprites(#initStudioEntered, me.sStudioID, me.sStudioName, iLocation, iLayout, me.sOwner, iSequenceRate)
  clearOldAvatarCastMembers()
end

on receiveDisplayStudio me, oCaller
  me.debug("receiveDisplayStudio()")
  if not voidp(oIsoScene) then
    getLoader().closeWindow()
    ElementMgr.newwindow("cc.controlbar.window")
    oIsoScene.lockDisplay(0)
  end if
end

on receiveAvatarEnter me, oCaller, sAvatarName
  me.debug("receiveAvatarEnter() " & sAvatarName)
end

on receiveAvatarExit me, oCaller, sAvatarName
  me.debug("receiveAvatarExit() " & sAvatarName)
end

on receiveAvatarUpdate me, oCaller, sAvatarName, iXPos, iYPos, iZPos, iDirection, sAction, iGender, sMission, sDefinition, bBot
  me.debug("receiveAvatarUpdate()" && "sAvatarName: " & sAvatarName && "iXPos: " & iXPos && "iYPos: " & iYPos && "iZPos: " & iZPos && "iDirection: " & iDirection && "sAction: " & sAction && "iGender: " & iGender && "sMission: " & sMission && "sDefinition: " & sDefinition && "bBot: " & bBot, 1)
  if voidp(oIsoScene) then
    return 
  end if
  oAvatar = oIsoScene.oAvatars.getAvatar(sAvatarName)
  if voidp(oAvatar) then
    oAvatar = new(script("IsoAvatar"), sAvatarName, oStudioMap.getAvatarScale(), sDefinition, sAvatarName, sMission, bBot)
    oAvatar.iLayer = 3
  end if
  if not ((sAction = "dnc") or (sAction = "std")) then
    if not voidp(iDirection) then
      oAvatar.faceDirection(iDirection)
    end if
  end if
  if not voidp(iXPos) and not voidp(iZPos) then
    oSquare = oIsoScene.oGrid.getSquareByRowCol(iZPos, iXPos)
    oAvatar.moveToSquare(oSquare)
  end if
  case sAction of
    "dnc":
      if not oAvatar.isDancing() then
        oAvatar.dance()
      end if
    "drk":
      oAvatar.drinkCoke()
    otherwise:
      if oAvatar.isDancing() then
        oAvatar.stopDancing()
      end if
  end case
end

on receiveMoveAvatar me, oCaller, sAvatarName, iXPos, iYPos, iZPos, bStop, bForce
  if voidp(oIsoScene) then
    return 
  end if
  oAvatar = oIsoScene.oAvatars.getAvatar(sAvatarName)
  if not voidp(oAvatar) then
    oSquare = oIsoScene.oGrid.getSquareByRowCol(iZPos, iXPos)
    if not voidp(oSquare) then
      if bForce then
        oAvatar.moveToSquare(oSquare)
      else
        oAvatar.addToPath(oSquare, bStop)
      end if
    end if
  end if
end

on receiveRemoveAvatar me, oCaller, sAvatarName
  me.debug("receiveRemoveAvatar()" && sAvatarName)
  if voidp(oIsoScene) then
    return 
  end if
  oAvatar = oIsoScene.oAvatars.getAvatar(sAvatarName)
  if not voidp(oAvatar) then
    oIsoScene.oAvatars.removeItem(oAvatar)
  end if
end

on receiveStudioChat me, oCaller, sAvatarName, sMessage, iSpeechMode
  me.debug("receiveStudioChat()" && sAvatarName && sMessage && iSpeechMode)
  if voidp(oIsoScene) then
    return 
  end if
  oAvatar = oIsoScene.oAvatars.getAvatar(sAvatarName)
  oMyAvatar = oIsoScene.oAvatars.getAvatar(oDenizenManager.getScreenName())
  if not voidp(oAvatar) and not voidp(oMyAvatar) then
    oSquare1 = oAvatar.getSquare()
    oSquare2 = oMyAvatar.getSquare()
    iDistance = integer(oIsoScene.oGrid.getDistanceBetweenSquares(oSquare1, oSquare2))
    if iDistance < 1 then
      iDistance = 1
    end if
    oColor = oAvatar.getEngine().getPartColor(#ch)
    me.debug("oColor: " & oColor)
    oPoint = oAvatar.oSquare.calcViewCenter()
    me.debug("oPoint: " & oPoint)
    if voidp(iSpeechMode) then
      iSpeechMode = 1
    end if
    iError = ochat.displaychat(sAvatarName, sMessage, oColor, oPoint, iSpeechMode, iDistance)
    if iError < 0 then
    else
      oAvatar.chat(sMessage)
    end if
  else
    me.debug("oAvatar was null")
  end if
  oIsoScene.oAvatars.hearChat(oAvatar)
end

on receiveFindPath me, oCaller, sAvatarName, aPath, iNowTime
  me.debug("receiveFindPath()" && sAvatarName && aPath && iNowTime)
end

on receiveNoCds me, oCaller
  me.debug("receiveNoCds()")
  ElementMgr.alert("NOCD_TITLE", "NOCD_DESC")
end

on receiveCdRequestAccepted me
  me.debug("receiveCdRequestAccepted()")
  ElementMgr.opencdplayer()
end

on receiveCdWaitTurn me
  me.debug("receiveCdWaitTurn()")
  ElementMgr.alert("CHOOSE_SONG_WAIT_TURN")
end

on receiveCdPlay me, oCaller, sAvatar, foCd, iCdPlayerPosId
  me.debug("receiveCdPlay() " & foCd.toString(), 1)
  me.getcdplayer().setAvatar(sAvatar)
  me.getcdplayer().setCd(foCd)
  me.getcdplayer().setPlaying(1)
  me.getcdplayer().setCdPlayerPosId(iCdPlayerPosId)
  if sAvatar = oDenizenManager.getScreenName() then
    sendAllSprites(#setSpeechMode, #sing)
  else
    sendAllSprites(#setSpeechMode, #speak)
  end if
  sSong = foCd.getSong()
  ElementMgr.getSequencer().loadOddCastSequence(sSong)
  oPossession = oIsoScene.getItemByPossessionId(me.getcdplayer().getCdPlayerPosId())
  if not voidp(oPossession) then
    oPossession.getAction().setOn()
  end if
  oIsoScene.displayCdPlaying()
  sendAllSprites(#startPerformance)
  updateStage()
  ElementMgr.getSequencer().play()
end

on receiveEligibleVoters me, oCaller, aEligibleVoterNames
  me.debug("receiveEligibleVoters()" & aEligibleVoterNames.toString())
  me.getcdplayer().setEligibleVoters(aEligibleVoterNames)
  me.debug("cd: " & me.getcdplayer().toString())
end

on receiveCdStop me
  me.debug("receiveCdStop()")
  ElementMgr.closeCdPlayer()
  me.getcdplayer().setPlaying(0)
  me.getcdplayer().clearEligibleVoters()
  ElementMgr.getSequencer().stop()
  oPossession = oIsoScene.getItemByPossessionId(me.getcdplayer().getCdPlayerPosId())
  if not voidp(oPossession) then
    oPossession.getAction().setOff()
  end if
  sendAllSprites(#setSpeechMode, #speak)
  oIsoScene.oInfoStand.display(oIsoScene.oSelectedItem)
  sendAllSprites(#stopPerformance)
end

on receiveCdLock me, oCaller, bLocked
  me.debug("receiveCdLock() " & bLocked)
  me.getcdplayer().setLocked(bLocked)
end

on receiveThumbsUp me, oCaller, sAvatarName, iThumbsUp
  me.debug("receiveThumbsUp() " & sAvatarName, 1)
  if voidp(oIsoScene) then
    return 
  end if
  me.getcdplayer().setThumbsUpVotes(integer(iThumbsUp))
  oAvatar = oIsoScene.oAvatars.getAvatar(sAvatarName)
  if not voidp(oAvatar) then
    oAvatar.displayThumbsUp()
  end if
end

on receiveThumbsDown me, oCaller, sAvatarName, iThumbsDown
  me.debug("receiveThumbsDown() " & sAvatarName, 1)
  if voidp(oIsoScene) then
    return 
  end if
  me.getcdplayer().setThumbsDownVotes(integer(iThumbsDown))
  oAvatar = oIsoScene.oAvatars.getAvatar(sAvatarName)
  if not voidp(oAvatar) then
    oAvatar.displayThumbsDown()
  end if
end

on receiveVotesResults me, oCaller, sAuthor, iThumbsUp, iThumbsDown, iPointsAwarded
  me.debug("receiveVotesResults() " & sAuthor && iThumbsUp && iThumbsDown && iPointsAwarded)
  ElementMgr.displayVoteResults(sAuthor, integer(iThumbsUp), integer(iThumbsDown), integer(iPointsAwarded))
end

on receivePlayVotesResultsSound me, oCaller, iThumbsUp, iThumbsDown
  me.debug("receivePlayVotesResultsSound() " & iThumbsUp && iThumbsDown)
  ElementMgr.getSequencer().stop()
  if (iThumbsUp >= 0) and (iThumbsDown = 0) then
    me.playThumbsUpSound(iThumbsUp)
  else
    me.playThumbsDownSound(iThumbsDown)
  end if
end

on receiveUpdateBackpack me, oCaller
  me.debug("receiveUpdateBackpack()")
  return 
end

on receiveDrinkCoke me, oCaller, sAvatarName, iPoints
  me.debug("receiveDrinkCoke() " & sAvatarName && iPoints)
  if iPoints < 0 then
    ElementMgr.alert("ALERT_COKE_LIMIT")
    return 
  end if
  if sAvatarName = oDenizenManager.getScreenName() then
    ElementMgr.displayDrinkCoke(integer(iPoints))
  end if
  if voidp(oIsoScene) then
    return 
  end if
  oAvatar = oIsoScene.oAvatars.getAvatar(sAvatarName)
  if not voidp(oAvatar) then
    oAvatar.drinkCoke()
  end if
  iCokesDrank = oDenizenManager.getCokesDrank()
  oDenizenManager.setCokesDrank(iCokesDrank + 1)
end

on receiveModMessage me, oCaller, sMessage
  me.debug("receiveModMessage() " + sMessage)
  if voidp(ElementMgr) then
    return 
  end if
  ElementMgr.alert("ALERT_MOD_MESSAGE", sMessage)
end

on playThumbsUpSound me, iThumbsUp
  if iThumbsUp < 3 then
    sound(8).play(member("plus_1"))
    return 
  end if
  if iThumbsUp <= 5 then
    sound(8).play(member("plus_3"))
    return 
  end if
  if iThumbsUp <= 10 then
    sound(8).play(member("plus_5"))
    return 
  end if
  if iThumbsUp <= 16 then
    sound(8).play(member("plus_10"))
    return 
  end if
  if iThumbsUp > 16 then
    sound(8).play(member("plus_16"))
    return 
  end if
end

on playThumbsDownSound me, iThumbsDown
  if iThumbsDown < 5 then
    aRandom = ["minus_1t1", "minus_1t2", "minus_1t3"]
    sMember = aRandom[random(aRandom.count)]
    sound(8).play(member(sMember))
    return 
  end if
  if iThumbsDown <= 10 then
    sound(8).play(member("minus_10"))
    return 
  end if
  if iThumbsDown > 10 then
    sound(8).play(member("minus_16"))
    return 
  end if
end

on getcdplayer me
  return me.foRoom.getcdplayer()
end

on getGatewaySprite me
  return sprite(me.spriteNum)
end

on getMixerServer me
  return oSession.fo_level0.getDefaultMixerServer()
end

on receiveTrivia me, oCaller, sQuestion, sAnswer, iDisplayTime
  me.debug("recieveTrivia() sQuestion: " & sQuestion & ", sAnswer: " & sAnswer & ", iSequenceRate: " & iDisplayTime)
  if not voidp(oIsoScene) then
    oIsoScene.oTrivia.displayTrivia(sQuestion, sAnswer, iDisplayTime)
  end if
end

on getPossessionsInBackpack me, sScreenName, iPage, iPageSize
  me.debug("getPossessionsInBackpack() " & sScreenName && iPage && iPageSize)
  me.foRoom.sendGetPossessionsInBackpack(sScreenName, iPage, iPageSize)
end

on receiveDisplayBackpack me, oCaller, oResult
  me.debug("receiveDisplayBackpack() ")
  if oResult.getTypeOf() <> "Backpack" then
    me.debug("receiveDisplayBackpack() ERROR")
    return 
  end if
  iError = 0
  me.debug("iError: " & iError)
  iCurrentPage = integer(oResult.getCurrentPage())
  me.debug("iCurrentPage: " & iCurrentPage)
  iTotalPages = integer(oResult.getTotalPages())
  me.debug("iTotalPages: " & iTotalPages)
  iTotalItems = integer(oResult.getTotalItems())
  iCds = integer(oResult.getNumberOfBlankCds())
  me.debug("iCds: " & iCds, 1)
  me.debug("iTotalItems: " & iTotalItems)
  aPossessions = oResult.getPossessions()
  me.debug("aPossessions: " & aPossessions)
  aProdList = []
  iLength = aPossessions.length
  repeat with i = 0 to iLength - 1
    oItem = aPossessions[i]
    me.debug("oItem: " & oItem.toString())
    aItem = [:]
    aItem[#prodID] = integer(oItem.getCatalogItem())
    me.debug("aItem: prodId: " & aItem)
    aItem[#posId] = integer(oItem.getId())
    me.debug("aItem: posId: " & aItem)
    oProperties = oItem.getProperties()
    me.debug("oProperties: " & oProperties)
    if voidp(oProperties) or (oProperties = VOID) then
      aItem[#attributes] = [:]
    else
      aItem[#attributes] = value(oItem.getProperties())
    end if
    me.debug("aItem: attributes: " & aItem)
    aProdList.add(aItem)
  end repeat
  me.debug("getPossessionsInBackpack_Result() iCurrentPage: " & iCurrentPage & ", iTotalPages: " & iTotalPages & ", iTotalItems: " & iTotalItems & ", iCds: " & iCds & ",  aProdList: " & aProdList)
  if not voidp(ElementMgr) then
    ElementMgr.getPossessionsInBackpack_Result(iError, aProdList, iCurrentPage, iTotalPages, iTotalItems, iCds)
  end if
end

on removePossessionFromBackpack me, iPosId, bTrade
  oBackPack = oDenizenManager.getBackpack()
  if not voidp(oBackPack) then
    oPos = oBackPack.getPossessionById(integer(iPosId))
    if not voidp(oPos) then
      oBackPack.removePossessionById(integer(iPosId))
      iCurrentPage = sendAllSprites(#getBackpackCurrentPage)
      if voidp(iCurrentPage) then
        iCurrentPage = 1
      end if
      oPossessionManager.getPossessionsInBackpack(oDenizenManager.getScreenName(), iCurrentPage, 25)
    end if
  end if
end

on sendJukeboxRequest me
  me.foRoom.sendJukeboxRequest()
end

on sendJukeboxPlay me, iSongId
  me.foRoom.sendJukeboxPlay(iSongId)
end

on sendJukeboxStop me
  me.foRoom.sendJukeboxStop()
end

on sendJukeboxEnd me
  me.foRoom.sendJukeboxEnd()
end

on receiveJukeboxRequestAccepted me
  ElementMgr.openjukeboxplayer()
  oDenizenManager.getAvailableTokens()
end

on receivePlaylistEmpty me
  ElementMgr.alert("ALERT_IJ_PLAYLIST")
end

on receiveJukeboxWaitTurn
  ElementMgr.alert("CHOOSE_SONG_WAIT_TURN")
end

on receiveJukeboxPlay me, oCaller, sAvatar, oSongData
  foSongPlaying = oSongData
  sIJsongplayer = sAvatar
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if ElementMgr.pOpenWindows[n].pname = "cc_jukebox.playback" then
      ElementMgr.pOpenWindows[n].closeWindow()
    end if
  end repeat
  oIsoScene.oInfoStand.displaySong(oSongData, sAvatar)
  myheadlessplayer = sendAllSprites(#getheadlessplayer)
  if voidp(myheadlessplayer) then
    myheadlessplayer = ElementMgr.LastUsedSprite()
    puppetSprite(myheadlessplayer, 1)
    sprite(myheadlessplayer).rect = rect(0, 0, 1, 1)
    sprite(myheadlessplayer).member = member("ftm_coke_player")
    sprite(myheadlessplayer).scriptInstanceList = [new(script("headless player script"))]
    updateStage()
    sprite(myheadlessplayer).rect = rect(0, 0, 1, 1)
    updateStage()
  end if
  sprite(myheadlessplayer).stopSong()
  me.fo_level0 = sprite(myheadlessplayer).getVariable("_root", 0)
  me.fo_level0.playsong(oSongData.getsongpath())
  me.fo_level0.setVolume(gSoundLevel)
  sprite(myheadlessplayer).pmode = #room
end

on receiveJukeboxStop me
  foSongPlaying = VOID
  sIJsongplayer = VOID
  if voidp(ElementMgr.oJukebox) = 0 then
    mywindow = ElementMgr.oJukebox.getOpenWindow()
    if voidp(mywindow) = 0 then
      if mywindow.pname = "cc_jukebox.playback" then
        ElementMgr.oJukebox.closeWindow()
      end if
    end if
  end if
  myheadlessplayer = sendAllSprites(#getheadlessplayer)
  sprite(myheadlessplayer).stopSong()
  sprite(myheadlessplayer).pmode = #idle
  oIsoScene.oInfoStand.display(oIsoScene.oSelectedItem)
end

on receiveJukeboxLock me, oCaller, bLocked
  repeat with n = 1 to count(oIsoScene.oFurniture.aItems)
    if string(oIsoScene.oFurniture.aItems[n]) contains "infinite_jukebox" then
      myitem = oIsoScene.oFurniture.aItems[n]
      exit repeat
    end if
  end repeat
  myitem.setState(bLocked)
end

on receiveNotEnoughTokens me
  ElementMgr.alert("ALERT_IJ_TOKENS")
end
