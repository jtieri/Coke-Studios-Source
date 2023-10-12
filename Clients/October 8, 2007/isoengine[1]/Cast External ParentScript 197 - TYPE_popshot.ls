property ancestor, aBallAnimFrames, iBallAnimIndex
global oIsoScene

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop
  me.ancestor = script("FurnitureItem").new(_sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop)
  (the actorList).add(me)
  oIsoScene.oFurniture.addItem(me)
  me.oAction = script("ACTION_" & me.sAction).new(me, me.iState, me.aAttributes)
  me.iBallAnimIndex = 1
  me.aBallAnimFrames = [0, 1, 2]
  return me
end

on setState me, _iState
  me.setDrawOrderAttribute("d", #visible, 1)
  me.ancestor.setState(_iState)
end

on animate me
  me.animateBall()
end

on animateBall me
  me.setDrawOrderAttribute("d", #visible, 1)
  iNextIndex = me.iBallAnimIndex + 1
  if iNextIndex > count(aBallAnimFrames) then
    setState(me, 0)
    setFrame(me, 0)
    iBallAnimIndex = 1
  else
    me.iBallAnimIndex = iNextIndex
    me.setFrame(me.aBallAnimFrames[me.iBallAnimIndex])
  end if
end
