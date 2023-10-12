property sProdID, sPosId, sImageBase, aAttributes, sType, sAction, iState, sCastLib, bDragging, iFPS, iTimer, iSprite, bDebug, iX, iY, iZ, oLeftWallMember, oRightWallMember, oAction, iLastX, iLastY, bFirstDraw, oPreviewMember
global oIsoScene, oStudio, oRoom, oDenizenManager, oSession, oPossessionStudio, ElementMgr, gFeatureSet

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iZ, _iX, _iY, _iDir
  me.bDebug = 0
  me.debug("new()")
  me.sProdID = _sProdId
  me.sPosId = _sPosId
  me.sImageBase = _sImageBase
  me.sType = _sType
  if voidp(_iState) then
    me.iState = 0
  else
    me.iState = _iState
  end if
  if voidp(_aAttributes) or (_aAttributes = EMPTY) then
    me.aAttributes = [:]
  else
    me.aAttributes = _aAttributes
  end if
  if voidp(_sAction) or (_sAction = EMPTY) then
    me.sAction = "Default"
  else
    me.sAction = _sAction
  end if
  me.sCastLib = "WallItems"
  me.bDragging = 0
  me.iFPS = oIsoScene.oIsoConstants.DEFAULT_FPS
  me.iTimer = the milliSeconds
  me.oLeftWallMember = member("leftwall " & me.sImageBase)
  me.oRightWallMember = member("rightwall " & me.sImageBase)
  me.iSprite = oIsoScene.oWallItems.getPooledSprite()
  sprite(me.iSprite).member = me.oLeftWallMember
  sprite(iSprite).scriptInstanceList.add(script("WallItemScript").new(me))
  sprite(me.iSprite).visible = 1
  if sprite(me.iSprite).member.type = #flash then
    sprite(me.iSprite).ink = 36
    me.debug("WallItem is flashMember. Sprite.ink is:" && sprite(me.iSprite).ink, 1)
  else
    sprite(me.iSprite).ink = 8
  end if
  if voidp(_iX) then
    me.iX = 0
  else
    me.iX = _iX
  end if
  if voidp(_iY) then
    me.iY = 0
  else
    me.iY = _iY
  end if
  if voidp(_iZ) then
    me.iZ = sprite(me.iSprite).locZ
  else
    me.iZ = _iZ
  end if
  sPreviewName = me.sImageBase & "_small"
  me.oPreviewMember = member(sPreviewName)
  me.bFirstDraw = 1
  return me
end

on mouseIsOverITem me
  return rollover(sprite(me.iSprite))
end

on getType me
  return me.sType
end

on sendPutInStudio me
  if not me.equals(oIsoScene.oSelectedItem) then
    return 
  end if
  oIsoScene.oWallItems.shiftItem(me)
  aDirtyItems = oIsoScene.oWallItems.setDepthsByPos()
  oIsoScene.oWallItems.sortItemsByDepth()
  oIsoScene.oWallItems.drawAll()
  if not voidp(oSession) and not voidp(oPossessionStudio) then
    oPossessionStudio.sendPutInStudio(me)
    repeat with oDirtyItem in aDirtyItems
      if not oDirtyItem.equals(me) then
        oPossessionStudio.sendPutInStudio(oDirtyItem)
      end if
    end repeat
  end if
end

on putInBackPack me
  if not gFeatureSet.isEnabled(#FURNITURE_PICKUP) then
    return 
  end if
  oIsoScene.deleteSelectedItem()
  aDirtyItems = oIsoScene.oWallItems.setDepthsByPos()
  oIsoScene.oWallItems.sortItemsByDepth()
  oIsoScene.oWallItems.drawAll()
end

on getProdId me
  return me.sProdID
end

on getAction me
  return me.oAction
end

on getPreviewImage me
  return me.oPreviewMember
end

on equals me, _oItem
  if voidp(_oItem) then
    return 0
  end if
  if me.sPosId = _oItem.sPosId then
    return 1
  else
    return 0
  end if
end

on resetLastPosition me
  if voidp(me.iLastX) or voidp(me.iLastY) then
    return 0
  end if
  if (me.iLastX = 0) or (me.iLastY = 0) then
    return 0
  end if
  me.setDrag(0)
  me.setGridPosition(me.iLastX, me.iLastY)
  sprite(me.iSprite).blend = 100
  return 1
end

on getPosId me
  return me.sPosId
end

on getGridX me
  return me.iX
end

on getGridY me
  return me.iY
end

on getGridZ me
  return me.iZ
end

on setXPos me, iXPos
  me.iX = iXPos
end

on setYPos me, iYPos
  me.iY = iYPos
end

on setZPos me, iZPos
  me.iZ = iZPos
end

on setState me, _iState
  me.iState = _iState
end

on getDirection me
  return 0
end

on getHeightOffset me
  return 0
end

on setHeightOffset me
  nothing()
end

on getState me
  return me.iState
end

on getAttributes me
  return me.aAttributes
end

on setAttributes me, _aAttributes
  me.aAttributes = _aAttributes
end

on setAttribute me, sProp, sState
  me.aAttributes.setaProp(symbol(sProp), sState)
end

on setItemsAllowedOnTop me, _bItemsAllowedOnTop
end

on getItemsAllowedOnTop me
  return 1
end

on deleteItem me
  oIsoScene.oWallItems.removeItem(me)
end

on mouseDownEvent me, iSpriteNum, bDoubleClick
  global gCatalog
  if the doubleClick or bDoubleClick then
    aCatItem = gCatalog.getItemByProdId(integer(me.sProdID))
    sCatItemLink = aCatItem[#attributes][#link]
    if not voidp(sCatItemLink) then
      gotoNetPage(sCatItemLink, ".")
    end if
  end if
  if sprite(me.iSprite).member.type = #flash then
    me.oAction.mouseDownEvent(me.iSprite)
  else
    me.oAction.mouseDownEvent()
  end if
  return 1
end

on testTradeDrop me
  bDropped = 0
  bTrading = not voidp(ElementMgr.getTrader())
  if bTrading then
    bDropped = sendAllSprites(#testTradeDrop)
  end if
  if voidp(bDropped) then
    return 0
  end if
  return bDropped
end

on setDragPosition me, _iX, _iY
  me.iX = _iX
  me.iY = _iX
  me.draw()
end

on setGridPosition me, _iX, _iY, _iZ
  me.iX = _iX
  me.iY = _iY
  if not voidp(_iZ) then
    me.iZ = _iZ
  end if
  me.draw()
end

on setDirection me, iDir
end

on setDrag me, bState
  if not me.bDragging and bState then
    me.iLastX = me.iX
    me.iLastY = me.iY
  end if
  me.bDragging = bState
  me.draw()
end

on getDrag me
  return me.bDragging
end

on drop me
  bIsEligible = me.draw()
  return bIsEligible
end

on destroy me
  oIsoScene.oWallItems.returnPooledSprite(me.iSprite)
  (the actorList).deleteOne(me)
end

on getSprites me
  return [me.iSprite]
end

on stepFrame me
  if not me.bDragging then
    return 
  end if
  if (the milliSeconds - me.iTimer) >= (1000 / me.iFPS) then
    me.iTimer = the milliSeconds
    me.iX = the mouseH
    me.iY = the mouseV
    me.draw()
  end if
end

on update me
  oIsoScene.oWallItems.sortItemsByDepth()
  me.draw(1)
end

on draw me, bIsEligible
  sprite(me.iSprite).locH = me.iX
  sprite(me.iSprite).locV = me.iY
  bTrading = not voidp(ElementMgr.getTrader())
  if voidp(bIsEligible) then
    bIsEligible = 0
  end if
  oPoint = point(me.iX, me.iY)
  iWallSprite = oIsoScene.oWall.getSpriteUnderPoint(oPoint)
  if not voidp(iWallSprite) then
    sDir = sendSprite(iWallSprite, #getId1)
    sCorner = sendSprite(iWallSprite, #getId4)
    if not bIsEligible then
      bIsEligible = me.getEligibleToDrop(iWallSprite, sDir, sCorner)
    end if
  end if
  if bIsEligible or bTrading or me.bFirstDraw then
    sprite(me.iSprite).blend = 100
  else
    sprite(me.iSprite).blend = 30
  end if
  if me.getDrag() then
    if bIsEligible and not bTrading then
      sprite(me.iSprite).locZ = oIsoScene.oWallItems.getMaxDepth()
    else
      sprite(me.iSprite).locZ = the maxinteger
    end if
  else
    sprite(me.iSprite).locZ = me.iZ
  end if
  if not voidp(sDir) then
    case sDir of
      "left":
        sprite(me.iSprite).member = me.oLeftWallMember
      "right":
        sprite(me.iSprite).member = me.oRightWallMember
    end case
  end if
  sprite(me.iSprite).width = sprite(me.iSprite).member.width
  sprite(me.iSprite).height = sprite(me.iSprite).member.height
  sprite(me.iSprite).visible = 1
  me.bFirstDraw = 0
  return bIsEligible
end

on getDepthTestSprite me, sDir
  oTestPoint = me.getDepthTestPoint(sDir)
  iDepthSprite = oIsoScene.oWall.getSpriteUnderPoint(oTestPoint)
  if not voidp(iDepthSprite) then
    return iDepthSprite
  end if
  iDepthSprite = oIsoScene.oWall.getSpriteUnderPoint(point(me.iX, me.iY))
  return iDepthSprite
end

on getDepthTestPoint me, sDir
  iTestX = sprite(me.iSprite).left
  if sDir = "right" then
    iTestX = iTestX + sprite(me.iSprite).width
  end if
  iTestY = sprite(me.iSprite).top + (sprite(me.iSprite).height / 2)
  return point(iTestX, iTestY)
end

on getEligibleToDrop me, iWallSprite, sDir, sCorner
  if voidp(iWallSprite) then
    return 0
  end if
  iOffset = 10
  if sprite(me.iSprite).top <= (sprite(iWallSprite).top - iOffset) then
    return 0
  end if
  if sprite(me.iSprite).bottom >= (sprite(iWallSprite).bottom + iOffset) then
    return 0
  end if
  return 1
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "WallItem " & sMessage
  end if
end

on isWallItem me
  return 1
end

on isFurniItem me
  return 0
end

on isAvatar me
  return 0
end

on isBurnedCd me
  return 0
end

on toString me
  return "[WALL ITEM] CAT_ID: " & me.sProdID & ", POS_ID: " & me.getPosId()
end

on hitTest me
  return rollover(me.iSprite)
end

on getSpritesUnderMouse me
  aSpritesUnderMouse = [:]
  _aSprites = me.getSprites()
  repeat with _iSprite in _aSprites
    if rollover(_iSprite) then
      if me.hitTest(_iSprite) then
        aSpritesUnderMouse.addProp(sprite(_iSprite).locZ, _iSprite)
      end if
    end if
  end repeat
  return aSpritesUnderMouse
end

on rolloverObject me
  _aSprites = me.getSprites()
  repeat with _iSprite in _aSprites
    if rollover(_iSprite) then
      return 1
    end if
  end repeat
  return 0
end

on getHighestDepth me
  iHighestDepth = 0
  _aSprites = me.getSprites()
  repeat with _iSprite in _aSprites
    if sprite(_iSprite).locZ > iHighestDepth then
      iHighestDepth = sprite(_iSprite).locZ
    end if
  end repeat
  return iHighestDepth
end

on hitTestAll me
  _aSprites = me.getSprites()
  repeat with i in _aSprites
    if me.hitTest(i) then
      return i
    end if
  end repeat
  return VOID
end

on canDelete me
  return 1
end

on canUse me
  return 0
end

on canPickup me
  return 1
end
