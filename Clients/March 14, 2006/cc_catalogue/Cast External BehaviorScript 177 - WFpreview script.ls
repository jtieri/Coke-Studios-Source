property iWallPatternIndex, iWallColorIndex, iFloorPatternIndex, iFloorColorIndex, aWallPatterns, aFloorPatterns, sAssetCast

on new me
  me.iFloorPatternIndex = 1
  me.iFloorColorIndex = 1
  me.iWallPatternIndex = 1
  me.iWallColorIndex = 1
  me.sAssetCast = "Catalogue"
  me.aWallPatterns = me.loadwallPatterns()
  me.aFloorPatterns = me.loadfloorPatterns()
  me.displayPattern()
  return me
end

on loadwallPatterns me
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

on loadfloorPatterns me
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

on scrollwallPattern me, iDir
  iNewPatternIndex = me.iWallPatternIndex + iDir
  if iNewPatternIndex < 1 then
    iNewPatternIndex = me.aWallPatterns.count
  end if
  if iNewPatternIndex > me.aWallPatterns.count then
    iNewPatternIndex = 1
  end if
  me.iWallPatternIndex = iNewPatternIndex
  me.iWallColorIndex = 1
  me.displayPattern()
end

on scrollwallColor me, iDir
  aColors = me.aWallPatterns[me.iWallPatternIndex]
  iNewColorIndex = me.iWallColorIndex + iDir
  if iNewColorIndex < 1 then
    iNewColorIndex = aColors.count
  end if
  if iNewColorIndex > aColors.count then
    iNewColorIndex = 1
  end if
  me.iWallColorIndex = iNewColorIndex
  me.displayPattern()
end

on scrollFloorPattern me, iDir
  iNewPatternIndex = me.iFloorPatternIndex + iDir
  if iNewPatternIndex < 1 then
    iNewPatternIndex = me.aFloorPatterns.count
  end if
  if iNewPatternIndex > me.aFloorPatterns.count then
    iNewPatternIndex = 1
  end if
  me.iFloorPatternIndex = iNewPatternIndex
  me.iFloorColorIndex = 1
  me.displayPattern()
end

on scrollFloorColor me, iDir
  aColors = me.aFloorPatterns[me.iFloorPatternIndex]
  iNewColorIndex = me.iFloorColorIndex + iDir
  if iNewColorIndex < 1 then
    iNewColorIndex = aColors.count
  end if
  if iNewColorIndex > aColors.count then
    iNewColorIndex = 1
  end if
  me.iFloorColorIndex = iNewColorIndex
  me.displayPattern()
end

on displayPattern me
  global TextMgr
  myimg = image(105, 105, 32)
  if voidp(iWallPatternIndex) then
    iWallPatternIndex = 1
  end if
  swallPatternName = me.aWallPatterns.getPropAt(me.iWallPatternIndex)
  member("cc.cat.wall.type").text = TextMgr.GetRefText(swallPatternName) & ": " & string(me.iWallColorIndex)
  aColorData = me.aWallPatterns[me.iWallPatternIndex][me.iWallColorIndex]
  if aColorData.dirtStyle = 1 then
    LeftWall = member("cat_left_wall_1_b_0_0_0", me.sAssetCast).image.duplicate()
    RightWall = member("cat_right_wall_1_b_0_0_0", me.sAssetCast).image.duplicate()
  else
    if aColorData.dirtStyle = 2 then
      LeftWall = member("cat_left_wall_2_b_0_0_0", me.sAssetCast).image.duplicate()
      RightWall = member("cat_right_wall_2_b_0_0_0", me.sAssetCast).image.duplicate()
    end if
  end if
  LeftWallcolor = aColorData.color
  RightWallcolor = aColorData.color
  LeftWallbgcolor = aColorData.bgColor
  RightWallbgcolor = aColorData.bgColor
  LeftWallblend = aColorData.dirtBlend
  RightWallblend = aColorData.dirtBlend
  member("cat_left_wall_1_a_0_0_0").palette = member("cat_left_wall_" & aColorData.palette, me.sAssetCast)
  member("cat_right_wall_1_a_0_0_0").palette = member("cat_right_wall_" & aColorData.palette, me.sAssetCast)
  LeftWallTextureblend = aColorData.textureBlend
  RightWallTextureblend = aColorData.textureBlend
  sFloorPatternName = me.aFloorPatterns.getPropAt(me.iFloorPatternIndex)
  member("cc.cat.floor.type").text = TextMgr.GetRefText(sFloorPatternName) & ": " & string(me.iFloorColorIndex)
  aColorData = me.aFloorPatterns[me.iFloorPatternIndex][me.iFloorColorIndex]
  member("floor_shape_preview").fillColor = aColorData.startcolor
  member("floor_shape_preview").endColor = aColorData.endColor
  FloorShapeblend = aColorData.shapeBlend
  member("studiofloor_1_preview").palette = member("cat_floor_" & aColorData.palette, me.sAssetCast)
  FloorShapecolor = aColorData.texturecolor
  FloorTextureblend = aColorData.textureBlend
  leftwallmatte = LeftWall.createMatte()
  rightwallmatte = RightWall.createMatte()
  roomprevwall = member("cat.roomprev.wall").image.duplicate()
  myimg.copyPixels(roomprevwall, roomprevwall.rect, roomprevwall.rect)
  roomprevfloor = member("cat.roomprev.floor").image.duplicate()
  floormatte = roomprevfloor.createMatte()
  myimg.copyPixels(roomprevfloor, roomprevfloor.rect + rect(0, 61, 0, 61), roomprevfloor.rect, [#ink: 8, #maskImage: floormatte])
  floorshape = member("floor_shape_preview").image.duplicate()
  shapematte = roomprevfloor.createMask()
  myimg.copyPixels(floorshape, floorshape.rect + rect(0, 61, 0, 61), floorshape.rect, [#ink: 5, #color: rgb(0, 0, 0), #bgColor: FloorShapecolor, #blend: FloorShapeblend, #maskImage: floormatte])
  floortexture = member("studiofloor_1_preview").image.duplicate()
  myimg.copyPixels(floortexture, floortexture.rect + rect(0, 61, 0, 61), floortexture.rect, [#blend: FloorTextureblend, #maskImage: floormatte])
  myimg.copyPixels(LeftWall, LeftWall.rect, LeftWall.rect, [#color: LeftWallcolor, #bgColor: LeftWallbgcolor, #blend: LeftWallblend, #ink: 8, #maskImage: leftwallmatte])
  myimg.copyPixels(RightWall, RightWall.rect + rect(50, 0, 50, 0), RightWall.rect, [#color: RightWallcolor, #bgColor: RightWallbgcolor, #blend: RightWallblend, #ink: 8, #maskImage: rightwallmatte])
  leftwalltexture = member("cat_left_wall_1_a_0_0_0").image.duplicate()
  rightwalltexture = member("cat_right_wall_1_a_0_0_0").image.duplicate()
  myimg.copyPixels(leftwalltexture, leftwalltexture.rect, leftwalltexture.rect, [#blend: LeftWallTextureblend, #ink: 8, #maskImage: leftwallmatte])
  myimg.copyPixels(rightwalltexture, rightwalltexture.rect + rect(50, 0, 50, 0), rightwalltexture.rect, [#blend: RightWallTextureblend, #ink: 8, #maskImage: rightwallmatte])
  member("WFprev").image = myimg
  member("WFprev").regPoint = point(0, 0)
end

on getwallpatternindex me
  return iWallPatternIndex
end

on getwallcolorindex me
  return iWallColorIndex
end

on getfloorpatternindex me
  return iFloorPatternIndex
end

on getfloorcolorindex me
  return iFloorColorIndex
end
