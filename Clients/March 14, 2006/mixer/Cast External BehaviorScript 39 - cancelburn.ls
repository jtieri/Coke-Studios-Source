property pWindowObject

on new me, windowobject
  pWindowObject = windowobject
  return me
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  sendAllSprites(#closeCD)
  sendAllSprites(#setStatus, "BURN", #up)
  pWindowObject.closeWindow()
  dontPassEvent()
end
