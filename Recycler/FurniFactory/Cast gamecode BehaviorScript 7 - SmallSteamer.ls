property iRow, iCol, iStartRow, iStartCol, iEndRow, iEndCol, iLayer, iMaxLength, aDepths, aRows, aCols, aAnimation, iStepsPerSquare, iPathPosition, iFPS, iFPSTimer, iFPSTimerLength, iRandomFlowTimer, iRandomFlowTimerLength, bIsFLowing, iDirection, iFramesPerLength, sBaseName, bPaused, iSoundChannel
global oIsoScene, oSpriteManager, oAvatar, bDebugCollision, oTextConstants

on beginSprite me
  me.iStepsPerSquare = 4
end

on initMachine me
  me.bPaused = 1
  me.iFPS = 15
  me.iFPSTimer = the milliSeconds
  me.iFPSTimerLength = 1000 / me.iFPS
  me.iRandomFlowTimer = the milliSeconds
  me.iRandomFlowTimerLength = me.setRandomTimerLength()
  me.bIsFLowing = 0
  the itemDelimiter = "_"
  me.sBaseName = sprite(me.spriteNum).member.name.item[1] & "_"
  the itemDelimiter = ","
  me.iMaxLength = abs(me.iEndCol - me.iStartCol)
  me.aDepths = []
  me.aRows = []
  me.aCols = []
  me.aAnimation = []
  me.aAnimation.add(me.sBaseName & 0 & "_" & 1)
  jRow = me.iStartRow
  jCol = me.iStartCol
  me.aRows.add(jRow)
  me.aCols.add(jCol)
  me.aDepths.add((jRow * 100) + jCol)
  repeat with i = 1 to me.iFPS * 1
    me.aAnimation.add(me.sBaseName & 1 & "_" & (i mod me.iFramesPerLength) + 1)
    jRow = me.iStartRow
    jCol = me.iStartCol
    me.aRows.add(jRow)
    me.aCols.add(jCol)
    me.aDepths.add((jRow * 100) + jCol)
  end repeat
  repeat with i = me.iStartCol to me.iEndCol
    repeat with j = 0 to me.iFramesPerLength
      me.aAnimation.add(me.sBaseName & i - me.iStartCol + 1 & "_" & (j mod me.iFramesPerLength) + 1)
      jRow = me.iStartRow
      jCol = i
      me.aRows.add(jRow)
      me.aCols.add(jCol)
      me.aDepths.add((jRow * 100) + jCol)
    end repeat
  end repeat
  repeat with i = 1 to me.iFPS * 3
    me.aAnimation.add(me.sBaseName & me.iEndCol - me.iStartCol + 1 & "_" & (i mod me.iFramesPerLength) + 1)
    jRow = me.iStartRow
    jCol = me.iEndCol
    me.aRows.add(jRow)
    me.aCols.add(jCol)
    me.aDepths.add((jRow * 100) + jCol)
  end repeat
  repeat with i = me.iEndCol - 1 down to me.iStartCol
    repeat with j = 0 to me.iFramesPerLength
      me.aAnimation.add(me.sBaseName & i - me.iStartCol + 1 & "_" & (j mod me.iFramesPerLength) + 1)
      jRow = me.iStartRow
      jCol = i
      me.aRows.add(jRow)
      me.aCols.add(jCol)
      me.aDepths.add((jRow * 100) + jCol)
    end repeat
  end repeat
  me.aAnimation.add(me.sBaseName & 0 & "_" & 1)
  jRow = me.iStartRow
  jCol = me.iStartCol
  me.aRows.add(jRow)
  me.aCols.add(jCol)
  me.aDepths.add((jRow * 100) + jCol)
  me.iDirection = 1
  me.iPathPosition = 1
  sprite(me.spriteNum).locZ = me.aDepths[me.iPathPosition]
  me.iRow = me.aRows[me.iPathPosition]
  me.iCol = me.aCols[me.iPathPosition]
  sprite(me.spriteNum).member = member(me.aAnimation[me.iPathPosition])
  (the actorList).add(me)
end

on pauseMachine me, bPauseValue
  me.bPaused = bPauseValue
end

on setRandomTimerLength me
  return (1000 * 1) + random(5 * 1000)
end

on getCollisionQuad me
  firstSquare = oIsoScene.oGrid.aSquares[me.iStartRow][me.iStartCol].calcViewCenter()
  lastSquare = oIsoScene.oGrid.aSquares[me.iStartRow][me.aCols[me.iPathPosition]].calcViewCenter()
  return [firstSquare + point(-10, -10), lastSquare + point(10, -10), lastSquare + point(10, 10), firstSquare + point(-10, 10)]
end

on testCollision me
  if not oAvatar = VOID then
    testSquare = oAvatar.getCurrentSquareForCollision()
    if bDebugCollision then
      cSprite = me.spriteNum + 100
      puppetSprite(cSprite, 1)
      sprite(cSprite).member = member("testbox")
      sprite(cSprite).blend = 50
      sprite(cSprite).quad = me.getCollisionQuad()
      sprite(cSprite).locZ = 10000
    end if
    if testSquare.iRow = me.iStartRow then
      if (me.iStartCol <= testSquare.iCol) and (testSquare.iCol <= me.aCols[me.iPathPosition]) then
        return 1
      end if
    end if
  end if
  return 0
end

on drawBots me
  if bIsFLowing then
    if me.iPathPosition = me.aAnimation.count then
      me.endFlow()
    else
      me.iPathPosition = me.iPathPosition + me.iDirection
      sprite(me.spriteNum).locZ = me.aDepths[me.iPathPosition]
      sprite(me.spriteNum).member = member(me.aAnimation[me.iPathPosition])
      me.iFPSTimer = the milliSeconds
    end if
  else
    if (the milliSeconds - me.iRandomFlowTimer) >= me.iRandomFlowTimerLength then
      me.startFlow()
    end if
  end if
  if me.testCollision() then
    put "The user has collided with the steamer based at" && me.iStartRow & "," & me.iStartCol
    oAvatar.doCollision(oTextConstants.sSteamerCollision, "cook")
  end if
end

on startFlow me
  me.iSoundChannel = oSpriteManager.checkOutSound()
  sound(me.iSoundChannel).volume = 40
  sound(me.iSoundChannel).pan = 1 * ((float(me.iStartCol - 9) / (21 - 9) * 200) - 100)
  if random(2) = 1 then
    sound(me.iSoundChannel).play(member("electric"))
  else
    sound(me.iSoundChannel).play(member("electricarc"))
  end if
  me.iDirection = 1
  me.iPathPosition = 1
  me.bIsFLowing = 1
end

on endFlow me
  sound(me.iSoundChannel).stop()
  oSpriteManager.checkInSound(me.iSoundChannel)
  sound(me.iSoundChannel).pan = 0
  me.bIsFLowing = 0
  me.iRandomFlowTimer = the milliSeconds
  me.iRandomFlowTimerLength = me.setRandomTimerLength()
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
  vList.addProp(#iFramesPerLength, [#comment: "Frames Per Length", #range: [1, 2, 3, 4, 5, 6, 7, 8], #format: #integer, #default: [1, 2, 3, 4, 5, 6, 7, 8][1]])
  return vList
end
