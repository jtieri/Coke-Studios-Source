property ancestor
global ElementMgr, TextMgr, oIsoScene, oStudio, oDenizenManager

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  return me
end

on mouseDownEvent me, bDoubleClick
  if voidp(oStudio) then
    return 
  end if
  return me.select(bDoubleClick)
end

on select me, bDoubleClick
  oIsoScene.moveAvatarToFrontOfItem(me.oItem)
  if bDoubleClick then
    me.use()
  end if
  return 0
end

on openmixer me
  if oStudio.isOwner(oDenizenManager.getScreenName()) or oDenizenManager.isMod() then
    ElementMgr.openmixer()
  else
    ElementMgr.alert("MIXER_NOT_OWNER")
  end if
end

on use me
  if oIsoScene.avatarIsInFrontOfItem(me.oItem) then
    me.openmixer()
  end if
end
