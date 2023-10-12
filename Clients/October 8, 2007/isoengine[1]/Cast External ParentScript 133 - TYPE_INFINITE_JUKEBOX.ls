property ancestor
global oIsoScene

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop
  me.ancestor = script("FurnitureItem").new(_sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop)
  (the actorList).add(me)
  oIsoScene.oFurniture.addItem(me)
  me.oAction = script("ACTION_" & me.sAction).new(me, me.iState, me.aAttributes)
  return me
end

on setState me, _iState
  put "jukebox furni received setstate=" & _iState
  me.ancestor.setState(_iState)
end

on animate me
  put "jukebox furni received animate"
  case me.getState() of
    0:
      me.setFrame(0)
    1:
      me.setFrame(1)
  end case
end

on equals me, _oItem
  if voidp(_oItem) then
    return 0
  end if
  if ancestor.sPosId = _oItem.sPosId then
    return 1
  else
    return 0
  end if
end
