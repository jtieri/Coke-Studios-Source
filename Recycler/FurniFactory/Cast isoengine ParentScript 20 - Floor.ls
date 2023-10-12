property iShapeSprite, aTileSprites, aPatterns, sCastLib
global oIsoScene

on new me
  me.aPatterns = me.loadPatterns()
  me.iShapeSprite = VOID
  me.aTileSprites = []
  me.sCastLib = "Studio"
  return me
end

on init me, oXml
  if voidp(oXml) then
    return 
  end if
  oShapeNode = getNode(oXml, "Shape")
  if not voidp(oShapeNode) then
    aProps = oIsoScene.oSpriteManager.buildSpriteProps(oShapeNode)
    me.drawFloorShape(aProps)
  end if
  oFloorTiles = getNode(oXml, "FloorTiles")
  if not voidp(oFloorTiles) then
    aProps = oIsoScene.oSpriteManager.buildSpriteProps(oFloorTiles)
    aFloorTiles = getNodes(oFloorTiles, "FloorTile")
    repeat with i = aFloorTiles.count down to 1
      oFloorTile = aFloorTiles[i]
      sFloorTile = oFloorTile.toString()
      iRow = integer(oFloorTile.attributes.row)
      iCol = integer(oFloorTile.attributes.col)
      iXOff = 0
      iYOff = 0
      if sFloorTile contains "xoff=" then
        iXOff = integer(oFloorTile.attributes.xoff)
      end if
      if sFloorTile contains "yoff=" then
        iYOff = integer(oFloorTile.attributes.yoff)
      end if
      me.drawFloortile(iRow, iCol, aProps, iXOff, iYOff)
    end repeat
  end if
end

on drawFloorShape me, aProps
  iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
  sprite(iSprite).locH = sprite(iSprite).locH - 1
  sprite(iSprite).locV = sprite(iSprite).locV - 2
  me.iShapeSprite = iSprite
  me.setPattern(1, 1, me.iShapeSprite)
end

on drawFloortile me, iRow, iCol, aProps, iXOff, iYOff
  oSquare = oIsoScene.oGrid.getSquareByRowCol(iRow, iCol)
  oLoc = oSquare.oViewPoints.bl
  aProps[#x] = oLoc.locH
  aProps[#y] = oLoc.locV
  iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
  if not voidp(iXOff) then
    sprite(iSprite).locH = sprite(iSprite).locH + iXOff
  end if
  if not voidp(iYOff) then
    sprite(iSprite).locV = sprite(iSprite).locV + iYOff
  end if
  sprite(iSprite).locH = sprite(iSprite).locH - 0
  sprite(iSprite).locV = sprite(iSprite).locV - 0
  me.aTileSprites.add(iSprite)
  me.setPattern(1, 1, iSprite)
end

on mouseDownEvent me, iSprite, oSprite
end

on mouseIsOverFloor me
  bRollover = 0
  repeat with i = 1 to me.aTileSprites.count
    if rollover(me.aTileSprites[i]) then
      bRollover = 1
      exit repeat
    end if
  end repeat
  return bRollover
end

on destroy me
  oIsoScene.oSpriteManager.returnPooledSprite(me.iShapeSprite)
  oIsoScene.oSpriteManager.returnPooledSprites(me.aTileSprites)
  me.aTileSprites = []
  me.iShapeSprite = VOID
end

on toggleDisplay me
  repeat with i in me.aTileSprites
    if the optionDown then
      sprite(i).visible = 1
      next repeat
    end if
    sprite(i).visible = not sprite(i).visible
  end repeat
  if not voidp(me.iShapeSprite) then
    sprite(me.iShapeSprite).visible = not sprite(me.iShapeSprite).visible
  end if
end

on loadPatterns me
  aFloorPatterns = [:]
  oPatternMember = member("floorpattern_patterns_index", me.sCastLib)
  if oPatternMember.memberNum = -1 then
    return aFloorPatterns
  end if
  sPatternText = oPatternMember.text
  repeat with i = 1 to sPatternText.lines.count
    sPatternLine = sPatternText.line[i]
    aPatternList = value(sPatternLine)
    sPatternName = aPatternList.name
    sColorField = aPatternList.field
    aColors = []
    oColorsMember = member(sColorField, me.sCastLib)
    sColorsText = oColorsMember.text
    repeat with ii = 1 to sColorsText.lines.count
      sColorLine = sColorsText.line[ii]
      aColorsList = value(sColorLine)
      aColors.add(aColorsList)
    end repeat
    if voidp(aColors) then
      next repeat
    end if
    aFloorPatterns.addProp(sPatternName, aColors)
  end repeat
  return aFloorPatterns
end

on setPattern me, iPatternIndex, iColorIndex, iSprite
  if me.aPatterns.count = 0 then
    return 
  end if
  if voidp(iPatternIndex) then
    iPatternIndex = 1
  end if
  if voidp(iColorIndex) then
    iColorIndex = 1
  end if
  if (iPatternIndex < 1) or (iPatternIndex > me.aPatterns.count) then
    iPatternIndex = 1
  end if
  sPatternName = me.aPatterns.getPropAt(iPatternIndex)
  aColors = me.aPatterns[iPatternIndex]
  if (iColorIndex < 1) or (iColorIndex > aColors.count) then
    iColorIndex = 1
  end if
  aColorData = aColors[iColorIndex]
  if aColorData = VOID then
    nothing()
  end if
  if iSprite = me.iShapeSprite then
    me.displayShapePattern(sPatternName, aColorData, me.iShapeSprite)
    return 
  end if
  if voidp(iSprite) then
    me.displayShapePattern(sPatternName, aColorData, me.iShapeSprite)
    repeat with i in me.aTileSprites
      me.displayPattern(sPatternName, aColorData, i)
    end repeat
  else
    me.displayPattern(sPatternName, aColorData, iSprite)
  end if
end

on displayShapePattern me, sPatternName, aColorData, iSprite
  sprite(iSprite).member.fillColor = aColorData.startcolor
  sprite(iSprite).member.endColor = aColorData.endColor
  sprite(iSprite).blend = aColorData.shapeBlend
  sprite(iSprite).color = aColorData.texturecolor
end

on displayPattern me, sPatternName, aColorData, iSprite
  sprite(iSprite).member.palette = member("floor_" & aColorData.palette, me.sCastLib)
  sprite(iSprite).blend = aColorData.textureBlend
end

on setRandomPattern me
  iPatternIndex = random(me.aPatterns.count)
  aColors = me.aPatterns[iPatternIndex]
  iColorIndex = random(aColors.count)
  me.setPattern(iPatternIndex, iColorIndex)
end
