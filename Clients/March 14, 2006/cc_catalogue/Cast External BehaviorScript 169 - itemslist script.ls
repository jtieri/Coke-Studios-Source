property pCatID, pItemsList, pitemsData, pwidth, pheight, pDisplayLines, pLineSpace, pPreviousData, pScrollImg, pScrollIndex, pcurrentpage

on new me, numwidth, numheight
  global ElementMgr
  pwidth = numwidth
  pheight = numheight
  the itemDelimiter = ":"
  currentpage = member("cc.catalogue.text.pagenum").text.item[2]
  the itemDelimiter = "/"
  pcurrentpage = integer(currentpage.item[1]) + 1
  the itemDelimiter = ","
  PageList = ElementMgr.cataloguepages()
  pCatID = PageList[pcurrentpage][#catId]
  pItemsList = ElementMgr.getcatalogueitems(pCatID)
  pLineSpace = 14
  pScrollIndex = 1
  displayloading(me)
  return me
end

on displayloading me
  global gMembersToDelete, TextMgr, oCatalogManager
  pitemsData = []
  pDisplayLines = pheight / pLineSpace
  put "pDisplayLines: " & pDisplayLines
  if member("itemslist").memberNum < 1 then
    listmember = new(#text)
    listmember.name = "itemslist"
    append(gMembersToDelete, listmember)
  else
    listmember = member("itemslist")
  end if
  listmember.boxType = #fixed
  listmember.color = rgb("#6C472D")
  listmember.fontSize = 10
  listmember.fontStyle = [#bold]
  listmember.rect = rect(0, 0, pwidth, pheight)
  listmember.font = "verdana"
  listmember.alignment = #center
  listmember.fixedLineSpace = pLineSpace
  mytext = EMPTY
  repeat with n = 1 to pDisplayLines / 2
    mytext = mytext & RETURN
  end repeat
  mytext = mytext & TextMgr.GetRefText("LOADING")
  listmember.text = mytext
  destimg = image(pwidth, pheight, the colorDepth)
  destimg.copyPixels(listmember.image.duplicate(), rect(0, 0, pwidth, pheight), rect(0, 0, pwidth, pheight))
  member("itemsdisplay").image = destimg
  member("itemsdisplay").regPoint = point(0, 0)
end

on updatecontent me
  global ElementMgr
  the itemDelimiter = ":"
  currentpage = member("cc.catalogue.text.pagenum").text.item[2]
  the itemDelimiter = "/"
  pcurrentpage = integer(currentpage.item[1]) + 1
  the itemDelimiter = ","
  PageList = ElementMgr.cataloguepages()
  pCatID = PageList[pcurrentpage][#catId]
  pItemsList = ElementMgr.getcatalogueitems(pCatID)
  if pPreviousData <> pitemsData then
    createimg(me)
  end if
  listmember = member("itemslist")
  if pScrollImg.height > pheight then
    destimg = image(pwidth, pheight, the colorDepth)
    sourceRect = rect(0, (pScrollIndex - 1) * pLineSpace, pwidth, ((pScrollIndex - 1) * pLineSpace) + pheight)
    destrect = destimg.rect
    destimg.copyPixels(pScrollImg, destrect, sourceRect)
    member("itemsdisplay").image = destimg
  else
    member("itemsdisplay").image = pScrollImg
  end if
  member("itemsdisplay").regPoint = point(0, 0)
end

on createimg me
  displaylist = []
  repeat with n in pitemsData
    myProdID = n[#prodID]
    repeat with myitem in pItemsList
      if myitem[#prodID] = myProdID then
        myitem[#price] = n[#price]
        append(displaylist, myitem)
        exit repeat
      end if
    end repeat
  end repeat
  destimage = image(pwidth, pheight, the colorDepth)
  member("itemslist").boxType = #adjust
  member("itemslist").fixedLineSpace = 12
  member("itemslist").alignment = #left
  member("itemslist").rect = rect(0, 0, pwidth - 44, 200)
  put "displayList count: " & count(displaylist)
  repeat with i = 1 to 8
    sendAllSprites(#showBuyButton, i, 0)
  end repeat
  repeat with n = 1 to count(displaylist)
    if voidp(displaylist[n].attributes[#color_small]) = 0 then
      mycolor = rgb(displaylist[n].attributes[#color_small])
    else
      mycolor = rgb(255, 255, 255)
    end if
    if member(displaylist[n][#imageBase] & "_small").memberNum > 0 then
      myImage = member(displaylist[n][#imageBase] & "_small").image.duplicate()
      destrect = rect((32 - myImage.width) / 2, (n - 1) * 36, ((32 - myImage.width) / 2) + myImage.width, ((n - 1) * 36) + myImage.height)
      mymatte = myImage.createMatte()
      destimage.copyPixels(myImage, destrect, myImage.rect, [#maskImage: mymatte, #bgColor: mycolor])
      myname = displaylist[n][#catDesc]
      myprice = displaylist[n][#price]
      member("itemslist").text = myname && "-" && myprice && "dB"
      textimg = member("itemslist").image.duplicate()
      destrect = rect(40, (n - 1) * 36, textimg.width + 40, ((n - 1) * 36) + textimg.height)
      destimage.copyPixels(textimg, destrect, textimg.rect)
      sendAllSprites(#showBuyButton, n, 1)
    end if
  end repeat
  pScrollImg = destimage
end
