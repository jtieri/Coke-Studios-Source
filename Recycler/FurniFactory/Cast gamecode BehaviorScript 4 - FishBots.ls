property iStartRow, iStartCol, iEndRow, iEndCol, iLayer, aBots, aBotShadows, iTravelCols, aSteps, aDepths, iStepsPerSquare, iBotSpacing, iFPS, iFPSTimer, iFPSTimerLength, iBotCollided, iCollisionWidth, iCollisionHeight, bPaused
global oIsoScene, oSpriteManager, oAvatar, bDebugCollision, oTextConstants, oComputer

on beginSprite me
  sprite(me.spriteNum).loc = point(-500, -500)
  me.iStepsPerSquare = 4
  me.iBotSpacing = 4
end

on initMachine me
  me.bPaused = 1
  me.iCollisionWidth = 10
  me.iCollisionHeight = 50
  me.aBots = []
  me.aBotShadows = []
  me.iTravelCols = abs(me.iEndCol - me.iStartCol)
  me.aSteps = []
  me.aDepths = []
  bDecreasing = me.iEndCol < me.iStartCol
  if bDecreasing then
    repeat with i = me.iStartCol down to me.iEndCol + 1
      interDist = oIsoScene.oGrid.aSquares[me.iStartRow][i - 1].calcViewCenter() - oIsoScene.oGrid.aSquares[me.iStartRow][i].calcViewCenter()
      repeat with j = 0 to 3
        jRow = me.iStartRow
        jCol = i
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
        me.aDepths.add((jRow * 100) + jCol)
        me.aSteps.add(oIsoScene.oGrid.aSquares[me.iStartRow][i].calcViewCenter() + (interDist * 1.0 / me.iStepsPerSquare * j))
      end repeat
    end repeat
  end if
  pPosition = 1
  me.aBots.add([#snum: me.spriteNum, #pos: pPosition])
  iNewShadowSprite = oSpriteManager.checkOutSprite()
  me.aBotShadows.add(iNewShadowSprite)
  puppetSprite(iNewShadowSprite, 1)
  sprite(iNewShadowSprite).member = member("human_shadow_sh")
  sprite(iNewShadowSprite).loc = point(-500, -500)
  sprite(iNewShadowSprite).blend = 100
  repeat while pPosition < (me.aSteps.count - (me.iStepsPerSquare * me.iBotSpacing))
    pPosition = pPosition + (me.iStepsPerSquare * me.iBotSpacing)
    iNewSprite = oSpriteManager.checkOutSprite()
    me.aBots.add([#snum: iNewSprite, #pos: pPosition])
    puppetSprite(iNewSprite, 1)
    sprite(iNewSprite).member = sprite(me.spriteNum).member
    sprite(iNewSprite).ink = 8
    iNewShadowSprite = oSpriteManager.checkOutSprite()
    me.aBotShadows.add(iNewShadowSprite)
    puppetSprite(iNewShadowSprite, 1)
    sprite(iNewShadowSprite).member = member("human_shadow_sh")
    sprite(iNewShadowSprite).loc = point(-500, -500)
    sprite(iNewShadowSprite).blend = 100
  end repeat
  put "number = " & me.aBots.count && "cols = " & me.iTravelCols
  me.iFPS = 15
  me.iFPSTimer = the milliSeconds
  me.iFPSTimerLength = 1000 / me.iFPS
  (the actorList).add(me)
end

on pauseMachine me, bPauseValue
  me.bPaused = bPauseValue
end

on drawBots me
  bCollision = 0
  repeat with i = 1 to me.aBots.count
    me.aBots[i].pos = me.aBots[i].pos + 1
    if me.aBots[i].pos > me.aSteps.count then
      me.aBots[i].pos = 1
    end if
    toolDelivery = oComputer.getCountOfTools() - oComputer.getCountOfToolsLeft()
    showBotsInGeneral = toolDelivery >= 5
    if showBotsInGeneral then
      showBotSpecifically = 1
    else
      showBotSpecifically = (i mod (5 - toolDelivery)) = 0
    end if
    if showBotSpecifically then
      sprite(me.aBots[i].snum).loc = me.aSteps[me.aBots[i].pos]
      sprite(me.aBots[i].snum).locZ = me.aDepths[me.aBots[i].pos]
      the itemDelimiter = "_"
      sMemberToUse = sprite(me.aBots[i].snum).member.name.item[1] & "_" & (me.aBots[i].pos mod 4) + 1
      sprite(me.aBots[i].snum).member = member(sprite(me.aBots[i].snum).member.name.item[1] & "_" & (me.aBots[i].pos mod 4) + 1)
      sprite(me.aBotShadows[i]).loc = me.aSteps[me.aBots[i].pos]
      sprite(me.aBotShadows[i]).locZ = 2
    else
      sprite(me.aBots[i].snum).loc = point(-500, -500)
      sprite(me.aBotShadows[i]).loc = point(-500, -500)
    end if
    if me.testCollision(me.aBots[i]) then
      bCollision = 1
      iBotCollided = i
    end if
  end repeat
  if bCollision then
    put "The user has collided with fish bot: row " & me.iStartRow && "bot #" & iBotCollided
    oAvatar.doCollision(oTextConstants.sBotCollision, "bot")
  end if
  me.iFPSTimer = the milliSeconds
end

on getCollisionRect me, iBot
  return rect(sprite(iBot).loc - point(me.iCollisionWidth / 2, me.iCollisionHeight), sprite(iBot).loc + point(me.iCollisionWidth / 2, 0))
end

on testCollision me, oBotObject
  if not oAvatar = VOID then
    bSpriteIntersection = not (intersect(me.getCollisionRect(oBotObject.snum), oAvatar.getCollisionRect()) = rect(0, 0, 0, 0))
    if bDebugCollision then
      cSprite = me.spriteNum + 170
      puppetSprite(cSprite + oBotObject.snum, 1)
      sprite(cSprite + oBotObject.snum).member = member("testbox")
      sprite(cSprite + oBotObject.snum).blend = 50
      sprite(cSprite + oBotObject.snum).rect = me.getCollisionRect(oBotObject.snum)
      sprite(cSprite + oBotObject.snum).locZ = 10000
    end if
    if bSpriteIntersection then
      return oAvatar.getCurrentSquareForCollision().iRow = me.iStartRow
    end if
  end if
  return 0
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
