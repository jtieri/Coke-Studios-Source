property bDebug, oMath2d, oIsoConstants, iYRot, iXRot, fSinY, fSinX, fCosY, fCosX, iXOff, iYOff, iFPS, iSequenceRate, iSqSize, iRows, iCols, oGrid, oMap, oHotSpots, oSpriteManager, oMouseSquare, oMouseGridPoint, oFMath, oBackground, oFloor, oWall, oDoor, oWindow, oRugs, oFurniture, oWallItems, oAvatars, oStaticItems, oHiliter, oStudioInfo, oInfoStand, oVoteItems, oAvatarIndicator, oTrivia, oSelectedItem, oSceneXml, oMapXml, oEntryXml, iLastClickTime, iAllowedClickTime, sLastRolloverItemName
global oIsoScene, oSession, oStudio, oPossessionStudio, oRoom, oStudioMap, oDenizenManager, gbTestMode, ElementMgr, gFeatureSet, gCatalog

on new me
  me.bDebug = 0
  me.debug("new() ")
  me.oIsoConstants = new(script("IsoConstants"))
  me.oMath2d = new(script("Math2d"))
  me.oFMath = newObject("Math")
  me.iYRot = me.oIsoConstants.DEFAULT_YROT
  me.iXRot = me.oIsoConstants.DEFAULT_XROT
  me.fSinY = sin(oMath2d.rad(me.iYRot))
  me.fSinX = sin(oMath2d.rad(me.iXRot))
  me.fCosY = cos(oMath2d.rad(me.iYRot))
  me.fCosX = cos(oMath2d.rad(me.iXRot))
  me.iXOff = me.oIsoConstants.DEFAULT_XOFF
  me.iYOff = me.oIsoConstants.DEFAULT_YOFF
  me.iSqSize = me.oIsoConstants.DEFAULT_SQSIZE
  me.iRows = me.oIsoConstants.DEFAULT_ROWS
  me.iCols = me.oIsoConstants.DEFAULT_COLS
  me.iFPS = me.oIsoConstants.DEFAULT_FPS
  me.iSequenceRate = me.oIsoConstants.DEFAULT_SEQUENCE_RATE
  puppetTempo(me.oIsoConstants.DEFAULT_FPS)
  oIsoScene = me
  me.iLastClickTime = the milliSeconds
  me.iAllowedClickTime = 650
  me.sLastRolloverItemName = EMPTY
  return me
end

on setLayout me, iLayout
  case iLayout of
    me.oIsoConstants.DEFAULT_LAYOUT_TYPE:
      me.iXOff = me.oIsoConstants.DEFAULT_XOFF
      me.iYOff = me.oIsoConstants.DEFAULT_YOFF
      me.iSqSize = me.oIsoConstants.DEFAULT_SQSIZE
      me.iRows = me.oIsoConstants.DEFAULT_ROWS
      me.iCols = me.oIsoConstants.DEFAULT_COLS
    me.oIsoConstants.DEFAULT_LG_LAYOUT_TYPE:
      me.iXOff = me.oIsoConstants.DEFAULT_LG_XOFF
      me.iYOff = me.oIsoConstants.DEFAULT_LG_YOFF
      me.iSqSize = me.oIsoConstants.DEFAULT_LG_SQSIZE
      me.iRows = me.oIsoConstants.DEFAULT_LG_ROWS
      me.iCols = me.oIsoConstants.DEFAULT_LG_COLS
  end case
end

on Init me, _oSceneXml, _oMapXml, _oEntryXml
  me.lockDisplay(1)
  me.oSceneXml = _oSceneXml
  me.oMapXml = _oMapXml
  me.oEntryXml = _oEntryXml
  if not voidp(me.oSceneXml) then
    oScene = me.oSceneXml.firstChild
    iLayoutType = integer(oScene.attributes.layoutType)
    me.setLayout(iLayoutType)
    me.iXOff = float(oScene.attributes.xoff)
    me.iYOff = float(oScene.attributes.yoff)
  end if
  me.oSpriteManager = new(script("IsoSpriteManager"), me)
  me.oGrid = new(script("IsoGrid"), me.iRows, me.iCols, me.iSqSize)
  me.oMap = new(script("Map"), me.oGrid.iRows, me.oGrid.iCols, oMapXml)
  me.oBackground = script("Background").new()
  me.oFloor = script("Floor").new()
  me.oWall = script("Wall").new()
  me.oDoor = script("Door").new()
  me.oWindow = script("Window").new()
  me.oWallItems = script("WallItems").new()
  me.oRugs = script("Rugs").new()
  me.oHiliter = script("Hiliter").new()
  me.oFurniture = script("Furniture").new()
  me.oStaticItems = script("StaticItems").new()
  me.oAvatars = script("Avatars").new()
  me.oStudioInfo = script("StudioInfo").new()
  me.oInfoStand = script("InfoStandObject").new()
  me.oVoteItems = script("VoteItems").new()
  me.oTrivia = script("TRIVIA").new()
  if not voidp(oScene) then
    me.initScene(oScene)
  end if
  me.oSelectedItem = VOID
  (the actorList).add(me)
end

on lockDisplay me, bState
  the updateLock = bState
  if not bState then
    if not voidp(me.oWallItems) then
      me.oWallItems.drawAll(1)
    end if
  end if
end

on setSequenceRate me, _iSequenceRate
  me.debug("setSequenceRate() " & _iSequenceRate)
  me.iSequenceRate = _iSequenceRate * (100 * 0.01)
end

on getSequenceRate me
  return me.iSequenceRate
end

on getEntryXml me
  return me.oEntryXml
end

on stepFrame me
  me.oMouseGridPoint = me.calcMouseToGridPoint()
  me.oMouseSquare = me.oGrid.getSquareByXZ(me.oMouseGridPoint.x, me.oMouseGridPoint.z)
  me.processRoomRollover()
end

on processRoomRollover me
  aSpriteList = me.getSpritesUnderMouse()
  if not voidp(aSpriteList) then
    if aSpriteList.count > 0 then
      iSpriteNum = aSpriteList[aSpriteList.count]
      oSpriteItem = sendSprite(iSpriteNum, #getController)
      if not voidp(oSpriteItem) then
        if oSpriteItem.isAvatar() then
          sName = oSpriteItem.getScreenName()
        else
          if not voidp(oStudioMap) then
            if oStudioMap.isPrivate() then
              aCatalogItem = gCatalog.getItemByProdId(oSpriteItem.getProdId())
              if voidp(aCatalogItem) then
                sName = EMPTY
              else
                sName = aCatalogItem[#name]
              end if
            end if
          end if
        end if
      else
        sName = EMPTY
      end if
    else
      sName = EMPTY
    end if
  else
    sName = EMPTY
  end if
  sName = string(sName)
  if me.sLastRolloverItemName <> sName then
    member("cb.rolldisplay").text = sName
    me.sLastRolloverItemName = sName
  end if
end

on clickAllowed me
  iElapsedTime = the milliSeconds - me.iLastClickTime
  if iElapsedTime > me.iAllowedClickTime then
    me.iLastClickTime = the milliSeconds
    return 1
  end if
  return 0
end

on mouseDownEvent me, bDoubleClick
  bClickAllowed = me.clickAllowed()
  if not bDoubleClick then
    if not bClickAllowed then
      return 
    end if
  end if
  if not voidp(me.oSelectedItem) then
    if me.oSelectedItem.getDrag() then
      if me.oSelectedItem.isWallItem() then
        bDropped = me.oSelectedItem.testTradeDrop()
        if bDropped then
          return 
        end if
      end if
      bDropped = me.dropSelectedItem()
      if bDropped then
        me.oSelectedItem = VOID
        return 
      end if
    end if
  end if
  if ElementMgr.mouseIsOverWindow() then
    return 
  end if
  bItemSelected = me.broadCastMouseEvent(bDoubleClick)
  if bItemSelected then
    return 1
  end if
  bDoorSelected = me.oDoor.mouseOverDoor()
  if bDoorSelected then
    me.oDoor.exitSelected()
    return 1
  end if
  me.clearInfoStand()
  if me.oMouseSquare <> VOID then
    oMapNode = me.oMap.getNode(me.oMouseSquare.iRow, me.oMouseSquare.iCol)
    if voidp(oMapNode) then
      return 1
    end if
    iWeight = oMapNode.w
    if (iWeight = me.oMap.oPathfinder.W_BLOCKED) or (iWeight = me.oMap.oPathfinder.W_ENTER) then
      return 0
    end if
    bDropped = me.dropSelectedItem()
    if bDropped then
      me.oSelectedItem = VOID
    else
      me.moveAvatar()
    end if
    return 1
  end if
  return 0
end

on canMoveToSquare me, _oSquare
  _aAvatars = me.oAvatars.getItemsAtSquare(_oSquare)
  if _aAvatars.count > 0 then
    return 0
  end if
  oMapNode = oIsoScene.oMap.getNode(_oSquare.iRow, _oSquare.iCol)
  iWeight = oMapNode.w
  if iWeight = me.oMap.oPathfinder.W_QUEUE then
    if not gFeatureSet.isEnabled(#PERFORMANCE) then
      ElementMgr.alert("FEATURE_DISABLED")
      return 
    end if
    oBackPack = oDenizenManager.getBackpack()
    if voidp(oBackPack) then
      return 0
    end if
    iBurnedCds = oBackPack.getNumberOfBurnedCds()
    if iBurnedCds > 0 then
      return 1
    else
      ElementMgr.alert("NOCD_TITLE", "NOCD_DESC")
      return 0
    end if
  end if
  _oItem = me.oFurniture.getItemAtSquareWithGreatestHeightOffset(_oSquare)
  if voidp(_oItem) then
    return 1
  end if
  bIsSeatable = me.oFurniture.isSeatableItem(_oItem)
  if bIsSeatable then
    return 1
  end if
  if _oItem.getProdId() = me.oIsoConstants.BURNED_CD then
    if _oItem.getHeightOffset() = 0 then
      return 1
    end if
  end if
  if _oItem.getType() = "Teleport" then
    oMyAvatar = me.oAvatars.getAvatar(oDenizenManager.getScreenName())
    if voidp(oMyAvatar) then
      return 1
    end if
    oMySquare = oMyAvatar.getSquare()
    if voidp(oMySquare) then
      return 1
    end if
    oTeleporter = me.oFurniture.getTeleporterAtSquare(oMySquare)
    if not voidp(oTeleporter) then
      return 0
    end if
    return 1
  end if
  return 1
end

on clearInfoStand me
  me.oInfoStand.clearInfoStand()
  if not voidp(me.oAvatarIndicator) then
    me.oAvatarIndicator.destroyItem()
    me.oAvatarIndicator = VOID
  end if
  me.displayCdPlaying()
  me.displaySongPlaying()
end

on broadCastMouseEvent me, bDoubleClick
  aSpritesUnderMouse = me.getSpritesUnderMouse()
  iCount = aSpritesUnderMouse.count()
  if iCount = 0 then
    return 0
  end if
  repeat with i = iCount down to 1
    iSpriteNum = aSpritesUnderMouse[i]
    oSpriteItem = sendSprite(iSpriteNum, #getController)
    if voidp(oSpriteItem) then
      next repeat
    end if
    oItem = VOID
    if oSpriteItem.isAvatar() then
      oItem = me.oAvatars.getAvatar(oSpriteItem.getScreenName())
    end if
    if oSpriteItem.isFurniItem() then
      if oSpriteItem.isRugITem() then
        oItem = me.oRugs.getItemByPossessionId(oSpriteItem.getPosId())
      else
        oItem = me.oFurniture.getItemByPossessionId(oSpriteItem.getPosId())
      end if
    end if
    if oSpriteItem.isWallItem() then
      oItem = me.oWallItems.getItemByPossessionId(oSpriteItem.getPosId())
    end if
    if voidp(oItem) then
      next repeat
    end if
    bHandled = me.handleMouseEvent(oItem, iSpriteNum, bDoubleClick)
    if bHandled then
      return 1
    end if
  end repeat
  return 0
end

on handleMouseEvent me, oItem, iSpriteNum, bDoubleClick
  bHandled = oItem.mouseDownEvent(iSpriteNum, bDoubleClick)
  if bHandled then
    me.setSelectedItem(oItem)
  end if
  return bHandled
end

on displayCdPlaying me
  if voidp(oStudio) then
    return 
  end if
  oCdplayer = oStudio.getcdplayer()
  bPlaying = oCdplayer.isPlaying()
  if bPlaying = 1 then
    oCd = oCdplayer.getCd()
    me.oInfoStand.displayCd(oCd)
  end if
end

on displaySongPlaying me
  if voidp(oStudio) then
    return 
  end if
  if voidp(oStudio.foSongPlaying) = 0 then
    oSong = oStudio.foSongPlaying
    sAvatar = oStudio.sIJsongplayer
    me.oInfoStand.displaySong(oSong, sAvatar)
  end if
end

on moveAvatar me, oTargetSquare
  if voidp(oTargetSquare) then
    oTargetSquare = me.oMouseSquare
  end if
  if voidp(oSession) then
    oAvatar = me.oAvatars.getAvatar("Aslan")
    if not voidp(oAvatar) then
      if oAvatar.oSquare.equals(oTargetSquare) then
        return 
      end if
      oAvatar.moveToSquare(oTargetSquare)
      oAvatar.walk()
      return 
    end if
  end if
  if voidp(oTargetSquare) then
    return 
  end if
  bIsOverFloor = me.isOverFloor(oTargetSquare)
  if not bIsOverFloor then
    return 
  end if
  bCanMove = me.canMoveToSquare(oTargetSquare)
  me.debug("moveAvatar() bCanMove: " & bCanMove)
  if not bCanMove then
    return 
  end if
  oAvatar = me.oAvatars.getAvatar(oSession.getScreenName())
  if not voidp(oAvatar) then
    if oAvatar.oSquare.equals(oTargetSquare) then
      return 
    end if
    me.debug("moveAvatar() calling oStudio.sendFindPath()")
    oStudio.sendFindPath(oTargetSquare.iCol, 0, oTargetSquare.iRow)
    dontPassEvent()
  end if
end

on moveAvatarToFrontOfItem me, _oItem
  oTargetSquare = me.getSquareInFrontOfItem(_oItem)
  bCanMove = me.canMoveToSquare(oTargetSquare)
  if bCanMove then
    oIsoScene.moveAvatar(oTargetSquare)
    return 1
  else
    return 0
  end if
end

on avatarIsInFrontOfItem me, _oItem
  oAvatar = me.oAvatars.getAvatar(oDenizenManager.getScreenName())
  if voidp(oAvatar) then
    return 0
  end if
  oAvatarSquare = oAvatar.getSquare()
  if voidp(oAvatarSquare) then
    return 0
  end if
  oTargetSquare = me.getSquareInFrontOfItem(_oItem)
  bAvatarInTargetSquare = oAvatarSquare.equals(oTargetSquare)
  return bAvatarInTargetSquare
end

on getSquareInFrontOfItem me, _oItem
  oItemSquare = _oItem.getSquare()
  iItemDirection = _oItem.getDirection()
  oTargetSquare = me.oGrid.getSquareAtDirection(oItemSquare, iItemDirection)
  return oTargetSquare
end

on keyDownEvent me
  nothing()
  case the key of
    "~":
      me.oGrid.toggleGridView()
    "!":
      me.oBackground.toggleDisplay()
    "@":
      me.oFloor.toggleDisplay()
    "#":
      me.oDoor.toggleDisplay()
    "$":
      me.oWall.toggleDisplay()
    "%":
      me.oHiliter.toggleDisplay()
    "^":
      me.oWindow.toggleDisplay()
    "&":
      me.oRugs.toggleDisplay()
    "*":
      me.oFurniture.toggleDisplay()
    "(":
      me.oWallItems.toggleDisplay()
    ")":
      me.oStaticItems.toggleDisplay()
    "_":
      me.oAvatars.toggleDisplay()
    "v":
      if the shiftDown then
        alert("VERSION: b0.01")
      end if
  end case
end

on getSelectedItem me
  return me.oSelectedItem
end

on setSelectedItem me, oItem, bDisplayInfo
  if voidp(oItem) then
    return 
  end if
  me.debug("setSelectedItem() " & oItem.toString())
  bTrading = not voidp(ElementMgr.getTrader())
  if not voidp(me.oSelectedItem) then
    if me.oSelectedItem.getDrag() then
      bDropped = me.dropSelectedItem()
      if bDropped then
        return 
      end if
    end if
  end if
  me.oSelectedItem = oItem
  if voidp(bDisplayInfo) then
    bDisplayInfo = 1
  end if
  if bDisplayInfo then
    me.oInfoStand.display(me.oSelectedItem)
  end if
  if me.oSelectedItem.getDrag() then
    bDropped = me.dropSelectedItem()
    return 
  end if
  if not me.oSelectedItem.isAvatar() and the optionDown then
    if voidp(oStudio) then
      bIsOwner = 1
      bIsMod = 1
    else
      bIsOwner = oStudio.isOwner(oDenizenManager.getScreenName())
      bIsMod = oDenizenManager.isMod()
    end if
    if bIsOwner or bIsMod then
      me.moveSelectedItem()
    end if
    return 
  end if
end

on createItem me, sProdID, sPosId, sImageBase, sType, sAction, iState, aAttributes, sCastLib, iRow, _iCol, iGridY, iDirection, iHeight, iHeightOffset, bItemsAllowedOnTop
  global oTempId
  if voidp(sPosId) then
    if voidp(oTempId) then
      oTempId = 1000
    else
      oTempId = oTempId + 1
    end if
    sPosId = string(oTempId)
  end if
  sTypeScript = "TYPE_" & sType
  oItem = script(sTypeScript).new(sProdID, sPosId, sImageBase, sType, sAction, iState, aAttributes, sCastLib, iRow, _iCol, iGridY, iDirection, iHeight, iHeightOffset, bItemsAllowedOnTop)
  oItem.draw()
  return oItem
end

on isOverFloor me, _oSquare
  oMapNode = oIsoScene.oMap.getNode(_oSquare.iRow, _oSquare.iCol)
  iWeight = oMapNode.w
  if iWeight = me.oMap.oPathfinder.W_BLOCKED then
    return 0
  else
    return 1
  end if
end

on squaresAreOverFloor me, _aSquares
  repeat with _oSquare in _aSquares
    bIsOverFloor = me.isOverFloor(_oSquare)
    if not bIsOverFloor then
      return 0
    end if
  end repeat
  return 1
end

on deleteSelectedItem me
  if not voidp(me.oSelectedItem) then
    if me.oSelectedItem.getDrag() then
      me.oSelectedItem.setDrag(0)
    end if
    me.oSelectedItem.deleteItem()
    me.oSelectedItem = VOID
    me.oInfoStand.display(me.oSelectedItem)
  end if
end

on deleteItem me, oItem
  if oItem.equals(me.oSelectedItem) then
    me.deleteSelectedItem()
    return 
  else
    oItem.deleteItem()
  end if
end

on rotateSelectedItem me
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
  if not voidp(me.oSelectedItem) then
    bSuccess = me.oSelectedItem.rotate()
    if not bSuccess then
      me.oSelectedItem.resetLastPosition()
      return 
    end if
    if not voidp(oSession) then
      if not oSession.bTestMode and not voidp(oPossessionStudio) then
        oPossessionStudio.sendUpdatePossession(me.oSelectedItem)
      end if
    end if
  end if
end

on useSelectedItem me
  if not voidp(me.oSelectedItem) then
  end if
end

on itemIsInBackpack me, oItem
  oBackPack = oDenizenManager.getBackpack()
  if voidp(oBackPack) then
    return 0
  end if
  bExists = oBackPack.idExists(oItem.getPosId())
  return bExists
end

on moveSelectedItem me, bForce
  if not gFeatureSet.isEnabled(#FURNITURE_MOVE) and voidp(bForce) then
    return 
  end if
  if not voidp(me.oSelectedItem) then
    if voidp(oStudio) then
      bIsOwner = 1
      bIsMod = 1
      bTrading = 0
    else
      bIsOwner = oStudio.isOwner(oDenizenManager.getScreenName())
      bIsMod = oDenizenManager.isMod()
      bTrading = not voidp(ElementMgr.getTrader())
    end if
    if not bIsOwner and not bIsMod and not bTrading then
      return 
    end if
    if bTrading then
      if not me.itemIsInBackpack(me.oSelectedItem) then
        put "items is in backpack can't trade it"
        return 
      end if
    end if
    sType = me.oSelectedItem.getType()
    if sType = "Wallpaper" then
      if bTrading then
        me.oSelectedItem.setDrag(1)
        return 
      end if
      me.oSelectedItem.displayWallReplace()
      me.deleteSelectedItem()
      return 
    end if
    if sType = "Floor" then
      if bTrading then
        me.oSelectedItem.setDrag(1)
        return 
      end if
      me.oSelectedItem.displayFloorReplace()
      me.deleteSelectedItem()
      return 
    end if
    me.oSelectedItem.setDrag(1)
  end if
end

on dropSelectedItem me, bReset
  if voidp(bReset) then
    bReset = 0
  end if
  bDropped = 0
  if not voidp(me.oSelectedItem) then
    if me.oSelectedItem.getDrag() then
      if bReset then
        if not me.oSelectedItem.resetLastPosition() then
          me.deleteSelectedItem()
        end if
        return 
      end if
      if ElementMgr.mouseIsOverBackpack() then
        if not me.oSelectedItem.resetLastPosition() then
          me.deleteSelectedItem()
        end if
        return 
      end if
      if voidp(oStudio) then
        bOwner = 1
        bIsMod = 1
      else
        bOwner = oStudio.isOwner(oDenizenManager.getScreenName())
        bIsMod = oDenizenManager.isMod()
      end if
      if not bOwner and not bIsMod then
        if not me.oSelectedItem.resetLastPosition() then
          me.deleteSelectedItem()
        end if
        return 
      end if
      bDropped = me.oSelectedItem.drop()
      if bDropped then
        me.oSelectedItem.setDrag(0)
        me.oSelectedItem.sendPutInStudio()
      else
        if not me.oSelectedItem.resetLastPosition() then
          me.deleteSelectedItem()
        end if
      end if
    end if
  end if
  return bDropped
end

on updateSelectedItem me, oSquare
  if not voidp(me.oSelectedItem) then
    if me.oSelectedItem.getDrag() then
      if me.oSelectedItem.isWallItem() then
        return 
      end if
      if ElementMgr.mouseIsOverBackpack() then
        return 
      end if
      bSuccess = me.oSelectedItem.placeItem(oSquare)
      return bSuccess
    end if
  end if
  return 0
end

on getSquareOffsets me, oItem, oSquare
  aOccupiedSquares = oItem.getOccupiedSquares()
  iGridX = oItem.getGridX()
  iGridZ = oItem.getGridZ()
  iXDif = oSquare.iCol - iGridX
  iZDif = oSquare.iRow - iGridZ
  aDifList = []
  repeat with i in aOccupiedSquares
    if voidp(i) then
      next repeat
    end if
    oDifSquare = me.oGrid.getSquareByRowCol(i.iRow + iZDif, i.iCol + iXDif)
    if not voidp(oDifSquare) then
      aDifList.add(oDifSquare)
    end if
  end repeat
  return aDifList
end

on addSelectedItemToTrade me
  if voidp(me.oSelectedItem) then
    put "addSelectedItemToTrade() selected item was void"
    return 
  end if
  if not me.oSelectedItem.isFurniItem() and not me.oSelectedItem.isWallItem() then
    put "addSelectedItemToTrade() NOT FURNI AND NOT WALL ITEM"
    return 
  end if
  if not me.oSelectedItem.getDrag() then
    put "addSelectedItemToTrade() NOT DRAG"
    return 
  end if
  iPosId = me.oSelectedItem.getPosId()
  oStudio.sendAddToTrade(iPosId)
  me.deleteSelectedItem()
end

on getItemByPossessionId me, iPosId
  oItem = me.oFurniture.getItemByPossessionId(iPosId)
  if not voidp(oItem) then
    return oItem
  end if
  oItem = me.oWallItems.getItemByPossessionId(iPosId)
  if not voidp(oItem) then
    return oItem
  end if
  oItem = me.oRugs.getItemByPossessionId(iPosId)
  if not voidp(oItem) then
    return oItem
  end if
  return VOID
end

on calcMouseToSquare me
  oGridPoint = me.calcMouseToGridPoint()
  oSquare = me.oGrid.getSquareByXZ(oGridPoint.x, oGridPoint.z)
  return oSquare
end

on calcMouseToGridPoint me
  oGridPoint = me.calcViewToGridPoint(point(the mouseH, the mouseV))
  return oGridPoint
end

on calcViewToGridPoint me, oViewPoint
  iViewX = oViewPoint.locH - me.iXOff
  iViewY = oViewPoint.locV - me.iYOff
  iZ = float(((iViewX / me.fCosY) - (iViewY / (me.fSinY * me.fSinX))) * (1 / ((me.fCosY / me.fSinY) + (me.fSinY / me.fCosY))))
  iX = float(1 / me.fCosY * (iViewX - (iZ * me.fSinY)))
  return vector(iX, 0, iZ)
end

on calcGridToViewPoint me, oGridPoint
  me.debug("calcViewPoint()")
  return point(me.calcViewX(oGridPoint), me.calcViewY(oGridPoint))
end

on calcGridToViewPoints me, oGridPoints
  me.debug("calcViewPoints()")
  oViewPoints = new(script("Quad"))
  oViewPoints.tl = me.calcViewPoint(oGridPoints.tl)
  oViewPoints.tr = me.calcViewPoint(oGridPoints.tr)
  oViewPoints.br = me.calcViewPoint(oGridPoints.br)
  oViewPoints.bl = me.calcViewPoint(oGridPoints.bl)
  return oViewPoints
end

on calcViewX me, o3dPoint
  return integer(me.iXOff + ((o3dPoint.z * me.fSinY) + (o3dPoint.x * me.fCosY)))
end

on calcViewY me, o3dPoint
  return integer(me.iYOff + ((o3dPoint.y * me.fCosX) - (((o3dPoint.z * me.fCosY) - (o3dPoint.x * me.fSinY)) / 2)))
end

on initScene me, oScene
  me.oBackground.Init(getNode(oScene, "Background"))
  me.oFloor.Init(getNode(oScene, "Floor"))
  me.oDoor.Init(getNode(oScene, "Door"))
  me.oWall.Init(getNode(oScene, "WAll"))
  me.oWindow.Init(getNode(oScene, "Window"))
  me.oWallItems.Init(getNode(oScene, "WallItems"))
  me.oRugs.Init(getNode(oScene, "Rugs"))
  me.oHiliter.Init(getNode(oScene, "Hiliter"))
  me.oFurniture.Init(getNode(oScene, "Furniture"))
  me.oStaticItems.Init(getNode(oScene, "StaticItems"))
  me.oAvatars.Init(getNode(oScene, "Avatars"))
  me.oVoteItems.Init()
  if oStudioMap.isWayneEnt() then
    me.oWall.hideDisplay()
  end if
  if oStudioMap.isPrivate() then
    me.oStudioInfo.Init()
    me.oInfoStand.Init()
  end if
end

on generateXml me
  oNewXml = newObject("XML")
  oRoot = me.oSceneXml.firstChild
  oNewRoot = oNewXml.createElement("Studio")
  oNewRoot.attributes = oRoot.attributes
  aNodes = oRoot.childNodes
  repeat with i = 0 to aNodes.length - 1
    oNode = aNodes[i]
    case oNode.nodeName of
      "Furniture":
        oNewNode = me.oFurniture.generateXml()
        oNewRoot.appendChild(oNewNode)
      otherwise:
        oNewRoot.appendChild(oNode.cloneNode(1))
    end case
  end repeat
  oNewXml.appendChild(oNewRoot)
  return oNewXml
end

on destroyScene me
  me.destroyObjects()
  (the actorList).deleteOne(me)
  oIsoScene = VOID
end

on destroyObjects me
  if not voidp(me.oBackground) then
    me.oBackground.destroy()
  end if
  if not voidp(me.oFloor) then
    me.oFloor.destroy()
  end if
  if not voidp(me.oWall) then
    me.oWall.destroy()
  end if
  if not voidp(me.oDoor) then
    me.oDoor.destroy()
  end if
  if not voidp(me.oHiliter) then
    me.oHiliter.destroy()
  end if
  if not voidp(me.oWindow) then
    me.oWindow.destroy()
  end if
  if not voidp(me.oRugs) then
    me.oRugs.destroy()
  end if
  if not voidp(me.oFurniture) then
    me.oFurniture.destroy()
  end if
  if not voidp(me.oWallItems) then
    me.oWallItems.destroy()
  end if
  if not voidp(me.oStaticItems) then
    me.oStaticItems.destroy()
  end if
  if not voidp(me.oAvatars) then
    me.oAvatars.destroy()
  end if
  if not voidp(me.oGrid) then
    me.oGrid.destroy()
  end if
  if not voidp(me.oSpriteManager) then
    me.oSpriteManager.destroy()
  end if
  if not voidp(me.oStudioInfo) then
    me.oStudioInfo.destroy()
  end if
  if not voidp(me.oInfoStand) then
    me.oInfoStand.destroy()
  end if
  if not voidp(me.oVoteItems) then
    me.oVoteItems.destroy()
  end if
  if not voidp(me.oAvatarIndicator) then
    me.oAvatarIndicator.destroyItem()
  end if
  if not voidp(me.oTrivia) then
    me.oTrivia.destroy()
  end if
  me.oSelectedItem = VOID
end

on createAvatarIndicator me, oAvatar
  if not voidp(me.oAvatarIndicator) then
    me.oAvatarIndicator.destroyItem()
    me.oAvatarIndicator = VOID
  end if
  me.oAvatarIndicator = script("AvatarIndicator").new(oAvatar)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "IsoScene: " & sMessage
  end if
end

on getItemsUnderMouse me
  aItemsUnderMouse = []
  aItemsUnderMouse = me.oFurniture.getItemsUnderMouse(aItemsUnderMouse)
  aItemsUnderMouse = me.oAvatars.getItemsUnderMouse(aItemsUnderMouse)
  return aItemsUnderMouse
end

on getSpritesUnderMouse me
  aSpritesUnderMouse = [:]
  aSpritesUnderMouse = me.oFurniture.getSpritesUnderMouse(aSpritesUnderMouse)
  aSpritesUnderMouse = me.oAvatars.getSpritesUnderMouse(aSpritesUnderMouse)
  aSpritesUnderMouse = me.oWallItems.getSpritesUnderMouse(aSpritesUnderMouse)
  aSpritesUnderMouse = me.oRugs.getSpritesUnderMouse(aSpritesUnderMouse)
  aSpritesUnderMouse.sort()
  return aSpritesUnderMouse
end

on getObjectsUnderMouse me
  aObjectsUnderMouse = [:]
  me.oFurniture.getObjectsUnderMouse(aObjectsUnderMouse)
  me.oAvatars.getObjectsUnderMouse(aObjectsUnderMouse)
  me.oWallItems.getObjectsUnderMouse(aObjectsUnderMouse)
  me.oRugs.getObjectsUnderMouse(aObjectsUnderMouse)
  aObjectsUnderMouse.sort()
  return aObjectsUnderMouse
end

on getTotalItems me
  iTotalItems = 0
  iTotalItems = iTotalItems + me.oWallItems.getTotalItems()
  iTotalItems = iTotalItems + me.oFurniture.getTotalItems()
  return iTotalItems
end

on checkMaxItemsExceeded me
  iTotalItems = me.getTotalItems()
  if iTotalItems >= me.oIsoConstants.DEFAULT_MAX_ITEMS then
    ElementMgr.alert("ALERT_MAX_ITEMS_EXCEEDED")
    return 0
  end if
  return 1
end
