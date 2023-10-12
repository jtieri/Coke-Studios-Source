property iSprite, iRow, iCol, iDepth
global oIsoScene, ElementMgr, oStudioMap

on new me
  me.iSprite = VOID
  return me
end

on stepFrame me
  me.updatePosition(oIsoScene.oMouseSquare)
end

on updatePosition me, oSquare
  if voidp(me.iSprite) then
    return 
  end if
  bRollover = 0
  if not voidp(oSquare) then
    bRollover = me.canDisplaySquare(oSquare)
  end if
  if voidp(oSquare) then
    me.hide()
    return 
  end if
  if (oSquare.iRow <> me.iRow) or (oSquare.iCol <> me.iCol) then
    if bRollover then
      me.show(oSquare)
    else
      me.hide()
    end if
    me.iRow = oSquare.iRow
    me.iCol = oSquare.iCol
  end if
end

on dragFurniPreview me
  if not voidp(oIsoScene.oSelectedItem) then
    if oIsoScene.oSelectedItem.isFurniItem() then
      if oIsoScene.oSelectedItem.getDrag() then
        oIsoScene.oSelectedItem.updatePreview()
      end if
    end if
  end if
end

on show me, oSquare
  sprite(me.iSprite).locH = oSquare.oViewPoints.bl.locH
  sprite(me.iSprite).locV = oSquare.oViewPoints.bl.locV
  sprite(me.iSprite).locZ = me.iDepth
  if oStudioMap.isPrivate() then
    if oSquare.equals(oIsoScene.oDoor.oSquare) then
      sprite(me.iSprite).locZ = oIsoScene.oDoor.getLowestZ() - 2
    end if
  end if
  sprite(me.iSprite).visible = 1
end

on hide me
  sprite(me.iSprite).visible = 0
end

on canDisplaySquare me, oSquare
  oMapNode = oIsoScene.oMap.getNode(oSquare.iRow, oSquare.iCol)
  if voidp(oMapNode) then
    return 0
  end if
  iWeight = oMapNode.w
  if iWeight = oIsoScene.oMap.oPathfinder.W_BLOCKED then
    return 0
  else
    return 1
  end if
end

on init me, oXml
  if voidp(oXml) then
    return 
  end if
  aProps = oIsoScene.oSpriteManager.buildSpriteProps(oXml)
  me.drawHiliter(aProps)
  (the actorList).add(me)
end

on drawHiliter me, aProps
  me.destroy()
  me.iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
  me.iDepth = sprite(me.iSprite).locZ
end

on destroy me
  oIsoScene.oSpriteManager.returnPooledSprite(me.iSprite)
  me.iSprite = VOID
  (the actorList).deleteOne(me)
end

on toggleDisplay me
  if not voidp(me.iSprite) then
    sprite(me.iSprite).visible = not sprite(me.iSprite).visible
  end if
end
