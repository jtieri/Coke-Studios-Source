property ancestor, bDebug
global oIsoScene

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop
  me.bDebug = 1
  me.debug("new()")
  me.setDaysDisplay()
  me.ancestor = script("FurnitureItem").new(_sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop)
  (the actorList).add(me)
  oIsoScene.oFurniture.addItem(me)
  me.oAction = script("ACTION_" & me.sAction).new(me, me.iState, me.aAttributes)
  return me
end

on setDaysDisplay me
  member("PosterStand2_NowShowing").name = "poster_stand_b_0_2_1_2_0"
  member("PosterStand4_NowShowing").name = "poster_stand_b_0_2_1_4_0"
end

on calculateBaseSquare me, sOrder, oSquare
  case sOrder of
    "a", "c":
    "b":
    "d":
  end case
  return oSquare
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "isoengine::TYPE_Date_Poster_Stand::" & sMessage
  end if
end
