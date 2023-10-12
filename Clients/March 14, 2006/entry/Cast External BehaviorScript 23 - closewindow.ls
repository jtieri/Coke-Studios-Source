property pWindowObject

on new me, windowobject
  pWindowObject = windowobject
  return me
end

on mouseUp me
  pWindowObject.closeWindow()
end
