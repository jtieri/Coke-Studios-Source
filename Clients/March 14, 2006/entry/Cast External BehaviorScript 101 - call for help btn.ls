on new me
  return me
end

on mouseUp me
  global ElementMgr, gFeatureSet
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n) = "cc_call_for_help" then
      ElementMgr.pOpenWindows[n].closeWindow()
      exit repeat
      next repeat
    end if
    if n = count(ElementMgr.pOpenWindows) then
      ElementMgr.newwindow("cc.call_for_help.window")
      exit repeat
    end if
  end repeat
end
