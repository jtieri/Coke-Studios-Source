property bDebug, oMap, aAStarMap, bUseDiagonals, aDirections, iDirLength, aOpen, aClosed, W_START, W_END, W_OPEN, W_ENTER, W_FIRSTMOVE, W_AVATAR, W_ITEM, W_VCHAIR, W_POINTER, W_QUEUE, W_STAGE, W_PERFORM, W_EXITSTAGE, W_BOTS, W_BLOCKED, oStartNode, oEndNode, iElapsedTime, bSmoothPath
global oIsoScene, oStudioMap

on new me, _oMap
  me.bDebug = 0
  me.debug("new AStar()")
  me.oMap = _oMap
  me.aAStarMap = me.createAStarMap(me.oMap.iRows, me.oMap.iCols)
  me.bUseDiagonals = oStudioMap.getUseDiagonals()
  me.aDirections = me.createDirections()
  me.iDirLength = me.aDirections.count
  me.debug("aDirections: " & me.aDirections)
  me.aOpen = []
  me.aClosed = []
  me.W_START = -2
  me.W_END = -1
  me.W_OPEN = 0
  me.W_ENTER = 10
  me.W_FIRSTMOVE = 20
  me.W_AVATAR = 50
  me.W_ITEM = 100
  me.W_VCHAIR = 110
  me.W_POINTER = 150
  me.W_QUEUE = 155
  me.W_STAGE = 175
  me.W_PERFORM = 180
  me.W_EXITSTAGE = 185
  me.W_BOTS = 200
  me.W_BLOCKED = 255
  me.bSmoothPath = 1
  return me
end

on findPath me, _oN1, _oN2
  me.debug("findPath()")
  iStartTime = the milliSeconds
  me.aDirections = me.createDirections()
  me.iDirLength = me.aDirections.count
  me.aAStarMap = me.createAStarMap(me.oMap.iRows, me.oMap.iCols)
  pt1 = point(_oN1.iCol, _oN1.iRow)
  pt2 = point(_oN2.iCol, _oN2.iRow)
  me.oStartNode = _oN1
  me.oEndNode = _oN2
  me.aOpen = []
  me.debug("STEP 1")
  s = new(script("AStarNode"))
  s.pt = pt1
  s.g = 0
  s.s = VOID
  s.h = me.getHeuristic(pt1, pt2)
  s.f = s.g + s.h
  s.w = _oN1.w
  s.parent = VOID
  me.debug("s: " & s)
  me.aOpen.append(s)
  me.debug("STEP 2")
  repeat while me.aOpen.count > 0
    n = me.aOpen[1]
    me.aOpen.deleteAt(1)
    me.debug("STEP 2.1 n: " & n)
    if n.pt = pt2 then
      me.iElapsedTime = the milliSeconds - iStartTime
      return me.constructPath(n)
    end if
    me.debug("STEP 2.2")
    aSuccessors = me.getSuccessors(n, pt2)
    iLength = aSuccessors.count
    repeat with i = 1 to iLength
      nn = aSuccessors[i]
      newg = n.g + me.getCost(n, nn)
      bInOpen = nn.s = n.open
      bInClosed = nn.s = n.closed
      if bInOpen or bInClosed then
        if nn.g <= newg then
          me.debug("nn.g <= newg continue")
          next repeat
        end if
      end if
      nn.parent = n
      nn.g = newg
      nn.h = me.getHeuristic(nn.pt, pt2)
      nn.f = nn.g + nn.h
      nn.s = nn.open
      me.debug("STEP 2.4 nn: " + nn)
      if not bInOpen then
        me.aOpen.append(nn)
      end if
      me.aAStarMap[nn.pt.locV][nn.pt.locH] = nn
    end repeat
    me.debug("STEP 2.5")
    n.s = n.closed
    me.aAStarMap[n.pt.locV][n.pt.locH] = n
  end repeat
  me.iElapsedTime = the milliSeconds - iStartTime
  return VOID
end

on smoothPath me, aPath
  stPt = aPath[aPath.count]
  aNewPath = []
  repeat with i = 1 to aPath.count
    pt = aPath[i]
    aNewPath.add(pt)
    aDirectPath = me.getDirectPath(pt, stPt)
    if not voidp(aDirectPath) then
      repeat with ii = 1 to aDirectPath.count
        aNewPath.add(aDirectPath[ii])
      end repeat
      return aNewPath
    end if
  end repeat
  return aNewPath
end

on getDirectPath me, pt1, pt2
  aDirectPath = []
  if pt1.locH = pt2.locH then
    iDir = 1
    if pt2.locV < pt1.locV then
      iDir = -1
    end if
    iDif = abs(pt1.locV - pt2.locV)
    repeat with i = 1 to iDif
      iNextV = pt1.locV + (iDir * i)
      oMapNode = me.oMap.getNode(iNextV, pt1.locH)
      if voidp(oMapNode) then
        return VOID
      end if
      if oMapNode.w = me.W_BLOCKED then
        return VOID
      end if
      if oMapNode.w = me.W_POINTER then
        return VOID
      end if
      oNextPt = point(pt1.locH, iNextV)
      bEndNode = oNextPt = pt2
      bPassable = me.getPassable(oMapNode, bEndNode)
      if not bPassable then
        return VOID
      end if
      aDirectPath.add(oNextPt)
    end repeat
    return aDirectPath
  end if
  if pt1.locV = pt2.locV then
    iDir = 1
    if pt2.locH < pt1.locH then
      iDir = -1
    end if
    iDif = abs(pt1.locH - pt2.locH)
    repeat with i = 1 to iDif
      iNextH = pt1.locH + (iDir * i)
      oMapNode = me.oMap.getNode(pt1.locV, iNextH)
      if voidp(oMapNode) then
        return VOID
      end if
      bPassable = me.getPassable(oMapNode, bEndNode)
      if not bPassable then
        return VOID
      end if
      aDirectPath.add(point(iNextH, pt1.locV))
    end repeat
    return aDirectPath
  end if
  return VOID
end

on getCost me, n, nn
  return 1
end

on getSuccessors me, n, pt2
  me.debug("getSuccessors() " & n)
  aSuccessors = []
  repeat with i = 1 to me.iDirLength
    dirPt = me.aDirections[i]
    nPt = n.pt
    nextPt = nPt + dirPt
    if nextPt = nPt then
      next repeat
    end if
    oMapNode = me.oMap.getNode(nextPt.locV, nextPt.locH)
    if oMapNode = VOID then
      next repeat
    end if
    bEndNode = oMapNode.equals(me.oEndNode)
    bPassable = me.getPassable(oMapNode, bEndNode)
    if not bPassable then
      next repeat
    end if
    nn = me.aAStarMap[nextPt.locV][nextPt.locH]
    if nn = VOID then
      nn = new(script("AStarNode"))
      nn.pt = nextPt
    end if
    aSuccessors.append(nn)
  end repeat
  oMapNode = me.oMap.getNode(n.pt.locV, n.pt.locH)
  if not voidp(oMapNode) then
    aP = oMapNode.p
    iNumPointers = aP.count
    if iNumPointers > 0 then
      repeat with i = 1 to iNumPointers
        oPNode = aP[i]
        nPt = n.pt
        nextPt = point(oPNode.col, oPNode.row)
        if nextPt = nPt then
          next repeat
        end if
        nn = me.aAStarMap[nextPt.locV][nextPt.locH]
        if voidp(nn) then
          nn = new(script("AStarNode"))
          nn.pt = nextPt
        end if
        aSuccessors.add(nn)
      end repeat
    end if
  end if
  return aSuccessors
end

on getHeuristic me, pt1, pt2
  dx = pt1.locH - pt2.locH
  dy = pt1.locV - pt2.locV
  return sqrt((dx * dx) + (dy * dy))
end

on createDirections me
  aDirections = []
  aDirections.append(point(0, -1))
  if me.bUseDiagonals then
    aDirections.append(point(1, -1))
  end if
  aDirections.append(point(1, 0))
  if me.bUseDiagonals then
    aDirections.append(point(1, 1))
  end if
  aDirections.append(point(0, 1))
  if me.bUseDiagonals then
    aDirections.append(point(-1, 1))
  end if
  aDirections.append(point(-1, 0))
  if me.bUseDiagonals then
    aDirections.append(point(-1, -1))
  end if
  return aDirections
end

on createAStarMap me, iRows, iCols
  aNodes = []
  repeat with iRow = 1 to iRows
    aRow = []
    repeat with iCol = 1 to iCols
      aRow.append(VOID)
    end repeat
    aNodes.append(aRow)
  end repeat
  return aNodes
end

on constructPath me, nnn
  me.debug("constructPath()")
  aPath = []
  repeat while 1
    aPath.append(nnn.pt)
    nnn = nnn.parent
    if nnn = VOID then
      exit repeat
    end if
  end repeat
  aPath = me.reverseList(aPath)
  aNewPath = me.smoothPath(aPath)
  if me.bSmoothPath then
    return aNewPath
  end if
  return aPath
end

on getNodeByPoint me, nn, aList
  iLength = aList.count
  repeat with i = 1 to aList.count
    n = aList[i]
    if n.equals(nn) then
      return n
    end if
  end repeat
end

on reverseList me, _aPath
  iLength = _aPath.count
  Ar = []
  repeat with i = iLength down to 1
    Ar.append(_aPath[i])
  end repeat
  return Ar
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "isoengine:AStar:" & sMessage
  end if
end

on getPassable me, oMapNode, bEndNode
  if oMapNode.w = me.W_BLOCKED then
    return 0
  end if
  oSquare = oIsoScene.oGrid.getSquareByRowCol(oMapNode.iRow, oMapNode.iCol)
  aAvatars = oIsoScene.oAvatars.getItemsAtSquare(oSquare)
  if aAvatars.count > 0 then
    return 0
  end if
  aFurnitureItems = oIsoScene.oFurniture.getItemsAtSquare(oSquare)
  bSeatableItem = oIsoScene.oFurniture.seatableItemInList(aFurnitureItems)
  if bSeatableItem and bEndNode then
    return 1
  end if
  if aFurnitureItems.count > 0 then
    return 0
  end if
  return 1
end
