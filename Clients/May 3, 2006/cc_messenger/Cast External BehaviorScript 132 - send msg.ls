on new me
  return me
end

on mouseDown me
  stopEvent()
end

on mouseUp me
  global ElementMgr
  if the debugPlaybackEnabled then
    put "send msg::mouseup"
  end if
  oMsg = ElementMgr.getMessengerObject()
  if the debugPlaybackEnabled then
    put "oMsg:" && ilk(oMsg) && oMsg
  end if
  if objectp(oMsg) then
    oMsg.sendMessage()
  end if
  if the debugPlaybackEnabled then
    put "ElementMgr.getMessengerObject():" && ElementMgr.getMessengerObject()
  end if
  stopEvent()
end
