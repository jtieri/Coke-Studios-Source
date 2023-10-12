on new me
  return me
end

on mouseDown me
  stopEvent()
end

on mouseUp me
  global ElementMgr
  ElementMgr.getMessengerObject().rejectInvite()
  stopEvent()
end
