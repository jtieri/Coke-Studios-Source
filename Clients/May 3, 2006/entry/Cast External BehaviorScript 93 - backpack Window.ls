property pStatus, pWindowObject, pDecalList, pRectDecal, pIndex, pItems, pcurrentpage, pTotalPages, pTotalItems
global oStudio

on new me, windowobject
  pStatus = #popup
  pWindowObject = windowobject
  pIndex = 1
  return me
end

on getBackpackCurrentPage me
  return me.pcurrentpage
end

on mouseDown me
  global ElementMgr
  if pStatus = #idle then
    if getPos(ElementMgr.pOpenWindows, pWindowObject) < count(ElementMgr.pOpenWindows) then
      pWindowObject.bringtofront()
    end if
    pDecalList = []
    repeat with n in pWindowObject.pSpritelist
      append(pDecalList, the clickLoc - sprite(n).loc)
    end repeat
    oldrect = pWindowObject.prect
    pRectDecal = rect(oldrect[1], oldrect[2], oldrect[3], oldrect[4]) - rect(sprite(me.spriteNum).left, sprite(me.spriteNum).top, sprite(me.spriteNum).left, sprite(me.spriteNum).top)
    pStatus = #drag
  end if
  stopEvent()
end

on getBackpackBackgroundSprite me
  return me.spriteNum
end

on mouseUp me
  if pStatus = #drag then
    pWindowObject.prect[1] = sprite(me.spriteNum).left + pRectDecal[1]
    pWindowObject.prect[2] = sprite(me.spriteNum).top + pRectDecal[2]
    pWindowObject.prect[3] = sprite(me.spriteNum).left + pRectDecal[3]
    pWindowObject.prect[4] = sprite(me.spriteNum).top + pRectDecal[4]
  end if
  pStatus = #idle
  stopEvent()
end

on mouseUpOutSide me
  if pStatus = #drag then
    pWindowObject.prect[1] = sprite(me.spriteNum).left + pRectDecal[1]
    pWindowObject.prect[2] = sprite(me.spriteNum).top + pRectDecal[2]
    pWindowObject.prect[3] = sprite(me.spriteNum).left + pRectDecal[3]
    pWindowObject.prect[4] = sprite(me.spriteNum).top + pRectDecal[4]
  end if
  pStatus = #idle
end

on exitFrame me
  global oPossessionManager, oDenizenManager
  if pStatus = #drag then
    pointloc = the mouseLoc
    if ((pointloc - pDecalList[1]).locH + sprite(me.spriteNum).width) > (the stage).rect.width then
      pointloc.locH = (the stage).rect.width - sprite(me.spriteNum).width + pDecalList[1].locH
    else
      if (pointloc - pDecalList[1]).locH < 0 then
        pointloc.locH = pDecalList[1].locH
      end if
    end if
    if ((pointloc - pDecalList[1]).locV + sprite(me.spriteNum).height) > (the stage).rect.height then
      pointloc.locV = (the stage).rect.height - sprite(me.spriteNum).height + pDecalList[1].locV
    else
      if (pointloc - pDecalList[1]).locV < 0 then
        pointloc.locV = pDecalList[1].locV
      end if
    end if
    repeat with n = 1 to count(pWindowObject.pSpritelist)
      delta = pDecalList[n]
      sprite(pWindowObject.pSpritelist[n]).loc = pointloc - delta
    end repeat
  else
    if pStatus = #popup then
      diff = (pWindowObject.prect[2] - 21) / 5.0
      if diff < 1 then
        pStatus = #idle
        myscreenname = oDenizenManager.getScreenName()
        oPossessionManager.getPossessionsInBackpack(myscreenname, 1, 25)
        sprite(pWindowObject.pSpritelist[count(pWindowObject.pSpritelist) - 1]).member = member("cc.backpack.front.down")
        sprite(pWindowObject.pSpritelist[count(pWindowObject.pSpritelist) - 1]).width = member("cc.backpack.front.down").width
        sprite(pWindowObject.pSpritelist[count(pWindowObject.pSpritelist) - 1]).height = member("cc.backpack.front.down").height
      else
        repeat with n in pWindowObject.pSpritelist
          sprite(n).locV = sprite(n).locV - diff
        end repeat
        pWindowObject.prect[2] = pWindowObject.prect[2] - diff
        pWindowObject.prect[4] = pWindowObject.prect[4] - diff
      end if
    else
      if pStatus = #popdown then
        diff = ((the stage).rect.height - pWindowObject.prect[2]) / 5.0
        sprite(pWindowObject.pSpritelist[count(pWindowObject.pSpritelist) - 1]).member = member("cc.backpack.front")
        sprite(pWindowObject.pSpritelist[count(pWindowObject.pSpritelist) - 1]).width = member("cc.backpack.front").width
        sprite(pWindowObject.pSpritelist[count(pWindowObject.pSpritelist) - 1]).height = member("cc.backpack.front").height
        if diff < 1 then
          pWindowObject.closeWindow()
        else
          repeat with n in pWindowObject.pSpritelist
            sprite(n).locV = sprite(n).locV + diff
          end repeat
          pWindowObject.prect[2] = pWindowObject.prect[2] + diff
          pWindowObject.prect[4] = pWindowObject.prect[4] + diff
        end if
      end if
    end if
  end if
end

on updatedisplay me
  global sLanguageSetting, TextMgr, ElementMgr
  if pTotalPages < 2 then
    pIndex = 1
    sendAllSprites(#hideleftarrow)
    sendAllSprites(#hiderightarrow)
    member("cc.pack.pagecount").text = EMPTY
  else
    sendAllSprites(#showleftarrow)
    sendAllSprites(#showrightarrow)
    mytemplate = TextMgr.GetRefText("USER_ITEMS_PAGE")
    mychar = offset("{num1}", mytemplate)
    delete char mychar to mychar + 5 of mytemplate
    put me.pcurrentpage & " " into char mychar of mytemplate
    mychar = offset("{num2}", mytemplate)
    delete char mychar to mychar + 5 of mytemplate
    put pTotalPages into char mychar of mytemplate
    member("cc.pack.pagecount").text = mytemplate
  end if
  repeat with n = 1 to 25
    sprite(pWindowObject.pSpritelist[n + 3]).member = member("room_object_placeholder_sd")
    sprite(pWindowObject.pSpritelist[n + 3]).width = 1
    sprite(pWindowObject.pSpritelist[n + 3]).height = 1
  end repeat
  catalogueitems = ElementMgr.getcatalogueitems()
  repeat with n = 1 to min(count(pItems), 25)
    myitem = pItems[n]
    myProdID = myitem.prodID
    if catalogueitems[myProdID].prodID <> myProdID then
      repeat with m = 1 to count(catalogueitems)
        myList = catalogueitems[m]
        if myList.prodID = myProdID then
          exit repeat
        end if
      end repeat
    else
      myList = catalogueitems[myProdID]
    end if
    myImgBase = myList.imageBase
    if voidp(myList.attributes[#color_small]) = 0 then
      myColor = rgb(myList.attributes[#color_small])
    else
      myColor = rgb(255, 255, 255)
    end if
    myPosId = myitem.posId
    sprite(pWindowObject.pSpritelist[n + 3]).bgColor = myColor
    sprite(pWindowObject.pSpritelist[n + 3]).ink = 36
    if myList[#type] = "Separator" then
      sprite(pWindowObject.pSpritelist[n + 3]).ink = 41
    end if
    sprite(pWindowObject.pSpritelist[n + 3]).member = member(myImgBase & "_small")
    sprite(pWindowObject.pSpritelist[n + 3]).pname = myList.name
    sprite(pWindowObject.pSpritelist[n + 3]).pProdID = myProdID
    sprite(pWindowObject.pSpritelist[n + 3]).pPosId = myPosId
    sprite(pWindowObject.pSpritelist[n + 3]).aAttributes = myitem[#attributes]
    sprite(pWindowObject.pSpritelist[n + 3]).width = member(myImgBase & "_small").width
    sprite(pWindowObject.pSpritelist[n + 3]).height = member(myImgBase & "_small").height
  end repeat
end
