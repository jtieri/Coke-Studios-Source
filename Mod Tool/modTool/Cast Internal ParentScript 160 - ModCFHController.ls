property oSession, sRoomId, bDebug
global oCallAlertDisplayManager, sModScreenName, oModSessionManager, ElementMgr, TextMgr, oStudioManager, oStudioByModManager

on new me
  me.bDebug = 1
  me.debug("new()")
  me.sRoomId = "Admin"
  return me
end

on getSession me
  return me.oSession
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "ModCFHController: " & sMessage
  end if
end

on logIn me, sDNS
  me.debug("login() " & sDNS)
  iPort = 9000
  me.oSession = oModSessionManager.getSession(sDNS, iPort)
  me.oSession.addController(me)
  if oSession.getConnected() then
    me.oSession.enterRoom(me.sRoomId, me)
  else
    if oSession.getConnecting() then
      alert("Session is currently connecting...")
      return 
    else
      me.oSession.connect(sModScreenName)
    end if
  end if
end

on sendModMessage me, sScreenName, sMessage
  me.debug("sendModMessage() " & sScreenName && sMessage)
  oRoom = me.getSession().getRoom(me.sRoomId)
  if not voidp(oRoom) then
    oRoom.sendModMessage(sScreenName, sMessage)
  end if
end

on sendPickUpCallForHelp me, iID, bIsAlert
  me.debug("sendPickUpCallForHelp() " & iID && bIsAlert)
  oRoom = me.getSession().getRoom(me.sRoomId)
  if not voidp(oRoom) then
    oRoom.sendPickUpCallForHelp(iID, bIsAlert)
  end if
end

on sendRespondToCallForHelp me, iID, bIsAlert, sResponse
  me.debug("sendRespondToCallForHelp() " & iID && bIsAlert && sResponse)
  oRoom = me.getSession().getRoom(me.sRoomId)
  if not voidp(oRoom) then
    oRoom.sendRespondToCallForHelp(iID, bIsAlert, sResponse)
  end if
end

on sendBanUser me, sScreenName, iInterval, sMessage, sComment
  me.debug("sendBanUser() " & sScreenName && iInterval && sMessage && sComment)
  oRoom = me.getSession().getRoom(me.sRoomId)
  if not voidp(oRoom) then
    oRoom.sendBanUser(sScreenName, iInterval, sMessage, sComment)
  end if
end

on sendWarnUser me, sScreenName, sMessage, sComment
  me.debug("sendWarnUser() " & sScreenName && sMessage && sComment)
  oRoom = me.getSession().getRoom(me.sRoomId)
  if not voidp(oRoom) then
    oRoom.sendWarnUser(sScreenName, sMessage, sComment)
  end if
end

on loggedIn me
  global oLogInManager
  me.debug("loggedIn()")
  oLogInManager.pVerificationSprite.scriptInstanceList[1].bGoFrame = 1
  me.oSession.enterRoom(me.sRoomId, me)
end

on loggedOut me
  me.debug("loggedOut()")
end

on connectionFailed me, iReasonId
  me.debug("connectionFailed() " & iReasonId)
end

on loginFailed me, iReasonId, sMessage
  me.debug("loginFailed() " & iReasonId && sMessage)
  alert("loginFailed() " && iReasonId && sMessage)
end

on lostConnection me
  me.debug("lostConnection()")
  alert("lostConnection()")
end

on exception me, iReasonId
  me.debug("exception() " & iReasonId)
end

on notify me, sMessage
  me.debug("notify() " & sMessage)
end

on roomEntered me, sRoomId
  me.debug("roomEntered()")
end

on roomEnterFailed me, sRoomId, iReasonId, sMessage
  me.debug("roomEnterFailed()")
  alert("roomEnterFailed()" && sRoomId && iReasonId && sMessage)
end

on roomExited me, sRoomId
  me.debug("roomExited()")
  me.oSession.removeController(me)
end

on receiveStartModStudio me, sModName, sStudioID
  me.debug("receiveStartModStudio() " & sModName && sStudioID)
  if not objectp(oStudioByModManager) then
    oStudioByModManager = new(script("StudioByModManager"), sModName)
  end if
  oStudioByModManager.addStudio(sModName, sStudioID)
  ElementMgr.startModStudio(sModName, sStudioID)
end

on receiveStopModStudio me, sModName, sStudioID
  me.debug("receiveStopModStudio() " & sModName && sStudioID)
  if not objectp(oStudioByModManager) then
    oStudioByModManager = new(script("StudioByModManager"), sModName)
  end if
  oStudioByModManager.deleteStudio(sModName, sStudioID)
  ElementMgr.stopModStudio(sModName, sStudioID)
end
