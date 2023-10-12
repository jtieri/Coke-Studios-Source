property ancestor, iFireAnimIndex, aFireAnimFrames
global oIsoScene

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop
  me.ancestor = script("FurnitureItem").new(_sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop)
  (the actorList).add(me)
  oIsoScene.oFurniture.addItem(me)
  me.oAction = script("ACTION_" & me.sAction).new(me, me.iState, me.aAttributes)
  me.ancestor.iNumFrames = 3
  me.iFireAnimIndex = 1
  me.aFireAnimFrames = [1, 2]
  return me
end

on setState me, _iState
  me.setDrawOrderAttribute("b", #visible, 1)
  me.setDrawOrderAttribute("d", #visible, 1)
  me.ancestor.setState(_iState)
end

on animate me
  case me.getState() of
    0:
      me.setFrame(me.aFireAnimFrames[0])
    1:
      me.animateFire()
  end case
end

on animateFire me
  me.setDrawOrderAttribute("b", #visible, 1)
  me.setDrawOrderAttribute("d", #visible, 1)
  iNextIndex = me.iFireAnimIndex + 1
  if iNextIndex > me.aFireAnimFrames.count then
    iNextIndex = 1
  end if
  me.iFireAnimIndex = iNextIndex
  me.setFrame(me.aFireAnimFrames[me.iFireAnimIndex])
end
