global ElementMgr, oDenizenManager, gFeatureSet

on new me
  return me
end

on mouseUp me
  if not gFeatureSet.isEnabled(#CHECK_DECIBELS) then
    ElementMgr.alert("FEATURE_DISABLED")
    return 
  end if
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n) = "cc_balance" then
      ElementMgr.pOpenWindows[n].closeWindow()
      exit repeat
      next repeat
    end if
    if n = count(ElementMgr.pOpenWindows) then
      ElementMgr.newwindow("cc.balance.window")
      myscreenname = oDenizenManager.getScreenName()
      oDenizenManager.getDenizenBalance(myscreenname)
      exit repeat
    end if
  end repeat
end
