property pWindowObject
global oStudio

on new me, windowobject
  pWindowObject = windowobject
  return me
end

on mouseUp me
  global oDenizenManager, ElementMgr, gFeatureSet
  if not gFeatureSet.isEnabled(#CALL_FOR_HELP) then
    ElementMgr.alert("FEATURE_DISABLED")
    return 
  end if
  mytext = member("cc_callfield").text
  oStudio.sendCallForHelp(mytext)
  if mytext <> EMPTY then
    pWindowObject.closeWindow()
    ElementMgr.newwindow("cc_callsent.window")
  end if
end
