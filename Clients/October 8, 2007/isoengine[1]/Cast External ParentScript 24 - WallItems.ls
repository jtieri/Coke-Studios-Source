property aItems, aSpritePool, aSpritePoolSource, iPoolMax, iDepthLow, iDepthHi
global oIsoScene

on new me
  me.aItems = []
  me.iPoolMax = 75
  me.aSpritePoolSource = []
  me.aSpritePool = []
  return me
end

on Init me, oXml
  if voidp(oXml) then
    return 
  end if
  me.aSpritePoolSource = oIsoScene.oSpriteManager.getPooledSprites(me.iPoolMax)
  me.iDepthLow = sprite(me.aSpritePoolSource[1]).locZ
  me.iDepthHi = me.iDepthLow + (me.aSpritePoolSource.count - 1)
  aWallItems = getNodes(oXml, "Item")
  repeat with i = 1 to aWallItems.count
    oItem = aWallItems[i]
    sProdID = oItem.attributes.prodID
    sPosId = oItem.attributes.posId
    iState = integer(oItem.attributes.state)
    aAttributes = value(oItem.attributes.attributes)
    iX = integer(oItem.attributes.gridX)
    iY = integer(oItem.attributes.gridY)
    aCatalogueItem = me.getCatalogueItem(sProdID)
    sImageBase = aCatalogueItem.imageBase
    sType = aCatalogueItem.type
    sAction = aCatalogueItem.Action
    sCastLib = VOID
    oIsoScene.createItem(sProdID, sPosId, sImageBase, sType, sAction, iState, aAttributes, sCastLib, iX, VOID, iY, VOID)
  end repeat
end

on getTotalItems me
  return me.aItems.count
end

on drawAll me, bForce
  repeat with i = 1 to me.aItems.count
    oItem = me.aItems[i]
    oItem.draw(bForce)
  end repeat
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

on setDepthsByPos me
  aDirtyItems = []
  iCount = me.aItems.count
  if iCount = 0 then
    return aDirtyItems
  end if
  repeat with iCurrPos = 1 to iCount
    oItem = me.aItems[iCurrPos]
    iZ = oItem.getGridZ()
    iRealPos = me.getPosByDepth(oItem)
    iRealDepth = me.getDepthByPos(iCurrPos)
    if iCurrPos <> iRealPos then
      oItem.setZPos(iRealDepth)
      aDirtyItems.add(oItem)
    end if
  end repeat
  return aDirtyItems
end

on getPosByDepth me, oItem
  iZ = oItem.getGridZ()
  iPos = iZ - me.iDepthLow + 1
  return iPos
end

on getDepthByPos me, iPos
  iDepth = me.iDepthLow + (iPos - 1)
  return iDepth
end

on getMaxDepth me
  return me.iDepthHi
end

on getHighestDepth me, oExcludeItem
  iHighestDepth = me.iDepthLow
  repeat with oItem in me.aItems
    if not voidp(oExcludeItem) then
      if oItem.equals(oExcludeItem) then
        next repeat
      end if
    end if
    if oItem.getGridZ() > iHighestDepth then
      iHighestDepth = oItem.getGridZ()
    end if
  end repeat
  return iHighestDepth
end

on getNextHighestDepth me, oExcludeItem
  iHighestDepth = me.getHighestDepth(oExcludeItem)
  iNextHighestDepth = iHighestDepth + 1
  return iNextHighestDepth
end

on sortItemsByDepth me
  aNewItems = []
  iCount = me.aItems.count
  repeat with i = me.iDepthLow to me.iDepthHi
    aItemsAtDepth = me.getItemsAtDepth(i)
    repeat with oItem in aItemsAtDepth
      aNewItems.add(oItem)
    end repeat
  end repeat
  me.aItems = aNewItems
end

on getItemsAtDepth me, iDepth
  aItemsAtDepth = []
  iCount = me.aItems.count
  repeat with i = 1 to iCount
    oItem = me.aItems[i]
    iZ = oItem.getGridZ()
    if iZ = iDepth then
      aItemsAtDepth.add(oItem)
    end if
  end repeat
  return aItemsAtDepth
end

on shiftItem me, oItem
  me.aItems.deleteOne(oItem)
  me.aItems.add(oItem)
end

on addItem me, oItem
  me.aItems.add(oItem)
  me.sortItemsByDepth()
  oItem.draw()
end

on removeItem me, oItem
  oItem.destroy()
  me.aItems.deleteOne(oItem)
end

on destroy me
  oIsoScene.deleteSelectedItem()
  repeat with i = 1 to me.aItems.count
    oItem = me.aItems[i]
    oItem.destroy()
  end repeat
  me.aItems = []
  me.clearSpritePool()
end

on printItems me, _aItems
  repeat with i = 1 to _aItems.count
    oItem = _aItems[i]
  end repeat
end

on toggleDisplay me
  repeat with i in me.aItems
    i.toggleDisplay()
  end repeat
end

on getPooledSprite me
  iSprite = VOID
  repeat with i = 1 to me.aSpritePoolSource.count
    _iSourceSprite = me.aSpritePoolSource[i]
    if me.aSpritePool.getOne(_iSourceSprite) = 0 then
      iSprite = _iSourceSprite
      me.aSpritePool.add(_iSourceSprite)
      puppetSprite(iSprite, 1)
      sprite(iSprite).scriptInstanceList = []
      exit repeat
    end if
  end repeat
  if voidp(iSprite) then
    alert("I'm all out of sprites. :(")
  end if
  return iSprite
end

on returnPooledSprites me, _aSprites
  if voidp(_aSprites) then
    return 
  end if
  repeat with i = 1 to _aSprites.count
    me.returnPooledSprite(_aSprites[i])
  end repeat
end

on returnPooledSprite me, iSprite
  if voidp(iSprite) then
    return 
  end if
  me.aSpritePool.deleteOne(iSprite)
  sprite(iSprite).scriptInstanceList = []
  puppetSprite(iSprite, 0)
end

on clearSpritePool me
  me.returnPooledSprites(me.aSpritePool)
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
  oRoot = oXml.createElement("WallItems")
  repeat with i = 1 to me.aItems.count
    oItem = me.aItems[i]
    oNode = oXml.createElement("Item")
    oNode.attributes.prodID = oItem.sProdID
    oNode.attributes.posId = oItem.sPosId
    oNode.attributes.state = oItem.iState
    oNode.attributes.attributes = string(oItem.aAttributes)
    oNode.attributes.gridX = oItem.iX
    oNode.attributes.gridY = oItem.iY
    oRoot.appendChild(oNode)
  end repeat
  return oRoot
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
