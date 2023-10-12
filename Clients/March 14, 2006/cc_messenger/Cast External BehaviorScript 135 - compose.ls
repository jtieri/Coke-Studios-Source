property bActive

on new me
  me.bActive = 0
  return me
end

on dimMmsBtns me
  sprite(me.spriteNum).blend = 30
  me.bActive = 0
end

on plainMmsBtns me
  sprite(me.spriteNum).blend = 100
  me.bActive = 1
end

on mouseDown me
  stopEvent()
end

on mouseUp me
  global ElementMgr
  if not me.bActive then
    return 
  end if
  oMsg = ElementMgr.getMessengerObject()
  if the debugPlaybackEnabled then
    put "oMsg:" && ilk(oMsg) && oMsg
  end if
  if objectp(oMsg) then
    oMsg.composeMessage()
  end if
  stopEvent()
end
