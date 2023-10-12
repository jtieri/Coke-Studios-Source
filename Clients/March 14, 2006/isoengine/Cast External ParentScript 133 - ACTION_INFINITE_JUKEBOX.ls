property ancestor
global oPossessionStudio, ElementMgr, oStudio, oIsoScene

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  return me
end

on mouseDownEvent me, bDoubleClick
  me.ancestor.mouseDownEvent()
  return me.select(bDoubleClick)
end

on toggleState me
  oStudio.sendJukeboxRequest()
end

on displayState me
  put "jukebox furni received displaystate"
  me.oItem.setFrame(me.oItem.getState())
end

on select me, bDoubleClick
  oIsoScene.moveAvatarToFrontOfItem(me.oItem)
  if bDoubleClick then
    me.use()
  end if
  return 0
end

on use me
  if oIsoScene.avatarIsInFrontOfItem(me.oItem) then
    oStudio.sendJukeboxRequest()
  end if
end
