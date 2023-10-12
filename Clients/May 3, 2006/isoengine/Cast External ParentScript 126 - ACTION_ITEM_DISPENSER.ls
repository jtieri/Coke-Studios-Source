property ancestor, iLength, iStartTime, bDebug
global oStudio, oIsoScene, oDenizenManager, oPossessionManager

on new me, _oItem, aAttributes
  bDebug = 0
  me.debug("new()")
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  me.iLength = 5000
  me.iStartTime = the milliSeconds
  me.displayState()
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "isoengine::ACTION_ITEM_DISPENSER:" & sMessage
  end if
end

on dispenseItem me
  global gFeatureSet, ElementMgr
  me.debug("dispenseItem()")
  if not gFeatureSet.isEnabled(#ITEM_DISPENSER) then
    ElementMgr.alert("FEATURE_DISABLED")
    return 
  end if
  sScreenName = oDenizenManager.getScreenName()
  if voidp(oDenizenManager) then
    return 
  end if
  oAvatar = oIsoScene.oAvatars.getAvatar(sScreenName)
  if voidp(oAvatar) then
    return 
  end if
  oPossessionManager.dispenseItem(sScreenName)
  me.toggleState()
end

on mouseDownEvent me, bDoubleClick
  me.debug("mouseDownEvent()")
  if voidp(oStudio) then
    return 
  end if
  return me.select(bDoubleClick)
end

on select me, bDoubleClick
  if bDoubleClick then
    me.dispenseItem()
  end if
  return 0
end

on stepFrame me
  if me.oItem.getState() = 0 then
    return 
  end if
  iElapsedTime = the milliSeconds - me.iStartTime
  if iElapsedTime >= me.iLength then
    me.setOff()
  end if
end

on toggleState me
  if me.oItem.getState() = 0 then
    me.setOn()
  else
    me.setOff()
  end if
end

on displayState me
  me.oItem.setFrame(me.oItem.getState())
end

on setOff me
  me.stopTimer()
end

on setOn me
  me.startTimer()
end

on startTimer me
  me.iStartTime = the milliSeconds
  me.oItem.setState(1)
end

on stopTimer me
  me.oItem.setState(0)
end
