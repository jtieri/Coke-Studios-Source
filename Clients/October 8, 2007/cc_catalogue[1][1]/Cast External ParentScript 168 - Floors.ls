property iPatternIndex, iColorIndex, aPatterns, sAssetCast, iFloorShapeSprite, iFloorTextureSprite

on new me
  me.iPatternIndex = 1
  me.iColorIndex = 1
  me.sAssetCast = "Catalogue"
  me.aPatterns = me.loadPatterns()
  updateStage()
  me.iFloorShapeSprite = sendAllSprites(#getFloorShapeSprite)
  me.iFloorTextureSprite = sendAllSprites(#getFloorTextureSprite)
  me.displayPattern()
  return me
end

on loadPatterns me
  aFloorPatterns = [:]
  oPatternMember = member("cat_floorpattern_patterns_index", me.sAssetCast)
  sPatternText = oPatternMember.text
  repeat with i = 1 to sPatternText.lines.count
    sPatternLine = sPatternText.line[i]
    aPatternList = value(sPatternLine)
    sPatternName = aPatternList.name
    sColorField = aPatternList.field
    aColors = []
    oColorsMember = member(sColorField, me.sAssetCast)
    sColorsText = oColorsMember.text
    repeat with ii = 1 to sColorsText.lines.count
      sColorLine = sColorsText.line[ii]
      aColorsList = value(sColorLine)
      aColors.add(aColorsList)
    end repeat
    aFloorPatterns.addProp(sPatternName, aColors)
  end repeat
  return aFloorPatterns
end

on scrollPattern me, iDir
  iNewPatternIndex = me.iPatternIndex + iDir
  if iNewPatternIndex < 1 then
    iNewPatternIndex = me.aPatterns.count
  end if
  if iNewPatternIndex > me.aPatterns.count then
    iNewPatternIndex = 1
  end if
  me.iPatternIndex = iNewPatternIndex
  me.iColorIndex = 1
  me.displayPattern()
end

on scrollColor me, iDir
  aColors = me.aPatterns[me.iPatternIndex]
  iNewColorIndex = me.iColorIndex + iDir
  if iNewColorIndex < 1 then
    iNewColorIndex = aColors.count
  end if
  if iNewColorIndex > aColors.count then
    iNewColorIndex = 1
  end if
  me.iColorIndex = iNewColorIndex
  me.displayPattern()
end

on displayPattern me
  global TextMgr
  sPatternName = me.aPatterns.getPropAt(me.iPatternIndex)
  member("cc.cat.floor.type").text = TextMgr.GetRefText(sPatternName) & ": " & string(me.iColorIndex)
  aColorData = me.aPatterns[me.iPatternIndex][me.iColorIndex]
  sprite(me.iFloorShapeSprite).member.fillColor = aColorData.startcolor
  sprite(me.iFloorShapeSprite).member.endColor = aColorData.endColor
  sprite(me.iFloorShapeSprite).blend = aColorData.shapeBlend
  sprite(me.iFloorShapeSprite).member.regPoint = point(0, 0)
  sprite(me.iFloorTextureSprite).member.palette = member("cat_floor_" & aColorData.palette, me.sAssetCast)
  sprite(me.iFloorShapeSprite).color = aColorData.texturecolor
  sprite(me.iFloorTextureSprite).blend = aColorData.textureBlend
end
