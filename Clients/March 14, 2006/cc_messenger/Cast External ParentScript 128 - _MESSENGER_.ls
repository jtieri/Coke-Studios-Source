property iFriendCount, iEnemyCount, iInviteCount, iTotalMessageCount, aFriends, aEnemies, aInvites, aMessages, bDebug, iUpdateTime, iTimerID, sTimerID, iUpdateFriendsStatusTime, sUpdateFriendsTimerID, iUpdateFriendsTimerID, aMyInvites
global ElementMgr, TextMgr, oDenizenManager

on new me
  me.bDebug = 0
  me.iUpdateFriendsStatusTime = 30000
  me.sUpdateFriendsTimerID = "FriendsStatusTimer"
  me.iUpdateFriendsTimerID = VOID
  me.iUpdateTime = 2500
  me.sTimerID = "MessengerTimer"
  me.iTimerID = VOID
  me.aMyInvites = []
  me.iFriendCount = 0
  me.iEnemyCount = 0
  me.iInviteCount = 0
  me.iTotalMessageCount = 0
  me.aFriends = []
  me.aEnemies = []
  me.aInvites = []
  me.aMessages = []
  script("_TIMER_").new(2000, #getNewData, me)
  me.startTimer()
  return me
end

on startFriendsUpdateTimer me
  me.iUpdateFriendsTimerID = timeout(me.sUpdateFriendsTimerID).new(me.iUpdateFriendsStatusTime, #getFriendsStatusUpdate, me)
end

on stopFriendsUpdateTimer me
  timeout(me.sUpdateFriendsTimerID).forget()
end

on startTimer me
  me.iTimerID = timeout(me.sTimerID).new(me.iUpdateTime, #updateStatus, me)
end

on stopTimer me
  timeout(me.sTimerID).forget()
end

on getNewData me
  oDenizenManager.getMessenger()
end

on updateData me, _iFriendCount, _iEnemyCount, _iInviteCount, _iTotalMessageCount, _aFriends, _aEnemies, _aInvites, _aMessages
  if me.bDebug then
    put "Messenger.updateData()"
    put "_iFriendCount: " & _iFriendCount
    put "_iEnemyCount: " & _iEnemyCount
    put "_iInviteCount: " & _iInviteCount
    put "_iTotalMessageCount: " & _iTotalMessageCount
    put "_aFriends: " & _aFriends
    put "_aEnemies: " & _aEnemies
    put "_aInvites: " & _aInvites
    put "_aMessages: " & _aMessages
  end if
  me.iFriendCount = _iFriendCount
  me.iEnemyCount = _iEnemyCount
  me.iInviteCount = _iInviteCount
  me.iTotalMessageCount = _iTotalMessageCount
  me.aFriends = _aFriends
  if the debugPlaybackEnabled then
    put "_MESSENGER_::updateData():" && _iFriendCount && "friends" & RETURN & RETURN & _aFriends
  end if
  me.aEnemies = _aEnemies
  me.aInvites = _aInvites
  me.aMessages = _aMessages
  me.updateStatus()
  mywindow = me.getOpenWindow()
  if not voidp(mywindow) then
    if mywindow.pname = "console_myinfo" then
      me.displayCurrentWindow()
    end if
  end if
  me.startFriendsUpdateTimer()
end

on updateStatus me
  bState = 0
  if (me.aInvites.count > 0) or (me.aMessages.count > 0) then
    bState = 1
  end if
  sendAllSprites(#setMessengerBlink, bState)
end

on openWindow me, sID, oArg
  myRect = me.closeWindow()
  mywindow = ElementMgr.newwindow(sID, myRect)
  me.displayWindow(mywindow, oArg)
end

on closeWindow me
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n) contains "console" then
      mywindow = ElementMgr.pOpenWindows[n]
      exit repeat
    end if
  end repeat
  if voidp(mywindow) then
    return 
  end if
  iLastRect = mywindow.closeWindow()
  return iLastRect
end

on getOpenWindow me
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n) contains "console" then
      mywindow = ElementMgr.pOpenWindows[n]
      return mywindow
      exit repeat
    end if
  end repeat
end

on displayWindow me, mywindow, oArg
  if the debugPlaybackEnabled then
    put "_MESSENGER_::displayWindow():" && ilk(oArg) && oArg
  end if
  me.updateStatus()
  if voidp(mywindow) then
    return 
  end if
  sWindowName = mywindow.pname
  case sWindowName of
    "console_myinfo":
      me.displayMyInfo(mywindow, oArg)
    "console_friends":
      me.displayFriends(mywindow, oArg)
    "console_getrequest":
      me.displayInvites(mywindow, oArg)
    "console_getmessage":
      me.displayMessages(mywindow, oArg)
    "console_removefriend":
      me.displayRemoveFriend(mywindow, oArg)
    "console_compose":
      me.displayCompose(mywindow, oArg)
  end case
end

on displayCurrentWindow me, oArg
  if the debugPlaybackEnabled then
    put "_MESSENGER_::displayCurrentWindow"
  end if
  mywindow = me.getOpenWindow()
  sWindowName = mywindow.pname
  case sWindowName of
    "console_compose":
      me.displayCompose(mywindow, oArg)
    otherwise:
      me.displayWindow(mywindow)
  end case
end

on openMyInfo me, bGetNewData
  me.openWindow("console_myinfo.window")
end

on displayMyInfo me, mywindow
  sScreenName = oDenizenManager.getScreenName()
  member("mmc_myname").text = sScreenName
  member("missionfield").text = oDenizenManager.getMissionStatement()
  mytemplate = TextMgr.GetRefText("MESSENGER_NEW_MESSAGES")
  sMessagesText = me.aMessages.count && mytemplate
  member("messages").text = sMessagesText
  mytemplate = TextMgr.GetRefText("MESSENGER_FRIEND_REQUESTS")
  sFriendRequestsText = me.aInvites.count && mytemplate
  member("requests").text = sFriendRequestsText
end

on openFriends me
  if the debugPlaybackEnabled then
    put "_MESSENGER_::openFriends()"
  end if
  me.openWindow("console_friends.window")
end

on displayFriends me, mywindow
  if voidp(mywindow) then
    return 
  end if
  mywindow.pScrollingLists.friendslist.pFriendsData = me.aFriends
  mywindow.pScrollingLists.friendslist.updatecontent()
  if the debugPlaybackEnabled then
    put "_MESSENGER_::displayFriends():" & RETURN & RETURN & me.aFriends
  end if
end

on openRemoveFriend me
  mywindow = me.getOpenWindow()
  removelist = mywindow.pScrollingLists.friendslist.pSelectedFriends
  me.openWindow("console_removefriend.window", removelist)
end

on displayRemoveFriend me, mywindow, removelist
  sprite(mywindow.pSpritelist[1]).pCustomData = [#removelist: removelist]
  member("deletiasanfoname").text = removelist[1]
end

on cancelRemoveFriend me
  mywindow = me.getOpenWindow()
  if voidp(mywindow) or (mywindow.pname <> "console_removefriend") then
    return 
  end if
  removelist = sprite(mywindow.pSpritelist[1]).pCustomData.removelist
  if count(removelist) then
    deleteAt(removelist, 1)
    sprite(mywindow.pSpritelist[1]).pCustomData.removelist = removelist
  end if
  if count(removelist) then
    me.displayRemoveFriend(mywindow, removelist)
  else
    me.openFriends()
  end if
end

on deleteFriend me
  mywindow = me.getOpenWindow()
  if voidp(mywindow) or (mywindow.pname <> "console_removefriend") then
    return 
  end if
  removelist = sprite(mywindow.pSpritelist[1]).pCustomData.removelist
  if count(removelist) then
    sFriendScreenName = removelist[1]
    sMyScreenName = oDenizenManager.getScreenName()
    oDenizenManager.removeFriends(sMyScreenName, [sFriendScreenName])
    me.removeFriend()
  end if
end

on removeFriend me
  mywindow = me.getOpenWindow()
  if voidp(mywindow) or (mywindow.pname <> "console_removefriend") then
    return 
  end if
  if me.aFriends.count < 1 then
    return 
  end if
  removelist = sprite(mywindow.pSpritelist[1]).pCustomData.removelist
  if count(removelist) then
    sFriendScreenName = removelist[1]
    deleteAt(removelist, 1)
    sprite(mywindow.pSpritelist[1]).pCustomData.removelist = removelist
    repeat with i = 1 to me.aFriends.count
      aFriend = me.aFriends[i]
      if aFriend.screenName = sFriendScreenName then
        me.aFriends.deleteAt(i)
        exit repeat
      end if
    end repeat
  end if
  if removelist.count > 0 then
    member("deletiasanfoname").text = removelist[1]
  else
    me.openFriends()
  end if
end

on removeFriendByName me, sScreenName
  iLength = me.aFriends.count()
  if iLength = 0 then
    return 
  end if
  repeat with i = 1 to iLength
    aFriend = me.aFriends[i]
    if aFriend[#screenName] = sScreenName then
      me.aFriends.deleteAt(i)
      if me.iFriendCount > 0 then
        me.iFriendCount = me.iFriendCount - 1
      end if
      exit repeat
    end if
  end repeat
  me.updateStatus()
  mywindow = me.getOpenWindow()
  if not voidp(mywindow) then
    me.displayCurrentWindow()
  end if
end

on addFriend me, aFriend
  sFriendName = aFriend[#screenName]
  if me.isFriend(sFriendName) then
    return 
  end if
  me.aFriends.add(aFriend)
  me.iFriendCount = me.iFriendCount + 1
  me.updateStatus()
  mywindow = me.getOpenWindow()
  if not voidp(mywindow) then
    me.displayCurrentWindow()
  end if
end

on isFriend me, sScreenName
  repeat with aFriend in me.aFriends
    sFriendName = aFriend[#screenName]
    if sFriendName = sScreenName then
      return 1
    end if
  end repeat
  return 0
end

on updateFriendsStatus me, aOnlineFriends
  repeat with i = 1 to me.aFriends.count()
    aFriend = me.aFriends[i]
    aOnlineFriend = me.getFriendByScreenName(aFriend[#screenName], aOnlineFriends)
    if voidp(aOnlineFriend) then
      aFriend[#online] = 0
      me.aFriends[i] = aFriend
      next repeat
      next repeat
    end if
    me.aFriends[i] = aOnlineFriend
  end repeat
  mywindow = me.getOpenWindow()
  if not voidp(mywindow) then
    if the debugPlaybackEnabled then
      put "_MESSENGER_::updateFriendsStatus()::displayCurrentWindow"
    end if
    if not voidp(mywindow.pScrollingLists) then
      if not voidp(mywindow.pScrollingLists.friendslist) then
        if not voidp(mywindow.pScrollingLists.friendslist.pSelectedFriends) then
          recipients = mywindow.pScrollingLists.friendslist.pSelectedFriends
        end if
      end if
    end if
    pCustomData = [#mailto: recipients, #camefrom: "friends"]
    me.displayCurrentWindow(pCustomData)
  end if
end

on getFriendByScreenName me, sFriendName, aFriendsList
  repeat with aFriend in aFriendsList
    if aFriend[#screenName] = sFriendName then
      return aFriend
    end if
  end repeat
end

on getFriendsStatusUpdate me
  aFriendNames = []
  repeat with aFriend in me.aFriends
    aFriendNames.add(aFriend[#screenName])
  end repeat
  oDenizenManager.getOnlineFriends(aFriendNames)
end

on openMessages me
  if me.aMessages.count = 0 then
    return 
  end if
  me.openWindow("console_getmessage.window")
end

on displayMessages me, mywindow
  if me.aMessages.count < 1 then
    return 
  end if
  mymessage = me.aMessages[1]
  setaProp(sprite(mywindow.pSpritelist[1]).pCustomData, #currentmsg, me.aMessages)
  sender = mymessage.sender
  if sender = "$SYSTEM$" then
    sender = "Coke Studios"
  end if
  member("mes_fromto").text = TextMgr.GetRefText("MESSENGER_READ_FROM") && sender
  member("receivedmessage").text = mymessage.message
  member("messagedate").text = TextMgr.getDate(mymessage.sentOn) && TextMgr.getTime(mymessage.sentOn)
end

on deleteMessage me, camefrom
  mymessage = me.aMessages[1]
  sSender = mymessage.sender
  sRecipient = mymessage.recipient
  sMessageHash = mymessage.messageHash
  oDenizenManager.removeMessage(sSender, sRecipient, sMessageHash)
  me.removeMessage()
  if voidp(camefrom) or (camefrom = "read") then
    if me.aMessages.count = 0 then
      me.openMyInfo()
    else
      me.openMessages()
    end if
  end if
end

on removeMessage me
  if me.aMessages.count < 1 then
    return 
  end if
  aMessage = me.aMessages[1]
  sSender = aMessage.sender
  me.aMessages.deleteAt(1)
  repeat with i = 1 to me.aFriends.count
    aFriend = me.aFriends[i]
    if aFriend.screenName = sSender then
      iMessagesFrom = aFriend.messagesFrom
      if iMessagesFrom > 0 then
        aFriend.messagesFrom = aFriend.messagesFrom - 1
        me.aFriends[i] = aFriend
        if me.iTotalMessageCount > 0 then
          me.iTotalMessageCount = me.iTotalMessageCount - 1
        end if
      end if
    end if
  end repeat
end

on openCompose me, pCustomData
  if the debugPlaybackEnabled then
    put "_MESSENGER_::openCompose:" && ilk(pCustomData) && pCustomData
  end if
  mywindow = me.getOpenWindow()
  me.openWindow("console_compose.window", pCustomData)
end

on displayCompose me, mywindow, pCustomData
  if the debugPlaybackEnabled then
    put "_MESSENGER_::displayCompose:" && ilk(pCustomData) && pCustomData
  end if
  sprite(mywindow.pSpritelist[1]).pCustomData = pCustomData
  recipients = pCustomData.mailto
  member("recipients").text = TextMgr.GetRefText("MESSENGER_RECIPIENT")
  if count(recipients) > 1 then
    member("names").text = TextMgr.GetRefText("MESSENGER_RECIPIENTS")
  else
    member("names").text = recipients[1]
  end if
end

on cancelCompose me
  mywindow = me.getOpenWindow()
  camefrom = sprite(mywindow.pSpritelist[1]).pCustomData[#camefrom]
  if camefrom = "read" then
    me.openMessages()
  else
    me.openFriends()
  end if
end

on sendMessage me
  if the debugPlaybackEnabled then
    put "_MESSENGER_::sendMessage"
  end if
  mywindow = me.getOpenWindow()
  if the debugPlaybackEnabled then
    put "_MESSENGER_::mywindow:" && ilk(mywindow) && mywindow
  end if
  if the debugPlaybackEnabled then
    put "_MESSENGER_::oDenizenManager:" && ilk(oDenizenManager) && oDenizenManager
  end if
  sFromScreenName = oDenizenManager.getScreenName()
  if the debugPlaybackEnabled then
    put "_MESSENGER_::sFromScreenName:" && ilk(sFromScreenName) && sFromScreenName
  end if
  if the debugPlaybackEnabled then
    put "_MESSENGER_::sprite(mywindow.pSpriteList[1]):" && ilk(sprite(mywindow.pSpritelist[1])) && sprite(mywindow.pSpritelist[1])
  end if
  if the debugPlaybackEnabled then
    put "_MESSENGER_::sprite(mywindow.pSpriteList[1]).pCustomData:" && ilk(sprite(mywindow.pSpritelist[1]).pCustomData) && sprite(mywindow.pSpritelist[1]).pCustomData
  end if
  if the debugPlaybackEnabled then
    put "_MESSENGER_::sprite(mywindow.pSpriteList[1]).pCustomData.mailto:" && ilk(sprite(mywindow.pSpritelist[1]).pCustomData.mailto) && sprite(mywindow.pSpritelist[1]).pCustomData.mailto
  end if
  aToScreenNameList = sprite(mywindow.pSpritelist[1]).pCustomData.mailto
  if the debugPlaybackEnabled then
    put "_MESSENGER_::aToScreenNameList:" && ilk(aToScreenNameList) && aToScreenNameList
  end if
  sMessage = member("message").text
  if the debugPlaybackEnabled then
    put "_MESSENGER_::sMessage:" && ilk(sMessage) && sMessage
  end if
  oDenizenManager.sendMessage(sFromScreenName, aToScreenNameList, sMessage)
  camefrom = sprite(mywindow.pSpritelist[1]).pCustomData[#camefrom]
  if camefrom = "read" then
    me.deleteMessage(camefrom)
  else
    me.cancelCompose()
  end if
end

on composeMessage me
  mywindow = me.getOpenWindow()
  recipients = mywindow.pScrollingLists.friendslist.pSelectedFriends
  pCustomData = [#mailto: recipients, #camefrom: "friends"]
  me.openCompose(pCustomData)
end

on replyToMessage me
  mywindow = me.getOpenWindow()
  mymsg = sprite(mywindow.pSpritelist[1]).pCustomData.currentmsg[1]
  mysender = mymsg.sender
  pCustomData = [#mailto: [mysender], #camefrom: "read"]
  me.openCompose(pCustomData)
end

on addMessage me, aMessage
  me.aMessages.add(aMessage)
  me.iTotalMessageCount = me.iTotalMessageCount + 1
  me.updateStatus()
  mywindow = me.getOpenWindow()
  if not voidp(mywindow) then
    if the debugPlaybackEnabled then
      put "_MESSENGER_::addMessage():displayCurrentWindow"
    end if
    me.displayCurrentWindow()
  end if
end

on openInvites me
  if me.aInvites.count = 0 then
    me.openMyInfo()
  else
    me.openWindow("console_getrequest.window")
  end if
end

on displayInvites me, mywindow
  if me.aInvites.count < 1 then
    return 
  end if
  myInvite = me.aInvites[1]
  setaProp(sprite(mywindow.pSpritelist[1]).pCustomData, #currentinvite, me.aInvites)
  member("requestsanfoname").text = myInvite.screenName
end

on removeInvite me
  mywindow = me.getOpenWindow()
  if voidp(mywindow) or (mywindow.pname <> "console_getrequest") then
    return 
  end if
  currentinvite = sprite(mywindow.pSpritelist[1]).pCustomData.currentinvite
  if currentinvite.count = 0 then
    return 
  end if
  aInvite = currentinvite[1]
  sInviter = aInvite.screenName
  currentinvite.deleteAt(1)
  sprite(mywindow.pSpritelist[1]).pCustomData.currentinvite = currentinvite
  repeat with i = 1 to me.aInvites.count
    aInvite = me.aInvites[i]
    if aInvite.screenName = sInviter then
      me.aInvites.deleteAt(i)
      if me.iInviteCount > 0 then
        me.iInviteCount = me.iInviteCount - 1
      end if
      exit repeat
    end if
  end repeat
  me.openInvites()
end

on rejectInvite me
  sInviter = member("requestsanfoname").text
  sInvitee = oDenizenManager.getScreenName()
  oDenizenManager.rejectInvitation(sInvitee, sInviter)
  me.removeInvite(me)
end

on acceptInvite me
  sInviter = member("requestsanfoname").text
  sInvitee = oDenizenManager.getScreenName()
  oDenizenManager.acceptInvitation(sInvitee, sInviter)
  me.removeInvite(me)
end

on addInvite me, aFriend
  sFriendName = aFriend[#screenName]
  if me.isFriend(sFriendName) then
    return 
  end if
  me.aInvites.add(aFriend)
  me.iInviteCount = me.iInviteCount + 1
  me.updateStatus()
  mywindow = me.getOpenWindow()
  if not voidp(mywindow) then
    me.displayCurrentWindow()
  end if
end

on addMyInvite me, sScreenName
  repeat with sMyInvite in me.aMyInvites
    if sMyInvite = sScreenName then
      return 
    end if
  end repeat
  me.aMyInvites.add(sScreenName)
end

on haveInvited me, sScreenName
  repeat with sMyInvite in me.aMyInvites
    if sMyInvite = sScreenName then
      return 1
    end if
  end repeat
  return 0
end
