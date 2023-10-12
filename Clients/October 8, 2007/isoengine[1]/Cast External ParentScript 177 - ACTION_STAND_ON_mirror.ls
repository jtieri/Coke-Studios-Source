property ancestor, iLength, iStartTime, bDebug, oStandingAvatar
global oPossessionStudio, oIsoScene, oStudio

on new me, _oItem, aAttributes
  me.bDebug = 1
  me.debug("new()")
  me.ancestor = script("ACTION_STAND_ON").new(_oItem, aAttributes)
  me.iLength = 3000
  me.iStartTime = the milliSeconds
  me.displayState()
  return me
end

on stepFrame me
  if me.oItem.getFrame() = 0 then
    return 
  end if
  oSquare = me.oItem.ancestor.getSquare()
  case me.oItem.iDirection of
    2:
      destSquare = oIsoScene.oGrid.getSquareByRowCol(oSquare.iRow + 1, oSquare.iCol)
      iDir = 0
    4:
      destSquare = oIsoScene.oGrid.getSquareByRowCol(oSquare.iRow, oSquare.iCol + 1)
      iDir = 6
  end case
  if oStandingAvatar.existsAtSquare(destSquare) = 0 then
    me.oItem.setFrame(0)
    me.oItem.draw()
  end if
end

on displayState me
  global testmirror
  me.debug("displayState()")
  testmirror = me
  oSquare = me.oItem.ancestor.getSquare()
  case me.oItem.iDirection of
    2:
      destSquare = oIsoScene.oGrid.getSquareByRowCol(oSquare.iRow + 1, oSquare.iCol)
      iDir = 0
    4:
      destSquare = oIsoScene.oGrid.getSquareByRowCol(oSquare.iRow, oSquare.iCol + 1)
      iDir = 6
  end case
  oAvatarlist = oIsoScene.oAvatars.getItemsAtSquare(destSquare)
  if count(oAvatarlist) > 0 then
    if me.oItem.getFrame() = 0 then
      oAvatar = oAvatarlist[1]
      oStandingAvatar = oAvatar
      oAvatar.faceDirection(iDir)
      baseimage = oAvatar.oEngine.getmirrorimage(me.oItem.iDirection)
      myID = me.oItem.ancestor.sPosId
      myMember = member("mirror_d_0_2_1_" & me.oItem.iDirection & "_" & myID)
      if myMember.memberNum < 1 then
        myMember = new(#bitmap, castLib("furniture"))
        myMember.name = "mirror_d_0_2_1_" & me.oItem.iDirection & "_" & myID
        me.oItem.loadAssets()
      end if
      world = member("mirror")
      world.resetWorld()
      if me.oItem.iDirection = 2 then
        myImage = image(baseimage.width, baseimage.height, baseimage.depth)
        sourceRect = baseimage.rect
        destQuad = [point(baseimage.width, 0), point(0, 0), point(0, baseimage.height), point(baseimage.width, baseimage.height)]
        myImage.copyPixels(baseimage, destQuad, sourceRect)
      else
        myImage = baseimage.duplicate()
      end if
      mytex = world.newTexture("reflect", #fromImageObject, myImage)
      myshad = world.shader("import_mat")
      myshad.textureList[1] = mytex
      myshad.textureModeList[1] = #wrapPlanar
      wrappedimage = world.image
      destimage = image(member("mirror_mask").width, member("mirror_mask").height, 32)
      destimage = member("mirrorbg").image.duplicate()
      destRect = destimage.rect
      hdecal = (wrappedimage.width / 2) - (destRect.width / 2)
      vdecal = (wrappedimage.height / 2) - (destRect.height / 2)
      sourceRect = destRect + rect(hdecal, vdecal, hdecal, vdecal)
      destimage.copyPixels(wrappedimage, destRect, sourceRect, [#maskImage: member("mirror_mask").image.createMask(), #maskOffset: point(hdecal, vdecal), #ink: 39])
      destimage.floodFill(38, 38, rgb(255, 255, 255))
      destimage.floodFill(10, 38, rgb(255, 255, 255))
      if me.oItem.iDirection = 2 then
        temp = destimage.duplicate()
        sourceRect = temp.rect
        destQuad = [point(temp.width, 0), point(0, 0), point(0, temp.height), point(temp.width, temp.height)]
        destimage.copyPixels(temp, destQuad, sourceRect)
      end if
      myMember.image = destimage
      if me.oItem.iDirection = 4 then
        myMember.regPoint = point(-18, 87)
      else
        myMember.regPoint = point(-11, 87)
      end if
      if me.oItem.iNumFrames < integer(myID) then
        me.oItem.iNumFrames = integer(myID)
      end if
      me.oItem.setFrame(integer(myID))
    else
    end if
  else
    if voidp(me.oItem) = 0 then
      me.oItem.setFrame(0)
    end if
  end if
  me.debug("displayState() calling draw()")
  me.oItem.draw()
end

on startAnimation me, _bDisplay
  me.debug("startAnimation()")
  me.startTimer()
end

on stopAnimation me, _bDisplay
  me.stopTimer()
end

on startTimer me
  me.iStartTime = the milliSeconds
  me.oItem.setState(1)
end

on stopTimer me
  me.oItem.setState(0)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "isoengine::ACTION_STAND_ON::" & sMessage
  end if
end

on standOn me
  me.displayState()
end
