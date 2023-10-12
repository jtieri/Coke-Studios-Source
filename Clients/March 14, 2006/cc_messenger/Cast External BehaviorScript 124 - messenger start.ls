property pParentWindow

on new me, parentwindow
  pParentWindow = parentwindow
  return me
end

on mouseDown me
  stopEvent()
end

on mouseUp me
  global ElementMgr
  ElementMgr.getMessengerObject().openMyInfo()
  stopEvent()
end
