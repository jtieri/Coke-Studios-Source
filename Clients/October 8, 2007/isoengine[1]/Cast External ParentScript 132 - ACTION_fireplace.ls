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
  case me.oItem.getState() of
    0:
      me.oItem.setAnimate(0)
    1:
      me.oItem.setAnimate(1)
  end case
  me.oItem.setFrame(0)
end

on toggleState me
  case me.oItem.getState() of
    0:
      me.oItem.setState(1)
    1:
      me.oItem.setState(0)
  end case
  if not voidp(oPossessionStudio) then
    oPossessionStudio.sendUpdatePossession(me.getItem())
  end if
end
