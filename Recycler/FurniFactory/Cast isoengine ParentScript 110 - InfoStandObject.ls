property aSprites, oItem, iPreviewRegPoint, aInfoStandProps, aDescriptionTextProps, oDescRect, oDescMember, sButtonBase, aDynamicMembers, sCastLib, sActive, sPressed, bOverwriteImages
global oIsoScene, gCatalog, oDenizenManager, oStudio, oPossessionStudio, ElementMgr, oStudioMap

on new me
  me.oDescMember = member("InfoStandDescription")
  me.oDescMember.backColor = 255
  me.oDescMember.fontSize = 10
  me.oDescMember.fontStyle = "plain"
  me.aInfoStandProps = [#member: "cc.infostand", #x: 695, #y: 345, #ink: 8]
  me.iPreviewRegPoint = point(723, 364)
  iDescX = 560
  iDescY = 380
  iDescWidth = 190
  iDescHeight = 55
  me.oDescRect = rect(iDescX, iDescY, iDescX + iDescWidth, iDescY + iDescHeight)
  me.aDescriptionTextProps = [#member: me.oDescMember, #x: me.oDescRect.left, #y: me.oDescRect.top, #ink: 8]
  me.sButtonBase = "d1"
  me.aDynamicMembers = []
  me.sCastLib = "IsoEngine"
  me.sActive = "active"
  me.sPressed = "pressed"
  me.bOverwriteImages = 1
  return me
end

on init me
end

on clearInfoStand me
  me.destroy()
end

on display me, _oItem
  me.destroy()
  me.oItem = _oItem
  if voidp(me.oItem) then
    return 
  end if
  if oItem.isWallItem() then
    if not oStudioMap.isPrivate() then
      return 0
    end if
    me.displayInfoStand()
    me.displayWallItem()
    me.displayButtons(me.getWallItemButtonList())
    return 
  end if
  if oItem.isFurniItem() then
    if not oStudioMap.isPrivate() then
      return 0
    end if
    if not oItem.bHasPreview then
      return 
    end if
    me.displayInfoStand()
    me.displayFurniItem()
    me.displayButtons(me.getFurniItemButtonList())
    return 
  end if
  if oItem.isAvatar() then
    me.displayInfoStand()
    me.displayAvatar()
    me.displayButtons(me.getAvatarButtonList())
    return 
  end if
end

on displayCd me, foCd
  if voidp(oStudio) then
    return 
  end if
  if voidp(foCd) then
    return 
  end if
  iCatId = foCd.getCatId()
  sAuthor = foCd.getAuthorName()
  sSongName = foCd.getSongName()
  aCatItem = gCatalog.getItemByProdId(integer(iCatId))
  if voidp(aCatItem) then
    return 
  end if
  sImageBase = aCatItem[#imageBase]
  oPreviewImage = member(sImageBase & "_small")
  if oPreviewImage.memberNum = -1 then
    return 
  end if
  me.destroy()
  me.displayInfoStand()
  me.displayPreviewImage(oPreviewImage)
  sText = "NOW PLAYING" & RETURN & sSongName & RETURN & "by: " & sAuthor & RETURN
  iThumbsUp = oStudio.getcdplayer().getThumbsUpVotes()
  iThumbsDown = oStudio.getcdplayer().getThumbsDownVotes()
  bHasVoted = foCd.hasVoted()
  iVote = foCd.getVote()
  if bHasVoted then
    sText = sText & "Your vote: "
    if iVote >= 0 then
      sText = sText & "Thumbs Up"
    else
      sText = sText & "Thumbs Down"
    end if
  else
    if iThumbsUp > 0 then
      sText = sText & "Positive Votes: " & iThumbsUp
    end if
  end if
  me.displayDescription(sText)
  me.displayButtons(me.getBurnedCdButtonList())
end

on displayWallItem me
  oPreviewImage = me.oItem.getPreviewImage()
  me.displayPreviewImage(oPreviewImage)
  iProdId = me.oItem.getProdId()
  aCatalogItem = gCatalog.getItemByProdId(me.oItem.getProdId())
  sName = aCatalogItem[#name]
  sRoomDesc = aCatalogItem[#roomDesc]
  sText = sName & RETURN & sRoomDesc
  me.displayDescription(sText)
end

on displayFurniItem me
  oPreviewImage = me.oItem.getPreviewImage()
  me.displayPreviewImage(oPreviewImage)
  iProdId = me.oItem.getProdId()
  aCatalogItem = gCatalog.getItemByProdId(me.oItem.getProdId())
  sName = aCatalogItem[#name]
  sRoomDesc = aCatalogItem[#roomDesc]
  sText = sName & RETURN & sRoomDesc
  aAttributes = me.oItem.getAttributes()
  if me.oItem.isBurnedCd() then
    sRoomDesc = aAttributes[#ownerName] & ": " & aAttributes[#songName]
    sText = sName & RETURN & sRoomDesc
  end if
  if me.oItem.getProdId() = oIsoScene.oIsoConstants.TELEPORTER then
    sDestinationName = aAttributes[#destinationName]
    if not voidp(sDestinationName) and (sDestinationName <> EMPTY) then
      sRoomDesc = aAttributes[#destinationOwner] & ": " & aAttributes[#destinationName]
      sText = sRoomDesc
    end if
  end if
  me.displayDescription(sText)
end

on displayAvatar me
  oPreviewImageObject = me.oItem.getPreviewImage()
  oPreviewMember = member("_PREVIEW_", "Internal")
  oPreviewMember.image.copyPixels(oPreviewImageObject, oPreviewImageObject.rect, oPreviewImageObject.rect)
  iSprite = me.displayPreviewImage(oPreviewMember)
  sprite(iSprite).ink = 36
  if oStudioMap.isPrivate() then
    sprite(iSprite).bgColor = rgb(255, 255, 255)
  else
    sprite(iSprite).bgColor = rgb(104, 83, 58)
  end if
  sprite(iSprite).locV = sprite(iSprite).locV + 10
  sBaseText = me.oItem.getScreenName() & RETURN & me.oItem.getMission()
  bDrinking = me.oItem.isDrinking()
  bTrading = me.oItem.isTrading()
  sFinalText = sBaseText
  if bDrinking then
    sFinalText = sBaseText & RETURN & "Carrying: Coke Bottle"
  end if
  if bTrading then
    sFinalText = sBaseText & RETURN & "Trading."
  end if
  me.displayDescription(sFinalText)
end

on displayInfoStand me
  iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(me.aInfoStandProps)
  sprite(iSprite).locZ = oIsoScene.oGrid.getHighestDepth()
  me.aSprites.add(iSprite)
end

on displayPreviewImage me, oPreviewImage
  iWidth = oPreviewImage.width
  iHeight = oPreviewImage.height
  iLeft = me.iPreviewRegPoint.locH - (iWidth / 2)
  iTop = me.iPreviewRegPoint.locV - iHeight
  iRight = iLeft + iWidth
  iBottom = iTop + iHeight
  oRect = rect(iLeft, iTop, iRight, iBottom)
  aProps = [#member: oPreviewImage.name, #x: iLeft, #y: iTop, #ink: 36]
  iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
  sprite(iSprite).bgColor = rgb(255, 255, 255)
  sprite(iSprite).rect = oRect
  sprite(iSprite).locZ = oIsoScene.oGrid.getHighestDepth()
  me.aSprites.add(iSprite)
  return iSprite
end

on displayDescription me, sText
  me.oDescMember.text = sText
  iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(me.aDescriptionTextProps)
  sprite(iSprite).rect = me.oDescRect
  sprite(iSprite).member.rect = me.oDescRect
  sprite(iSprite).locZ = oIsoScene.oGrid.getHighestDepth()
  me.oDescMember.hilite = 1
  me.oDescMember.fontStyle = "plain"
  set the textStyle of line 1 of member "InfoStandDescription" to "bold"
  me.aSprites.add(iSprite)
end

on destroy me
  oIsoScene.oSpriteManager.returnPooledSprites(me.aSprites)
  repeat with sMemberName in me.aDynamicMembers
    oMember = member(sMemberName, me.sCastLib)
    if oMember.memberNum <> -1 then
      oMember.erase()
    end if
  end repeat
  me.aSprites = []
end

on getBurnedCdButtonList me
  aButtonList = []
  foCd = oStudio.getcdplayer().getCd()
  sAuthor = foCd.getAuthorName()
  if oStudio.getcdplayer().getAvatar() = oDenizenManager.getScreenName() then
    return aButtonList
  end if
  bHasVoted = foCd.hasVoted()
  if (bHasVoted = 0) or not bHasVoted then
    aButtonList.add("Thumbs Up")
    aButtonList.add("Thumbs Down")
  end if
  return aButtonList
end

on getFurniItemButtonList me
  bIsMod = me.isMod()
  bIsOwner = me.isOwner()
  aButtonList = []
  if bIsMod or bIsOwner then
    aButtonList.add("Move")
    aButtonList.add("Rotate")
    if me.oItem.canPickup() then
      aButtonList.add("Pick up")
    end if
    if me.oItem.canDelete() then
      aButtonList.add("Delete")
    end if
    if me.oItem.canUse() then
      aButtonList.add("Use")
    end if
  end if
  return aButtonList
end

on getAvatarButtonList me
  bIsMod = me.isMod()
  bIsMe = me.isMe()
  bIsOwner = me.isOwner()
  aButtonList = []
  if bIsMe then
    bIsSitting = me.oItem.isSitting()
    bIsDancing = me.oItem.isDancing()
    if bIsDancing then
      aButtonList.add("Stop Dancing")
    else
      if not bIsSitting then
        aButtonList.add("Dance")
      end if
    end if
    if voidp(oStudio) then
      bIsPlaying = 0
    else
      bIsPlaying = oStudio.getcdplayer().isPlaying() = 1
    end if
    if bIsPlaying then
      sCdPlayerAvatar = oStudio.getcdplayer().getAvatar()
      bIsPerforming = sCdPlayerAvatar = oDenizenManager.getScreenName()
      if bIsPerforming then
        aButtonList.add("Stop Performing")
      end if
    end if
  else
    if bIsOwner or bIsMod then
      aButtonList.add("Kick Out")
    end if
    bIsTrading = me.oItem.isTrading()
    if not bIsTrading then
      aButtonList.add("Trade")
    end if
    oMessenger = ElementMgr.getMessengerObject()
    bIsFriend = oMessenger.isFriend(me.oItem.getScreenName())
    bHaveInvited = oMessenger.haveInvited(me.oItem.getScreenName())
    if not bIsFriend and not bHaveInvited then
      aButtonList.add("Ask to become a friend")
    end if
  end if
  return aButtonList
end

on getWallItemButtonList me
  bIsMod = me.isMod()
  bIsOwner = me.isOwner()
  aButtonList = []
  if bIsMod or bIsOwner then
    aButtonList.add("Move")
    aButtonList.add("Pick up")
    if me.oItem.canDelete() then
      aButtonList.add("Delete")
    end if
  end if
  return aButtonList
end

on displayButtons me, aButtons
  iTop = me.oDescRect.bottom
  iRight = me.oDescRect.right
  iXOffset = 3
  repeat with sButton in aButtons
    iSprite = me.createButtonSprite(sButton)
    sprite(iSprite).locV = iTop
    sprite(iSprite).locH = iRight - sprite(iSprite).width - iXOffset
    iRight = sprite(iSprite).locH
  end repeat
end

on createButtonSprite me, sID
  oActiveMember = me.createButtonMember(sID, me.sActive)
  oPressedMember = me.createButtonMember(sID, me.sPressed)
  aSpriteProps = [#member: oActiveMember.name, #x: 0, #y: 0, #ink: 8]
  iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(aSpriteProps)
  sprite(iSprite).locZ = oIsoScene.oGrid.getHighestDepth()
  sprite(iSprite).scriptInstanceList.add(script("InfoStandSpriteScript").new(sID, me, oActiveMember, oPressedMember))
  me.aSprites.add(iSprite)
  return iSprite
end

on createTextMember me, sText
  sDynamicTextName = "_DYNAMIC_" & sText
  oTextMember = member(sDynamicTextName, me.sCastLib)
  if (oTextMember.memberNum <> -1) and me.bOverwriteImages then
    oTextMember.erase()
  end if
  oTextMember = member(sDynamicTextName, me.sCastLib)
  if oTextMember.memberNum = -1 then
    oTextMember = new(#text, castLib(me.sCastLib))
    oTextMember.name = sDynamicTextName
    oTextMember.text = sText
    oTextMember.boxType = #fixed
    oTextMember.color = rgb("#EEDBC6")
    oTextMember.fontSize = 10
    oTextMember.fontStyle = [#bold]
    oTextMember.font = "verdana"
    me.aDynamicMembers.add(sDynamicTextName)
  end if
  return oTextMember
end

on createButtonMember me, sText, sState
  sDynamicButtonName = "_DYNAMIC_" & sText & "_" & sState
  oButtonMember = member(sDynamicButtonName, me.sCastLib)
  if (oButtonMember.memberNum <> -1) and me.bOverwriteImages then
    oButtonMember.erase()
  end if
  oButtonMember = member(sDynamicButtonName, me.sCastLib)
  if oButtonMember.memberNum = -1 then
    oButtonMember = new(#bitmap, castLib(me.sCastLib))
    oButtonMember.name = sDynamicButtonName
    sLeftMember = "button." & me.sButtonBase & ".left." & sState
    sMiddleMember = "button." & me.sButtonBase & ".middle." & sState
    sRightMember = "button." & me.sButtonBase & ".right." & sState
    oLeftMember = member(sLeftMember)
    oMiddleMember = member(sMiddleMember)
    oRightMember = member(sRightMember)
    imLeft = oLeftMember.image
    imMiddle = oMiddleMember.image
    imRight = oRightMember.image
    oTextMember = me.createTextMember(sText)
    imText = oTextMember.image
    oLoc = oTextMember.charPosToLoc(oTextMember.text.length + 1)
    iTextWidth = oLoc.locH
    iTextHeight = oLoc.locV
    iTotalWidth = imLeft.width + iTextWidth + imRight.width
    iTotalHeight = imMiddle.height
    oButtonImage = image(iTotalWidth, iTotalHeight, 16)
    oSourceRect = imLeft.rect
    oDestRect = rect(0, 0, imLeft.width, imLeft.height)
    oButtonImage.copyPixels(imLeft, oDestRect, oSourceRect)
    oSourceRect = imMiddle.rect
    oDestRect = rect(imLeft.width, 0, imLeft.width + iTextWidth, iTotalHeight)
    oButtonImage.copyPixels(imMiddle, oDestRect, oSourceRect)
    iVOffset = 4
    oSourceRect = rect(0, 0, iTextWidth, oTextMember.height)
    oDestRect = rect(imLeft.width, iVOffset, imLeft.width + iTextWidth, iVOffset + oTextMember.height)
    oButtonImage.copyPixels(imText, oDestRect, oSourceRect)
    oSourceRect = imRight.rect
    oDestRect = rect(imLeft.width + iTextWidth, 0, imLeft.width + iTextWidth + imRight.width, iTotalHeight)
    oButtonImage.copyPixels(imRight, oDestRect, oSourceRect)
    oButtonMember.image = oButtonImage
    oButtonMember.regPoint = point(0, 0)
    me.aDynamicMembers.add(sDynamicButtonName)
  end if
  return oButtonMember
end

on mouseUpEvent me, sID
  case sID of
    "Dance":
      if me.isAvatar() and me.isMe() and not me.oItem.isDancing() then
        me.oItem.dance()
        if not voidp(oStudio) then
          oStudio.sendUpdateAvatar(VOID, VOID, VOID, VOID, "dnc")
        end if
        me.display(oIsoScene.oSelectedItem)
      end if
    "Stop Dancing":
      if me.isAvatar() and me.isMe() and me.oItem.isDancing() then
        me.oItem.stopDancing()
        if not voidp(oStudio) then
          oStudio.sendUpdateAvatar(VOID, VOID, VOID, VOID, "std")
        end if
        me.display(oIsoScene.oSelectedItem)
      end if
    "Kick Out":
      if me.isAvatar() then
        if me.isOwner() or me.isMod() then
          sScreenName = me.oItem.getScreenName()
          oStudio.sendKickAvatar(sScreenName)
        end if
      end if
    "Trade":
      if me.isAvatar() then
        sTradee = me.oItem.getScreenName()
        oStudio.sendStartTrade(sTradee)
        me.display(VOID)
      end if
    "Ask to become a friend":
      if me.isAvatar() and not me.isMe() then
        if not voidp(ElementMgr) then
          ElementMgr.alert("MESSENGER_REQUEST_SENT")
        end if
        bIsFriend = ElementMgr.getMessengerObject().isFriend(me.oItem.getScreenName())
        bHaveInvited = ElementMgr.getMessengerObject().haveInvited(me.oItem.getScreenName())
        if bIsFriend or bHaveInvited then
          me.display(VOID)
          return 
        end if
        oDenizenManager.inviteFriend(oDenizenManager.getScreenName(), me.oItem.getScreenName())
        ElementMgr.getMessengerObject().addMyInvite(me.oItem.getScreenName())
        me.display(VOID)
      end if
    "Delete":
      if me.isFurniItem() or me.isWallItem() then
        iPosId = me.oItem.getPosId()
        if not voidp(ElementMgr) then
          ElementMgr.displayDeleteConfirm(iPosId)
        end if
      end if
    "Pick up":
      if me.isFurniItem() or me.isWallItem() then
        me.oItem.putInBackPack()
        oIsoScene.oSelectedItem = VOID
        me.display(oIsoScene.oSelectedItem)
      end if
    "Rotate":
      if me.isFurniItem() then
        me.oItem.rotateItem()
        me.display(oIsoScene.oSelectedItem)
      end if
    "Move":
      if me.isFurniItem() or me.isWallItem() then
        oIsoScene.moveSelectedItem()
      end if
    "Use":
      if me.isFurniItem() or me.isWallItem() then
        me.oItem.oAction.use()
      end if
    "Thumbs Up":
      bHasVoted = me.hasVoted()
      if (bHasVoted = 0) or not bHasVoted then
        oStudio.getcdplayer().getCd().votePositive()
        oStudio.sendThumbsUp()
      end if
      me.displayCd(oStudio.getcdplayer().getCd())
      me.display(VOID)
    "Thumbs Down":
      bHasVoted = me.hasVoted()
      if (bHasVoted = 0) or not bHasVoted then
        oStudio.getcdplayer().getCd().voteNegative()
        oStudio.sendThumbsDown()
      end if
      me.displayCd(oStudio.getcdplayer().getCd())
      me.display(VOID)
    "Stop Performing":
      oStudio.sendCdEnd()
      me.display(VOID)
  end case
end

on hasVoted me
  if voidp(oStudio) then
    return 0
  end if
  return oStudio.getcdplayer().getCd().hasVoted()
end

on isOwner me
  if voidp(oStudio) then
    return 1
  end if
  return oStudio.isOwner(oDenizenManager.getScreenName())
end

on isMod me
  if voidp(oStudio) then
    return 1
  end if
  return oDenizenManager.isMod()
end

on isAvatar me
  if voidp(me.oItem) then
    return 0
  end if
  if voidp(oIsoScene.oSelectedItem) then
    return 
  end if
  if oIsoScene.oSelectedItem <> me.oItem then
    return 
  end if
  return me.oItem.isAvatar()
end

on isFurniItem me
  if voidp(me.oItem) then
    return 0
  end if
  if voidp(oIsoScene.oSelectedItem) then
    return 
  end if
  if oIsoScene.oSelectedItem <> me.oItem then
    return 
  end if
  return me.oItem.isFurniItem()
end

on isWallItem me
  if voidp(me.oItem) then
    return 0
  end if
  if voidp(oIsoScene.oSelectedItem) then
    return 
  end if
  if oIsoScene.oSelectedItem <> me.oItem then
    return 
  end if
  return me.oItem.isWallItem()
end

on isMe me
  if not me.isAvatar() then
    return 0
  end if
  if voidp(oStudio) then
    return 1
  end if
  return me.oItem.getScreenName() = oDenizenManager.getScreenName()
end
