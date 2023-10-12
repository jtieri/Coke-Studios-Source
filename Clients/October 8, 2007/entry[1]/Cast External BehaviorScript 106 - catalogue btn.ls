global ElementMgr, TextMgr, gFeatureSet

on new me
  return me
end

on mouseUp me
  if not gFeatureSet.isEnabled(#CATALOG) then
    ElementMgr.alert("FEATURE_DISABLED")
    return 
  end if
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n) contains "catalogue" then
      ElementMgr.pOpenWindows[n].closeWindow()
      exit repeat
      next repeat
    end if
    if n = count(ElementMgr.pOpenWindows) then
      ElementMgr.newwindow("catalogue.page1.window")
      updateStage()
      totalPages = ElementMgr.cataloguepages().count() - 1
      member("cc.catalogue.text.pagenum").text = TextMgr.GetRefText("CAT_PAGE") & ": 1/" & totalPages
      exit repeat
    end if
  end repeat
end
