property sProdID, sPosId, sImageBase, aAttributes, sType, sAction, iState, sCastLib, iWidth, iHeight, iDepth, iHeightOffset, bItemsAllowedOnTop, iDirection, aDirections, iDirectionIndex, iFrame, iNumFrames, aDrawOrder, iRow, iCol, iGridX, iGridZ, iGridY, bDragging, bAnimate, aAssets, aAlias, ORDER, height, width, depth, direction, frame, iFPS, iTimer, bDebug, oAction, bVisible, bBlocksPath, bSeatable, oPreviewMember, iPreviewSprite, bHasPreview, iLastRow, iLastCol, iLastGridY, iLastHeightOffset, iLastDirectionIndex, oHitTestColor8, oHitTestColor16
global oIsoScene, oPossessionStudio, oStudioMap, oStudio, oRoom, oDenizenManager, oSession, ElementMgr

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, _bItemsAllowedOnTop
  me.bDebug = 1
  me.sProdID = _sProdId
  me.sPosId = _sPosId
  me.sImageBase = _sImageBase
  me.sType = _sType
  if voidp(_sAction) or (_sAction = EMPTY) then
    me.sAction = "Default"
  else
    me.sAction = _sAction
  end if
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
  if voidp(_iRow) then
    me.iRow = 1
  else
    me.iRow = _iRow
  end if
  if voidp(_iCol) then
    me.iCol = 1
  else
    me.iCol = _iCol
  end if
  if voidp(_iGridY) then
    me.iGridY = 0
  else
    me.iGridY = _iGridY
  end if
  if voidp(_iDirection) then
    me.iDirection = 2
  else
    me.iDirection = _iDirection
  end if
  if voidp(_sCastLib) then
    me.sCastLib = "Furniture"
  else
    me.sCastLib = _sCastLib
  end if
  me.iWidth = 1
  me.iDepth = 1
  if not voidp(_iHeight) then
    me.iHeight = _iHeight
  end if
  if voidp(_iHeightOffset) then
    me.iHeightOffset = 0
  else
    me.iHeightOffset = _iHeightOffset
  end if
  if voidp(_bItemsAllowedOnTop) then
    me.bItemsAllowedOnTop = 1
  else
    me.bItemsAllowedOnTop = _bItemsAllowedOnTop
  end if
  me.iNumFrames = 1
  me.aAssets = [:]
  me.ORDER = 1
  me.height = 2
  me.width = 3
  me.depth = 4
  me.direction = 5
  me.frame = 6
  me.loadAlias()
  me.loadAssets()
  me.setWidth()
  me.setDepth()
  me.setNumFrames()
  me.setDirections()
  me.setDirectionIndex()
  me.setDirection(me.iDirection)
  me.setDrawOrder()
  me.bDragging = 0
  me.bAnimate = 0
  me.iFrame = 0
  me.iFPS = 8
  me.iTimer = the milliSeconds
  me.bBlocksPath = 1
  me.bSeatable = 0
  me.bVisible = 1
  sPreviewName = me.sImageBase & "_small"
  me.oPreviewMember = member(sPreviewName)
  me.bHasPreview = me.oPreviewMember.number > 0
  me.createPreviewSprite(me.oPreviewMember)
  me.iLastDirectionIndex = me.iDirectionIndex
  me.oHitTestColor8 = paletteIndex(0)
  me.oHitTestColor16 = rgb(255, 255, 255)
  return me
end

on sendPutInStudio me
  if not me.equals(oIsoScene.oSelectedItem) then
    return 
  end if
  if not voidp(oSession) then
    if not oSession.bTestMode and not voidp(oPossessionStudio) then
      oPossessionStudio.sendPutInStudio(me)
    end if
  end if
end

on createPreviewSprite me, _oPreviewMember
  me.iPreviewSprite = oIsoScene.oSpriteManager.getPooledSprite()
  if not me.bHasPreview then
    return 
  end if
  sprite(me.iPreviewSprite).member = _oPreviewMember
  sprite(me.iPreviewSprite).ink = 36
  sprite(me.iPreviewSprite).blend = 200
  sprite(me.iPreviewSprite).locZ = the maxinteger
  sprite(me.iPreviewSprite).scriptInstanceList.add(script("DragPreviewScript").new(me))
  me.hidePreview()
end

on updatePreview me
  if not me.bHasPreview then
    return 
  end if
  sprite(me.iPreviewSprite).locH = the mouseH
  sprite(me.iPreviewSprite).locV = the mouseV
  sprite(me.iPreviewSprite).visible = 1
  me.setVisible(0)
end

on hidePreview me
  if not me.bHasPreview then
    return 
  end if
  sprite(me.iPreviewSprite).visible = 0
  sprite(me.iPreviewSprite).locH = -100
  sprite(me.iPreviewSprite).locV = 0
  me.setVisible(1)
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

on getPosId me
  return me.sPosId
end

on getType me
  return me.sType
end

on getGridX me
  return me.iCol
end

on getGridY me
  return me.iGridY
end

on getHeight me
  return me.iHeight
end

on setHeightOffset me, _iHeightOffset
  me.iHeightOffset = _iHeightOffset
end

on getHeightOffset me
  return me.iHeightOffset
end

on setItemsAllowedOnTop me, _bItemsAllowedOnTop
  me.bItemsAllowedOnTop = _bItemsAllowedOnTop
end

on getItemsAllowedOnTop me
  return me.bItemsAllowedOnTop
end

on getGridZ me
  return me.iRow
end

on setXPos me, iXPos
  me.iGridX = iXPos
  me.iCol = iXPos
end

on setYPos me, iYPos
  me.iGridY = iYPos
  me.setGridY(iYPos)
end

on setZPos me, iZPos
  me.iGridZ = iZPos
  me.iRow = iZPos
end

on setAttributes me, _aAttributes
  me.aAttributes = _aAttributes
end

on getDirection me
  return me.iDirection
end

on setGridY me, _iGridY
  if _iGridY < 0 then
    return 
  end if
  if _iGridY > oIsoScene.oIsoConstants.DEFAULT_MAX_HEIGHT then
    return 0
  end if
  me.iGridY = _iGridY
  me.draw()
  return 1
end

on changeGridY me, iDir
  return me.setGridY(me.iGridY + iDir)
end

on setState me, _iState
  me.iState = _iState
  me.oAction.displayState()
end

on getState me
  return me.iState
end

on getAttributes me
  return me.aAttributes
end

on setAttribute me, sProp, sState
  me.aAttributes.setaProp(symbol(sProp), sState)
end

on deleteItem me
  if me.isRugITem() then
    oIsoScene.oRugs.removeItem(me)
  else
    oIsoScene.oFurniture.removeItem(me)
  end if
end

on mouseIsOverITem me
  _aSprites = me.getSprites()
  repeat with _iSprite in _aSprites
    if me.hitTest(_iSprite) then
      return 1
    end if
  end repeat
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

on hitTest me, iSpriteNum
  _oSprite = sprite(iSpriteNum)
  if voidp(_oSprite) then
    return 0
  end if
  _oMember = _oSprite.member
  if voidp(_oMember) then
    return 0
  end if
  if _oMember.memberNum <= 0 then
    return 0
  end if
  _oMemberLoc = _oSprite.mapStageToMember(the mouseLoc)
  if voidp(_oMemberLoc) then
    return 0
  end if
  _oImage = _oMember.image
  _oPixelColor = _oImage.getPixel(_oMemberLoc)
  iBitDepth = _oImage.depth
  bHitTest = 0
  if iBitDepth = 8 then
    if _oPixelColor <> me.oHitTestColor8 then
      return 1
    end if
  end if
  if (iBitDepth > 8) and (iBitDepth < 32) then
    if _oPixelColor <> me.oHitTestColor16 then
      return 1
    end if
  end if
  return 0
end

on mouseDownEvent me, iSpriteNum, bDoubleClick
  me.debug("FURNI MOUSE DOWN: " & me.sPosId)
  iSpriteNum = me.hitTestAll()
  bHitTest = not voidp(iSpriteNum)
  if not bHitTest then
    return 0
  end if
  if me.getDrag() then
    return 0
  end if
  bTrading = not voidp(ElementMgr.getTrader())
  if bTrading then
    return 1
  end if
  bPass = me.oAction.mouseDownEvent(bDoubleClick)
  if not voidp(bPass) then
    if not bPass then
      return 1
    end if
  end if
  if not oStudioMap.isPrivate() then
    return 0
  end if
  if voidp(bPass) or (bPass and not me.getDrag()) then
    oIsoScene.moveAvatar()
  end if
  return 1
end

on putInBackPack me
  if voidp(oStudio) then
    bIsOwner = 1
    bIsMod = 1
  else
    bIsOwner = oStudio.isOwner(oDenizenManager.getScreenName())
    bIsMod = oDenizenManager.isMod()
  end if
  if not bIsOwner and not bIsMod then
    return 
  end if
  if not voidp(oIsoScene.oSelectedItem) and oIsoScene.oSelectedItem.equals(me) then
    if not me.getDrag() then
      if voidp(oSession) then
        oIsoScene.deleteSelectedItem()
      else
        oPossessionStudio.sendPutInBackpack(me)
      end if
    end if
  end if
end

on placeItem me, oSquare
  me.debug("####### BEGIN PLACE ITEM ########: " & oSquare.toString())
  if me.isRugITem() then
    return me.placeRugItem(oSquare)
  end if
  aDifList = oIsoScene.getSquareOffsets(me, oSquare)
  bOverFloor = oIsoScene.squaresAreOverFloor(aDifList)
  if not bOverFloor then
    return 0
  end if
  oMapNode = oIsoScene.oMap.getNode(oSquare.iRow, oSquare.iCol)
  iWeight = oMapNode.w
  if (iWeight = oIsoScene.oMap.oPathfinder.W_BLOCKED) or (iWeight = oIsoScene.oMap.oPathfinder.W_ENTER) then
    return 0
  end if
  bIsSeatableItem = oIsoScene.oFurniture.isSeatableItem(me)
  aAvatars = oIsoScene.oAvatars.getItemsAtSquares(aDifList)
  if aAvatars.count > 0 then
    return 0
  end if
  me.debug("NO AVATARS IN WAY:")
  repeat with s in aDifList
    me.debug("s: " & s.toString())
  end repeat
  if bIsSeatableItem then
    aItemsAtSquares = oIsoScene.oFurniture.getItemsAtSquaresExcept(aDifList, me)
    bContainsSeatableItems = oIsoScene.oFurniture.containsSeatableItems(aItemsAtSquares)
    if bContainsSeatableItems then
      return 0
    end if
  end if
  iGridY = 0
  iTestLow = 0
  iTestHi = me.getHeight()
  repeat with i = 1 to oIsoScene.oIsoConstants.DEFAULT_MAX_HEIGHT
    aItemsInRange = oIsoScene.oFurniture.getItemsAtSquaresInHeightRangeExcept(aDifList, me, iTestLow, iTestHi)
    iCount = aItemsInRange.count()
    if iCount > 0 then
      oItemInWay = oIsoScene.oFurniture.getItemWithGreatestHeightOffset(aItemsInRange)
      bAllowItemsOnTop = oItemInWay.getItemsAllowedOnTop()
      if not bAllowItemsOnTop then
        return 0
      end if
      iTestLow = oItemInWay.getHeightOffset() + oItemInWay.getHeight()
      if iTestLow >= oIsoScene.oIsoConstants.DEFAULT_MAX_HEIGHT_OFFSET then
        return 0
      end if
      iTestHi = iTestLow + oItemInWay.getHeight()
      iGridY = oItemInWay.getGridY() + 1
      next repeat
    end if
    me.setDragPosition(oSquare.iRow, oSquare.iCol, iGridY, iTestLow)
    return 1
  end repeat
  return 0
end

on placeRugItem me, oSquare
  aDifList = oIsoScene.getSquareOffsets(me, oSquare)
  bOverFloor = oIsoScene.squaresAreOverFloor(aDifList)
  if not bOverFloor then
    return 0
  end if
  _iGridY = oIsoScene.oRugs.getNextHighestDepth()
  me.setDragPosition(oSquare.iRow, oSquare.iCol, _iGridY, 0)
  return 1
end

on rotateItem me
  if oIsoScene.oSelectedItem.equals(me) then
    oIsoScene.rotateSelectedItem()
  end if
end

on setGridPosition me, _iRow, _iCol, _iGridY, _iHeightOffset
  me.hidePreview()
  me.iRow = _iRow
  me.iCol = _iCol
  if not voidp(_iGridY) then
    me.iGridY = _iGridY
  end if
  if not voidp(_iHeightOffset) then
    me.iHeightOffset = _iHeightOffset
  end if
  me.draw()
  me.iLastRow = me.iRow
  me.iLastCol = me.iCol
  me.iLastGridY = me.iGridY
  me.iLastHeightOffset = me.iHeightOffset
  oIsoScene.oAvatars.updateAll()
end

on setDragPosition me, _iRow, _iCol, _iGridY, _iHeightOffset
  me.hidePreview()
  me.iRow = _iRow
  me.iCol = _iCol
  me.iHeightOffset = _iHeightOffset
  me.iGridY = _iGridY
  me.draw()
end

on resetLastPosition me
  if voidp(me.iLastRow) or voidp(me.iLastCol) then
    return 0
  end if
  oSquare = oIsoScene.oGrid.getSquareByRowCol(me.iLastRow, me.iLastCol)
  if not oIsoScene.isOverFloor(oSquare) then
    return 0
  end if
  me.iDirectionIndex = me.iLastDirectionIndex
  me.setDirection(me.aDirections[me.iDirectionIndex])
  me.iFrame = 0
  me.setDrag(0)
  me.setGridPosition(me.iLastRow, me.iLastCol, me.iLastGridY, me.iLastHeightOffset)
  return 1
end

on existsAtSquare me, oSquare
  if voidp(oSquare) then
    return 
  end if
  aList = me.getOccupiedSquares()
  repeat with i = 1 to aList.count
    if oSquare.equals(aList[i]) then
      return 1
    end if
  end repeat
  return 0
end

on setDrag me, bState
  if not me.bDragging and bState then
    me.iLastRow = me.iRow
    me.iLastCol = me.iCol
    me.iLastGridY = me.iGridY
    me.iLastHeightOffset = me.iHeightOffset
  end if
  me.bDragging = bState
  if me.bDragging then
    me.iFrame = 0
  end if
  if not me.bDragging then
    me.iFrame = 0
  end if
end

on getDrag me
  return me.bDragging
end

on drop me
  me.debug("drop()")
  oSquare = oIsoScene.oMouseSquare
  if voidp(oSquare) then
    return 0
  end if
  if not oIsoScene.isOverFloor(oSquare) then
    return 0
  end if
  bSuccess = me.placeItem(oSquare)
  if bSuccess then
    me.iLastDirectionIndex = me.iDirectionIndex
    me.setGridPosition(oSquare.iRow, oSquare.iCol, me.iGridY, me.iHeightOffset)
  end if
  return bSuccess
end

on destroy me
  _aSprites = me.getSprites()
  _aSprites.add(me.iPreviewSprite)
  oIsoScene.oSpriteManager.returnPooledSprites(_aSprites)
  (the actorList).deleteOne(me)
end

on toggleDisplay me
  _aSprites = me.getSprites()
  repeat with i in _aSprites
    sprite(i).visible = not sprite(i).visible
  end repeat
end

on getSprites me
  _aSprites = []
  repeat with i = me.aDrawOrder.count down to 1
    sOrder = me.aDrawOrder.getPropAt(i)
    aOrderAttributes = me.aDrawOrder[i]
    iSprite = aOrderAttributes.sprite
    _aSprites.add(iSprite)
  end repeat
  return _aSprites
end

on stepFrame me
  if not voidp(me.oAction) then
    me.oAction.stepFrame()
  end if
  if not me.bAnimate and not me.bDragging then
    return 
  end if
  if (the milliSeconds - me.iTimer) >= (1000 / me.iFPS) then
    if me.bAnimate then
      me.animate()
    end if
    me.iTimer = the milliSeconds
  end if
end

on animate me
  me.nextFrame(1)
end

on getHeightSquare me, oBaseSquare
  _iRow = oBaseSquare.iRow - me.iGridY
  _iCol = oBaseSquare.iCol - me.iGridY
  oHeightSquare = oIsoScene.oGrid.getSquareByRowCol(_iRow, _iCol)
  if voidp(oHeightSquare) then
    return oBaseSquare
  else
    return oHeightSquare
  end if
end

on update me
  me.draw()
end

on getSquare me
  return oIsoScene.oGrid.getSquareByRowCol(me.iRow, me.iCol)
end

on draw me
  oSquare = me.getSquare()
  if voidp(oSquare) then
    return 
  end if
  oHeightSquare = oSquare
  oLeft = oHeightSquare.getViewLeft()
  oRight = oHeightSquare.getViewRight()
  repeat with i = 1 to me.aDrawOrder.count
    sOrder = me.aDrawOrder.getPropAt(i)
    aOrderAttributes = me.aDrawOrder[i]
    iSprite = aOrderAttributes.sprite
    sprite(iSprite).visible = 0
    if (sOrder = "sd") and (me.iHeightOffset > 0) then
      next repeat
    end if
    if aOrderAttributes.visible = 0 then
      next repeat
    end if
    aMemberProps = me.getMemberDrawProps(sOrder, me.iDirection)
    iZ = me.calculateZOrder(sOrder, oSquare)
    sprite(iSprite).locZ = iZ
    iLocV = oLeft.locV - me.iHeightOffset - aOrderAttributes.vShift
    oMember = aMemberProps.member
    if voidp(oMember) then
      if sprite(iSprite).flipH then
        sprite(iSprite).locH = oRight.locH
      else
        sprite(iSprite).locH = oLeft.locH
      end if
      sprite(iSprite).locV = iLocV
      sprite(iSprite).visible = me.bVisible
      next repeat
    end if
    bFlip = aMemberProps.flip
    sprite(iSprite).member = oMember
    sprite(iSprite).locH = oLeft.locH
    sprite(iSprite).locV = iLocV
    sprite(iSprite).flipH = 0
    sprite(iSprite).ink = aOrderAttributes.ink
    sprite(iSprite).blend = aOrderAttributes.blend
    sprite(iSprite).bgColor = aOrderAttributes.bgColor
    if bFlip then
      sprite(iSprite).flipH = 1
      sprite(iSprite).locH = oRight.locH
    end if
    sprite(iSprite).visible = me.bVisible
  end repeat
end

on setVisible me, _bVisible
  bDraw = 0
  if me.bVisible <> _bVisible then
    bDraw = 1
  end if
  me.bVisible = _bVisible
  if bDraw then
    me.draw()
  end if
end

on getVisible me
  return me.bVisible
end

on getMemberDrawProps me, sOrder, iDir
  oMember = VOID
  sName = me.buildImageName(sOrder, iDir)
  bFlip = 0
  aMemberAlias = me.aAlias[sName]
  if not voidp(aMemberAlias) then
    oMember = member(aMemberAlias.asset, me.sCastLib)
    bFlip = aMemberAlias.flip
  end if
  if voidp(oMember) and (sOrder = "sd") then
    sShadowName = me.sImageBase & "_sd_" & iDir
    aMemberAlias = me.aAlias[sShadowName]
    if not voidp(aMemberAlias) then
      oMember = member(aMemberAlias.asset, me.sCastLib)
      bFlip = aMemberAlias.flip
    end if
  end if
  if voidp(oMember) then
    oMember = me.aAssets[sName]
  end if
  aProps = [#member: oMember, #flip: bFlip]
  return aProps
end

on buildImageName me, sOrder, iDir
  if sOrder = "sd" then
    return me.sImageBase & "_" & sOrder
  end if
  if me.sCastLib = EMPTY then
    return me.sImageBase & "_" & sOrder & "_" & "0" & "_" & string(iDir) & "_" & string(me.iFrame)
  else
    return me.sImageBase & "_" & sOrder & "_" & "0" & "_" & string(me.iWidth) & "_" & string(me.iDepth) & "_" & string(iDir) & "_" & string(me.iFrame)
  end if
end

on setHeight me, _iHeight
  me.iHeight = _iHeight
end

on setWidth me
  if me.width = -1 then
    me.iWidth = 1
    return 
  end if
  oMember = me.aAssets[1]
  sName = oMember.name
  me.iWidth = integer(me.getParamFromName(sName, me.width))
end

on setDepth me
  if me.depth = -1 then
    me.iDepth = 1
    return 
  end if
  oMember = me.aAssets[1]
  sName = oMember.name
  me.iDepth = integer(me.getParamFromName(sName, me.depth))
end

on setNumFrames me
  iHighestFrame = 0
  repeat with i = 1 to me.aAssets.count
    sName = me.aAssets.getPropAt(i)
    iFrame = integer(me.getParamFromName(sName, me.frame))
    if iFrame > iHighestFrame then
      iHighestFrame = iFrame
    end if
  end repeat
  me.iNumFrames = iHighestFrame
end

on nextFrame me, iDir
  iNextFrame = me.iFrame + iDir
  if iNextFrame > me.iNumFrames then
    iNextFrame = 0
  end if
  if iNextFrame < 0 then
    iNextFrame = me.iNumFrames
  end if
  me.iFrame = iNextFrame
  me.draw()
end

on setFrame me, _iFrame
  if (_iFrame < 0) or (_iFrame > me.iNumFrames) then
    _iFrame = 0
  end if
  me.iFrame = _iFrame
  me.draw()
end

on setAnimate me, bState
  me.bAnimate = bState
end

on setDirection me, iDir
  if me.aDirections.getPos(iDir) = 0 then
    me.setDirectionIndex()
    me.iDirection = me.aDirections[me.iDirectionIndex]
  else
    me.iDirection = iDir
  end if
end

on setDirectionIndex me
  iIndex = me.aDirections.getPos(me.iDirection)
  if iIndex = 0 then
    iIndex = 1
  end if
  me.iDirectionIndex = iIndex
end

on rotate me, iDir
  if voidp(iDir) then
    iDir = 1
  end if
  iNewDirectionIndex = me.iDirectionIndex + iDir
  if iNewDirectionIndex > me.aDirections.count then
    iNewDirectionIndex = 1
  end if
  if iNewDirectionIndex < 1 then
    iNewDirectionIndex = me.aDirections.count
  end if
  me.iLastDirectionIndex = me.iDirectionIndex
  me.iDirectionIndex = iNewDirectionIndex
  me.setDirection(me.aDirections[iDirectionIndex])
  me.iFrame = 0
  oSquare = oIsoScene.oGrid.getSquareByRowCol(me.iRow, me.iCol)
  bSuccess = me.placeItem(oSquare)
  if bSuccess then
    me.iLastDirectionIndex = me.iDirectionIndex
    oIsoScene.oAvatars.updateAll()
  end if
  return bSuccess
end

on setDrawOrder me
  _aDrawOrder = []
  _aDrawOrder.sort()
  repeat with i = 1 to me.aAssets.count
    sName = me.aAssets.getPropAt(i)
    if not (sName starts me.sImageBase) then
      next repeat
    end if
    sOrder = me.getParamFromName(sName, me.ORDER)
    if _aDrawOrder.getPos(sOrder) = 0 then
      _aDrawOrder.add(sOrder)
    end if
  end repeat
  repeat with i = 1 to me.aAlias.count
    sName = me.aAlias.getPropAt(i)
    if not (sName starts me.sImageBase) then
      next repeat
    end if
    sOrder = me.getParamFromName(sName, me.ORDER)
    if _aDrawOrder.getPos(sOrder) = 0 then
      _aDrawOrder.add(sOrder)
    end if
  end repeat
  me.aDrawOrder = [:]
  repeat with i = 1 to _aDrawOrder.count
    sOrder = _aDrawOrder[i]
    iInk = 8
    iBlend = 100
    if sOrder = "sd" then
      iBlend = 40
    end if
    iSprite = oIsoScene.oSpriteManager.getPooledSprite()
    if sOrder <> "sd" then
      sprite(iSprite).scriptInstanceList.add(script("SceneItemScript").new(me))
    end if
    oInkMember = member(me.sImageBase & "_" & sOrder & ".ink", me.sCastLib)
    if oInkMember.memberNum <> -1 then
      iInk = integer(oInkMember.text)
    end if
    oBlendMember = member(me.sImageBase & "_" & sOrder & ".blend", me.sCastLib)
    if oBlendMember.memberNum <> -1 then
      iBlend = integer(oBlendMember.text)
    end if
    oBGColor = rgb(255, 255, 255)
    sColorProp = "color_" & sOrder
    oColor = me.aAttributes[sColorProp]
    if not voidp(oColor) then
      oBGColor = rgb(oColor)
    end if
    me.aDrawOrder.addProp(sOrder, [#ink: iInk, #blend: iBlend, #sprite: iSprite, #visible: 1, #bgColor: oBGColor, #vShift: 0])
  end repeat
end

on getDrawOrderForSprite me, _iSprite
  repeat with i = 1 to me.aDrawOrder.count
    sOrder = me.aDrawOrder.getPropAt(i)
    aOrderAttributes = me.aDrawOrder[i]
    iOrderSprite = aOrderAttributes.sprite
    if _iSprite = iOrderSprite then
      return sOrder
    end if
  end repeat
  return VOID
end

on getDrawOrderAttribute me, sOrder, sProp
  return me.aDrawOrder[sOrder][sProp]
end

on setDrawOrderAttribute me, sOrder, sProp, sValue
  me.aDrawOrder[sOrder][sProp] = sValue
end

on getParamFromName me, sName, iIndex
  iBaseLength = me.sImageBase.length
  sParams = sName.char[iBaseLength + 2..sName.length]
  sOldDelimiter = the itemDelimiter
  the itemDelimiter = "_"
  sParam = sParams.item[iIndex]
  the itemDelimiter = sOldDelimiter
  return sParam
end

on loadAssets me
  me.aAssets = [:]
  iNumMembers = the number of castMembers of castLib the sCastLib of me
  repeat with i = 1 to iNumMembers
    oMember = member(i, me.sCastLib)
    if oMember.memberNum = -1 then
      next repeat
    end if
    if (oMember.name starts me.sImageBase) and (oMember.type = #bitmap) and not (oMember.name contains ".") then
      sOrder = me.getParamFromName(oMember.name, me.ORDER)
      if sOrder = EMPTY then
        next repeat
      end if
      me.aAssets.addProp(oMember.name, oMember)
    end if
  end repeat
  repeat with i = 1 to me.aAlias.count
    aAliasMember = me.aAlias[i]
    sAsset = aAliasMember.asset
    bExists = not voidp(me.aAssets.getaProp(sAsset))
    if not bExists then
      oMember = member(sAsset, me.sCastLib)
      if oMember.memberNum = -1 then
        next repeat
      end if
      me.aAssets.addProp(oMember.name, oMember)
    end if
  end repeat
end

on loadAlias me
  me.aAlias = [:]
  oldDelimiter = the itemDelimiter
  the itemDelimiter = "="
  sAliasText = member("memberalias.index", me.sCastLib).text
  repeat with i = 1 to sAliasText.lines.count
    sLine = sAliasText.line[i]
    if sLine = EMPTY then
      next repeat
    end if
    sFrom = sLine.item[1]
    sTo = sLine.item[2]
    if (sFrom = EMPTY) or (sTo = EMPTY) then
      next repeat
    end if
    if not (sFrom starts me.sImageBase) then
      next repeat
    end if
    bFlip = 0
    if sTo.char[sTo.length] = "*" then
      sTo = sTo.char[1..sTo.length - 1]
      bFlip = 1
    end if
    oMember = member(sTo, me.sCastLib)
    if oMember.memberNum = -1 then
      next repeat
    end if
    me.aAlias.addProp(sFrom, [#asset: sTo, #flip: bFlip])
  end repeat
end

on setDirections me
  me.aDirections = []
  me.aDirections.sort()
  repeat with i = 1 to me.aAssets.count
    sName = me.aAssets.getPropAt(i)
    iDir = integer(me.getParamFromName(sName, me.direction))
    if not voidp(iDir) and (me.aDirections.getPos(iDir) = 0) then
      me.aDirections.add(iDir)
    end if
  end repeat
  repeat with i = 1 to me.aAlias.count
    sName = me.aAlias.getPropAt(i)
    if not (sName starts me.sImageBase) then
      next repeat
    end if
    iDir = integer(me.getParamFromName(sName, me.direction))
    if not voidp(iDir) and (me.aDirections.getPos(iDir) = 0) then
      me.aDirections.add(iDir)
    end if
  end repeat
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "FurnitureItem: " & sMessage
  end if
end

on getOccupiedSquares me
  aList = []
  case me.iDirection of
    0, 4:
      repeat with i = 1 to me.iDepth
        _iRow = me.iRow + (i - 1)
        repeat with ii = 1 to me.iWidth
          _iCol = me.iCol + (ii - 1)
          oSquare = oIsoScene.oGrid.getSquareByRowCol(_iRow, _iCol)
          aList.add(oSquare)
        end repeat
      end repeat
    2, 6:
      repeat with i = 1 to me.iDepth
        _iCol = me.iCol + (i - 1)
        repeat with ii = 1 to me.iWidth
          _iRow = me.iRow + (ii - 1)
          oSquare = oIsoScene.oGrid.getSquareByRowCol(_iRow, _iCol)
          aList.add(oSquare)
        end repeat
      end repeat
  end case
  return aList
end

on calculateZOrder me, sOrder, oDefaultSquare
  if me.isRugITem() then
    return me.iGridY
  end if
  oSquare = me.calculateBaseSquare(sOrder, oDefaultSquare)
  sLayerMap = me.calculateLayerMap(sOrder)
  iZ = oSquare.getDepthFromMap(sLayerMap, me.iGridY)
  return iZ
end

on calculateLayerMap me, sOrder
  sLayerMap = sOrder
  case sOrder of
    "a", "b":
    "c":
      sLayerMap = "a"
    "d":
      sLayerMap = "b"
  end case
  return sLayerMap
end

on calculateBaseSquare me, sOrder, oSquare
  case sOrder of
    "a", "b":
      oSquare = me.getSquareByGreatestDepth()
    "c":
    "d":
  end case
  return oSquare
end

on getSquareByGreatestDepth me
  _iRow = me.iRow
  _iCol = me.iCol
  case me.iDirection of
    2, 6:
      _iRow = me.iRow + (me.iWidth - 1)
      _iCol = me.iCol + (me.iDepth - 1)
    4, 0:
      _iRow = me.iRow + (me.iDepth - 1)
      _iCol = me.iCol + (me.iWidth - 1)
  end case
  oSquare = oIsoScene.oGrid.getSquareByRowCol(_iRow, _iCol)
  if voidp(oSquare) then
    oSquare = oIsoScene.oGrid.getSquareByRowCol(me.iRow, me.iCol)
  end if
  return oSquare
end

on getSquareByGreatestRightView me
  _iRow = me.iRow
  _iCol = me.iCol
  case me.iDirection of
    2, 6:
      _iCol = me.iCol + (me.iDepth - 1)
    4, 0:
      _iCol = me.iCol + (me.iWidth - 1)
  end case
  oSquare = oIsoScene.oGrid.getSquareByRowCol(_iRow, _iCol)
  if voidp(oSquare) then
    oSquare = oIsoScene.oGrid.getSquareByRowCol(me.iRow, me.iCol)
  end if
  return oSquare
end

on getSeatable me
  return me.bSeatable
end

on getBlocksPath me
  return me.bBlocksPath
end

on isRugITem me
  return me.sType = "RUG"
end

on isWallItem me
  return 0
end

on isFurniItem me
  return 1
end

on isAvatar me
  return 0
end

on isBurnedCd me
  return me.sProdID = 89
end

on toString me
  return "[FURNI ITEM] TYPE: " & me.sType & ", CAT_ID: " & me.sProdID & ", POS_ID: " & me.getPosId()
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
