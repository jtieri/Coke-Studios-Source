property ancestor
global oPossessionStudio

on new me, _oItem, aAttributes
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
  me.oItem.setAnimate(1)
end

on toggleState me
  if me.oItem.getState() = 5 then
    me.oItem.setState(0)
  else
    me.oItem.setState(me.oItem.getState() + 1)
  end if
  if not voidp(oPossessionStudio) then
    oPossessionStudio.sendUpdatePossession(me.getItem())
  end if
end
