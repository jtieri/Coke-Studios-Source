property ancestor
global oIsoScene

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iZ, _iX, _iY, _iDir, _iHeightOffset, bItemsAllowedOnTop
  put "new Poster():_sAction: " && _sAction && "_iState: " && "_aAttributes" && _aAttributes
  me.ancestor = script("WallItem").new(_sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iZ, _iX, _iY, _iDir, _iHeightOffset, bItemsAllowedOnTop)
  (the actorList).add(me)
  oIsoScene.oWallItems.addItem(me)
  me.oAction = script("ACTION_" & me.sAction).new(me, me.iState, me.aAttributes)
  return me
end
