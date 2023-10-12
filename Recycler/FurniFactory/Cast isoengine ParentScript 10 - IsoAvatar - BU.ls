property ancestor, aCurrentDirection, oEngine, iSprite, iShadowSprite, oPreviewMember, sMission, sScreenName, bPerforming, bDrinking, sDrawOrder, sShadowDrawOrder, iHitTestColor1, iHitTestColor2, iGridY, sPosId, bTrading
global oIsoScene, oStudioMap, oPossessionStudio, oDenizenManager

on new me, sID, _iScale, _sAttributes, _sScreenName, _sMission
  me.sScreenName = _sScreenName
  me.sMission = _sMission
  me.iSprite = oIsoScene.oSpriteManager.getPooledSprite()
  sprite(me.iSprite).visible = 1
  me.iShadowSprite = oIsoScene.oSpriteManager.getPooledSprite()
  sprite(me.iShadowSprite).visible = 1
  me.oEngine = new(script("AvatarEngine"), _sAttributes, _iScale)
  me.oEngine.initSprites(me.iSprite, me.iShadowSprite)
  sprite(me.iSprite).scriptInstanceList.add(script("SceneItemScript").new(me))
  me.ancestor = script("IsoSprite").rawNew()
  callAncestor(#new, me, sID)
  me.setFPS(me.oEngine.getFPS())
  me.iScale = 100
  me.iSpeed = 2
  me.aCurrentDirection = me.down
  me.iSpeed = 6
  me.bPerforming = 0
  me.bDrinking = 0
  me.sDrawOrder = "av"
  me.sShadowDrawOrder = "avsd"
  me.iGridY = 0
  me.bTrading = 0
  me.iHitTestColor1 = 65535
  me.iHitTestColor2 = 32767
  oIsoScene.oAvatars.addItem(me)
  me.sPosId = -100
  (the actorList).add(me)
  return me
end

on getSprites me
  return [me.iSprite, me.iShadowSprite]
end

on getSprite me
  return me.iSprite
end

on equals me, _oItem
  if voidp(_oItem) then
    return 0
  end if
  if not _oItem.isAvatar() then
    return 0
  end if
  return me.getScreenName() = _oItem.getScreenName()
end

on mouseDownEvent me, iSpriteNum, bDoubleClick
  if bDoubleClick then
    return 0
  end if
  iSpriteNum = me.hitTestAll()
  bHitTest = not voidp(iSpriteNum)
  if bHitTest then
    oIsoScene.createAvatarIndicator(me)
  end if
  return bHitTest
end

on mouseIsOverITem me
  if me.hitTest() then
    return 1
  else
    return 0
  end if
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

on hitTest me
  _oSprite = sprite(me.oEngine.iImageSprite)
  _oMember = _oSprite.member
  if voidp(_oMember) then
    return 
  end if
  if _oMember.memberNum <= 0 then
    return 0
  end if
  _oMemberLoc = _oSprite.mapStageToMember(the mouseLoc)
  if voidp(_oMemberLoc) then
    return 0
  end if
  _oMember = _oSprite.member
  _oImage = _oMember.image
  _iPixelColor = _oImage.getPixel(_oMemberLoc, #integer)
  if _iPixelColor = me.iHitTestColor1 then
    return 0
  end if
  if _iPixelColor = me.iHitTestColor2 then
    return 0
  end if
  return 1
end

on rotate me
  me.oEngine.rotate()
end

on getScreenName me
  return me.sScreenName
end

on getMission me
  return me.sMission
end

on getDrag me
  return 0
end

on deleteItem me
  oIsoScene.oAvatars.removeItem(me)
end

on getPreviewImage me
  return me.oEngine.getPreviewImage()
end

on getEngine me
  return me.oEngine
end

on setItemsAllowedOnTop me, _bItemsAllowedOnTop
end

on getItemsAllowedOnTop me
  return 0
end

on destroy me
  oIsoScene.oSpriteManager.returnPooledSprite(me.iSprite)
  oIsoScene.oSpriteManager.returnPooledSprite(me.iShadowSprite)
  (the actorList).deleteOne(me)
end

on toggleDisplay me
  sprite(me.iSprite).visible = not sprite(me.iSprite).visible
end

on createSprite me, _sMember
  return sprite(me.oEngine.iImageSprite)
end

on stepFrame me
  bDoFrameEvent = me.oEngine.stepFrame()
  if bDoFrameEvent then
    me.doFrameEvent()
  end if
end

on doFrameEvent me
  callAncestor(#doFrameEvent, me)
end

on setAvatar me, oAvatar
end

on display me
  if voidp(me.oSquare) then
    return 
  end if
  me.oEngine.setLoc(me.oViewPoint)
  me.iDepth = me.calculateZOrder(me.sDrawOrder)
  iShadowDepth = me.calculateZOrder(me.sShadowDrawOrder)
  if oStudioMap.isPrivate() then
    if me.oSquare.equals(oIsoScene.oDoor.oSquare) then
      me.iDepth = oIsoScene.oDoor.getLowestZ() - 2
      iShadowDepth = oIsoScene.oDoor.getLowestZ() - 3
    end if
  end if
  me.oEngine.setDepth(me.iDepth, iShadowDepth)
end

on animateAlongPath me, _aPath, iTimeDelta
  callAncestor(#animateAlongPath, me, _aPath, iTimeDelta)
end

on nextPath me
end

on stopPathAnimation me
  if not me.bMoving then
    me.updateStatus()
    me.checkForTeleporter()
  end if
end

on animateToSquare me, _oSquare
  me.walk()
  callAncestor(#animateToSquare, me, _oSquare)
end

on applyDirection me, aDirection
  me.debug("applyDirection()")
  aDirection = me.roundPoint(aDirection)
  me.aCurrentDirection = aDirection
  iIndex = me.aDirections.getPos(aDirection)
  if iIndex > 0 then
    me.oEngine.changeDirection(iIndex - 1)
  end if
end

on roundPoint me, oP
  oP.locH = integer(oP.locH)
  oP.locV = integer(oP.locV)
  return oP
end

on checkForTeleporter me
  oItem = oIsoScene.oFurniture.getTeleporterAtSquare(me.oSquare)
  if not voidp(oItem) then
    oItem.oAction.turnOn()
    if me.getScreenName() = oDenizenManager.getScreenName() then
      script("_TIMER_").new(2000, #goToStudioViaTeleporter, me, oItem.sPosId)
    end if
  end if
end

on moveToSquare me, _oSquare
  me.ancestor.moveToSquare(_oSquare)
  me.updateStatus()
  if voidp(oDenizenManager) then
    return 
  end if
  if me.getScreenName() = oDenizenManager.getScreenName() then
    oItem = oIsoScene.oFurniture.getTeleporterAtSquare(me.oSquare)
    if not voidp(oItem) then
      script("_TIMER_").new(1200, #moveToFrontOfTeleporter, me, oItem.sPosId)
    end if
  end if
end

on goToStudioViaTeleporter me, iTeleporterId
  oItem = oIsoScene.oFurniture.getTeleporterAtSquare(me.oSquare)
  if voidp(oItem) then
    return 
  end if
  if not voidp(oPossessionStudio) then
    oPossessionStudio.sendTeleport(iTeleporterId)
  end if
end

on moveToFrontOfTeleporter me, iTeleporterId
  oItem = oIsoScene.oFurniture.getItemByPossessionId(iTeleporterId)
  if not voidp(oItem) then
    if oItem.getSquare() = me.oSquare then
      oIsoScene.moveAvatarToFrontOfItem(oItem)
    end if
  end if
end

on updateStatus me
  oSeatableItem = oIsoScene.oFurniture.getSeatableItemAtSquareWithGreatestHeightOffset(me.oSquare)
  bIsSeatable = not voidp(oSeatableItem)
  if bIsSeatable then
    iDir = oSeatableItem.getDirection()
    me.sit(iDir)
  else
    me.stand()
  end if
  bSitting = me.isSitting()
  _iOffset = 0
  _iGridY = 0
  if bIsSeatable then
    _iOffset = oSeatableItem.getHeightOffset()
    _iGridY = oSeatableItem.getGridY()
  end if
  if not bIsSeatable then
    oTeleporter = oIsoScene.oFurniture.getTeleporterAtSquare(me.oSquare)
    if not voidp(oTeleporter) then
      oTeleporter.oAction.turnOn()
      iDir = oTeleporter.getDirection()
      me.faceDirection(iDir)
    end if
  end if
  me.setHeightOffset(_iOffset)
  me.setGridY(_iGridY)
  me.display()
end

on stopAnimation me
  callAncestor(#stopAnimation, me)
end

on stand me
  me.oEngine.stand()
end

on walk me
  if not me.oEngine.isWalking() then
    me.setGridY(0)
    me.setHeightOffset(0)
    me.oEngine.walk()
  end if
end

on sit me, iDir
  me.faceDirection(iDir)
  if me.isDancing() then
    me.stopDancing()
  end if
  me.oEngine.sit()
end

on isSitting me
  return me.oEngine.isSitting()
end

on dance me
  me.oEngine.dance(1)
end

on stopDancing me
  me.oEngine.dance(0)
end

on isDancing me
  return me.oEngine.bDance
end

on setPerforming me, _bPerforming
  me.bPerforming = _bPerforming
end

on isPerforming me
  return me.bPerforming
end

on isDrinking me
  return me.oEngine.isCarrying()
end

on chat me, sMessage
  me.oEngine.chat(sMessage)
end

on faceDirection me, iDir
  aDir = me.aDirections[iDir + 1]
  oDir = point(aDir[1], aDir[2])
  me.applyDirection(oDir)
end

on existsAtSquare me, _oSquare
  if me.getSquare().equals(_oSquare) then
    return 1
  else
    return 0
  end if
end

on isWallItem me
  return 0
end

on isFurniItem me
  return 0
end

on isAvatar me
  return 1
end

on isBurnedCd me
  return 0
end

on displayThumbsUp me
  me.showVoteICon(1)
end

on displayThumbsDown me
  me.showVoteICon(0)
end

on showVoteICon me, bState
  script("VoteIndicator").new(bState, me.iSprite)
end

on drinkCoke me
  me.bDrinking = 1
  me.oEngine.setItemAction("crr")
end

on getGridY me
  return me.iGridY
end

on setGridY me, _iGridY
  me.iGridY = _iGridY
end

on setHeightOffset me, _iHeightOffset
  me.oEngine.setHeightOffset(_iHeightOffset)
end

on getHeightOffset me
  return me.oEngine.getHeightOffset()
end

on calculateZOrder me, sOrder
  if voidp(me.oSquare) then
    return 
  end if
  iZ = me.oSquare.getDepthFromMap(sOrder, me.iGridY)
  return iZ
end

on getSquare me
  return me.oSquare
end

on toString me
  return "[AVATAR] " & me.getScreenName()
end

on debug me, sMessage, bForce
  me.ancestor.debug(sMessage, bForce)
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

on setTrading me, bStatus
  me.bTrading = bStatus
end

on isTrading me
  return me.bTrading
end
