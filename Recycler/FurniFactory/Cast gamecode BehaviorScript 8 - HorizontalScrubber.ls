property iRow, iCol, iStartRow, iStartCol, iEndRow, iEndCol, iLayer, iTravelCols, aSteps, aElevations, aDepths, aRows, aCols, iStepsPerSquare, iPathPosition, iFPS, iFPSTimer, iFPSTimerLength, iRandomDirTimer, iRandomDirTimerLength, iDirection, iStartElevation, iEndElevation, iCollisionWidth, iCollisionHeight, aCollisionRowSpan, bPaused
global oIsoScene, oSpriteManager, oAvatar, bDebugCollision, oTextConstants, oComputer

on beginSprite me
  sprite(me.spriteNum).loc = point(-500, -500)
  me.iStepsPerSquare = 4
end

on initMachine me
  me.bPaused = 1
  me.aCollisionRowSpan = []
  repeat with i = me.iStartRow to me.iEndRow
    me.aCollisionRowSpan.add(i)
  end repeat
  me.iCollisionWidth = 36
  me.iCollisionHeight = 48
  me.iTravelCols = abs(me.iEndCol - me.iStartCol)
  me.aSteps = []
  me.aElevations = []
  me.aDepths = []
  me.aRows = []
  me.aCols = []
  iCurrentElevation = 1
  repeat with i = me.iStartCol to me.iEndCol - 1
    interDist = oIsoScene.oGrid.aSquares[me.iStartRow][i + 1].calcViewCenter() - oIsoScene.oGrid.aSquares[me.iStartRow][i].calcViewCenter()
    repeat with j = 0 to 3
      jRow = me.iEndRow
      jCol = i
      me.aRows.add(jRow)
      me.aCols.add(jCol)
      me.aDepths.add((jRow * 100) + jCol)
      me.aElevations.add(iCurrentElevation)
      me.aSteps.add(oIsoScene.oGrid.aSquares[me.iStartRow][i].calcViewCenter() + (interDist * 1.0 / me.iStepsPerSquare * j))
    end repeat
  end repeat
  repeat with i = me.iEndCol down to me.iStartCol + 1
    interDist = oIsoScene.oGrid.aSquares[me.iStartRow][i - 1].calcViewCenter() - oIsoScene.oGrid.aSquares[me.iStartRow][i].calcViewCenter()
    repeat with j = 0 to 3
      jRow = me.iEndRow
      jCol = i
      me.aRows.add(jRow)
      me.aCols.add(jCol)
      me.aDepths.add((jRow * 100) + jCol)
      me.aElevations.add(iCurrentElevation)
      me.aSteps.add(oIsoScene.oGrid.aSquares[me.iStartRow][i].calcViewCenter() + (interDist * 1.0 / me.iStepsPerSquare * j))
    end repeat
  end repeat
  repeat with i = me.iStartElevation to me.iEndElevation - 1
    interDist = 24
    repeat with j = 0 to 3
      jRow = me.iEndRow
      jCol = me.iStartCol
      me.aRows.add(jRow)
      me.aCols.add(jCol)
      me.aDepths.add((jRow * 100) + jCol)
      iCurrentElevation = ((i - 1) * interDist) + (interDist * 1.0 / me.iStepsPerSquare * j)
      me.aElevations.add(iCurrentElevation)
      me.aSteps.add(oIsoScene.oGrid.aSquares[me.iStartRow][me.iStartCol].calcViewCenter())
    end repeat
  end repeat
  repeat with i = me.iEndElevation down to me.iStartElevation + 1
    interDist = 24
    repeat with j = 0 to 3
      jRow = me.iEndRow
      jCol = me.iStartCol
      me.aRows.add(jRow)
      me.aCols.add(jCol)
      me.aDepths.add((jRow * 100) + jCol)
      iCurrentElevation = ((i - 1) * interDist) - (interDist * 1.0 / me.iStepsPerSquare * j)
      me.aElevations.add(iCurrentElevation)
      me.aSteps.add(oIsoScene.oGrid.aSquares[me.iStartRow][me.iStartCol].calcViewCenter())
    end repeat
  end repeat
  me.iDirection = [1, -1][random(2)]
  me.iPathPosition = me.iEndCol - 1
  sprite(me.spriteNum).locZ = me.aDepths[me.iPathPosition]
  me.iRow = me.aRows[me.iPathPosition]
  me.iCol = me.aCols[me.iPathPosition]
  sprite(me.spriteNum).loc = me.aSteps[me.iPathPosition] - point(0, me.aElevations[me.iPathPosition])
  me.iFPS = 15
  me.iFPSTimer = the milliSeconds
  me.iFPSTimerLength = 1000 / me.iFPS
  me.iRandomDirTimer = the milliSeconds
  me.iRandomDirTimerLength = 1000 * 5
  (the actorList).add(me)
end

on pauseMachine me, bPauseValue
  me.bPaused = bPauseValue
end

on getCollisionRect me, theRowIndex
  rRawRect = rect(sprite(me.spriteNum).loc - point(me.iCollisionWidth / 2, me.iCollisionHeight), sprite(me.spriteNum).loc + point(me.iCollisionWidth / 2, 0))
  pXDif = (theRowIndex - 1) * (oIsoScene.oGrid.aSquares[1][1].oViewPoints[4] - oIsoScene.oGrid.aSquares[1][1].oViewPoints[2]) / 2.0
  pYDif = (theRowIndex - 1) * (oIsoScene.oGrid.aSquares[1][1].oViewPoints[1] - oIsoScene.oGrid.aSquares[1][1].oViewPoints[3]) / 2.0
  rXDif = rect(abs(pXDif[1]), abs(pXDif[2]), abs(pXDif[1]), abs(pXDif[2]))
  rYDif = rect(abs(pYDif[1]), abs(pYDif[2]), abs(pYDif[1]), abs(pYDif[2]))
  return rRawRect - rXDif + rYDif
end

on testCollision me
  bCollision = 0
  if not oAvatar = VOID then
    repeat with i = 1 to me.aCollisionRowSpan.count
      if bDebugCollision then
        cSprite = me.spriteNum + 150
        puppetSprite(cSprite + i, 1)
        sprite(cSprite + i).member = member("testbox")
        sprite(cSprite + i).blend = float(i) / me.aCollisionRowSpan.count * 100
        sprite(cSprite + i).rect = me.getCollisionRect(i)
        sprite(cSprite + i).locZ = 10000
      end if
      bSpriteIntersection = not (intersect(me.getCollisionRect(i), oAvatar.getCollisionRect()) = rect(0, 0, 0, 0))
      if bSpriteIntersection then
        if oAvatar.getCurrentSquareForCollision().iRow = me.aCollisionRowSpan[i] then
          return 1
        end if
      end if
    end repeat
  end if
  return bCollision
end

on drawBots me
  iElapsedTime = the milliSeconds - me.iRandomDirTimer
  if (iElapsedTime >= me.iRandomDirTimerLength) and (random(150) = 1) then
    me.iRandomDirTimer = the milliSeconds
    me.iDirection = me.iDirection * -1
  end if
  if (me.iPathPosition = me.aSteps.count) and (me.iDirection = 1) then
    me.iDirection = -1
  else
    if (me.iPathPosition = 1) and (me.iDirection = -1) then
      me.iDirection = 1
    end if
  end if
  me.iPathPosition = me.iPathPosition + me.iDirection
  sprite(me.spriteNum).loc = me.aSteps[me.iPathPosition] - point(0, me.aElevations[me.iPathPosition])
  sprite(me.spriteNum).locZ = me.aDepths[me.iPathPosition]
  me.iFPSTimer = the milliSeconds
  if me.testCollision() then
    put "The user has collided with the whale base cart."
    oAvatar.doCollision(oTextConstants.sHoriScrubberCollision, "hit")
  end if
end

on stepFrame me
  toolDelivery = oComputer.getCountOfTools() - oComputer.getCountOfToolsLeft()
  moveObject = toolDelivery >= 6
  if not me.bPaused and moveObject then
    if me.iFPS > 0 then
      iElapsedTime = the milliSeconds - me.iFPSTimer
      if iElapsedTime >= me.iFPSTimerLength then
        me.drawBots()
        return 1
      end if
    end if
  end if
  return 0
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
  vList.addProp(#iStartRow, [#comment: "Start Row", #range: vRowColRange, #format: #integer, #default: vRowColRange[1]])
  vList.addProp(#iStartCol, [#comment: "Start Column", #range: vRowColRange, #format: #integer, #default: vRowColRange[1]])
  vList.addProp(#iEndRow, [#comment: "End Row", #range: vRowColRange, #format: #integer, #default: vRowColRange[1]])
  vList.addProp(#iEndCol, [#comment: "End Column", #range: vRowColRange, #format: #integer, #default: vRowColRange[1]])
  vList.addProp(#iStartElevation, [#comment: "Start Elevation", #range: vRowColRange, #format: #integer, #default: vRowColRange[1]])
  vList.addProp(#iEndElevation, [#comment: "End Elevation", #range: vRowColRange, #format: #integer, #default: vRowColRange[1]])
  vList.addProp(#iLayer, [#comment: "Layer", #range: vLayerRange, #format: #integer, #default: vLayerRange[1]])
  return vList
end
