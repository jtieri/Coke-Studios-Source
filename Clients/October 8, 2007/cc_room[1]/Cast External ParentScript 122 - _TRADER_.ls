property traderstuff, tradeestuff
global ElementMgr, oPossessionManager, oDenizenManager

on new me
  me.openWindow("sanfo_trading.window")
  return me
end

on openWindow me, sID, oArg
  myRect = me.closeWindow()
  MyWindow = ElementMgr.newwindow(sID, myRect)
  me.displayWindow(MyWindow, oArg)
end

on closeWindow me
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n) contains "trading" then
      MyWindow = ElementMgr.pOpenWindows[n]
      exit repeat
    end if
  end repeat
  if voidp(MyWindow) then
    return 
  end if
  iLastRect = MyWindow.closeWindow()
  return iLastRect
end

on getOpenWindow me
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n) contains "trading" then
      MyWindow = ElementMgr.pOpenWindows[n]
      return MyWindow
      exit repeat
    end if
  end repeat
end

on displayWindow me, MyWindow, oArg
  global gCatalog, TextMgr, gMembersToDelete
  if voidp(oArg) = 0 then
    rightcheckbox = sendAllSprites(#getrightcheckbox)
    leftcheckbox = sendAllSprites(#getleftcheckbox)
    if oArg.trader = oDenizenManager.getScreenName() then
      leftego = oArg.tradee
      leftitems = oArg.tradeeItems
      rightego = oArg.trader
      rightitems = oArg.traderItems
      mycheckbox = oArg.traderAgrees
      hischeckbox = oArg.tradeeAgrees
    else
      leftego = oArg.trader
      leftitems = oArg.traderItems
      rightego = oArg.tradee
      rightitems = oArg.tradeeItems
      mycheckbox = oArg.tradeeAgrees
      hischeckbox = oArg.traderAgrees
    end if
    myphrase = TextMgr.GetRefText("TRADER_BOX_DESC")
    mychar = offset("{tradername}", myphrase)
    delete char mychar to mychar + length("tradername}") of myphrase
    put leftego & " " into char mychar of myphrase
    member("cc.tradingtext1").text = myphrase
    myphrase = TextMgr.GetRefText("TRADER_AGREES")
    mychar = offset("{tradername}", myphrase)
    delete char mychar to mychar + length("tradername}") of myphrase
    put leftego & " " into char mychar of myphrase
    member("cc.tradingtext3").text = myphrase
    if mycheckbox then
      sprite(rightcheckbox).member = member("cc.interface.checkbox.active.on")
    else
      sprite(rightcheckbox).member = member("cc.interface.checkbox.active.off")
    end if
    if hischeckbox then
      sprite(leftcheckbox).member = member("cc.interface.checkbox.active.on")
    else
      sprite(leftcheckbox).member = member("cc.interface.checkbox.active.off")
    end if
    rightslots = [sendAllSprites(#getrightslot1), sendAllSprites(#getrightslot2), sendAllSprites(#getrightslot3), sendAllSprites(#getrightslot4), sendAllSprites(#getrightslot5), sendAllSprites(#getrightslot6)]
    DefList = []
    repeat with n = 1 to count(rightitems)
      append(DefList, gCatalog.getItemByProdId(rightitems[n]))
    end repeat
    repeat with n = 1 to count(DefList)
      if member("mybox" & n).memberNum < 1 then
        myMember = new(#bitmap)
        append(gMembersToDelete, myMember)
        myMember.name = "mybox" & n
      end if
      baseimg = member("tradingbox").image.duplicate()
      itemmember = member(DefList[n].imageBase & "_small")
      itemimg = itemmember.image.duplicate()
      sourceRect = itemimg.rect
      leftpix = (baseimg.width - itemimg.width) / 2
      toppix = (baseimg.height - itemimg.height) / 2
      destRect = rect(leftpix, toppix, leftpix + itemimg.width, toppix + itemimg.height)
      baseimg.copyPixels(itemimg, destRect, sourceRect)
      member("mybox" & n).image = baseimg
      member("mybox" & n).regPoint = point(0, 0)
      sprite(rightslots[n]).member = member("mybox" & n)
      sprite(rightslots[n]).pContent = DefList[n]
    end repeat
    leftslots = [sendAllSprites(#getleftslot1), sendAllSprites(#getleftslot2), sendAllSprites(#getleftslot3), sendAllSprites(#getleftslot4), sendAllSprites(#getleftslot5), sendAllSprites(#getleftslot6)]
    DefList = []
    repeat with n = 1 to count(leftitems)
      append(DefList, gCatalog.getItemByProdId(leftitems[n]))
    end repeat
    repeat with n = 1 to count(DefList)
      if member("hisbox" & n).memberNum < 1 then
        myMember = new(#bitmap)
        append(gMembersToDelete, myMember)
        myMember.name = "hisbox" & n
      end if
      if voidp(DefList[n].attributes[#color_small]) = 0 then
        myColor = rgb(DefList[n].attributes[#color_small])
      else
        myColor = rgb(255, 255, 255)
      end if
      baseimg = member("tradingbox").image.duplicate()
      itemmember = member(DefList[n].imageBase & "_small")
      itemimg = itemmember.image.duplicate()
      mymatte = itemimg.createMatte()
      sourceRect = itemimg.rect
      leftpix = (baseimg.width - itemimg.width) / 2
      toppix = (baseimg.height - itemimg.height) / 2
      destRect = rect(leftpix, toppix, leftpix + itemimg.width, toppix + itemimg.height)
      baseimg.copyPixels(itemimg, destRect, sourceRect, [#maskImage: mymatte, #bgColor: myColor])
      member("hisbox" & n).image = baseimg
      member("hisbox" & n).regPoint = point(0, 0)
      sprite(leftslots[n]).member = member("hisbox" & n)
      sprite(leftslots[n]).pContent = DefList[n]
    end repeat
  end if
end
