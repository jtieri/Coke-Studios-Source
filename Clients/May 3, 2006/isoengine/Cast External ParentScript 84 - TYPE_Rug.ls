property ancestor
global oIsoScene, oSession, oStudio, oPossessionStudio, gFeatureSet

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop
  me.ancestor = script("FurnitureItem").new(_sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop)
  (the actorList).add(me)
  if voidp(_iGridY) or (_iGridY < oIsoScene.oRugs.iDepthLow) then
    me.iGridY = oIsoScene.oRugs.getNextHighestDepth()
  end if
  oIsoScene.oRugs.addItem(me)
  me.oAction = script("ACTION_" & me.sAction).new(me, me.iState, me.aAttributes)
  return me
end

on setGridY me, _iGridY
  me.iGridY = _iGridY
  me.draw()
end

on sendPutInStudio me
  if not me.equals(oIsoScene.oSelectedItem) then
    return 
  end if
  oIsoScene.oRugs.shiftItem(me)
  aDirtyItems = oIsoScene.oRugs.setDepthsByPos()
  oIsoScene.oRugs.sortItemsByDepth()
  oIsoScene.oRugs.drawAll()
  if not voidp(oSession) and not voidp(oPossessionStudio) then
    oPossessionStudio.sendPutInStudio(me)
    repeat with oDirtyItem in aDirtyItems
      if not oDirtyItem.equals(me) then
        oPossessionStudio.sendPutInStudio(oDirtyItem)
      end if
    end repeat
  end if
end

on putInBackPack me
  if not gFeatureSet.isEnabled(#FURNITURE_PICKUP) then
    return 
  end if
  oIsoScene.deleteSelectedItem()
  aDirtyItems = oIsoScene.oRugs.setDepthsByPos()
  oIsoScene.oRugs.sortItemsByDepth()
  oIsoScene.oRugs.drawAll()
  if not voidp(oSession) then
    if not oSession.bTestMode and not voidp(oPossessionStudio) then
      oPossessionStudio.sendPutInBackpack(me)
      repeat with oDirtyItem in aDirtyItems
        if not oDirtyItem.equals(me) then
          oPossessionStudio.sendPutInStudio(oDirtyItem)
        end if
      end repeat
    end if
  end if
end

on deleteItem me
  oIsoScene.oRugs.removeItem(me)
end
