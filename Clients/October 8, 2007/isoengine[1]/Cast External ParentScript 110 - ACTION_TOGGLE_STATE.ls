property ancestor
global oPossessionStudio

on new me, _oItem, aAttributes
  put "toggle_state aAttributes:" && aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  me.displayState()
  return me
end

on mouseDownEvent me
  me.ancestor.mouseDownEvent()
  if the doubleClick then
    me.toggleState()
  end if
end

on displayState me
  me.oItem.setFrame(me.oItem.getState())
end

on toggleState me
  if me.oItem.getState() = 0 then
    me.oItem.setState(1)
  else
    me.oItem.setState(0)
  end if
  if not voidp(oPossessionStudio) then
    oPossessionStudio.sendUpdatePossession(me.getItem())
  end if
end
