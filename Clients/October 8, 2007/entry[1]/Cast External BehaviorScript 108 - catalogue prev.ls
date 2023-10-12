property pParentWindow

on new me, parentwindow
  pParentWindow = parentwindow
  return me
end

on mouseUp me
  global ElementMgr, TextMgr, gWalls, gFloors, oCatalogManager
  the updateLock = 1
  the itemDelimiter = ":"
  currentpage = member("cc.catalogue.text.pagenum").text.item[2]
  the itemDelimiter = "/"
  currentpage = integer(currentpage.item[1]) - 1
  the itemDelimiter = ","
  PageList = ElementMgr.cataloguepages()
  if currentpage < 1 then
    currentpage = PageList.count() - 1
  end if
  member("cc.catalogue.text.pagenum").text = TextMgr.GetRefText("CAT_PAGE") & ":" && currentpage & "/" & PageList.count() - 1
  myRect = pParentWindow.prect
  if currentpage > 2 then
    if currentpage = 15 then
      pParentWindow.closeWindow()
      ElementMgr.newwindow("catalogue.pagedynamic.window", myRect)
      member("cc.catalogue.text.pagenum").text = TextMgr.GetRefText("CAT_PAGE") & ":" && currentpage & "/" & PageList.count() - 1
      oCatalogManager.getProductList()
    else
      member("cc.catalogue.text.pagenum").text = TextMgr.GetRefText("CAT_PAGE") & ":" && currentpage & "/" & PageList.count() - 1
      ElementMgr.pOpenWindows.catalogue_pagedynamic.pScrollingLists.itemslist.updatecontent()
    end if
    repeat with n = 1 to count(PageList)
      if PageList[n][#page] = currentpage then
        mypage = PageList[n][#catId]
        exit repeat
      end if
    end repeat
    member("catalogue_dyntitle2").text = TextMgr.GetRefText("cat_" & mypage & "_title")
    member("cc.catalogue.text3.infotext").text = TextMgr.GetRefText("cat_" & mypage & "_desc")
  else
    pParentWindow.closeWindow()
    ElementMgr.newwindow("catalogue.page" & currentpage & ".window", myRect)
  end if
  member("cc.catalogue.text.pagenum").text = TextMgr.GetRefText("CAT_PAGE") & ":" && currentpage & "/" & PageList.count() - 1
  the updateLock = 0
end
