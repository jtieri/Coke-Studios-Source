property bDebug, iRows, iCols, iSqSize, iGridWidth, iGridDepth, iGridViewWidth, iGridViewHeight, aSquares, oGridSprite, bGridDrawn, oFMath, bCenter
global oIsoScene

on new me, _iRows, _iCols, _iSqSize
  me.iRows = _iRows
  me.iCols = _iCols
  me.iSqSize = _iSqSize
  me.bDebug = 0
  me.debug("new()")
  me.Init()
  return me
end

on centerGrid me
  iScreenCenterX = integer(oIsoScene.oIsoConstants.DEFAULT_SCENE_WIDTH / 2.0)
  iScreenCenterY = integer(oIsoScene.oIsoConstants.DEFAULT_SCENE_HEIGHT / 2.0)
  iNewX = iScreenCenterX
  iNewY = iScreenCenterY - integer(me.iGridViewHeight / 2.0)
  oIsoScene.iXOff = iNewX
  oIsoScene.iYOff = iNewY
  me.Init()
end

on Init me
  me.aSquares = []
  me.iGridWidth = me.iCols * me.iSqSize
  me.iGridDepth = me.iRows * me.iSqSize
  me.createSquares()
  me.doDepthCalcs()
  me.calcGridViewWidth()
  me.calcGridViewHeight()
  me.createSprite(0)
  me.bGridDrawn = 0
  me.oFMath = newObject("Math")
end

on createSquares me, oXml
  me.debug("createSquares()")
  me.aSquares = []
  if oXml = VOID then
    repeat with iRow = 1 to me.iRows
      aRow = []
      repeat with iCol = 1 to me.iCols
        oSquare = new(script("IsoSquare"), me, iRow, iCol, 0)
        aRow.append(oSquare)
      end repeat
      me.aSquares.append(aRow)
    end repeat
  end if
end

on calcGridViewWidth me
  oLeftSquare = me.aSquares[me.iRows][1]
  iLeftX = oLeftSquare.oViewPoints.bl.locH
  oRightSquare = me.aSquares[1][me.iCols]
  iRightX = oRightSquare.oViewPoints.tr.locH
  iWidth = iRightX - iLeftX
  me.iGridViewWidth = iWidth
  return me.iGridViewWidth
end

on calcGridViewHeight me
  oTopSquare = me.aSquares[1][1]
  iTopY = oTopSquare.oViewPoints.tl.locV
  oBottomSquare = me.aSquares[me.iRows][me.iCols]
  iBottomY = oBottomSquare.oViewPoints.br.locV
  iHeight = iBottomY - iTopY
  me.iGridViewHeight = iHeight
  return me.iGridViewHeight
end

on createSprite me, bDisplay
  me.debug("createSprite()")
  me.oGridSprite = sprite(oIsoScene.oSpriteManager.getPooledSprite())
  me.oGridSprite.member = member("GridDisplay")
  me.oGridSprite.member.regPoint = point(0, 0)
  me.oGridSprite.width = me.iGridViewWidth
  me.oGridSprite.height = me.iGridViewHeight
  oOffsetP = point((me.iGridViewWidth - (the stageRight - the stageLeft)) / 2, (me.iGridViewHeight - (the stageBottom - the stageTop)) / 2)
  me.oGridSprite.locH = -oOffsetP.locH
  me.oGridSprite.locV = -oOffsetP.locV
  me.oGridSprite.ink = 41
  me.oGridSprite.blend = 50
  me.oGridSprite.visible = bDisplay
end

on getSquareByRowCol me, iRow, iCol
  me.debug("getSquareByRowCol()")
  if (iRow > me.iRows) or (iCol > me.iCols) or (iRow < 1) or (iCol < 1) then
    return VOID
  end if
  return me.aSquares[iRow][iCol]
end

on getGridIndex me, iRow, iCol
  me.debug("getGridIndex()")
  return (iRow * me.iRows) + iCol
end

on getSquareByXZ me, iX, iZ
  me.debug("getSquareByXZ()")
  if (iX < 0) or (iX > me.iGridWidth) then
    return VOID
  end if
  if (iZ > 0) or (iZ < -me.iGridDepth) then
    return VOID
  end if
  iCol = me.oFMath.ceil(float(abs(iX)) / float(me.iSqSize))
  iRow = me.oFMath.ceil(float(abs(iZ)) / float(me.iSqSize))
  if (iCol <= 0) or (iRow <= 0) then
    return VOID
  end if
  if (iCol > me.iCols) or (iRow > me.iRows) then
    return VOID
  end if
  oSquare = me.aSquares[iRow][iCol]
  return oSquare
end

on getRandomSquare me
  me.debug("getRandomSquare()")
  return me.aSquares[random(me.iRows)][random(me.iCols)]
end

on getDepthAtSquare me, iRow, iCol, sMapProp
  oSquare = me.getSquareByRowCol(iRow, iCol)
  iDepth = oSquare.getDepthFromMap(sMapProp)
  return iDepth
end

on toggleGridView me
  me.debug("toggleGridView()")
  me.oGridSprite.visible = not me.oGridSprite.visible
  oBGSprite = oIsoScene.oSpriteManager.getSprite("Background")
  if oBGSprite <> VOID then
    oBGSprite.oSprite.visible = not oBGSprite.oSprite.visible
  end if
  if me.oGridSprite.visible then
    if not me.bGridDrawn then
      me.drawGrid()
    end if
  end if
end

on drawGrid me
  me.debug("drawGrid()")
  oImage = image(me.iGridViewWidth, me.iGridViewHeight, 8)
  oImage.fill(oImage.rect, rgb(256, 256, 256))
  oOffsetP = point(-oIsoScene.iXOff + (me.iGridViewWidth / 2), -oIsoScene.iYOff)
  me.drawAllText(oImage, oOffsetP)
  me.drawAllLines(oImage, oOffsetP)
  me.oGridSprite.member.image = oImage
  me.oGridSprite.member.regPoint = point(me.oGridSprite.member.rect.width / 2, me.oGridSprite.member.rect.top)
  me.oGridSprite.width = me.oGridSprite.member.width
  me.oGridSprite.height = me.oGridSprite.member.height
  me.oGridSprite.locH = oIsoScene.iXOff
  me.oGridSprite.locV = oIsoScene.iYOff
  me.oGridSprite.locZ = the maxinteger
  me.oGridSprite.blend = 100
  me.oGridSprite.ink = 36
  me.bGridDrawn = 1
end

on drawSquare me, oImage, oSquare, oOffsetP
  me.debug("drawSquare()")
  oMember = member("GridDisplayIndex")
  me.drawText(oImage, oSquare.oViewCenter + oOffsetP, oMember, integer(oSquare.iRow) & "," & integer(oSquare.iCol))
  oViewPoints = oSquare.calcViewPoints()
  me.drawLine(oImage, oViewPoints.tl + oOffsetP, oViewPoints.tr + oOffsetP)
  me.drawLine(oImage, oViewPoints.tr + oOffsetP, oViewPoints.br + oOffsetP)
  me.drawLine(oImage, oViewPoints.br + oOffsetP, oViewPoints.bl + oOffsetP)
  me.drawLine(oImage, oViewPoints.bl + oOffsetP, oViewPoints.tl + oOffsetP)
end

on drawAllLines me, oImage, oOffsetP
  repeat with iRow = 1 to me.iRows
    oStartSquare = me.aSquares[iRow][1]
    oStartViewPoints = oStartSquare.calcViewPoints()
    oStartP = oStartViewPoints.tl + oOffsetP
    oEndSquare = me.aSquares[iRow][me.iCols]
    oEndViewPoints = oEndSquare.calcViewPoints()
    oEndP = oEndViewPoints.tr + oOffsetP
    me.drawLine(oImage, oStartP, oEndP)
  end repeat
  oStartSquare = me.aSquares[me.iRows][1]
  oStartViewPoints = oStartSquare.calcViewPoints()
  oStartP = oStartViewPoints.bl + oOffsetP
  oEndSquare = me.aSquares[me.iRows][me.iCols]
  oEndViewPoints = oEndSquare.calcViewPoints()
  oEndP = oEndViewPoints.br + oOffsetP
  me.drawLine(oImage, oStartP, oEndP)
  repeat with iCol = 1 to me.iCols
    oStartSquare = me.aSquares[1][iCol]
    oStartViewPoints = oStartSquare.calcViewPoints()
    oStartP = oStartViewPoints.tl + oOffsetP
    oEndSquare = me.aSquares[me.iRows][iCol]
    oEndViewPoints = oEndSquare.calcViewPoints()
    oEndP = oEndViewPoints.bl + oOffsetP
    me.drawLine(oImage, oStartP, oEndP)
  end repeat
  oStartSquare = me.aSquares[1][me.iCols]
  oStartViewPoints = oStartSquare.calcViewPoints()
  oStartP = oStartViewPoints.tr + oOffsetP
  oEndSquare = me.aSquares[me.iRows][me.iCols]
  oEndViewPoints = oEndSquare.calcViewPoints()
  oEndP = oEndViewPoints.br + oOffsetP
  me.drawLine(oImage, oStartP, oEndP)
end

on drawAllText me, oImage, oOffsetP
  oMember = member("GridDisplayIndex")
  repeat with iRow = 1 to me.iRows
    repeat with iCol = 1 to me.iCols
      oSquare = me.aSquares[iRow][iCol]
      me.drawText(oImage, oSquare.oViewCenter + oOffsetP, oMember, integer(oSquare.iRow) & "," & integer(oSquare.iCol))
    end repeat
  end repeat
end

on drawLine me, oImage, oPoint1, oPoint2
  me.debug("drawLine() oPoint1: " & oPoint1 & ", oPoint2: " & oPoint2)
  oImage.draw(oPoint1, oPoint2, [#lineSize: 1, #color: rgb(150, 0, 0)])
end

on drawText me, oImage, oPoint, oMember, sText
  oMember.text = sText
  oSource = oMember.image.rect
  oDest = rect(oPoint.locH - (oSource.width / 2), oPoint.locV - (oSource.height / 2), oPoint.locH + (oSource.width / 2), oPoint.locV + (oSource.height / 2))
  oImage.copyPixels(oMember.image, oDest, oSource)
end

on drawPixel me, oImage, oPoint
  oImage.setPixel(oPoint, rgb(0, 150, 0))
end

on getHighestDepth me
  oLastSquare = me.getSquareByRowCol(me.iRows, me.iCols)
  iHighestDepth = oLastSquare.getHighestDepth()
  return iHighestDepth
end

on destroy me
  oIsoScene.oSpriteManager.returnPooledSprite(me.oGridSprite.spriteNum)
  me.oGridSprite = VOID
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "IsoGrid: " & sMessage
  end if
end

on doDepthCalcs me
  iIndex = 1
  repeat with _iRow = 1 to me.iRows
    _iCol = 0
    repeat with iTempRow = _iRow down to 1
      _iCol = _iCol + 1
      oSquare = me.getSquareByRowCol(iTempRow, _iCol)
      iBaseDepth = iIndex * oSquare.iLayers
      oSquare.setBaseDepth(iBaseDepth)
      oSquare.calcLayerDepths(iBaseDepth)
      iIndex = iIndex + 1
    end repeat
  end repeat
  repeat with _iCol = 2 to me.iCols
    _iRow = me.iRows + 1
    repeat with iTempCol = _iCol to me.iCols
      _iRow = _iRow - 1
      oSquare = me.getSquareByRowCol(_iRow, iTempCol)
      iBaseDepth = iIndex * oSquare.iLayers
      oSquare.setBaseDepth(iBaseDepth)
      oSquare.calcLayerDepths(iBaseDepth)
      iIndex = iIndex + 1
    end repeat
  end repeat
end

on getPixelDistanceBetweenSquares me, oSquare1, oSquare2
  oPoint1 = oSquare1.calcViewCenter()
  oPoint2 = oSquare2.calcViewCenter()
  x1 = oPoint1.locH
  x2 = oPoint2.locH
  y1 = oPoint1.locV
  y2 = oPoint2.locV
  xDif = abs(x2 - x1)
  yDif = abs(y2 - y1)
  iDistance = sqrt(power(xDif, 2) + power(yDif, 2))
  return iDistance
end

on getDistanceBetweenSquares me, oSquare1, oSquare2
  x1 = oSquare1.iCol
  x2 = oSquare2.iCol
  y1 = oSquare1.iRow
  y2 = oSquare2.iRow
  xDif = abs(x2 - x1)
  yDif = abs(y2 - y1)
  iDistance = sqrt(power(xDif, 2) + power(yDif, 2))
  return iDistance
end

on getSquareAtDirection me, oSquare1, iDirection
  iRow1 = oSquare1.iRow
  iCol1 = oSquare1.iCol
  iRow2 = iRow1
  iCol2 = iCol1
  case iDirection of
    0:
      iRow2 = iRow1 - 1
      iCol2 = iCol2
    1:
      iRow2 = iRow1 - 1
      iCol2 = iCol1 + 1
    2:
      iRow2 = iRow1
      iCol2 = iCol1 + 1
    3:
      iRow2 = iRow1 + 1
      iCol2 = iCol1 + 1
    4:
      iRow2 = iRow1 + 1
      iCol2 = iCol1
    5:
      iRow2 = iRow1 + 1
      iCol2 = iCol1 - 1
    6:
      iRow2 = iRow1
      iCol2 = iCol1 - 1
    7:
      iRow2 = iRow1 - 1
      iCol2 = iCol1 - 1
  end case
  return me.getSquareByRowCol(iRow2, iCol2)
end

on getDirectionToSquare me, oSquare1, oSquare2
  iRowOffset = oSquare2.getRow() - oSquare1.getRow()
  iColOffset = oSquare2.getCol() - oSquare1.getCol()
  if iRowOffset < 0 then
    iRowOffset = -1
  end if
  if iRowOffset > 0 then
    iRowOffset = 1
  end if
  if iColOffset < 0 then
    iColOffset = -1
  end if
  if iColOffset > 0 then
    iColOffset = 1
  end if
  if (iRowOffset = 0) and (iColOffset = 0) then
    return VOID
  end if
  if iRowOffset = 0 then
    case iColOffset of
      1:
        iDir = 2
      (-1):
        iDir = 6
    end case
    return iDir
  end if
  if iColOffset = 0 then
    case iRowOffset of
      1:
        iDir = 4
      (-1):
        iDir = 0
    end case
    return iDir
  end if
  if iRowOffset = -1 then
    case iColOffset of
      0:
        iDir = 0
      1:
        iDir = 1
      (-1):
        iDir = 7
    end case
    return iDir
  end if
  if iRowOffset = 1 then
    case iColOffset of
      0:
        iDir = 0
      1:
        iDir = 3
      (-1):
        iDir = 5
    end case
    return iDir
  end if
  return VOID
end
