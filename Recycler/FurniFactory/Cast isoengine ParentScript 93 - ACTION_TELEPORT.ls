property ancestor, bHilite, bDoorOpen, bOn, iLength, iStartTime
global oPossessionStudio, oIsoScene, oStudio

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  me.bHilite = 0
  me.bDoorOpen = 1
  me.bOn = 0
  me.iLength = 3000
  me.iStartTime = the milliSeconds
  me.displayState()
  return me
end

on mouseDownEvent me, bDoubleClick
  return me.select(bDoubleClick)
end

on select me, bDoubleClick
  if bDoubleClick then
    return 0
  end if
  if voidp(oStudio) then
    return 1
  end if
  if oIsoScene.avatarIsInFrontOfItem(me.oItem) then
    oIsoScene.moveAvatar(me.oItem.getSquare())
    return 0
  end if
  oIsoScene.moveAvatarToFrontOfItem(me.oItem)
  return 0
end

on stepFrame me
  if me.oItem.getState() = 0 then
    return 
  end if
  iElapsedTime = the milliSeconds - me.iStartTime
  if iElapsedTime >= me.iLength then
    me.turnOff()
  end if
end

on displayState me
  me.oItem.setFrame(0)
  if me.oItem.getState() = 0 then
    me.oItem.setAnimate(0)
  else
    me.oItem.setAnimate(1)
  end if
  me.oItem.setDrawOrderAttribute("b", #visible, me.bHilite)
  me.oItem.setDrawOrderAttribute("g", #visible, not me.bDoorOpen)
  me.oItem.draw()
end

on turnOn me
  if me.bOn then
    return 
  end if
  me.bOn = 1
  me.showHilite()
  me.closeDoor()
  me.startAnimation()
end

on turnOff me, bDontSendUpdate
  me.bOn = 0
  me.hideHilite()
  me.openDoor()
  me.stopAnimation()
end

on startAnimation me, _bDisplay
  me.startTimer()
end

on stopAnimation me, _bDisplay
  me.stopTimer()
end

on openDoor me, _bDisplay
  me.bDoorOpen = 1
  if _bDisplay then
    me.displayState()
  end if
end

on closeDoor me, _bDisplay
  me.bDoorOpen = 0
  if _bDisplay then
    me.displayState()
  end if
end

on showHilite me, _bDisplay
  me.bHilite = 1
  if _bDisplay then
    me.displayState()
  end if
end

on hideHilite me, _bDisplay
  me.bHilite = 0
  if _bDisplay then
    me.displayState()
  end if
end

on startTimer me
  me.iStartTime = the milliSeconds
  me.oItem.setState(1)
end

on stopTimer me
  me.oItem.setState(0)
end
