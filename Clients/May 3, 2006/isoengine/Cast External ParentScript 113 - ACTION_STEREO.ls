property ancestor
global oIsoScene, oPossessionStudio, ElementMgr, oStudio, oDenizenManager

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  me.displayState()
  return me
end

on mouseDownEvent me, bDoubleClick
  if voidp(oStudio) then
    return 
  end if
  return me.select(bDoubleClick)
end

on select me, bDoubleClick
  put "*** SELECT STEREO: DOUBLE CLICK: " & bDoubleClick, " *** "
  oIsoScene.moveAvatarToFrontOfItem(me.oItem)
  if bDoubleClick then
    if oIsoScene.avatarIsInFrontOfItem(me.oItem) then
      me.doubleClickStereo()
    end if
  end if
  return 0
end

on doubleClickStereo me
  global gFeatureSet
  if voidp(oStudio) then
    return 
  end if
  if not gFeatureSet.isEnabled(#CDPLAYER) then
    ElementMgr.alert("FEATURE_DISABLED")
    return 
  end if
  oBackPack = oDenizenManager.getBackpack()
  if not voidp(oBackPack) then
    iBurnedCds = oDenizenManager.getBackpack().getNumberOfBurnedCds()
    if voidp(iBurnedCds) or (iBurnedCds = 0) then
      ElementMgr.alert("NOCD_TITLE", "NOCD_DESC")
      return 
    end if
  end if
  bLocked = oStudio.getcdplayer().isLocked() = 1
  sCdPlayerAvatar = oStudio.getcdplayer().getAvatar()
  bIsMe = sCdPlayerAvatar = oDenizenManager.getScreenName()
  if bLocked then
    if not bIsMe then
      oStudio.receiveCdWaitTurn()
    else
      oStudio.sendCdStop()
    end if
  else
    oStudio.sendCdRequest(me.oItem.getPosId())
  end if
end

on displayState me
  me.oItem.setFrame(0)
  if me.oItem.getState() = 0 then
    me.oItem.setAnimate(0)
  else
    me.oItem.setAnimate(1)
  end if
end

on toggleState me
  if me.oItem.getState() = 0 then
    me.setOn()
  else
    me.setOff()
  end if
  oPossessionStudio.sendUpdatePossession(me.getItem())
end

on setOff me
  me.oItem.setState(0)
end

on setOn me
  me.oItem.setState(1)
end
