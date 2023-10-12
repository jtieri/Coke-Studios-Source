property pname, aAttributes, pProdID, pPosId, bDebug
global gCatalog, oIsoScene, oStudioMap, oRoom, oStudio, oDenizenManager, ElementMgr

on new me
  bDebug = 0
  return me
end

on mouseDown me
  bIsOwner = oStudio.isOwner(oDenizenManager.getScreenName())
  bTrading = not voidp(ElementMgr.getTrader())
  if not bIsOwner and not bTrading then
    put "CANNOT PUT ITEM DOWN"
    return 
  end if
  if not oStudioMap.isPrivate() and not bTrading then
    return 
  end if
  oSelectedItem = oIsoScene.getSelectedItem()
  if not voidp(oSelectedItem) then
    if oSelectedItem.getDrag() then
      return 
    end if
  end if
  if not oIsoScene.checkMaxItemsExceeded() then
    return 
  end if
  oItem = gCatalog.getItemByProdId(me.pProdID)
  sImageBase = oItem[#imageBase]
  sType = oItem[#type]
  sAction = oItem[#Action]
  iState = oItem[#state]
  iHeight = oItem[#height]
  if voidp(iHeight) then
    iHeight = 0
  end if
  iHeightOffset = 0
  bItemsAllowedOnTop = oItem[#itemsAllowedOnTop]
  if voidp(bItemsAllowedOnTop) then
    bItemsAllowedOnTop = 0
  end if
  if voidp(me.aAttributes) then
    _aAttributes = oItem[#attributes]
  else
    _aAttributes = me.aAttributes
  end if
  sCastLib = "Furniture"
  iRow = VOID
  iCol = VOID
  iGridY = VOID
  iDirection = 2
  if oStudioMap.isPrivate() then
    me.debug("CAN'T PLACE WALLPAPER IN WAYNE ENT", 1)
    if oStudioMap.isWayneEnt() and (sType = "Wallpaper") then
      return 
    end if
  end if
  put "wayne enterprises check done"
  put "props = " && pProdID && pPosId && sImageBase && sType && sAction && iState && aAttributes && sCastLib && iRow && iCol && iGridY && iDirection && iHeight && iHeightOffset && bItemsAllowedOnTop
  oFurniItem = oIsoScene.createItem(me.pProdID, me.pPosId, sImageBase, sType, sAction, iState, _aAttributes, sCastLib, iRow, iCol, iGridY, iDirection, iHeight, iHeightOffset, bItemsAllowedOnTop)
  put "oFurniItem created"
  oIsoScene.setSelectedItem(oFurniItem, 0)
  put "oFurniItem selected"
  oIsoScene.moveSelectedItem(1)
  put "moved selected item"
  stopEvent()
end

on mouseUp me
  stopEvent()
end

on displayRollover me, bState
  sDisplay = me.pname
  if bState then
    if me.pProdID = oIsoScene.oIsoConstants.BURNED_CD then
      sDisplay = me.aAttributes[#ownerName] & ": " & me.aAttributes[#songName]
    end if
    if me.pProdID = oIsoScene.oIsoConstants.TELEPORTER then
      sDestinationName = me.aAttributes[#destinationName]
      if not voidp(sDestinationName) and (sDestinationName <> EMPTY) then
        sDisplay = aAttributes[#destinationOwner] & ": " & aAttributes[#destinationName]
      end if
    end if
  end if
  if voidp(sDisplay) then
    sDisplay = EMPTY
  end if
  member("cc.pack.rollover.text").text = string(sDisplay)
end

on mouseEnter me
  me.displayRollover(1)
end

on mouseLeave me
  me.displayRollover(0)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "entry::backpack item script::" & sMessage
  end if
end
