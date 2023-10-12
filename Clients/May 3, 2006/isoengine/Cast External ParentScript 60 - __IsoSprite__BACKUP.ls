property bDebug, oPoint, sImage, sID, sMember, sType, oSprite, oViewPoint, oViewPointOverride, iLayer, oSquare, iDepth, iSpeed, oTargetSquare, bMoving, bPathMoving, aPath, iPathIndex, bLoaded, iScale, oPointDir, oRegistrationPoint, aDirections, aDir, iHeightOffset, UP_RIGHT, right, DOWN_RIGHT, down, DOWN_LEFT, left, UP_LEFT, up, iTimeDelta
global oIsoScene

on new me, _sId, _sMember
  me.bDebug = 0
  me.debug("new Sprite()" & _sId)
  me.bLoaded = 1
  me.iScale = 100
  me.oRegistrationPoint = point(0, 0)
  me.oPoint = vector(0, 0, 0)
  me.sID = _sId
  me.sMember = _sMember
  me.oViewPoint = point(0, 0)
  me.iLayer = oIsoScene.oIsoConstants.DEFAULT_LAYER
  me.oSquare = VOID
  me.iDepth = 0
  me.iSpeed = 5
  me.oTargetSquare = VOID
  me.bMoving = 0
  me.aPath = []
  me.bPathMoving = 0
  me.iPathIndex = 0
  me.sType = "Default"
  me.oSprite = me.createSprite(me.sMember)
  me.initDirections()
  me.aDir = me.UP_RIGHT
  me.iTimeDelta = 0
  me.iHeightOffset = 0
  return me
end

on getId me
  return me.sID
end

on setDir me, iX, iY
  me.aDir = [iX, iY]
end

on getSquare me
  return me.oSquare
end

on initDirections me
  me.UP_RIGHT = [0, 1]
  me.right = [1, 1]
  me.DOWN_RIGHT = [1, 0]
  me.down = [1, -1]
  me.DOWN_LEFT = [0, -1]
  me.left = [-1, -1]
  me.UP_LEFT = [-1, 0]
  me.up = [-1, 1]
  me.aDirections = []
  me.aDirections.add(me.UP_RIGHT)
  me.aDirections.add(me.right)
  me.aDirections.add(me.DOWN_RIGHT)
  me.aDirections.add(me.down)
  me.aDirections.add(me.DOWN_LEFT)
  me.aDirections.add(me.left)
  me.aDirections.add(me.UP_LEFT)
  me.aDirections.add(me.up)
end

on createSprite me, _sMember
  _oSprite = sprite(oIsoScene.oSpriteManager.getPooledSprite())
  _oSprite.member = member(_sMember)
  _oSprite.backColor = 0
  _oSprite.ink = 36
  _oSprite.trails = 0
  _oSprite.visible = 0
  return _oSprite
end

on setViewPointOverride me, Op
  me.oViewPointOverride = Op
end

on findPath me, oEndSquare
  me.debug("findPath()")
  me.doCalc()
  oStartSquare = me.oSquare
  oN1 = oIsoScene.oMap.getNode(oStartSquare.iRow, oStartSquare.iCol)
  oN2 = oIsoScene.oMap.getNode(oEndSquare.iRow, oEndSquare.iCol)
  _aPath = oIsoScene.oMap.oPathfinder.findPath(oN1, oN2)
  if _aPath = VOID then
    return 
  end if
  me.debug("findPath() _aPath: B4 REVERSE" & _aPath)
  me.debug("findPath() _aPath: AFTER REVERSE" & _aPath)
  if _aPath.count < 2 then
    me.debug("findPath() < 2: returning")
    return 
  end if
  _aPath.deleteAt(1)
  me.animateAlongPath(_aPath)
end

on reverseList me, _aPath
  iLength = _aPath.count
  aR = []
  repeat with i = iLength down to 1
    aR.append(_aPath[i])
  end repeat
  return aR
end

on animateAlongPath me, aP, _iTimeDelta
  me.debug("animateAlongPath()")
  me.aPath = aP
  me.bPathMoving = 1
  me.iPathIndex = 0
  me.iTimeDelta = 0
  me.nextPath()
end

on nextPath me
  me.debug("nextPath()")
  me.iPathIndex = me.iPathIndex + 1
  if me.iPathIndex > me.aPath.count then
    me.stopPathAnimation()
    return 
  end if
  _oPoint = me.aPath[me.iPathIndex]
  oNode = oIsoScene.oMap.getNode(_oPoint.locV, _oPoint.locH)
  me.debug("oNode: " & oNode)
  if (oNode = VOID) or (oNode.w = oIsoScene.oMap.oPathfinder.W_BLOCKED) then
  end if
  _oSquare = oIsoScene.oGrid.getSquareByRowCol(_oPoint.locV, _oPoint.locH)
  me.animateToSquare(_oSquare)
end

on stopPathAnimation me
  me.debug("stopPathAnimation()")
  me.bPathMoving = 0
  me.bMoving = 0
end

on animateToRandomSquare me
  me.debug("animateToRandomSquare()")
  _oSquare = oIsoScene.oGrid.getRandomSquare()
  me.animateToSquare(_oSquare)
end

on animateToSquare me, oTarget
  me.debug("animateToSquare()")
  me.oTargetSquare = oTarget
  me.bMoving = 1
  oStartPoint = point(me.oPoint.x, me.oPoint.z)
  oEndPoint = point(me.oTargetSquare.oGridCenter.x, me.oTargetSquare.oGridCenter.z)
  iDistance = oIsoScene.oMath2d.distance(oStartPoint, oEndPoint)
  iFrameInterval = 1000 / oIsoScene.iFPS
  iNumFrames = (oIsoScene.getSequenceRate() - me.iTimeDelta) / iFrameInterval
  me.iSpeed = iDistance / iNumFrames
  me.iTimeDelta = 0
  oDirection = oIsoScene.oMath2d.direction(oEndPoint, oStartPoint)
  oDirection = oIsoScene.oMath2d.unit(oDirection)
  me.applyDirection(oDirection)
end

on stopAnimation me
  me.debug("stopAnimation()")
  me.bMoving = 0
  if me.bPathMoving then
    me.nextPath()
  else
    me.stopPathAnimation()
  end if
end

on stepFrame me
  if not me.bMoving then
    return 
  end if
  oStartPoint = point(me.oPoint.x, me.oPoint.z)
  oEndPoint = point(me.oTargetSquare.oGridCenter.x, me.oTargetSquare.oGridCenter.z)
  if (oStartPoint.locH = oEndPoint.locH) and (oStartPoint.locV = oEndPoint.locV) then
    me.bMoving = 0
    return 
  end if
  iDistance = oIsoScene.oMath2d.distance(oStartPoint, oEndPoint)
  if iDistance <= me.iSpeed then
    me.moveToGridPoint(me.oTargetSquare.oGridCenter)
    me.stopAnimation()
    return 
  end if
  oDirection = oIsoScene.oMath2d.direction(oEndPoint, oStartPoint)
  oDirection = oIsoScene.oMath2d.unit(oDirection)
  oTranslation = oDirection * me.iSpeed
  me.move(oTranslation.locH, 0, oTranslation.locV)
end

on applyDirection me, oDirection
end

on move me, iX, iY, iZ
  me.debug("move()")
  if iX <> VOID then
    me.oPoint.x = me.oPoint.x + iX
  end if
  if iY <> VOID then
    me.oPoint.y = me.oPoint.y + iY
  end if
  if iZ <> VOID then
    me.oPoint.z = me.oPoint.z + iZ
  end if
  me.doCalc()
  me.display()
end

on moveToSquare me, _oSquare
  me.moveToRowCol(_oSquare.iRow, _oSquare.iCol)
end

on moveTo me, iX, iY, iZ
  if iX <> VOID then
    me.oPoint.x = iX
  end if
  if iY <> VOID then
    me.oPoint.y = iY
  end if
  if iZ <> VOID then
    me.oPoint.z = iZ
  end if
  me.doCalc()
  me.display()
end

on moveToGridPoint me, oGridPoint
  me.debug("moveToGridPoint()")
  me.oPoint.x = oGridPoint.x
  me.oPoint.y = oGridPoint.y
  me.oPoint.z = oGridPoint.z
  me.doCalc()
  me.display()
end

on moveToRowCol me, iRow, iCol
  me.debug("moveToRowCol()")
  _oSquare = oIsoScene.oGrid.getSquareByRowCol(iRow, iCol)
  if not voidp(me.oSquare) then
    if not _oSquare.equals(me.oSquare) then
      iRowDelta = abs(me.oSquare.iRow - iRow)
      iColDelta = abs(me.oSquare.iCol - iCol)
      if (iRowDelta <= 2) and (iColDelta <= 2) then
        me.iTimeDelta = 0
        me.animateToSquare(_oSquare)
        return 
      end if
    end if
  end if
  me.moveToGridPoint(_oSquare.calcGridCenter())
end

on doCalc me
  me.debug("doCalc()")
  me.calcSquare()
  me.calcHeight()
  me.calcViewPoint()
  me.calcDepth()
  me.debug("doCalc() iDepth: " & me.iDepth)
end

on calcSquare me
  me.oSquare = oIsoScene.oGrid.getSquareByXZ(me.oPoint.x, me.oPoint.z)
end

on calcHeight me
  me.oPoint.y = me.oSquare.calcHeight(me.oPoint.x, me.oPoint.z)
end

on calcViewPoint me
  o2dPoint = oIsoScene.calcGridToViewPoint(me.oPoint)
  me.oViewPoint = o2dPoint - me.oRegistrationPoint
end

on calcDepth me
  me.debug("calcDepth()")
  me.iDepth = me.oSquare.getDepthByLayer(me.iLayer)
  me.iDepth = me.oSquare.getDepthFromMap("av", 0)
end

on display me
  if not me.bLoaded then
    return 
  end if
  me.debug("display() iDepth: " & me.iDepth)
  me.oSprite.width = me.oSprite.member.width * (me.iScale * 0.01)
  me.oSprite.height = me.oSprite.member.height * (me.iScale * 0.01)
  if me.oViewPointOverride <> VOID then
    me.oSprite.locH = me.oViewPointOverride.locH
    me.oSprite.locV = me.oViewPointOverride.locV
  else
    me.oSprite.locH = me.oViewPoint.locH
    me.oSprite.locV = me.oViewPoint.locV + me.iHeightOffset
  end if
  me.oSprite.locZ = me.iDepth
  me.oSprite.visible = 1
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "IsoSprite. ID: " & me.sID & ": " & sMessage
  end if
end

on toString me
  return "[IsoSprite] iDepth: " & me.iDepth
end

on setHeightOffset me, _iHeightOffset
  me.iHeightOffset = _iHeightOffset
end

on getHeightOffset me
  return me.iHeightOffset
end
