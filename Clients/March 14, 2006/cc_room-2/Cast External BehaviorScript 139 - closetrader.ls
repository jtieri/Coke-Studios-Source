global oStudio, ElementMgr

on new me
  return me
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  global ElementMgr, oStudio
  if the runMode = "author" then
    testval = 1
  else
    testval = 0
  end if
  testval = 0
  ElementMgr.getTrader().closeWindow()
  oStudio.sendCancelTrade(testval)
  dontPassEvent()
end
