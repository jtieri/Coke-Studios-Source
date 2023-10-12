property aSessions, bDebug
global oModSessionManager

on beginSprite me
  me.bDebug = 1
  me.aSessions = []
  oModSessionManager = me
end

on getSession me, sServer, iPort
  repeat with oSession in me.aSessions
    if (oSession.getServer() = sServer) and (oSession.getPort() = iPort) then
      if me.bDebug then
        put "ModSessionManager.getSession() returning existing session: " & sServer && iPort
      end if
      return oSession
    end if
  end repeat
  if me.bDebug then
    put "ModSessionManager.getSession() creating new session: " & sServer && iPort
  end if
  oSession = script("ModSession").new(me.spriteNum)
  oSession.setServer(sServer)
  oSession.setPort(iPort)
  me.aSessions.add(oSession)
  return oSession
end

on printAllSessions me
  repeat with oSession in me.aSessions
    put "[SEssion] " & oSession.getServer() && oSession.getPort()
    put RETURN
    put oSession.getRooms()
    put RETURN
  end repeat
end

on getSessionByIp me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "ModSessionManager: " & sMessage
  end if
end
