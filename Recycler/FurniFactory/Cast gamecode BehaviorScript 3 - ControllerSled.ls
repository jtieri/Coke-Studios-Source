property iDirection, oPoint, iImageSprite, iFPS, iFPSTimer, iFPSTimerLength, bCarry, iCarryTimer, iCarryTimerLength, iSpriteInk, bMove, bMoving, iStepsToNextTile, iStepsTravelled, pCurrentSquareLoc, pNextSquareLoc, aStepSizes, pLastTileLoc, pCurrentTileLoc, aDirectionPointVectors, iRow, iLastRow, iCol, iLastCol, iLayer, aSteps, aDepths, aRows, aCols, iStartCol, iEndCol, iStartRow, iEndRow, iStepsPerSquare, iPathPosition, bPaused
global oStudioMap, oAvatar, oIsoScene, iSledTrackValue, iBotSquareValue, oSpriteManager, oMapObject

on beginSprite me
  sprite(me.spriteNum).locZ = 1
  me.bMove = 0
end

on initMachine me, _sAttributes, _iScale, _bPreviewOnly
  me.bPaused = 1
  me.aSteps = []
  me.aDepths = []
  me.aRows = []
  me.aCols = []
  me.iStartCol = 0
  me.iEndCol = 30
  me.iStartRow = me.iRow
  me.iStepsPerSquare = 4
  startFound = 0
  endFound = 0
  repeat with i = 1 to 30
    if oMapObject.oGridVals[me.iStartRow][i] = 110 then
      if not startFound then
        startFound = 1
        me.iStartCol = i
      end if
      next repeat
    end if
    if startFound and not endFound then
      endFound = 1
      me.iEndCol = i
    end if
  end repeat
  put "column range:" && me.iStartCol && me.iEndCol
  repeat with i = me.iStartCol to me.iEndCol - 1
    interDist = oIsoScene.oGrid.aSquares[me.iStartRow][i + 1].calcViewCenter() - oIsoScene.oGrid.aSquares[me.iStartRow][i].calcViewCenter()
    repeat with j = 0 to me.iStepsPerSquare - 1
      jRow = me.iStartRow
      jCol = i
      me.aRows.add(jRow)
      me.aCols.add(jCol)
      me.aDepths.add((jRow * 100) + jCol)
      me.aSteps.add(oIsoScene.oGrid.aSquares[me.iStartRow][i].calcViewCenter() + (interDist * 1.0 / me.iStepsPerSquare * j))
    end repeat
  end repeat
  me.iImageSprite = me.spriteNum
  me.iDirection = [1, -1][random(2)]
  me.iPathPosition = random(me.aSteps.count - 2) + 1
  sprite(me.iImageSprite).locZ = me.aDepths[me.iPathPosition]
  me.iRow = me.aRows[me.iPathPosition]
  me.iCol = me.aCols[me.iPathPosition]
  me.iLastRow = me.iRow
  me.iLastCol = me.iCol
  me.setLoc(me.aSteps[me.iPathPosition])
  oMapObject.oGridVals[me.iRow][me.iCol] = iSledTrackValue + 1
  me.iFPS = 15
  me.iFPSTimer = the milliSeconds
  me.iFPSTimerLength = 1000 / me.iFPS
  oAvatar.aSleds.add(me)
  (the actorList).add(me)
end

on pauseMachine me, bPauseValue
  me.bPaused = bPauseValue
end

on getDirectionPoint me, dirVal
  return me.aDirectionPointVectors.getProp(symbol(string(dirVal)))
end

on calcViewCenter me
  return sprite(me.iImageSprite).loc
end

on getFPS me
  return me.iFPS
end

on initSprites me, _iImageSprite, _iShadowSprite
  me.iImageSprite = _iImageSprite
  me.iShadowSprite = _iShadowSprite
  me.createMember()
  me.createSprites()
end

on getPreviewImage me
  return me.oPreviewImage
end

on end me
end

on createBuffer me
  me.oBuffer = image(me.iWidth, me.iHeight + 20, me.iColorDepth, me.iAlphaDepth)
  me.oBuffer.fill(me.oBuffer.rect, me.oBufferBGColor)
end

on createMember me
  sName = string(me.iImageSprite)
  oExistingMember = member(sName, me.sAvatarCast)
  if oExistingMember.memberNum <= 0 then
    me.oImageMember = new(#bitmap, castLib(me.sAvatarCast))
  else
    me.oImageMember = oExistingMember
  end if
  me.oImageMember.name = sName
  oMemberImage = image(me.oBuffer.width * (me.iScale * 0.01), me.oBuffer.height * (me.iScale * 0.01), me.iColorDepth, me.iAlphaDepth)
  oMemberImage.copyPixels(me.oBuffer, me.oBuffer.rect * (me.iScale * 0.01), me.oBuffer.rect)
  me.oImageMember.image = oMemberImage
  me.oImageMember.regPoint = point(me.iWidth * (me.iScale * 0.01) / 2, me.iHeight * (me.iScale * 0.01))
end

on createSprites me
  puppetSprite(me.iImageSprite, 1)
  sprite(me.iImageSprite).member = me.oImageMember
  if me.bDoFloodFill then
    sprite(me.iImageSprite).bgColor = me.oSpriteBgColor
  else
    sprite(me.iImageSprite).bgColor = me.oBufferBGColor
  end if
  sprite(me.iImageSprite).ink = me.iSpriteInk
  puppetSprite(me.iShadowSprite, 1)
  sShadowMember = "human_shadow_sh"
  if not voidp(oStudioMap) then
    if oStudioMap.isPrivate() then
      sShadowMember = "human_shadow_h"
    end if
  end if
  sprite(me.iShadowSprite).member = member(sShadowMember, "Internal")
end

on getBuffer me
  return me.oBuffer
end

on stepFrame me
  if not me.bPaused then
    if me.iFPS > 0 then
      iElapsedTime = the milliSeconds - me.iFPSTimer
      if iElapsedTime >= me.iFPSTimerLength then
        me.doFrameEvent()
        return 1
      end if
    end if
  end if
  return 0
end

on evaluateMove me
  if (me.iStepsTravelled = 0) or (me.iStepsTravelled = integer(me.iStepsToNextTile)) then
    oCurrentSquare = oIsoScene.calcPointToSquare(sprite(me.iImageSprite).loc)
    testNext = point(oCurrentSquare.iRow, oCurrentSquare.iCol) + me.getDirectionPoint(me.iDirection)
    if oMapObject.oGridVals[testNext[1]][testNext[2]] < iSledTrackValue then
      case iDirection of
        2:
          me.iDirection = 6
        6:
          me.iDirection = 2
      end case
    end if
    me.iRow = oCurrentSquare.iRow
    me.iCol = oCurrentSquare.iCol
    me.pCurrentSquareLoc = point(oCurrentSquare.iRow, oCurrentSquare.iCol)
    sprite(iImageSprite).locZ = (oCurrentSquare.iRow * 100) + oCurrentSquare.iCol
    if me.iDirection = 0 then
      me.pNextSquareLoc = me.pCurrentSquareLoc + me.getDirectionPoint(me.iDirection)
      me.iStepsTravelled = 1
    else
      if me.iDirection = 2 then
        me.pNextSquareLoc = me.pCurrentSquareLoc + me.getDirectionPoint(me.iDirection)
        me.iStepsTravelled = 1
      else
        if me.iDirection = 6 then
          me.pNextSquareLoc = me.pCurrentSquareLoc + me.getDirectionPoint(me.iDirection)
          me.iStepsTravelled = 1
        else
          if me.iDirection = 4 then
            me.pNextSquareLoc = me.pCurrentSquareLoc + me.getDirectionPoint(me.iDirection)
            me.iStepsTravelled = 1
          else
            me.bMove = 0
            me.pNextSquareLoc = me.pCurrentSquareLoc
          end if
        end if
      end if
    end if
    me.doTheMove()
  else
    me.iStepsTravelled = me.iStepsTravelled + 1
  end if
end

on doTheMove me
  if (me.iPathPosition = 1) or (me.iPathPosition = me.aSteps.count) then
    sound(oSpriteManager.iEffectSound).volume = 200
    sound(oSpriteManager.iEffectSound).pan = 100 * me.iDirection
    sound(oSpriteManager.iEffectSound).play(member("sedn_i25"))
    me.iDirection = me.iDirection * -1
  end if
  me.iPathPosition = me.iPathPosition + me.iDirection
  me.setLoc(me.aSteps[me.iPathPosition])
  sprite(me.iImageSprite).locZ = 100
  me.iRow = me.aRows[me.iPathPosition]
  me.iCol = me.aCols[me.iPathPosition]
  if (me.iRow <> me.iLastRow) or (me.iCol <> me.iLastCol) then
    oMapObject.oGridVals[me.iRow][me.iCol] = iSledTrackValue + 1
    oMapObject.oGridVals[me.iLastRow][me.iLastCol] = iSledTrackValue
    me.iLastRow = me.iRow
    me.iLastCol = me.iCol
  end if
end

on doFrameEvent me
  me.doTheMove()
  me.bMove = 1
  me.bMoving = 1
  me.iFPSTimer = the milliSeconds
  updateStage()
end

on advanceAnimFrame me
  if me.iAnimStep = me.iAnimStepMax then
    me.iAnimStep = 0
  else
    me.iAnimStep = me.iAnimStep + 1
  end if
end

on calcAnim me
  bDrawAnim = 0
  repeat with i = 1 to me.aRuntimeConfig.count
    sPart = me.aRuntimeConfig.getPropAt(i)
    aPartConfig = me.aRuntimeConfig[sPart]
    sAction = aPartConfig[#act]
    bAnim = aPartConfig[#anim]
    if bAnim then
      bDrawAnim = 1
      aAnimFrames = me.aConfigSettings[sPart][sAction][#fr]
      if aAnimFrames.getPos(me.iAnimStep mod 4) > 0 then
        me.aRuntimeConfig[sPart][#animIndex] = me.iAnimStep mod 4
      end if
    end if
  end repeat
  return bDrawAnim
end

on display me, bForce
  iStartTime = the milliSeconds
  if voidp(me.oImageMember) then
    return 
  end if
  me.oImageMember.image.copyPixels(me.oBuffer, me.oBuffer.rect * (me.iScale * 0.01), me.oBuffer.rect, [#dither: me.iDither])
  if me.bDoFloodFill then
    me.oImageMember.image.floodFill(0, 0, me.oSpriteBgColor)
  end if
  me.iDisplayTime = the milliSeconds - iStartTime
  me.iDisplayCount = me.iDisplayCount + 1
end

on createQuadFromRect me, rRect, bFlip
  oP1 = point(rRect.left, rRect.top)
  oP2 = point(rRect.right, rRect.top)
  oP3 = point(rRect.right, rRect.bottom)
  oP4 = point(rRect.left, rRect.bottom)
  if bFlip then
    return [oP2, oP1, oP4, oP3]
  else
    return [oP1, oP2, oP3, oP4]
  end if
end

on getMemberRect me, oMember
  oRegPoint = oMember.regPoint
  vAdd = 0
  if oRegPoint.locV < oMember.rect.bottom then
    vAdd = oMember.rect.bottom - oRegPoint.locV
  end if
  return rect(oRegPoint.locH, oRegPoint.locV - 110, oRegPoint.locH + 77, oRegPoint.locV + vAdd)
end

on setLoc me, oLoc
  me.oPoint = oLoc
  if voidp(me.iImageSprite) then
    return 
  end if
  sprite(me.iImageSprite).locH = me.oPoint.locH
  sprite(me.iImageSprite).locV = me.oPoint.locV
end

on getLoc me, oLoc
  return me.oPoint
end

on getRealDirection me, iDir, aDirs
  bRealExists = aDirs.getPos(iDir) > 0
  if bRealExists then
    return iDir
  end if
  if iDir = 7 then
    return VOID
  end if
  iFakeDir = me.aDirectionMap.getProp(iDir)
  bFakeExists = aDirs.getPos(iFakeDir) > 0
  if bFakeExists then
    return iFakeDir
  else
    return VOID
  end if
end

on getDirectionOffset me, iDir, iDirOff
  iNewDir = iDir + iDirOff
  if iNewDir < 0 then
    iNewDir = 8 + iNewDir
  end if
  if iNewDir > 7 then
    iNewDir = iNewDir mod 8
  end if
  return iNewDir
end

on setDirection me, iDir, bDisplay
  if voidp(iDir) then
    iDir = 2
  end if
  if me.iDirection = iDir then
    return 
  end if
  me.iDirection = iDir
  me.setDrawOrder()
  me.display()
end

on setFPS me, _iFPS, bDisplay
  me.iFPS = _iFPS
  if me.iFPS = 0 then
    me.iFPSTimerLength = the maxinteger
  else
    me.iFPSTimerLength = 1000 / me.iFPS
  end if
end

on setAnimFrame me, iFrame, bDisplay
  if (iFrame >= 0) and (iFrame <= me.iAnimStepMax) then
    me.iAnimStep = iFrame
  end if
end

on flipHSpriteRect me, oSprite
  oOrigSpriteRect = oSprite.rect
  iLeft = oOrigSpriteRect.left
  iLocH = oSprite.locH
  iHDif = ((iLocH - iLeft) * 2) - oOrigSpriteRect.width
  rDifRect = rect(iHDif, 0, iHDif, 0)
  oNewRect = oOrigSpriteRect + rDifRect
  return oNewRect
end

on calcViewRect me
  iLeft = me.oPoint.locH - (me.oScaledRect.width / 2)
  iRight = iLeft + me.oScaledRect.width
  iTop = me.oPoint.locV - me.oScaledRect.height
  iBottom = me.oPoint.locV
  return rect(iLeft, iTop, iRight, iBottom)
end

on changeDirection me, iDir
  me.setDirection(iDir)
end

on carry me
  me.setPartActive("ri", 1)
  me.iCarryTimer = the milliSeconds
end

on isCarrying me
  return me.bCarry
end

on setHeightOffset me, _iHeightOffset
  me.iHeightOffset = _iHeightOffset
end

on getHeightOffset me
  return me.iHeightOffset
end

on getPropertyDescriptionList me
  vRowColRange = []
  repeat with i = 1 to 30
    vRowColRange.add(i)
  end repeat
  vLayerRange = []
  repeat with i = 1 to 10
    vLayerRange.add(i)
  end repeat
  vList = [:]
  vList.addProp(#iRow, [#comment: "Row", #range: vRowColRange, #format: #integer, #default: vRowColRange[1]])
  vList.addProp(#iCol, [#comment: "Column", #range: vRowColRange, #format: #integer, #default: vRowColRange[1]])
  vList.addProp(#iLayer, [#comment: "Layer", #range: vLayerRange, #format: #integer, #default: vLayerRange[1]])
  return vList
end
