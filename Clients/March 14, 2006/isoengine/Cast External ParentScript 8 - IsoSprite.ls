property bDebug, oPoint, sImage, sID, sMember, sType, oSprite, oViewPoint, oViewPointOverride, iLayer, oSquare, iDepth, iSpeed, oTargetSquare, bMoving, aPath, iPathIndex, bLoaded, iScale, oPointDir, oRegistrationPoint, aDirections, aDir, iHeightOffset, iAnimTimer, UP_RIGHT, right, DOWN_RIGHT, down, DOWN_LEFT, left, UP_LEFT, up, iTimeDelta, oLastLoc, iFPS
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
  me.iPathIndex = 0
  me.sType = "Default"
  me.oSprite = me.createSprite(me.sMember)
  me.initDirections()
  me.aDir = me.UP_RIGHT
  me.iTimeDelta = 0
  me.iHeightOffset = 0
  me.iFPS = oIsoScene.iFPS
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
  me.debug("findPath() ")
  me.doCalc()
  oStartSquare = me.oSquare
  oN1 = oIsoScene.oMap.getNode(oStartSquare.iRow, oStartSquare.iCol)
  oN2 = oIsoScene.oMap.getNode(oEndSquare.iRow, oEndSquare.iCol)
  _aPath = oIsoScene.oMap.oPathfinder.findPath(oN1, oN2)
  if _aPath = VOID then
    return 
  end if
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

on addToPath me, _oSquare, bStop
  _oPoint = point(_oSquare.iCol, _oSquare.iRow)
  me.aPath.add(_oPoint)
  if not voidp(bStop) then
    if bStop = 0 then
      me.aPath.add(0)
    end if
  end if
  if not me.bMoving then
    me.nextPath()
  end if
end

on nextPath me
  if voidp(me.iAnimTimer) then
    me.iAnimTimer = the milliSeconds
  end if
  iElapsedTime = the milliSeconds - me.iAnimTimer
  me.iAnimTimer = the milliSeconds
  if me.aPath.count() = 0 then
    me.stopPathAnimation()
    return 
  end if
  _oPoint = me.aPath[1]
  me.aPath.deleteAt(1)
  if _oPoint = 0 then
    me.nextPath()
    return 
  end if
  _oSquare = oIsoScene.oGrid.getSquareByRowCol(_oPoint.locV, _oPoint.locH)
  me.animateToSquare(_oSquare)
end

on addStopToPath me
  me.debug("addStopToPath()", 1)
end

on stopPathAnimation me
  me.debug("stopPathAnimation()")
  if not me.bMoving then
    return 
  end if
  me.aPath = []
  me.bMoving = 0
end

on clearPath me
  me.debug("clearPath()", 1)
  me.aPath = []
  me.bMoving = 0
end

on animateToRandomSquare me
  me.debug("animateToRandomSquare()")
  _oSquare = oIsoScene.oGrid.getRandomSquare()
  me.animateToSquare(_oSquare)
end

on getFPS me
  return me.iFPS
end

on setFPS me, _iFPS
  me.iFPS = _iFPS
end

on animateToSquare me, oTarget
  if voidp(me.oSquare) then
    me.debug("me.oSquare = void", 1)
    me.moveToGridPoint(oTarget.calcGridCenter())
    me.stopPathAnimation()
    return 0
  end if
  if not oTarget.equals(me.oSquare) then
    iRowDelta = abs(me.oSquare.iRow - oTarget.iRow)
    iColDelta = abs(me.oSquare.iCol - oTarget.iCol)
    if (iRowDelta <= 2) and (iColDelta <= 2) then
      me.oTargetSquare = oTarget
      me.bMoving = 1
      oStartPoint = point(me.oPoint.x, me.oPoint.z)
      oEndPoint = point(me.oTargetSquare.oGridCenter.x, me.oTargetSquare.oGridCenter.z)
      iDistance = oIsoScene.oMath2d.distance(oStartPoint, oEndPoint)
      iFrameInterval = 1000 / me.iFPS
      iNumFrames = (oIsoScene.getSequenceRate() - me.iTimeDelta) / iFrameInterval
      me.iSpeed = iDistance / iNumFrames
      me.iTimeDelta = 0
      oDirection = oIsoScene.oMath2d.direction(oEndPoint, oStartPoint)
      oDirection = oIsoScene.oMath2d.unit(oDirection)
      me.applyDirection(oDirection)
      me.doFrameEvent()
      return 1
    else
      me.moveToGridPoint(oTarget.calcGridCenter())
      me.stopPathAnimation()
      return 0
    end if
  else
    me.moveToGridPoint(oTarget.calcGridCenter())
    me.stopPathAnimation()
    return 0
  end if
end

on doFrameEvent me
  if not me.bMoving then
    return 
  end if
  oStartPoint = point(me.oPoint.x, me.oPoint.z)
  oEndPoint = point(me.oTargetSquare.oGridCenter.x, me.oTargetSquare.oGridCenter.z)
  if (oStartPoint.locH = oEndPoint.locH) and (oStartPoint.locV = oEndPoint.locV) then
    me.debug("oStartPoint.locH = oEndPoint.locH", 1)
    me.nextPath()
    return 
  end if
  iDistance = oIsoScene.oMath2d.distance(oStartPoint, oEndPoint)
  if iDistance <= me.iSpeed then
    me.nextPath()
    return 
  end if
  oDirection = oIsoScene.oMath2d.direction(oEndPoint, oStartPoint)
  oDirection = oIsoScene.oMath2d.unit(oDirection)
  oTranslation = oDirection * (me.iSpeed * 1)
  me.move(oTranslation.locH, 0, oTranslation.locV)
end

on applyDirection me, oDirection
end

on move me, iX, iY, iZ
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
  if voidp(_oSquare) then
    return 
  end if
  me.moveToGridPoint(_oSquare.oGridCenter)
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
  _oSquare = oIsoScene.oGrid.getSquareByRowCol(iRow, iCol)
  me.addToPath(_oSquare)
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
    put "IsoSprite::ID: " & me.sID & ": " & sMessage
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
