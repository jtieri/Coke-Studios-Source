property iPatternIndex, iColorIndex, aPatterns, sAssetCast, iLeftWallSprite, iRightWallSprite, iLeftWallTextureSprite, iRightWallTextureSprite, iWallBackgroundsprite

on new me
  me.iPatternIndex = 1
  me.iColorIndex = 1
  me.sAssetCast = "Catalogue"
  updateStage()
  me.iLeftWallSprite = sendAllSprites(#getLeftWallSprite)
  me.iRightWallSprite = sendAllSprites(#getRightWallSprite)
  me.iLeftWallTextureSprite = sendAllSprites(#getLeftWallTextureSprite)
  me.iRightWallTextureSprite = sendAllSprites(#getRightWallTextureSprite)
  me.iWallBackgroundsprite = sendAllSprites(#getWallBackgroundSprite)
  me.aPatterns = me.loadPatterns()
  me.displayPattern()
  return me
end

on loadPatterns me
  aWallPatterns = [:]
  oPatternMember = member("cat_wallpattern_patterns_index", me.sAssetCast)
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
    aWallPatterns.addProp(sPatternName, aColors)
  end repeat
  return aWallPatterns
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
  aColorData = me.aPatterns[me.iPatternIndex][me.iColorIndex]
  if aColorData.dirtStyle = 1 then
    sprite(me.iLeftWallSprite).member = member("cat_left_wall_1_b_0_0_0", me.sAssetCast)
    sprite(me.iRightWallSprite).member = member("cat_right_wall_1_b_0_0_0", me.sAssetCast)
  end if
  if aColorData.dirtStyle = 2 then
    sprite(me.iLeftWallSprite).member = member("cat_left_wall_2_b_0_0_0", me.sAssetCast)
    sprite(me.iRightWallSprite).member = member("cat_right_wall_2_b_0_0_0", me.sAssetCast)
  end if
  sprite(me.iLeftWallSprite).color = aColorData.color
  sprite(me.iRightWallSprite).color = aColorData.color
  sprite(me.iLeftWallSprite).bgColor = aColorData.bgColor
  sprite(me.iRightWallSprite).bgColor = aColorData.bgColor
  sprite(me.iLeftWallSprite).blend = aColorData.dirtBlend
  sprite(me.iRightWallSprite).blend = aColorData.dirtBlend
  sprite(me.iLeftWallTextureSprite).member.palette = member("cat_left_wall_" & aColorData.palette, me.sAssetCast)
  sprite(me.iRightWallTextureSprite).member.palette = member("cat_right_wall_" & aColorData.palette, me.sAssetCast)
  sprite(me.iLeftWallTextureSprite).blend = aColorData.textureBlend
  sprite(me.iRightWallTextureSprite).blend = aColorData.textureBlend
end
