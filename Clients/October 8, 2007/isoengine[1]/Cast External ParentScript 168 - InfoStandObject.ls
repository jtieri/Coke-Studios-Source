property aSprites, oItem, iPreviewRegPoint, aInfoStandProps, aDescriptionTextProps, oDescRect, oDescMember, sButtonBase, aDynamicMembers, sCastLib, sActive, sPressed, bOverwriteImages
global oIsoScene, gCatalog, oDenizenManager, oStudio, oPossessionStudio, ElementMgr, oStudioMap, gFeatureSet, oSession

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

on Init me
end

on clearInfoStand me
  me.destroy()
end

on display me, _oItem
  put "infostand : received display()"
  me.destroy()
  me.oItem = _oItem
  put "infostand : oItem = " & oItem
  if voidp(me.oItem) then
    return 
  end if
  if oItem.isWallItem() then
    if not oStudioMap.isPrivate() then
      return 0
    end if
    me.displayInfoStand()
    me.displayWallItem()
    me.DisplayButtons(me.getWallItemButtonList())
    return 
  end if
  if oItem.isFurniItem() then
    put "it's a furni item"
    if not oStudioMap.isPrivate() then
      return 0
    end if
    if not oItem.bHasPreview then
      return 
    end if
    me.displayInfoStand()
    me.displayFurniItem()
    me.DisplayButtons(me.getFurniItemButtonList())
    return 
  end if
  if oItem.isAvatar() then
    me.displayInfoStand()
    me.displayAvatar()
    me.DisplayButtons(me.getAvatarButtonList())
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
  iThumbsUp = integer(oStudio.getcdplayer().getThumbsUpVotes())
  iThumbsDown = integer(oStudio.getcdplayer().getThumbsDownVotes())
  bHasVoted = foCd.hasVoted()
  bEligibleVoter = oStudio.getcdplayer().isEligibleVoter(oDenizenManager.getScreenName())
  bIsPlayer = oStudio.getcdplayer().getAvatar() = oDenizenManager.getScreenName()
  bIsAuthor = foCd.getAuthorName() = oDenizenManager.getScreenName()
  iVote = integer(foCd.getVote())
  if bHasVoted then
    sText = sText & "Your vote: "
    if iVote >= 0 then
      sText = sText & "Thumbs Up"
    else
      sText = sText & "Thumbs Down"
    end if
  else
    if not bEligibleVoter and not bIsPlayer then
      sText = sText & "Your vote: Thumbs Up"
    else
      if iThumbsUp > 0 then
        sText = sText & "Positive Votes: " & iThumbsUp
      end if
    end if
  end if
  me.displayDescription(sText)
  me.DisplayButtons(me.getBurnedCdButtonList())
end

on displayWallItem me
  oPreviewImage = me.oItem.getPreviewImage()
  me.displayPreviewImage(oPreviewImage)
  iProdId = me.oItem.getProdId()
  aCatalogItem = gCatalog.getItemByProdId(me.oItem.getProdId())
  if iProdId = 109 then
    sName = aCatalogItem[#name]
    sRoomDesc = aCatalogItem[#roomDesc]
  else
    sName = aCatalogItem[#name]
    sRoomDesc = aCatalogItem[#roomDesc]
  end if
  sText = sName & RETURN & sRoomDesc
  if me.oItem.sAction = "TOP_40_CHART" then
    sAuthor = me.oItem.aAttributes[#author]
    sTitle = me.oItem.aAttributes[#title]
    sDesc = me.oItem.aAttributes[#desc]
    if not (voidp(sDesc) or voidp(sAuthor) or voidp(sTitle)) then
      sText = sName & RETURN
      if not voidp(sDesc) then
        sText = sText & sDesc & RETURN
      end if
      if not voidp(sAuthor) then
        sText = sText & sAuthor & RETURN
      end if
      if not voidp(sTitle) then
        sText = sText & sTitle
      end if
    end if
  end if
  me.displayDescription(sText)
end

on displayFurniItem me
  put "infostand: received displayFurniItem()"
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
  me.displayDescription(sText)
end

on displayAvatar me
  oPreviewImageObject = me.oItem.getPreviewImage()
  oPreviewMember = member("_PREVIEW_", "AvatarEngine")
  oPreviewMember.image.copyPixels(oPreviewImageObject, oPreviewImageObject.rect, oPreviewImageObject.rect)
  iSprite = me.displayPreviewImage(oPreviewMember)
  sprite(iSprite).ink = 36
  if oStudioMap.isPrivate() then
    sprite(iSprite).bgColor = rgb(255, 255, 255)
  else
    sprite(iSprite).bgColor = rgb(100, 100, 100)
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
  put "infostand : received displayinfostand()"
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
  repeat with i = 1 to the number of castMembers of castLib "IsoEngine"
    oMember = member(i, "IsoEngine")
    sName = oMember.name
    if sName contains "_DYNAMIC_INFOSTAND_" then
      oMember.erase()
    end if
  end repeat
  me.aSprites = []
end

on getBurnedCdButtonList me
  aButtonList = []
  foCd = oStudio.getcdplayer().getCd()
  sAuthor = foCd.getAuthorName()
  bEligibleVoter = oStudio.getcdplayer().isEligibleVoter(oDenizenManager.getScreenName())
  if not bEligibleVoter then
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
  bIsOwner = me.isOwner()
  aButtonList = []
  aCatItem = gCatalog.getItemByProdId(integer(me.oItem.sProdID))
  if voidp(aCatItem) then
    bModifiable = 1
  else
    bModifiable = aCatItem.modifiable
  end if
  if bIsOwner then
    aButtonList.add("Move")
    if me.oItem.getProdId() <> 192 then
      aButtonList.add("Rotate")
    end if
    if me.oItem.canPickup() and bModifiable then
      aButtonList.add("Pick up")
    end if
    if me.oItem.canDelete() and bModifiable then
      aButtonList.add("Delete")
    end if
    if me.oItem.canUse() then
      aButtonList.add("Use")
    end if
  end if
  if voidp(getaProp(me.oItem.aAttributes, #urlLink)) = 0 then
    aButtonList.add(me.oItem.aAttributes[#urlTitle])
  end if
  return aButtonList
end

on getAvatarButtonList me
  bIsMod = me.isMod()
  bIsMe = me.isMe()
  bIsOwner = me.isOwner()
  bIsBot = me.isBot()
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
    if (bIsOwner or bIsMod) and not bIsBot then
      aButtonList.add("Kick Out")
    end if
    bIsTrading = me.oItem.isTrading()
    if not bIsTrading and not bIsBot then
      aButtonList.add("Trade")
    end if
    oMessenger = ElementMgr.getMessengerObject()
    bIsFriend = oMessenger.isFriend(me.oItem.getScreenName())
    bHaveInvited = oMessenger.haveInvited(me.oItem.getScreenName())
    if not bIsFriend and not bHaveInvited and not bIsBot then
      aButtonList.add("Ask to become a friend")
    end if
  end if
  return aButtonList
end

on getWallItemButtonList me
  bIsOwner = me.isOwner()
  aButtonList = []
  if bIsOwner then
    aButtonList.add("Move")
    aButtonList.add("Pick up")
    if me.oItem.canDelete() then
      aButtonList.add("Delete")
    end if
    if me.oItem.getProdId() = 184 then
      aButtonList.add("Edit URL")
    end if
  end if
  return aButtonList
end

on DisplayButtons me, aButtons
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
  mytest = 0
  if voidp(me.oItem) = 0 then
    if voidp(me.oItem[#aAttributes]) = 0 then
      if voidp(getaProp(me.oItem.aAttributes, #urlLink)) = 0 then
        mytest = 1
      end if
    end if
  end if
  if mytest then
    if sID = me.oItem.aAttributes[#urlTitle] then
      sprite(iSprite).scriptInstanceList.add(script("URLbutton").new(me.oItem.aAttributes[#urlLink], me, oActiveMember, oPressedMember))
    else
      sprite(iSprite).scriptInstanceList.add(script("InfoStandSpriteScript").new(sID, me, oActiveMember, oPressedMember))
    end if
  else
    sprite(iSprite).scriptInstanceList.add(script("InfoStandSpriteScript").new(sID, me, oActiveMember, oPressedMember))
  end if
  me.aSprites.add(iSprite)
  return iSprite
end

on createTextMember me, sText
  sDynamicTextName = "_DYNAMIC_INFOSTAND_" & sText
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
  sDynamicButtonName = "_DYNAMIC_INFOSTAND_" & sText & "_" & sState
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
      if not gFeatureSet.isEnabled(#DANCING) then
        ElementMgr.alert("FEATURE_DISABLED")
        return 
      end if
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
      if not gFeatureSet.isEnabled(#TRADING) then
        ElementMgr.alert("FEATURE_DISABLED")
        return 
      end if
      if me.isAvatar() then
        sTradee = me.oItem.getScreenName()
        oStudio.sendStartTrade(sTradee)
        me.display(VOID)
      end if
    "Ask to become a friend":
      if not gFeatureSet.isEnabled(#MESSENGER) then
        ElementMgr.alert("FEATURE_DISABLED")
        return 
      end if
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
      if not gFeatureSet.isEnabled(#FURNITURE_DELETE) then
        ElementMgr.alert("FEATURE_DISABLED")
        return 
      end if
      if me.isFurniItem() or me.isWallItem() then
        iPosId = me.oItem.getPosId()
        if not voidp(ElementMgr) then
          ElementMgr.displayDeleteConfirm(iPosId)
        end if
      end if
    "Pick up":
      if not gFeatureSet.isEnabled(#FURNITURE_PICKUP) then
        ElementMgr.alert("FEATURE_DISABLED")
        return 
      end if
      if me.isFurniItem() then
        if the debugPlaybackEnabled then
          put "me.oItem:" && ilk(me.oItem) && me.oItem
          put "section 1"
        end if
        if not gFeatureSet.isEnabled(#FURNITURE_PICKUP) then
          return 
        end if
        if voidp(oStudio) then
          bIsOwner = 1
          bIsMod = 1
        else
          bIsOwner = oStudio.isOwner(oDenizenManager.getScreenName())
          bIsMod = oDenizenManager.isMod()
        end if
        if bIsOwner or bIsMod then
          if the debugPlaybackEnabled then
            put "section 2"
            put "oIsoScene.oSelectedItem:" && ilk(oIsoScene.oSelectedItem) && oIsoScene.oSelectedItem
            put "oIsoScene.oSelectedItem.ancestor.equals(me.oItem):" && oIsoScene.oSelectedItem.equals(me.oItem)
          end if
          if not voidp(oIsoScene.oSelectedItem) then
            if oIsoScene.oSelectedItem.equals(me.oItem) then
              if the debugPlaybackEnabled then
                put "section 3"
              end if
              if not me.oItem.getDrag() then
                if the debugPlaybackEnabled then
                  put "section 4..."
                end if
                if voidp(oSession) then
                  put "section 4.1"
                  oIsoScene.deleteSelectedItem()
                else
                  put "section 4.2"
                  oPossessionStudio.sendPutInBackpack(me.oItem)
                end if
              end if
            end if
          end if
        end if
      else
        if me.isWallItem() then
          if not voidp(oSession) then
            if the debugPlaybackEnabled then
              put "section 5"
            end if
            if not oSession.bTestMode and not voidp(oPossessionStudio) then
              if the debugPlaybackEnabled then
                put "section 6"
              end if
              oPossessionStudio.sendPutInBackpack(me.oItem)
              if the debugPlaybackEnabled then
                put "section 7"
              end if
              repeat with oDirtyItem in me.oItem.aDirtyItems
                if not oDirtyItem.equals(me.oItem) then
                  if the debugPlaybackEnabled then
                    put "section 8"
                  end if
                  oPossessionStudio.sendPutInStudio(oDirtyItem)
                  if the debugPlaybackEnabled then
                    put "section 9"
                  end if
                end if
              end repeat
            end if
          end if
        end if
      end if
    "Rotate":
      if not gFeatureSet.isEnabled(#FURNITURE_ROTATE) then
        ElementMgr.alert("FEATURE_DISABLED")
        return 
      end if
      if me.isFurniItem() then
        me.oItem.rotateItem()
        me.display(oIsoScene.oSelectedItem)
      end if
    "Move":
      if not gFeatureSet.isEnabled(#FURNITURE_MOVE) then
        ElementMgr.alert("FEATURE_DISABLED")
        return 
      end if
      if me.isFurniItem() or me.isWallItem() then
        oIsoScene.moveSelectedItem()
      end if
    "Use":
      if not gFeatureSet.isEnabled(#FURNITURE_USE) then
        ElementMgr.alert("FEATURE_DISABLED")
        return 
      end if
      if me.isFurniItem() or me.isWallItem() then
        me.oItem.oAction.use()
      end if
    "Thumbs Up":
      if not gFeatureSet.isEnabled(#VOTING) then
        ElementMgr.alert("FEATURE_DISABLED")
        return 
      end if
      bHasVoted = me.hasVoted()
      if (bHasVoted = 0) or not bHasVoted then
        oStudio.getcdplayer().getCd().votePositive()
        oStudio.sendThumbsUp()
      end if
      me.displayCd(oStudio.getcdplayer().getCd())
      me.display(VOID)
    "Thumbs Down":
      if not gFeatureSet.isEnabled(#VOTING) then
        ElementMgr.alert("FEATURE_DISABLED")
        return 
      end if
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
    "Stop song":
      oStudio.sendJukeboxStop()
      me.display(VOID)
    "Edit URL":
      ElementMgr.newwindow("cc.editurl.window")
      if voidp(me.oItem.aAttributes[#urlLink]) then
        myURL = "http://"
      else
        myURL = me.oItem.aAttributes[#urlLink]
      end if
      member("enter_url").text = myURL
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

on isBot me
  if not me.isAvatar() then
    return 0
  end if
  return me.oItem.isBot()
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

on displaySong me, foSong, sAvatar
  if voidp(oStudio) then
    return 
  end if
  if voidp(foSong) then
    return 
  end if
  sAuthor = foSong.getartistName()
  sSongName = foSong.getSongName()
  sGenre = foSong.getGenreName()
  oPreviewImage = member("IJplayer_small")
  if oPreviewImage.memberNum = -1 then
    return 
  end if
  me.destroy()
  me.displayInfoStand()
  me.displayPreviewImage(oPreviewImage)
  sText = "NOW PLAYING" & RETURN & sSongName & RETURN & "by: " & sAuthor & RETURN & "genre: " & sGenre
  me.displayDescription(sText)
  if sAvatar = oDenizenManager.getDenizen().getScreenName() then
    me.DisplayButtons(["Stop song"])
  end if
end
