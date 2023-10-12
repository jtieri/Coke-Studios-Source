property aTileSprites, aPatterns, sCastLib
global oIsoScene

on new me
  me.aPatterns = me.loadPatterns()
  me.aTileSprites = []
  me.sCastLib = "Studio"
  return me
end

on init me, oXml
  if voidp(oXml) then
    return 
  end if
  aWallTiles = getNodes(oXml, "WallTile")
  repeat with i = 1 to aWallTiles.count
    oWallTile = aWallTiles[i]
    sWallTile = oWallTile.toString()
    iRow = integer(oWallTile.attributes.row)
    iCol = integer(oWallTile.attributes.col)
    sDir = oWallTile.attributes.dir
    if sWallTile contains "corner" then
      bCorner = 1
    else
      bCorner = 0
    end if
    iXOff = 0
    iYOff = 0
    if sWallTile contains "xoff=" then
      iXOff = integer(oWallTile.attributes.xoff)
    end if
    if sWallTile contains "yoff=" then
      iYOff = integer(oWallTile.attributes.yoff)
    end if
    if bCorner then
      sId4 = "wallcorner"
    else
      sId4 = VOID
    end if
    case sDir of
      "right":
        me.drawWallTile(iRow, iCol, "right_wall_1_b_0_2_0", "right", "right_wall", "color", sId4, iXOff, iYOff)
        me.drawWallTile(iRow, iCol, "right_wall_1_a_0_2_0", "right", "right_wall", "texture", sId4, iXOff, iYOff)
      "left":
        me.drawWallTile(iRow, iCol, "left_wall_1_b_0_0_0", "left", "left_wall", "color", sId4, iXOff, iYOff)
        me.drawWallTile(iRow, iCol, "left_wall_1_a_0_0_0", "left", "left_wall", "texture", sId4, iXOff, iYOff)
    end case
  end repeat
end

on drawWallTile me, iRow, iCol, sMember, sId1, sId2, sId3, sId4, iXOff, iYOff
  oSquare = oIsoScene.oGrid.getSquareByRowCol(iRow, iCol)
  oLoc = oSquare.oViewPoints.bl
  aProps = [#member: sMember, #x: oLoc.locH, #y: oLoc.locV, #ink: 8]
  iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
  sprite(iSprite).scriptInstanceList.add(script("WallScript").new(me, sId1, sId2, sId3, sId4, oSquare))
  if sId1 = "left" then
    oSquare = oIsoScene.oGrid.getSquareByRowCol(iRow - 1, iCol - 1)
  end if
  iDepth = oSquare.getDepthByLayer(15)
  if not voidp(iXOff) then
    sprite(iSprite).locH = sprite(iSprite).locH + iXOff
  end if
  if not voidp(iYOff) then
    sprite(iSprite).locV = sprite(iSprite).locV + iYOff
  end if
  sprite(iSprite).locV = sprite(iSprite).locV + 0
  me.aTileSprites.add(iSprite)
  me.setPattern(1, 1, iSprite)
end

on destroy me
  oIsoScene.oSpriteManager.returnPooledSprites(me.aTileSprites)
  me.aTileSprites = []
end

on toggleDisplay me
  repeat with i in me.aTileSprites
    sprite(i).visible = not sprite(i).visible
  end repeat
end

on getSpriteUnderPoint me, oLoc
  repeat with i in me.aTileSprites
    if oLoc.inside(sprite(i).rect) then
      return i
    end if
  end repeat
end

on loadPatterns me
  aWallPatterns = [:]
  oPatternMember = member("wallpattern_patterns_index", me.sCastLib)
  if oPatternMember.memberNum = -1 then
    return aWallPatterns
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
    aWallPatterns.addProp(sPatternName, aColors)
  end repeat
  return aWallPatterns
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
  if voidp(iSprite) then
    repeat with i in me.aTileSprites
      me.displayPattern(sPatternName, aColorData, i)
    end repeat
  else
    me.displayPattern(sPatternName, aColorData, iSprite)
  end if
end

on displayPattern me, sPatternName, aColorData, iSprite
  sDir = sendSprite(iSprite, #getId1)
  if sDir = "right" then
    iDir = 2
  else
    iDir = 1
  end if
  sImageBase = sendSprite(iSprite, #getId2)
  sType = sendSprite(iSprite, #getId3)
  case sType of
    "color":
      sMember = sImageBase & "_" & aColorData.dirtStyle & "_b_0_" & iDir & "_0"
      sprite(iSprite).color = aColorData.color
      sprite(iSprite).bgColor = aColorData.bgColor
      sprite(iSprite).blend = aColorData.dirtBlend
    "texture":
      sPaletteMember = sDir & "_wall_" & aColorData.palette
      sprite(iSprite).member.palette = member(sPaletteMember, me.sCastLib)
      sprite(iSprite).blend = aColorData.textureBlend
  end case
end

on setRandomPattern me
  iPatternIndex = random(me.aPatterns.count)
  aColors = me.aPatterns[iPatternIndex]
  iColorIndex = random(aColors.count)
  me.setPattern(iPatternIndex, iColorIndex)
end
