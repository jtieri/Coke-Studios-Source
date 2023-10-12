property ancestor
global oIsoScene

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop
  put "new Teleport()"
  me.ancestor = script("FurnitureItem").new(_sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop)
  put "ancestor set..."
  (the actorList).add(me)
  put "added me to the actorlist..."
  oIsoScene.oFurniture.addItem(me)
  put "added me to the list of furniture..."
  me.oAction = script("ACTION_" & me.sAction).new(me, me.iState, me.aAttributes)
  put "instanciated action script"
  return me
end

on calculateLayerMap me, sOrder
  sLayerMap = sOrder
  case sOrder of
    "c", "b", "d":
      sLayerMap = "a"
  end case
  return sLayerMap
end
