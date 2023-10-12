property ancestor, bHilite, bDoorOpen, bOn, iLength, iStartTime, lFrames, iFrameIndex
global oPossessionStudio, oIsoScene, oStudio, oDenizenManager

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  me.bHilite = 0
  me.bDoorOpen = 1
  me.bOn = 0
  me.lFrames = [1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 1, 0]
  me.displayState()
  return me
end

on mouseDownEvent me, bDoubleClick
  return me.select(bDoubleClick)
end

on select me, bDoubleClick
  global gFeatureSet, ElementMgr
  if bDoubleClick then
    if voidp(oStudio) then
      return 1
    end if
    if oIsoScene.avatarIsInFrontOfItem(me.oItem) then
      if not gFeatureSet.isEnabled(#TELEPORTING) then
        ElementMgr.alert("FEATURE_DISABLED")
        return 
      end if
      put "moving to the front of the item"
      oIsoScene.moveAvatar(me.oItem.getSquare())
      return 0
    end if
    oIsoScene.moveAvatarToFrontOfItem(me.oItem)
  end if
  return 0
end

on stepFrame me
  if (me.oItem.getState() = 0) or (count(me.oItem.aAssets) = 1) then
    me.oItem.setFrame(0)
  else
    if (the timer mod 5) = 0 then
      if iFrameIndex < count(lFrames) then
        put "animatingÉ"
        iFrameIndex = iFrameIndex + 1
        myframe = lFrames[iFrameIndex]
        me.oItem.setFrame(myframe)
      else
        iFrameIndex = 1
        me.oItem.setState(0)
        me.oItem.setFrame(0)
      end if
    end if
  end if
end

on displayState me
  me.oItem.draw()
end

on turnOn me
  if me.bOn then
    return 
  end if
  me.bOn = 1
  me.showHilite()
  me.closeDoor()
  me.oItem.setState(1)
  oAvatarSquare = oIsoScene.oAvatars.getAvatar(oDenizenManager.getScreenName()).getSquare()
  mysquare = oIsoScene.getSquareInFrontOfItem(me.oItem)
  oAvatarlist = oIsoScene.oAvatars.getItemsAtSquare(mysquare)
  if count(oAvatarlist) then
    oAvatar = oAvatarlist[1]
    sAvatarName = oAvatar.getScreenName()
  else
    put "no avatar on that square"
  end if
  if voidp(oAvatar) = 0 then
    oIsoScene.oAvatars.removeItem(oAvatar)
  end if
end

on turnOff me, bDontSendUpdate
  me.bOn = 0
  me.hideHilite()
  me.openDoor()
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
