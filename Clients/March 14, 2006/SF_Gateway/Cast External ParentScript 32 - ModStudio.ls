property bDebug, foRoom, oSession, oController

on new me, _oSession, _oController
  me.bDebug = 1
  me.oSession = _oSession
  me.oController = _oController
  return me
end

on setRoomObject me, _foRoom
  me.debug("setRoomObject() " & _foRoom)
  me.foRoom = _foRoom
  me.setCallbacks()
end

on setCallbacks me
  sprite(me.oSession.getFlashSprite()).setCallback(me.foRoom, "receiveStudioChat", #receiveStudioChat, me)
  sprite(me.oSession.getFlashSprite()).setCallback(me.foRoom, "receiveStartModStudio", #receiveStartModStudio, me)
  sprite(me.oSession.getFlashSprite()).setCallback(me.foRoom, "receiveStopModStudio", #receiveStopModStudio, me)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "ModStudio: " & sMessage, bForce
  end if
end

on receiveStudioChat me, oCaller, sAvatarName, sMessage, sSpeechMode
  me.debug("receiveStudioChat()" && sAvatarName && sMessage)
  me.oController.receiveStudioChat(sAvatarName, sMessage, sSpeechMode)
end

on receiveStartModStudio me, oCaller, sModName, sStudioID
  me.debug("receiveStartModStudio() " & sModName && sStudioID)
  me.oController.receiveStartModStudio(sModName, sStudioID)
end

on receiveStopModStudio me, oCaller, sModName, sStudioID
  me.debug("receiveStopModStudio() " & sModName && sStudioID)
  me.oController.receiveStopModStudio(sModName, sStudioID)
end
