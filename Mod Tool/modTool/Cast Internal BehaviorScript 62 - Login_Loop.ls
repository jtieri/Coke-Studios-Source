global oModControllerManager

on exitFrame me
  go(the frame)
end

on initGetGameServerResult me, foGameServer
  put "Login_loop initGameGameServerResult() " & foGameServer.toString()
  oModControllerManager.getCFHController().logIn(foGameServer.getDNS())
end
