on new me
  return me
end

on mouseUp me
  global ElementMgr, oDenizenManager, oPossessionManager, gFeatureSet
  if not gFeatureSet.isEnabled(#BACKPACK) then
    ElementMgr.alert("FEATURE_DISABLED")
    return 
  end if
  oBackPack = oDenizenManager.getBackpack()
  if voidp(oBackPack) then
    return 
  end if
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n) = "cc_backpack" then
      sprite(ElementMgr.pOpenWindows[n].pSpritelist[2]).pStatus = #popdown
      exit repeat
      next repeat
    end if
    if n = count(ElementMgr.pOpenWindows) then
      ElementMgr.newwindow("cc.backpack.window")
      exit repeat
    end if
  end repeat
end
