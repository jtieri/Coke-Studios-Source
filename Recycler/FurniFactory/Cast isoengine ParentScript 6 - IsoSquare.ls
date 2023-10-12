property bDebug, oGrid, iRow, iCol, iHeight, iType, sDir, iLayers, iLayerDepthOff, iLayerStartDepth, aLayerDepths, iBaseDepth, iMinX, iMaxX, iMinY, iMaxY, iMinZ, iMaxZ, oGridCenter, oGridPoints, oViewCenter, oViewPoints
global oIsoScene

on new me, _oGrid, _iRow, _iCol, _iHeight, _iType, _sDir
  me.bDebug = 0
  me.debug("new()")
  me.oGrid = _oGrid
  me.iRow = _iRow
  me.iCol = _iCol
  me.iHeight = _iHeight
  me.iType = _iType
  me.sDir = _sDir
  me.iLayers = oIsoScene.oIsoConstants.DEFAULT_LAYERS
  me.iLayerDepthOff = oIsoScene.oIsoConstants.DEFAULT_START_DEPTH
  me.iLayerStartDepth = oIsoScene.oIsoConstants.DEFAULT_DEPTH_OFF
  me.aLayerDepths = []
  me.doGridCalc()
  return me
end

on doGridCalc me
  me.debug("doGridCalc()")
  me.iMinX = me.calcMinX()
  me.iMaxX = me.calcMaxX()
  me.iMinY = me.calcMinY()
  me.iMaxY = me.calcMaxY()
  me.iMinZ = me.calcMinZ()
  me.iMaxZ = me.calcMaxZ()
  me.calcGridPoints()
  me.calcGridCenter()
  me.calcViewPoints()
  me.calcViewCenter()
end

on printSquare me
  put "[SQUARE]"
  put "iMinX: " & me.iMinX
  put "iMaxX: " & me.iMaxX
  put "iMinY: " & me.iMinY
  put "iMaxY: " & me.iMaxY
  put "iMinZ: " & me.iMinZ
  put "iMaxZ: " & me.iMaxZ
  put "oGridCenter: " & me.oGridCenter
  put "oGridPoints: " & me.oGridPoints.toString()
  put "oViewPoints: " & me.oViewPoints.toString()
end

on calcMinX me
  me.debug("calcMinX()")
  return me.oGrid.iSqSize * (me.iCol - 1)
end

on calcMaxX me
  me.debug("calcMaxX()")
  return me.iMinX + me.oGrid.iSqSize
end

on calcMinY me
  me.debug("calcMinY()")
  return 0
end

on calcMaxY me
  me.debug("calcMaxY()")
  return 0
end

on calcMinZ me
  me.debug("calcMinZ()")
  return -(me.oGrid.iSqSize * (me.iRow - 1)) - me.oGrid.iSqSize
end

on calcMaxZ me
  me.debug("calcMaxZ()")
  return -(me.oGrid.iSqSize * (me.iRow - 1))
end

on calcGridCenter me
  if me.oGridCenter <> VOID then
    return me.oGridCenter
  end if
  me.debug("calcGridCenter()")
  oPoint = vector(0, 0, 0)
  oPoint.x = integer(me.iMinX + (abs(me.iMaxX - me.iMinX) / 2))
  oPoint.y = integer(me.iMaxY - (abs(me.iMaxY - me.iMinY) / 2))
  oPoint.z = integer(me.iMinZ + (abs(me.iMaxZ - me.iMinZ) / 2))
  me.oGridCenter = oPoint
  return me.oGridCenter
end

on calcViewCenter me
  if me.oViewCenter <> VOID then
    return me.oViewCenter
  end if
  me.debug("calcViewCenter()")
  _oViewPoints = me.calcViewPoints()
  _iViewWidth = me.calcViewWidth()
  _iViewHeight = me.calcViewHeight()
  me.oViewCenter = point(integer(_oViewPoints.bl.locH + (_iViewWidth / 2)), integer(_oViewPoints.tl.locV + (_iViewHeight / 2)))
  return me.oViewCenter
end

on calcViewWidth me
  me.debug("calcViewWidth()")
  _oViewPoints = me.calcViewPoints()
  return abs(_oViewPoints.tr.locH - _oViewPoints.bl.locH)
end

on calcViewHeight me
  me.debug("calcViewHeight()")
  _oViewPoints = me.calcViewPoints()
  return abs(_oViewPoints.br.locV - _oViewPoints.tl.locV)
end

on calcViewPoints me
  if me.oViewPoints <> VOID then
    return me.oViewPoints
  end if
  me.debug("calcViewPoints()")
  _oGridPoints = me.calcGridPoints()
  _oViewPoints = new(script("Quad"))
  _oViewPoints.tl = oIsoScene.calcGridToViewPoint(_oGridPoints.tl)
  _oViewPoints.tr = oIsoScene.calcGridToViewPoint(_oGridPoints.tr)
  _oViewPoints.br = oIsoScene.calcGridToViewPoint(_oGridPoints.br)
  _oViewPoints.bl = oIsoScene.calcGridToViewPoint(_oGridPoints.bl)
  me.oViewPoints = _oViewPoints
  return me.oViewPoints
end

on calcGridPoints me
  if me.oGridPoints <> VOID then
    return me.oGridPoints
  end if
  me.debug("calcGridPoints()")
  _oGridPoints = new(script("Quad"))
  _oGridPoints.tl = me.calcPoint1()
  _oGridPoints.tr = me.calcPoint2()
  _oGridPoints.br = me.calcPoint3()
  _oGridPoints.bl = me.calcPoint4()
  me.oGridPoints = _oGridPoints
  return me.oGridPoints
end

on calcPoint1 me
  me.debug("calcPoint1()")
  oPoint = vector(0, 0, 0)
  oPoint.x = me.iMinX
  oPoint.y = me.iMaxY
  oPoint.z = me.iMaxZ
  return oPoint
end

on calcPoint2 me
  me.debug("calcPoint2()")
  oPoint = vector(0, 0, 0)
  oPoint.x = me.iMaxX
  oPoint.y = me.iMaxY
  oPoint.z = me.iMaxZ
  return oPoint
end

on calcPoint3 me
  me.debug("calcPoint3()")
  oPoint = vector(0, 0, 0)
  oPoint.x = me.iMaxX
  oPoint.y = me.iMaxY
  oPoint.z = me.iMinZ
  return oPoint
end

on calcPoint4 me
  me.debug("calcPoint4()")
  oPoint = vector(0, 0, 0)
  oPoint.x = me.iMinX
  oPoint.y = me.iMaxY
  oPoint.z = me.iMinZ
  return oPoint
end

on calcHeight me, iX, iZ
  me.debug("calcHeight()")
  return me.iMaxY
end

on getViewLeft me
  return me.oViewPoints.bl
end

on getViewRight me
  return me.oViewPoints.tr
end

on getDepthFromMap me, sMapProp, iGridY
  iLayer = me.getLayer(sMapProp)
  iHeightLayer = me.getHeightLayer(iLayer, iGridY)
  iDepth = me.getDepthByLayer(iHeightLayer)
  return iDepth
end

on getHeightLayer me, iLayer, iGridY
  if voidp(iGridY) then
    iGridY = 0
  end if
  iLayersPerMap = oIsoScene.oIsoConstants.aLayerMap.count
  iHeightLayer = iLayer + (iLayersPerMap * iGridY)
  return iHeightLayer
end

on getLayer me, sMapProp
  return oIsoScene.oIsoConstants.aLayerMap[sMapProp]
end

on getDepthByLayer me, iLayer
  me.debug("getDepth()")
  if iLayer = VOID then
    iLayer = 1
  end if
  return me.aLayerDepths[iLayer]
end

on getHighestDepth me
  return me.aLayerDepths[me.aLayerDepths.count]
end

on calcLayerDepths me, _iBaseDepth
  me.debug("calcLayerDepths()")
  _aLayerDepths = []
  repeat with iLayer = 1 to me.iLayers
    iDepth = _iBaseDepth + (iLayer - 1)
    _aLayerDepths.append(iDepth)
  end repeat
  me.debug("aLayerDepths: " + _aLayerDepths)
  me.aLayerDepths = _aLayerDepths
  return me.aLayerDepths
end

on setBaseDepth me, _iBaseDepth
  me.iBaseDepth = _iBaseDepth
end

on getBaseDepth me
  return me.iBaseDepth
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "IsoSquare: " & sMessage
  end if
end

on equals me, oSquare
  if voidp(oSquare) then
    return 0
  end if
  return (me.iRow = oSquare.iRow) and (me.iCol = oSquare.iCol)
end

on toString me
  s = "[ISOSQUARE] ROW: " & me.iRow & ", COL: " & me.iCol
  return s
end
