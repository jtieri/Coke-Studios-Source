property aSprites, iRow, iCol, oSquare
global oIsoScene, oStudioMap

on new me
  me.aSprites = []
  return me
end

on init me, oXml
  if voidp(oXml) then
    return 
  end if
  me.iRow = integer(oXml.attributes.row)
  me.iCol = integer(oXml.attributes.col)
  sImageBase = oXml.attributes.imageBase
  sImageBase = oStudioMap.getWindowName()
  me.drawWindow(sImageBase)
end

on drawWindow me, sImageBase
  me.destroy()
  me.oSquare = oIsoScene.oGrid.getSquareByRowCol(me.iRow, me.iCol)
  oLoc = me.oSquare.oViewPoints.bl
  sImageBase = "studio.window." & sImageBase & "."
  aProps = [#x: oLoc.locH, #y: oLoc.locV, #ink: 8]
  aProps[#member] = sImageBase & "1"
  iSprite1 = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
  me.aSprites.add(iSprite1)
  aProps[#member] = sImageBase & "2"
  iSprite2 = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
  me.aSprites.add(iSprite2)
  aProps[#member] = sImageBase & "3"
  iSprite3 = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
  me.aSprites.add(iSprite3)
end

on setDepth me
  repeat with i = 1 to me.aSprites.count
    iSprite = me.aSprites[i]
    _oSquare = oIsoScene.oGrid.getSquareByRowCol(me.iRow - 1 + 4 - (i - 1), me.iCol - 1 + 2)
    iDepth = _oSquare.getDepthByLayer(19)
    sprite(iSprite).locZ = iDepth
  end repeat
end

on getDepthTestSprite me, iTestSprite
  oTestPoint = me.getDepthTestPoint(iTestSprite)
  iDepthSprite = oIsoScene.oWall.getSpriteUnderPoint(oTestPoint)
  return iDepthSprite
end

on getDepthTestPoint me, iTestSprite
  iTestX = sprite(iTestSprite).right
  iTestY = sprite(iTestSprite).top + (sprite(iTestSprite).height / 2)
  return point(iTestX, iTestY)
end

on destroy me
  oIsoScene.oSpriteManager.returnPooledSprites(me.aSprites)
  me.aSprites = []
end

on toggleDisplay me
  repeat with i in me.aSprites
    sprite(i).visible = not sprite(i).visible
  end repeat
end
