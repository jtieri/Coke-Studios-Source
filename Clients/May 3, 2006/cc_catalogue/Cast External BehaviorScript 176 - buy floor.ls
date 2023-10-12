on new me
  return me
end

on mouseUp me
  global gFeatureSet, ElementMgr, oPossessionManager, oDenizenManager, gFloors
  if not gFeatureSet.isEnabled(#PURCHASING) then
    ElementMgr.alert("FEATURE_DISABLED")
    return 
  end if
  floorpattern = sendAllSprites(#getfloorpatternindex)
  floorcolor = sendAllSprites(#getfloorcolorindex)
  myAttributes = [#texture: floorpattern, #color: floorcolor]
  myscreenname = oDenizenManager.getScreenName()
  oPossessionManager.prePurchaseItem(myscreenname, 2, myAttributes)
  dontPassEvent()
end
