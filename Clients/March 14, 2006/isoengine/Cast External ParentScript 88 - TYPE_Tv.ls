property ancestor, aSineAnimFrames, iSineAnimIndex, iFlickerAnimFrame, aFlickerStates
global oIsoScene

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop
  me.ancestor = script("FurnitureItem").new(_sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop)
  (the actorList).add(me)
  oIsoScene.oFurniture.addItem(me)
  me.oAction = script("ACTION_" & me.sAction).new(me, me.iState, me.aAttributes)
  me.aSineAnimFrames = [1, 2, 3, 4]
  me.iSineAnimIndex = 1
  me.iFlickerAnimFrame = 8
  me.aFlickerStates = [1, 1, 1, 0, 0, 0]
  return me
end

on setState me, _iState
  me.setDrawOrderAttribute("b", #visible, 1)
  me.ancestor.setState(_iState)
end

on animate me
  case me.getState() of
    0:
    1:
      me.animateSine()
    2:
      me.animateFlicker()
  end case
end

on animateSine me
  me.setDrawOrderAttribute("b", #visible, 1)
  iNextIndex = me.iSineAnimIndex + 1
  if iNextIndex > me.aSineAnimFrames.count then
    iNextIndex = 1
  end if
  me.iSineAnimIndex = iNextIndex
  me.setFrame(me.aSineAnimFrames[me.iSineAnimIndex])
end

on animateFlicker me
  bState = me.aFlickerStates[random(me.aFlickerStates.count)]
  me.setDrawOrderAttribute("b", #visible, bState)
  me.setFrame(me.iFlickerAnimFrame)
end
