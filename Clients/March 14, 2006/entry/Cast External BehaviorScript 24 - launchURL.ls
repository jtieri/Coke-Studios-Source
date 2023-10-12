property pWindowObject

on new me, windowobject
  pWindowObject = windowobject
  return me
end

on mouseUp me
  global launchWebURL, launchWebTarget
  gotoNetPage(launchWebURL, launchWebTarget)
  pWindowObject.closeWindow()
end
