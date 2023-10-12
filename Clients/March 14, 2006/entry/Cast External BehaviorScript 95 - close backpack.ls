property pWindowObject

on new me, windowobject
  pWindowObject = windowobject
  return me
end

on mouseDown me
  stopEvent()
end

on mouseUp me
  sprite(pWindowObject.pSpritelist[2]).pStatus = #popdown
  stopEvent()
end
