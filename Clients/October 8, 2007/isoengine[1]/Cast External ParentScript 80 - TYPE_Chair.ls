property ancestor
global oIsoScene

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop
  me.ancestor = script("FurnitureItem").new(_sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop)
  (the actorList).add(me)
  oIsoScene.oFurniture.addItem(me)
  me.oAction = script("ACTION_" & me.sAction).new(me, me.iState, me.aAttributes)
  me.bSeatable = 1
  return me
end

on calculateLayerMap me, sOrder
  sLayerMap = sOrder
  case sOrder of
    "a":
    "b":
      if (me.iDirection = 2) or (me.iDirection = 4) then
        sLayerMap = "a"
      end if
    "c":
      sLayerMap = "a"
    "d":
      sLayerMap = "b"
  end case
  return sLayerMap
end