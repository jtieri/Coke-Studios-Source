property ancestor
global oIsoScene

on new me, sID, sMember
  me.ancestor = script("IsoSprite").rawNew()
  callAncestor(#new, me, sID, sMember)
  return me
end

on stepFrame me
  oSquare = oIsoScene.oMouseSquare
  if oSquare = VOID then
    me.oSprite.visible = 0
  else
    oNode = oIsoScene.oMap.getNode(oSquare.iCol, oSquare.iRow)
    iW = oNode.w
    if iW = oIsoScene.oMap.oPathfinder.W_BLOCKED then
      me.oSprite.visible = 0
      return 
    end if
    me.moveToRowCol(oSquare.iRow, oSquare.iCol)
  end if
end

on setViewPointOverride me
  nothing()
end

on display me
  callAncestor(#display, me)
end
