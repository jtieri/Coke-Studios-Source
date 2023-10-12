property ancestor, iLength, iStartTime
global oStudio, oIsoScene, oDenizenManager

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  me.iLength = 5000
  me.iStartTime = the milliSeconds
  me.displayState()
  return me
end

on drinkCoke me
  if voidp(oDenizenManager) then
    return 
  end if
  oAvatar = oIsoScene.oAvatars.getAvatar(oDenizenManager.getScreenName())
  if voidp(oAvatar) then
    return 
  end if
  if oAvatar.isDrinking() then
    return 
  end if
  iCokesDrank = oDenizenManager.getCokesDrank()
  if iCokesDrank >= 10 then
    return 
  end if
  if not voidp(oStudio) then
    oStudio.sendDrinkCoke()
  end if
  me.toggleState()
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
    if oIsoScene.avatarIsInFrontOfItem(me.oItem) then
      me.drinkCoke()
    end if
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
