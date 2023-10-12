property pMixNum, pParentWindow

on new me, parentwindow
  pParentWindow = parentwindow
  return me
end

on setmixtoburn me, mixnum
  pMixNum = mixnum
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  global oStudioManager, oDenizenManager
  sendAllSprites(#burnCD)
  oStudioManager.burnMixToCD(oDenizenManager.getScreenName(), pMixNum)
  pParentWindow.closeWindow()
  dontPassEvent()
end
