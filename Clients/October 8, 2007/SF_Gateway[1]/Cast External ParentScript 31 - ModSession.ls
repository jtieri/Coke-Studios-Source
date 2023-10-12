property bDebug, bInitialized, bReadyForuse, foSession, sClientID, sDefaultServer, iDefaultPort, sServer, iPort, bConnected, fo_level0, iFlashSprite, sID, bTestMode, aControllers, aStudios, bConnecting
global TextMgr, oDenizenManager

on new me, _iFlashSprite
  me.bDebug = 1
  me.bInitialized = 0
  me.bReadyForuse = 0
  me.sDefaultServer = TextMgr.GetRefText("LOCAL_GAME_SERVER")
  me.iDefaultPort = 9000
  me.sServer = me.sDefaultServer
  me.iPort = me.iDefaultPort
  me.bConnected = 0
  me.bConnecting = 0
  me.fo_level0 = VOID
  me.bTestMode = 0
  me.iFlashSprite = _iFlashSprite
  me.aControllers = []
  me.aStudios = [:]
  me.Init()
  return me
end

on addController me, oController
  me.aControllers.deleteOne(oController)
  me.aControllers.add(oController)
end

on removeController me, oController
  me.aControllers.deleteOne(oController)
  if me.aControllers.count = 0 then
    me.disconnect()
  end if
end

on exitFrame me
end

on Init me
  if not me.bInitialized then
    if voidp(me.foSession) then
      me.foSession = sprite(me.iFlashSprite).getVariable("_level0.oSession", 0)
      me.fo_level0 = sprite(me.iFlashSprite).getVariable("_level0", 0)
      me.setNewSession()
      me.bInitialized = 1
      me.bReadyForuse = 1
    end if
  end if
end

on setCallbacks me
  sprite(me.iFlashSprite).setCallback(me.foSession, "connectionFailed", #connectionFailed, me)
  sprite(me.iFlashSprite).setCallback(me.foSession, "connected", #connected, me)
  sprite(me.iFlashSprite).setCallback(me.foSession, "loggedIn", #loggedIn, me)
  sprite(me.iFlashSprite).setCallback(me.foSession, "loginFailed", #loginFailed, me)
  sprite(me.iFlashSprite).setCallback(me.foSession, "loggedOut", #loggedOut, me)
  sprite(me.iFlashSprite).setCallback(me.foSession, "lostConnection", #lostConnection, me)
  sprite(me.iFlashSprite).setCallback(me.foSession, "exception", #exception, me)
  sprite(me.iFlashSprite).setCallback(me.foSession, "notify", #notify, me)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "ModSession: " & sMessage, bForce
  end if
end

on getFlashSprite me
  return me.iFlashSprite
end

on setConnected me, _bConnected
  me.bConnected = _bConnected
end

on getConnected me
  return me.bConnected
end

on setConnecting me, _bConnecting
  me.bConnecting = _bConnecting
end

on getConnecting me
  return me.bConnecting
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
  me.foSession = me.fo_level0.SESSION_createSession()
  if not voidp(me.foSession) then
    me.setCallbacks()
    me.setConnectionProps(me.getServer(), me.getPort())
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
  me.setConnecting(1)
  me.bTestMode = 0
  if me.getConnected() or me.bTestMode then
    repeat with oController in me.aControllers
      oController.loggedIn()
    end repeat
    me.setConnecting(0)
    return 
  end if
  me.setNewSession()
  me.setConnectionProps(me.getServer(), me.getPort())
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
    repeat with oController in me.aControllers
      oController.loggedOut()
    end repeat
    return 
  end if
  me.foSession.disconnect()
  me.setConnecting(0)
end

on enterRoom me, sStudioID, oController
  aStudio = me.createStudio(sStudioID, oController)
  oRoom = aStudio[#room]
  oRoom.sendEnterRoom()
end

on exitRoom me, sStudioID
  aStudio = me.aStudios[sStudioID]
  if not voidp(aStudio) then
    oRoom = aStudio[#room]
    oRoom.sendExitRoom()
  end if
end

on removeRoom me, sStudioID
  me.aStudios.deleteProp(sStudioID)
end

on getStudio me, sStudioID
  oStudio = me.aStudios[sStudioID]
  return oStudio
end

on getRoom me, sStudioID
  aStudio = me.aStudios[sStudioID]
  if not voidp(aStudio) then
    oRoom = aStudio[#room]
    return oRoom
  end if
end

on connectionFailed me, oCaller, iReasonId, sReason
  me.debug("connectionFailed()" && string(iReasonId) && sReason)
  iReasonId = integer(iReasonId)
  sMessage = EMPTY
  case iReasonId of
    4:
      sMessage = "The _connection.connect method returned false"
    5:
      sMessage = "The socket could not connect to the server..."
  end case
  me.setConnected(0)
  me.setConnecting(0)
  repeat with oController in me.aControllers
    oController.connectionFailed(iReasonId)
  end repeat
end

on connected me, oCaller
  put "connected()!"
  me.logIn()
end

on loggedIn me, oCaller
  me.debug("loggedIn()")
  me.setClientID(me.foSession.getTicket())
  me.setConnected(1)
  me.setConnecting(0)
  repeat with oController in me.aControllers
    oController.loggedIn()
  end repeat
end

on loginFailed me, oCaller, iReasonId, sReason
  me.debug("loginFailed() " && string(iReasonId) && sReason)
  me.setConnecting(0)
  iReasonId = integer(iReasonId)
  sMessage = EMPTY
  case iReasonId of
    8956:
      sMessage = "Your username could not be found."
    8957:
      sMessage = "Another person with your username is already logged in."
    9999:
      sMessage = "The server is currently full."
    8950:
      sMessage = "FULL: or An improperly formed message was received"
  end case
  repeat with oController in me.aControllers
    oController.loginFailed(iReasonId, sMessage)
  end repeat
end

on loggedOut me, oCaller
  me.debug("loggedOut()")
  me.setConnected(0)
  me.setConnecting(0)
  repeat with oController in me.aControllers
    oController.loggedOut()
  end repeat
end

on lostConnection me, oCaller
  me.debug("closed()")
  me.setConnected(0)
  me.setConnecting(0)
  repeat with oController in me.aControllers
    oController.lostConnection()
  end repeat
end

on exception me, oCaller, iReasonId, sReason
  me.debug("exception()")
  repeat with oController in me.aControllers
    oController.exception(iReasonId)
  end repeat
end

on notify me, oCaller, sMsg
  me.debug("notify()" && sMsg)
  repeat with oController in me.aControllers
    oController.notify(sMsg)
  end repeat
end

on createStudio me, sRoomId, oController
  me.debug("createStudio() " & sRoomId)
  aStudio = me.aStudios[sRoomId]
  if not voidp(aStudio) then
    return aStudio
  end if
  oRoom = script("ModRoom").new(me, oController)
  oStudio = script("ModStudio").new(me, oController)
  foRoom = me.foSession.createStudio(sRoomId)
  oRoom.setRoomObject(foRoom)
  oStudio.setRoomObject(foRoom)
  aStudio = [#room: oRoom, #studio: oStudio]
  me.aStudios[sRoomId] = aStudio
  return aStudio
end

on getRooms me
  put "SESSION ROOMS:"
  keySet = me.foSession.getRooms().keySet()
  repeat with i = 0 to keySet.length
    put "Room: " & keySet[i]
  end repeat
end
