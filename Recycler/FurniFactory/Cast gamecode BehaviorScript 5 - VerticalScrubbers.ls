property iRow, iCol, iStartRow, iStartCol, iEndRow, iEndCol, iLayer, iTravelCols, aSteps, aDepths, aRows, aCols, iStepsPerSquare, iPathPosition, iFPS, iFPSTimer, iFPSTimerLength, iRandomDirTimer, iRandomDirTimerLength, iDirection, iCollisionWidth, iCollisionHeight, bPaused
global oIsoScene, oSpriteManager, oAvatar, bDebugCollision, oTextConstants, oComputer

on beginSprite me
  sprite(me.spriteNum).loc = point(-500, -500)
  me.iStepsPerSquare = 4
end

on initMachine me
  me.bPaused = 1
  me.iCollisionWidth = 10
  me.iCollisionHeight = 115
  me.iTravelCols = abs(me.iEndCol - me.iStartCol)
  me.aSteps = []
  me.aDepths = []
  me.aRows = []
  me.aCols = []
  bDecreasing = me.iEndCol < me.iStartCol
  if bDecreasing then
    repeat with i = me.iStartCol down to me.iEndCol + 1
      interDist = oIsoScene.oGrid.aSquares[me.iStartRow][i - 1].calcViewCenter() - oIsoScene.oGrid.aSquares[me.iStartRow][i].calcViewCenter()
      repeat with j = 0 to 3
        jRow = me.iStartRow
        jCol = i
        me.aRows.add(jRow)
        me.aCols.add(jCol)
        me.aDepths.add((jRow * 100) + jCol)
        me.aSteps.add(oIsoScene.oGrid.aSquares[me.iStartRow][i].calcViewCenter() + (interDist * 1.0 / me.iStepsPerSquare * j))
      end repeat
    end repeat
  else
    repeat with i = me.iStartCol to me.iEndCol - 1
      interDist = oIsoScene.oGrid.aSquares[me.iStartRow][i + 1].calcViewCenter() - oIsoScene.oGrid.aSquares[me.iStartRow][i].calcViewCenter()
      repeat with j = 0 to 3
        jRow = me.iStartRow
        jCol = i
        me.aRows.add(jRow)
        me.aCols.add(jCol)
        me.aDepths.add((jRow * 100) + jCol)
        me.aSteps.add(oIsoScene.oGrid.aSquares[me.iStartRow][i].calcViewCenter() + (interDist * 1.0 / me.iStepsPerSquare * j))
      end repeat
    end repeat
  end if
  me.iDirection = [1, -1][random(2)]
  me.iPathPosition = random(me.aSteps.count - 2) + 1
  sprite(me.spriteNum).locZ = me.aDepths[me.iPathPosition]
  me.iRow = me.aRows[me.iPathPosition]
  me.iCol = me.aCols[me.iPathPosition]
  sprite(me.spriteNum).loc = me.aSteps[me.iPathPosition]
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

on getCollisionRect me
  return rect(sprite(me.spriteNum).loc - point(me.iCollisionWidth / 2, me.iCollisionHeight), sprite(me.spriteNum).loc + point(me.iCollisionWidth / 2, 0))
end

on testCollision me
  if not oAvatar = VOID then
    bSpriteIntersection = not (intersect(me.getCollisionRect(), oAvatar.getCollisionRect()) = rect(0, 0, 0, 0))
    if bDebugCollision then
      cSprite = me.spriteNum + 100
      puppetSprite(cSprite, 1)
      sprite(cSprite).member = member("testbox")
      sprite(cSprite).blend = 50
      sprite(cSprite).rect = me.getCollisionRect()
      sprite(cSprite).locZ = 10000
    end if
    if bSpriteIntersection then
      return oAvatar.getCurrentSquareForCollision().iRow = me.iRow
    end if
  end if
  return 0
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
  sprite(me.spriteNum).loc = me.aSteps[me.iPathPosition]
  sprite(me.spriteNum).locZ = me.aDepths[me.iPathPosition]
  me.iFPSTimer = the milliSeconds
  if me.testCollision() then
    put "The user has collided with scrubber in row " & me.iRow
    oAvatar.doCollision(oTextConstants.sVertScrubberCollision, "hit")
  end if
end

on stepFrame me
  if not me.bPaused then
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
  vList.addProp(#iLayer, [#comment: "Layer", #range: vLayerRange, #format: #integer, #default: vLayerRange[1]])
  return vList
end
