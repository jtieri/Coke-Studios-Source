property ancestor
global oIsoScene, ElementMgr

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop
  me.ancestor = script("FurnitureItem").new(_sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop)
  (the actorList).add(me)
  oIsoScene.oFurniture.addItem(me)
  me.oAction = script("ACTION_" & me.sAction).new(me, me.iState, me.aAttributes)
  return me
end

on displayWallReplace me
  iPosId = me.getPosId()
  iFloorTexture = 1
  iFloorColor = 1
  iWallTexture = me.aAttributes[#texture]
  iWallColor = me.aAttributes[#color]
  if not voidp(ElementMgr) then
    ElementMgr.displayWallReplace(iPosId, iWallTexture, iWallColor, iFloorTexture, iFloorColor)
  end if
end
