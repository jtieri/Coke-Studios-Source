property ancestor
global ElementMgr, TextMgr, oIsoScene, gFeatureSet, oStudio, oDenizenManager

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
  if not gFeatureSet.isEnabled(#MIXER) then
    ElementMgr.alert("FEATURE_DISABLED")
    return 
  end if
  if oStudio.isOwner(oDenizenManager.getScreenName()) or oDenizenManager.isMod() then
    ElementMgr.openmixer()
  else
    ElementMgr.alert("MIXER_NOT_OWNER")
  end if
end

on use me
  if not gFeatureSet.isEnabled(#FURNITURE_USE) then
    return 
  end if
  if oIsoScene.avatarIsInFrontOfItem(me.oItem) then
    me.openmixer()
  end if
end
