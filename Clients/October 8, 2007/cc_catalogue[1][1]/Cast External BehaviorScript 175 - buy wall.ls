on new me
  return me
end

on mouseUp me
  global gFeatureSet, ElementMgr, oPossessionManager, oDenizenManager, gWalls
  if not gFeatureSet.isEnabled(#PURCHASING) then
    ElementMgr.alert("FEATURE_DISABLED")
    return 
  end if
  wallpattern = sendAllSprites(#getwallpatternindex)
  wallcolor = sendAllSprites(#getwallcolorindex)
  myAttributes = [#texture: wallpattern, #color: wallcolor]
  myscreenname = oDenizenManager.getScreenName()
  oPossessionManager.prePurchaseItem(myscreenname, 1, myAttributes)
  dontPassEvent()
end
