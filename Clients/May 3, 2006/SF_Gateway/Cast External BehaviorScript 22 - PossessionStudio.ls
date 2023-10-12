property bDebug, foRoom
global oSession, oStudio, oPossessionStudio, ElementMgr, oIsoScene, oStudioMap, gCatalog, oPossessionManager, oDenizenManager, gFeatureSet

on beginSprite me
  me.bDebug = 0
  oPossessionStudio = me
end

on setRoomObject me, _foRoom
  me.debug("setRoomObject() " & _foRoom)
  me.foRoom = _foRoom
  me.setCallbacks()
end

on setCallbacks me
  sprite(me.spriteNum).setCallback(me.foRoom, "receivePossessionUpdate", #receivePossessionUpdate, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveRemovePossession", #receiveRemovePossession, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveTeleport", #receiveTeleport, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "receiveRollResult", #receiveRollResult, me)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "PossessionStudio: " & sMessage
  end if
end

on sendRollRequest me, iMaxRoll, posId
  me.foRoom.sendRollRequest(iMaxRoll, posId)
end

on sendEnterStudioViaTeleporter me, iTeleporterId
  me.debug("sendEnterStudioViaTeleporter() " & iTeleporterId)
  if oSession.bTestMode then
    return 
  end if
  oStudio.getcdplayer().reset()
  me.foRoom.sendEnterStudioViaTeleporter(iTeleporterId)
end

on sendUpdatePossession me, oItem
  me.debug("sendUpdatePossession() " & oItem.toString())
  if oSession.bTestMode then
    return 
  end if
  iID = oItem.getPosId()
  iXPos = oItem.getGridX()
  iYPos = oItem.getGridY()
  iZPos = oItem.getGridZ()
  iHeightOffset = oItem.getHeightOffset()
  iDirection = oItem.getDirection()
  iState = oItem.getState()
  sAttributes = oItem.getAttributes()
  me.foRoom.sendUpdatePossession(iID, iXPos, iYPos, iZPos, iHeightOffset, iDirection, iState, sAttributes)
end

on sendPutInStudio me, oItem
  me.debug("sendPutInStudio() " & oItem.toString())
  if not gFeatureSet.isEnabled(#FURNITURE_PUTDOWN) then
    return 
  end if
  if oSession.bTestMode then
    return 
  end if
  iID = oItem.getPosId()
  iXPos = oItem.getGridX()
  iYPos = oItem.getGridY()
  iZPos = oItem.getGridZ()
  iHeightOffset = oItem.getHeightOffset()
  iDirection = oItem.getDirection()
  iState = oItem.getState()
  sAttributes = oItem.getAttributes()
  me.foRoom.sendPutInStudio(iID, iXPos, iYPos, iZPos, iHeightOffset, iDirection, iState, sAttributes)
end

on sendPutInBackpack me, oItem
  me.debug("sendPutInBackpack() " & oItem.toString())
  if not gFeatureSet.isEnabled(#FURNITURE_PICKUP) then
    return 
  end if
  if oSession.bTestMode then
    return 
  end if
  iID = oItem.getPosId()
  me.foRoom.sendPutInBackpack(iID)
  me.addPossessionToBackpack(oItem, 1)
end

on deleteItem me, iPosId
  me.debug("deleteItem() " & iPosId)
  if not gFeatureSet.isEnabled(#FURNITURE_DELETE) then
    return 
  end if
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendRemovePossession(iPosId)
end

on replaceWall me, iPosId, iWallTexture, iWallColor
  me.debug("replaceWall() " & iPosId && iWallTexture && iWallColor)
  if not gFeatureSet.isEnabled(#FURNITURE_PUTDOWN) then
    return 
  end if
  me.foRoom.sendPutInStudio(iPosId, 1, 0, 1, 0, 2, 0, [#texture: iWallTexture, #color: iWallColor])
end

on replaceFloor me, iPosId, iFloorTexture, iFloorColor
  me.debug("replaceFloor() " & iPosId && iFloorTexture && iFloorColor)
  if not gFeatureSet.isEnabled(#FURNITURE_PUTDOWN) then
    return 
  end if
  me.foRoom.sendPutInStudio(iPosId, 1, 0, 1, 0, 2, 0, [#texture: iFloorTexture, #color: iFloorColor])
end

on sendTeleport me, iPosId
  me.debug("sendTeleport() " & iPosId)
  if not gFeatureSet.isEnabled(#TELEPORTING) then
    return 
  end if
  me.foRoom.sendTeleport(iPosId)
end

on sendMoveToTeleporter me, iPosId
  me.debug("sendMoveToTeleporter() " & iPosId)
  me.foRoom.sendMoveToTeleporter(iPosId)
end

on sendMoveToStandOn me, iPosId
  me.debug("sendMoveToStandOn() " & iPosId)
  me.foRoom.sendMoveToStandOn(iPosId)
end

on receiveRollResult me, _flashObject, iResult, iPosId
  iPosId = integer(iPosId)
  iResult = integer(iResult)
  put "PossessionSTudio: receiveRollResult" & iResult & "," & iPosId
  oPossessionAction = oIsoScene.getItemByPossessionId(iPosId).oAction
  put "PossessionSTudio: receiveRollResult: oPossession" & oPossessionAction
  if not voidp(oPossessionAction) then
    oPossessionAction.receiveRollResult(iResult)
  end if
end

on receivePossessionUpdate me, oCaller, iPosId, iCatId, iXPos, iYPos, iZPos, iHeightOffset, iDirection, iState, sAttributes, bItemsAllowedOnTop
  me.debug("receivePossessionUpdate() " & iPosId && iCatId && iXPos && iYPos && iZPos && iHeightOffset && iDirection && iState && sAttributes && bItemsAllowedOnTop)
  iPosId = integer(iPosId)
  iCatId = integer(iCatId)
  if voidp(oIsoScene) then
    return 
  end if
  oItem = gCatalog.getItemByProdId(iCatId)
  if oItem[#type] = "Wallpaper" then
    aAttributes = value(sAttributes)
    iTexture = aAttributes[#texture]
    iColor = aAttributes[#color]
    oIsoScene.oWall.setPattern(iTexture, iColor)
    oStudio.removePossessionFromBackpack(iPosId)
    return 
  end if
  if oItem[#type] = "Floor" then
    aAttributes = value(sAttributes)
    iTexture = aAttributes[#texture]
    iColor = aAttributes[#color]
    oIsoScene.oFloor.setPattern(iTexture, iColor)
    oStudio.removePossessionFromBackpack(iPosId)
    return 
  end if
  if voidp(iYPos) then
    iYPos = 0
  end if
  if voidp(iState) then
    iState = 0
  end if
  iXPos = integer(iXPos)
  iYPos = integer(iYPos)
  iZPos = integer(iZPos)
  iHeightOffset = integer(iHeightOffset)
  iDirection = integer(iDirection)
  iState = integer(iState)
  oPossession = oIsoScene.getItemByPossessionId(iPosId)
  if not voidp(oPossession) then
    if not voidp(iXPos) and (iXPos <> EMPTY) then
      oPossession.setXPos(iXPos)
    end if
    if not voidp(iYPos) and (iYPos <> EMPTY) then
      oPossession.setYPos(iYPos)
    end if
    if not voidp(iZPos) and (iZPos <> EMPTY) then
      oPossession.setZPos(iZPos)
    end if
    if not voidp(iHeightOffset) and (iHeightOffset <> EMPTY) then
      oPossession.setHeightOffset(iHeightOffset)
    end if
    if not voidp(iDirection) and (iDirection <> EMPTY) then
      oPossession.setDirection(iDirection)
    end if
    if not voidp(iState) and (iState <> EMPTY) then
      oPossession.setState(iState)
    end if
    if not voidp(sAttributes) and (sAttributes <> EMPTY) then
      aAttributes = value(sAttributes)
      oPossession.setAttributes(aAttributes)
    end if
    if not voidp(bItemsAllowedOnTop) and (bItemsAllowedOnTop <> EMPTY) then
      oPossession.setItemsAllowedOnTop(bItemsAllowedOnTop)
    end if
    oPossession.update(1)
    if not voidp(oIsoScene.oAvatars) then
      oIsoScene.oAvatars.updateAll()
    end if
    oStudio.removePossessionFromBackpack(iPosId)
    return 
  else
  end if
  if not voidp(oItem) then
    sImageBase = oItem[#imageBase]
    sType = oItem[#type]
    sAction = oItem[#Action]
    sCastLib = "Furniture"
    iRow = iZPos
    iCol = iXPos
    iGridY = iYPos
    if voidp(iState) or (iState = EMPTY) then
      iState = oItem[#state]
    end if
    if voidp(sAttributes) or (sAttributes = EMPTY) then
      aAttributes = oItem[#attributes]
    else
      aAttributes = value(sAttributes)
    end if
    if voidp(iDirection) or (iDirection = EMPTY) then
      iDirection = 2
    end if
    iHeight = oItem[#height]
    if voidp(bItemsAllowedOnTop) or (bItemsAllowedOnTop = EMPTY) then
      bItemsAllowedOnTop = 1
    end if
    oFurnitureItem = oIsoScene.createItem(iCatId, iPosId, sImageBase, sType, sAction, iState, aAttributes, sCastLib, iRow, iCol, iGridY, iDirection, iHeight, iHeightOffset, bItemsAllowedOnTop)
    oFurnitureItem.update(1)
    if not voidp(oIsoScene.oAvatars) then
      oIsoScene.oAvatars.updateAll()
    end if
    oStudio.removePossessionFromBackpack(iPosId)
  end if
end

on addPossessionToBackpack me, oPossession, bPush
  bIsOwner = oStudio.isOwner(oDenizenManager.getScreenName())
  if bIsOwner then
    oBackPack = oDenizenManager.getBackpack()
    if not voidp(oBackPack) then
      oBackPack.addPossessionByItem(integer(oPossession.getPosId()), integer(oPossession.getProdId()), string(oPossession.getAttributes()), bPush)
      iCurrentPage = sendAllSprites(#getBackpackCurrentPage)
      if voidp(iCurrentPage) then
        iCurrentPage = 1
      end if
      oPossessionManager.getPossessionsInBackpack(oDenizenManager.getScreenName(), iCurrentPage, 25)
    end if
  end if
end

on receiveRemovePossession me, oCaller, iPosId, bDeleted
  if the debugPlaybackEnabled then
    put "receiveRemovePossession(): iPosId=" & iPosId && "bDeleted=" & bDeleted
  end if
  me.debug("receiveRemovePossession() " & iPosId, bDeleted)
  if voidp(oIsoScene) then
    return 
  end if
  oPossession = oIsoScene.getItemByPossessionId(iPosId)
  if not voidp(oPossession) then
    if not bDeleted then
      if oIsoScene.isFurniItem() or oIsoScene.isWallItem() then
        oPossession.putInBackPack()
        oIsoScene.oSelectedItem = VOID
        oIsoScene.oInfoStand.display(oIsoScene.oSelectedItem)
      end if
    end if
    oIsoScene.deleteItem(oPossession)
    if not voidp(oIsoScene.oAvatars) then
      oIsoScene.oAvatars.updateAll()
    end if
  else
  end if
end

on receiveTeleport me, oCaller, iLocation, iLayout, sStudioID, sStudioName, iDestinationPosId
  me.debug("receiveTeleport() iLocation: " & iLocation & ", iLayout: " & iLayout & ", sStudioId: " & sStudioID & ", sStudioName: " & sStudioName & ", iDestinationPosId: " & iDestinationPosId)
  if voidp(sStudioID) or (sStudioID = EMPTY) or (sStudioID = 0) then
    return 
  end if
  if voidp(iLocation) or (iLocation = VOID) or (iLocation = EMPTY) or (iLocation = 0) then
    return 
  end if
  if voidp(iLayout) or (iLayout = VOID) or (iLayout = EMPTY) or (iLayout = 0) then
    return 
  end if
  if voidp(iDestinationPosId) or (iDestinationPosId = VOID) or (iDestinationPosId = EMPTY) or (iDestinationPosId = 0) then
    return 
  end if
  sCurrentStudioId = oStudio.getStudioID()
  if sCurrentStudioId = sStudioID then
    me.debug("receiveTeleport() moving to teleporter in same studio", 1)
    oTeleporter = oIsoScene.oFurniture.getItemByPossessionId(iDestinationPosId)
    if voidp(oTeleporter) then
      me.debug("receiveTeleport() void", 1)
      return 
    else
      me.debug("sendingMoveToTeleport()", 1)
      me.sendMoveToTeleporter(iDestinationPosId)
      return 
    end if
  end if
  ElementMgr.closeAllWindows()
  oIsoScene.destroyScene()
  oStudioMap = script("StudioMap").new(integer(iLocation), integer(iLayout), sStudioID, sStudioName)
  oStudioMap.setEnterStudioViaTeleport(integer(iDestinationPosId))
  go("EnterStudio")
end

on getGatewaySprite me
  return sprite(me.spriteNum)
end
