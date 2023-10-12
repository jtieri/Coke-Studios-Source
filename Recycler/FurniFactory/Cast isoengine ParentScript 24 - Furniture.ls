property aItems
global oIsoScene

on new me
  me.aItems = []
  return me
end

on init me, oXml
  if voidp(oXml) then
    return 
  end if
  sXmlString = oXml.toString()
  if sXmlString contains "castLib=" then
    sCastLib = oXml.attributes.castLib
  else
    sCastLib = "Furniture"
  end if
  aFurniItems = getNodes(oXml, "Item")
  repeat with i = 1 to aFurniItems.count
    oItem = aFurniItems[i]
    sXmlString = oItem.toString()
    if sXmlString contains "prodId=" then
      sProdID = oItem.attributes.prodID
    else
      sProdID = VOID
    end if
    if sXmlString contains "posId=" then
      sPosId = oItem.attributes.posId
    else
      sPosId = VOID
    end if
    if sXmlString contains "state=" then
      iState = integer(oItem.attributes.state)
    else
      iState = 0
    end if
    if sXmlString contains "attributes=" then
      aAttributes = value(oItem.attributes.attributes)
    else
      aAttributes = [:]
    end if
    if sXmlString contains "gridZ=" then
      iRow = integer(oItem.attributes.gridZ)
    else
      return 
    end if
    if sXmlString contains "gridY=" then
      iGridY = integer(oItem.attributes.gridY)
    else
      iGridY = 0
    end if
    if sXmlString contains "gridX=" then
      iCol = integer(oItem.attributes.gridX)
    else
      return 
    end if
    if sXmlString contains "dir=" then
      iDirection = integer(oItem.attributes.dir)
    else
      iDirection = 2
    end if
    if not voidp(sProdID) then
      aCatalogueItem = me.getCatalogueItem(sProdID)
      sImageBase = aCatalogueItem.imageBase
      sType = aCatalogueItem.type
      sAction = aCatalogueItem.Action
    else
      if sXmlString contains "imageBase=" then
        sImageBase = oItem.attributes.imageBase
      else
        return 
      end if
      if sXmlString contains "type=" then
        sType = oItem.attributes.type
      else
        sType = "Default"
      end if
      if sXmlString contains "action=" then
        sAction = oItem.attributes.Action
      else
        sAction = "Default"
      end if
    end if
    oIsoScene.createItem(sProdID, sPosId, sImageBase, sType, sAction, iState, aAttributes, sCastLib, iRow, iCol, iGridY, iDirection)
  end repeat
end

on getTotalItems me
  return me.aItems.count
end

on getCatalogueItem me, sProdID
  global gCatalogue
  repeat with i = 1 to gCatalogue.count
    aCatalogueItem = gCatalogue[i]
    if aCatalogueItem.prodID = sProdID then
      return aCatalogueItem
    end if
  end repeat
end

on updateAll me
  repeat with oItem in me.aItems
    oItem.update()
  end repeat
end

on updateItemByPosId me, sPosId
  repeat with oItem in me.aItems
    if oItem.sPosId = sPosId then
      oItem.update()
      return 
    end if
  end repeat
end

on updateItem me, oItem
  oItem.update()
end

on addItem me, oItem
  me.aItems.add(oItem)
end

on removeItem me, oItem
  oItem.destroy()
  me.aItems.deleteOne(oItem)
end

on removeAll me
  oIsoScene.deleteSelectedItem()
  repeat with i = 1 to me.aItems.count
    oItem = me.aItems[i]
    oItem.destroy()
  end repeat
  me.aItems = []
end

on destroy me
  oIsoScene.deleteSelectedItem()
  repeat with i = 1 to me.aItems.count
    oItem = me.aItems[i]
    oItem.destroy()
  end repeat
  me.aItems = []
end

on toggleDisplay me
  repeat with i in me.aItems
    i.toggleDisplay()
  end repeat
end

on containsSeatableItems me, _aItems
  repeat with oItem in _aItems
    if me.isSeatableItem(oItem) then
      return 1
    end if
  end repeat
  return 0
end

on isSeatableItem me, oItem
  if (oItem.getType() = "Chair") or (oItem.getType() = "Sofa") or (oItem.getType() = "Stool") then
    return 1
  else
    return 0
  end if
end

on getItemsAtSquaresExcept me, _aSquares, _oItem
  aList = []
  repeat with oSquare in _aSquares
    _aItems = me.getItemsAtSquare(oSquare)
    repeat with oItem in _aItems
      if oItem.equals(_oItem) then
        next repeat
      end if
      iPos = aList.getPos(oItem)
      if iPos = 0 then
        aList.add(oItem)
      end if
    end repeat
  end repeat
  return aList
end

on getItemsAtSquare me, oSquare
  aList = []
  repeat with oItem in me.aItems
    if oItem.existsAtSquare(oSquare) then
      aList.add(oItem)
    end if
  end repeat
  return aList
end

on getItemsAtSquareExcept me, oSquare, _oItem
  aList = []
  repeat with oItem in me.aItems
    if oItem.equals(_oItem) then
      next repeat
    end if
    if oItem.existsAtSquare(oSquare) then
      aList.add(oItem)
    end if
  end repeat
  return aList
end

on getGreatestNumberOfItemsForSquares me, aSquares
  iCount = 0
  repeat with oSquare in aSquares
    _aItems = me.getItemsAtSquare(oSquare)
    iCount = iCount + _aItems.count()
  end repeat
  return iCount
end

on getGreatestGridYForSquaresExcept me, aSquares, oItem
  iGreatestGridY = 0
  repeat with oSquare in aSquares
    iItemGridY = me.getGreatestGridYForSquareExcept(oSquare, oItem)
    if iItemGridY > iGreatestGridY then
      iGreatestGridY = iItemGridY
    end if
  end repeat
  return iGreatestGridY
end

on getGreatestGridYForSquareExcept me, oSquare, _oItem
  iGreatestGridY = 0
  _aItems = me.getItemsAtSquareExcept(oSquare, _oItem)
  repeat with oItem in _aItems
    if oItem.equals(_oItem) then
      next repeat
    end if
    iItemGridY = oItem.getGridY()
    if iItemGridY > iGreatestGridY then
      iGreatestGridY = iItemGridY
    end if
  end repeat
  return iGreatestGridY
end

on getGreatestHeightForSquares me, aSquares
  iGreatestHeight = 0
  repeat with oSquare in aSquares
    iHeight = me.getGreatestHeightAtSquare(oSquare)
    if iHeight > iGreatestHeight then
      iGreatestHeight = iHeight
    end if
  end repeat
  return iGreatestHeight
end

on getGreatestHeightForSquaresExcept me, aSquares, oItem
  iGreatestHeight = 0
  repeat with oSquare in aSquares
    iHeight = me.getGreatestHeightAtSquareExcept(oSquare, oItem)
    if iHeight > iGreatestHeight then
      iGreatestHeight = iHeight
    end if
  end repeat
  return iGreatestHeight
end

on getGreatestHeightAtSquareExcept me, oSquare, _oItem
  iGreatestHeight = 0
  _aItems = me.getItemsAtSquareExcept(oSquare, _oItem)
  repeat with oItem in _aItems
    if oItem.equals(_oItem) then
      next repeat
    end if
    iHeight = oItem.getHeightOffset() + oItem.getHeight()
    if iHeight > iGreatestHeight then
      iGreatestHeight = iHeight
    end if
  end repeat
  return iGreatestHeight
end

on getGreatestHeightAtSquare me, oSquare
  iGreatestHeight = 0
  _aItems = me.getItemsAtSquare(oSquare)
  repeat with oItem in _aItems
    iHeight = oItem.getHeightOffset() + oItem.getHeight()
    iGreatestHeight = iGreatestHeight + iHeight
  end repeat
  return iGreatestHeight
end

on getItemsAtSquareByHeightExcept me, oSquare, _oItem, iHeight
  aList = []
  repeat with oItem in me.aItems
    if oItem.equals(_oItem) then
      next repeat
    end if
    if oItem.existsAtSquare(oSquare) then
      if oItem.getGridY() = iHeight then
        aList.add(oItem)
      end if
    end if
  end repeat
  return aList
end

on getItemsAtSquaresInHeightRangeExcept me, aSquares, _oItem, iLow, iHi
  aItemsInRange = []
  repeat with oSquare in aSquares
    _aItems = me.getItemsAtSquareInHeightRangeExcept(oSquare, _oItem, iLow, iHi)
    repeat with oItem in _aItems
      aItemsInRange.add(oItem)
    end repeat
  end repeat
  return aItemsInRange
end

on getItemsAtSquareInHeightRangeExcept me, oSquare, _oItem, iLow, iHi
  aItemsInRange = []
  _aItems = me.getItemsAtSquareExcept(oSquare, _oItem)
  repeat with oItem in _aItems
    iItemLow = oItem.getHeightOffset()
    iItemHi = iItemLow + oItem.getHeight()
    if iItemLow = iLow then
      aItemsInRange.add(oItem)
      next repeat
    end if
    if (iItemLow > iLow) and (iItemHi <= iHi) then
      aItemsInRange.add(oItem)
      next repeat
    end if
    if (iItemLow < iLow) and (iItemHi >= iHi) then
      aItemsInRange.add(oItem)
      next repeat
    end if
  end repeat
  return aItemsInRange
end

on getItemAtSquareWithGreatestHeightOffset me, oSquare
  _aItems = me.getItemsAtSquare(oSquare)
  if _aItems.count = 0 then
    return VOID
  end if
  oItem = me.getItemWithGreatestHeightOffset(_aItems)
  return oItem
end

on getSeatableItemAtSquareWithGreatestHeightOffset me, oSquare
  aSeatableItems = me.getSeatableItemsAtSquare(oSquare)
  oItem = me.getItemWithGreatestHeightOffset(aSeatableItems)
  return oItem
end

on getSeatableItemsAtSquare me, oSquare
  _aSeatableItems = []
  _aItems = me.getItemsAtSquare(oSquare)
  if _aItems.count = 0 then
    return _aSeatableItems
  end if
  repeat with oItem in _aItems
    if me.isSeatableItem(oItem) then
      _aSeatableItems.add(oItem)
    end if
  end repeat
  return _aSeatableItems
end

on getItemWithGreatestHeightOffset me, _aItems
  if _aItems.count = 0 then
    return VOID
  end if
  _oItem = _aItems[1]
  iGreatestHeight = 0
  repeat with i = 1 to _aItems.count
    oItem = _aItems[i]
    iItemHeightOfset = oItem.getHeightOffset()
    if iItemHeightOfset > iGreatestHeight then
      iGreatestHeight = iItemHeightOfset
      _oItem = oItem
    end if
  end repeat
  return _oItem
end

on seatableItemInList me, _aItems
  repeat with i in _aItems
    if i.getSeatable() then
      return 1
    end if
  end repeat
  return 0
end

on getItemByPossessionId me, iPosId
  repeat with i in me.aItems
    if i.getPosId() = iPosId then
      return i
    end if
  end repeat
end

on generateXml me
  oXml = newObject("XML")
  oRoot = oXml.createElement("Furniture")
  repeat with i = 1 to me.aItems.count
    oItem = me.aItems[i]
    oNode = oXml.createElement("Item")
    if not voidp(oItem.sProdID) then
      oNode.attributes.prodID = oItem.sProdID
    end if
    if not voidp(oItem.sPosId) then
      oNode.attributes.posId = oItem.sPosId
    end if
    oNode.attributes.state = oItem.iState
    oNode.attributes.attributes = string(oItem.aAttributes)
    oNode.attributes.gridX = oItem.iCol
    oNode.attributes.gridY = oItem.iGridY
    oNode.attributes.gridZ = oItem.iRow
    oNode.attributes.dir = oItem.iDirection
    oRoot.appendChild(oNode)
  end repeat
  return oRoot
end

on getItemsUnderMouse me, aItemsUnderMouse
  if voidp(aItemsUnderMouse) then
    aItemsUnderMouse = []
  end if
  repeat with i in me.aItems
    if i.mouseIsOverITem() then
      aItemsUnderMouse.add(i)
    end if
  end repeat
  return aItemsUnderMouse
end

on getSpritesUnderMouse me, aSpritesUnderMouse
  if voidp(aSpritesUnderMouse) then
    aSpritesUnderMouse = [:]
  end if
  repeat with i in me.aItems
    aItemSprites = i.getSpritesUnderMouse()
    repeat with x = 1 to aItemSprites.count()
      _iZ = aItemSprites.getPropAt(x)
      _iSprite = aItemSprites[x]
      aSpritesUnderMouse.addProp(_iZ, _iSprite)
    end repeat
  end repeat
  return aSpritesUnderMouse
end

on getObjectsUnderMouse me, aObjectsUnderMouse
  repeat with i in me.aItems
    bRollover = i.rolloverObject()
    if bRollover then
      _iZ = i.getHighestDepth()
      aObjectsUnderMouse.addProp(_iZ, i)
    end if
  end repeat
  return aObjectsUnderMouse
end

on getTeleporterAtSquare me, oSquare
  if voidp(oSquare) then
    return VOID
  end if
  _aItems = me.getItemsAtSquare(oSquare)
  repeat with i in _aItems
    if i.getType() = "Teleport" then
      return i
    end if
  end repeat
  return VOID
end
