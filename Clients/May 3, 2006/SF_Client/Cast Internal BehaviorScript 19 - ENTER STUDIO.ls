property sID, iPercentage
global oDenizenManager, oSession, oRoom, oStudio, oPossessionStudio, oStudioMap, ElementMgr, oStudioManager

on exitFrame me
  me.updateLoader()
  go(the frame)
end

on beginSprite me
  put RETURN & RETURN, "*****************"
  put "** ENTERING STUDIO **"
  me.sID = EMPTY
  me.openLoader()
  me.iPercentage = 100
  ElementMgr.closeAllWindows()
  oSession.bTestMode = 0
  if oSession.bTestMode then
    script("_TIMER_").new(1000, #initRoomEntered, me)
    exit
  end if
  if oRoom.getInARoom() then
    me.initExitRoom()
  else
    me.initGetGameServer()
  end if
end

on initExitRoom me
  put "--> initExitRoom()"
  me.sID = "Exiting Studio"
  oRoom.sendExitRoom()
end

on initRoomExited me, sStudioID
  put "--> initRoomExited() " & sStudioID
  me.initGetGameServer()
end

on initGetGameServer me
  put "--> REQUESTING GAME SERVER FOR " & oStudioMap.getStudioID()
  oStudioManager.getGameServerByStudioID(oStudioMap.getStudioID())
end

on initGetGameServerResult me, oGameServer
  put "--> RECEIVED GAME SERVER: " & oGameServer.getDNS()
  put "--> CURRENT SERVER: " & oSession.getServer()
  put "--> NEW SERVER: " & oGameServer.getDNS()
  oStudioMap.setGameServer(oGameServer)
  if oSession.getConnected() then
    if oSession.getServer() = oGameServer.getDNS() then
      me.initEnterRoom()
    else
      me.initDisconnect()
    end if
  else
    me.initDisconnect()
  end if
end

on initDisconnect me
  put "--> initDisconnect()"
  me.sID = "Disconnecting."
  oSession.disconnect()
end

on initLoggedOut me
  put "--> initLoggedOut()"
  me.initConnect()
end

on initConnect me
  put "--> initConnect()"
  me.sID = "Connecting.."
  oSession.setConnectionProps(oStudioMap.getGameServer().getDNS(), oStudioMap.getGameServer().getPort())
  oSession.connect(oDenizenManager.getScreenName())
end

on initConnected me
  put "--> initConnected()"
  put "--> logging in"
  oSession.logIn()
end

on initLoggedIn me
  put "--> initLoggedIn()"
  me.initEnterRoom()
end

on initEnterRoom me
  put "--> initEnterRoom() " & oStudioMap.getStudioID()
  me.sID = "Entering:" && oStudioMap.getStudioName()
  oRoom.sendEnterRoom(oStudioMap.getStudioID())
end

on initRoomEntered me, sStudioID
  put "--> initRoomEntered() " & sStudioID
  put "--> ROOM ENTERED: " & sStudioID & " **"
  go("LoadCasts3")
end

on openLoader me
  getLoader().openWindow()
  me.updateLoader()
end

on closeLoader me
  getLoader().closeWindow()
end

on updateLoader me
  getLoader().displayStatus(me.sID, me.iPercentage)
end
