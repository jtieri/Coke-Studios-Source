property bDebug, bDebugFlash, bDebugXML, bInitialized, bReadyForuse, foSession, sClientID, sDefaultServer, iDefaultPort, sServer, iPort, bConnected, fo_level0, bTestMode
global oSession, oRoom, oStudio, oMusicStudio, oPossessionStudio, oDenizenManager, ElementMgr, gFeatureSet, TextMgr

on beginSprite me
  me.bDebug = 0
  me.bDebugFlash = 0
  me.bDebugXML = 0
  me.bInitialized = 0
  me.bReadyForuse = 0
  me.sDefaultServer = TextMgr.GetRefText("LOCAL_GAME_SERVER")
  me.iDefaultPort = 9000
  me.sServer = me.sDefaultServer
  me.iPort = me.iDefaultPort
  me.bConnected = 0
  me.fo_level0 = VOID
  me.bTestMode = 0
  oSession = me
end

on exitFrame me
  if not me.bInitialized then
    if voidp(me.fo_level0) then
      me.fo_level0 = sprite(me.spriteNum).getVariable("_level0", 0)
    end if
    if not voidp(me.fo_level0) and voidp(me.foSession) then
      me.setNewSession()
      me.bInitialized = 1
      me.bReadyForuse = 1
    end if
  end if
end

on setCallbacks me
  sprite(me.spriteNum).setCallback(me.fo_level0, "doDebug", #doDebug, me)
  sprite(me.spriteNum).setCallback(me.fo_level0, "doDebugXML", #doDebugXML, me)
  sprite(me.spriteNum).setCallback(me.fo_level0, "doEncryption", #doEncryption, me)
  sprite(me.spriteNum).setCallback(me.foSession, "connectionFailed", #connectionFailed, me)
  sprite(me.spriteNum).setCallback(me.foSession, "connected", #connected, me)
  sprite(me.spriteNum).setCallback(me.foSession, "loggedIn", #loggedIn, me)
  sprite(me.spriteNum).setCallback(me.foSession, "loginFailed", #loginFailed, me)
  sprite(me.spriteNum).setCallback(me.foSession, "loggedOut", #loggedOut, me)
  sprite(me.spriteNum).setCallback(me.foSession, "lostConnection", #lostConnection, me)
  sprite(me.spriteNum).setCallback(me.foSession, "exception", #exception, me)
  sprite(me.spriteNum).setCallback(me.foSession, "notify", #notify, me)
  sprite(me.spriteNum).setCallback(me.foSession, "message", #message, me)
  sprite(me.spriteNum).setCallback(me.foSession, "receiveAddFriend", #receiveAddFriend, me)
  sprite(me.spriteNum).setCallback(me.foSession, "receiveInvitation", #receiveInvitation, me)
  sprite(me.spriteNum).setCallback(me.foSession, "receiveRemoveFriend", #receiveRemoveFriend, me)
  sprite(me.spriteNum).setCallback(me.foSession, "receiveMessengerMessage", #receiveMessengerMessage, me)
  sprite(me.spriteNum).setCallback(me.foSession, "receiveMessengerMessageRejected", #receiveMessengerMessageRejected, me)
  me.fo_level0.bDebug = 0
  me.fo_level0.bDebugXML = 0
end

on doEncryption me
  return gFeatureSet.isEnabled(#ENCRYPTION)
end

on doDebug me, oCaller, sMessage, bForce
  if me.bDebugFlash then
    put "FLASH: " & sMessage
  end if
end

on doDebugXML me, oCaller, sMessage, bForce
  if me.bDebugXML then
    put "FLASH XML: " & sMessage
  end if
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "Session: " & sMessage
  end if
end

on setConnected me, _bConnected
  me.bConnected = _bConnected
end

on getConnected me
  return me.bConnected
end

on getScreenName me
  return me.foSession.getLoginName()
end

on setServer me, _sServer
  me.sServer = _sServer
end

on getServer me
  return me.sServer
end

on setPort me, _iPort
  me.iPort = _iPort
end

on getPort me
  return me.iPort
end

on setClientID me, sID
  me.sClientID = sID
end

on getClientID me
  return me.sClientID
end

on setNewSession me
  me.debug("setNewSession()")
  me.foSession = me.fo_level0.SESSION_createSession()
  if not voidp(me.foSession) then
    me.setCallbacks()
    if (the moviePath contains "C:\") or (the moviePath contains "@\") then
      me.setConnectionProps(me.sDefaultServer, me.iDefaultPort)
    else
      if the moviePath contains "sflocal" then
        me.setConnectionProps("sflocal.cokemusic.com", me.iDefaultPort)
      else
        me.setConnectionProps(me.fo_level0.getDefaultGameServer(), me.iDefaultPort)
      end if
    end if
  end if
end

on setConnectionProps me, sIpAddress, iPortNum
  me.debug("setConnectionProps() " && sIpAddress && string(iPortNum))
  if not voidp(sIpAddress) and (sIpAddress <> VOID) and (sIpAddress <> EMPTY) then
    me.foSession.setIpAddress(sIpAddress)
    me.setServer(sIpAddress)
  end if
  if not voidp(iPortNum) and (iPortNum <> VOID) then
    me.foSession.setPort(integer(iPortNum))
    me.setPort(iPort)
  end if
end

on connect me, sLoginName
  me.bTestMode = 0
  if me.getConnected() or me.bTestMode then
    sendAllSprites(#initLoggedIn)
    return 
  end if
  me.debug("***NOT CONNECTED***")
  me.debug("sLoginName: " & sLoginName)
  if not voidp(sLoginName) then
    me.foSession.connect(sLoginName)
  else
    me.foSession.connect(me.getScreenName())
  end if
end

on logIn me
  me.debug("login()")
  me.foSession.loginUser(oDenizenManager.getDenizen().getSecret())
end

on disconnect me
  if not (me.getConnected() or me.bTestMode) then
    sendAllSprites(#initLoggedOut)
    return 
  end if
  me.foSession.disconnect()
end

on connected me, oCaller
  sendAllSprites(#initConnected)
end

on connectionFailed me, oCaller, iReasonId, sReason
  global gCLOSING
  me.debug("connectionFailed()" && string(iReasonId) && sReason)
  iReasonId = integer(iReasonId)
  case iReasonId of
    4:
    5:
  end case
  me.setConnected(0)
  gCLOSING = 1
  if not voidp(ElementMgr) then
    ElementMgr.connectionFailed(iReasonId)
  end if
end

on loggedIn me, oCaller
  me.debug("loggedIn()")
  me.setClientID(me.foSession.getTicket())
  me.setConnected(1)
  sendAllSprites(#initLoggedIn)
end

on loginFailed me, oCaller, iReasonId, sReason
  global gCLOSING
  me.debug("loginFailed() " && string(iReasonId) && sReason)
  iReasonId = integer(iReasonId)
  case iReasonId of
    8956:
    8957:
    9999:
    8950:
  end case
  gCLOSING = 1
  if not voidp(ElementMgr) then
    ElementMgr.loginFailed(iReasonId)
  end if
end

on loggedOut me, oCaller
  me.debug("loggedOut()")
  me.setConnected(0)
  sendAllSprites(#initLoggedOut)
end

on lostConnection me, oCaller
  global gCLOSING
  me.debug("closed()")
  me.setConnected(0)
  gCLOSING = 1
  if not voidp(ElementMgr) then
    ElementMgr.lostConnection()
  end if
end

on exception me, oCaller, iReasonId, sReason
  me.debug("exception()")
end

on notify me, oCaller, sMsg
  me.debug("notify()" && sMsg)
  if not voidp(ElementMgr) then
    ElementMgr.notify(sMsg)
  end if
end

on message me, oCaller, sMsg
  me.debug("message() " & sMsg)
  if voidp(ElementMgr) then
    return 
  end if
  ElementMgr.alert("ALERT_MOD_MESSAGE", sMsg)
end

on receiveAddFriend me, oCaller, oFriend
  me.debug("receiveAddFriend() " & oFriend, 1)
  aFriend = oDenizenManager.getDenizenPropList(oFriend)
  if voidp(aFriend[#screenName]) then
    return 
  end if
  aFriend[#messagesFrom] = integer(oFriend.getMessagesFrom())
  me.debug("aFriend: " & aFriend, 1)
  ElementMgr.getMessengerObject().addFriend(aFriend)
end

on receiveInvitation me, oCaller, oFriend
  me.debug("receiveInvitation() " & oFriend.toString(), 1)
  aFriend = oDenizenManager.getDenizenPropList(oFriend)
  if voidp(aFriend[#screenName]) then
    return 
  end if
  aFriend[#messagesFrom] = integer(oFriend.getMessagesFrom())
  me.debug("aFriend: " & aFriend, 1)
  ElementMgr.getMessengerObject().addInvite(aFriend)
end

on receiveRemoveFriend me, oCaller, sFriend
  me.debug("receiveRemoveFriend() " & sFriend, 1)
  ElementMgr.getMessengerObject().removeFriendByName(sFriend)
end

on receiveMessengerMessage me, oCaller, oRC
  me.debug("receiveMessengerMessage() " & oRC.toString(), 1)
  aMessage = oDenizenManager.getMessagePropList(oRC)
  me.debug("aMessage: " & aMessage, 1)
  ElementMgr.getMessengerObject().addMessage(aMessage)
end

on receiveMessengerMessageRejected me, oCaller
  me.debug("receiveMessengerMessageRejected()", 1)
  ElementMgr.alert("ALERT_MESSENGER_LANG")
end

on getStudio me, sRoomId
  me.debug("getStudio() " & sRoomId)
  foStudio = me.foSession.getStudio(sRoomId)
  return foStudio
end

on createStudio me, sRoomId
  me.debug("createStudio() " & sRoomId)
  foRoom = me.foSession.createStudio(sRoomId)
  oRoom.setRoomObject(foRoom)
  oStudio.setRoomObject(foRoom)
  oPossessionStudio.setRoomObject(foRoom)
  return foRoom
end

on getRooms me
  keySet = me.foSession.getRooms().keySet()
  repeat with i = 0 to keySet.length
    put "Room: " & keySet[i]
  end repeat
end

on getGatewaySprite me
  return sprite(me.spriteNum)
end
