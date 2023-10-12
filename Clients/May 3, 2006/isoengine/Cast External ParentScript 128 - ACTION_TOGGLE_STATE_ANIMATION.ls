property ancestor
global oPossessionStudio

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  return me
end

on mouseDownEvent me
  me.ancestor.mouseDownEvent()
  if the doubleClick then
    me.toggleState()
  end if
end

on displayState me
  if me.oItem.getState() = 0 then
    me.oItem.setAnimate(0)
    me.oItem.iFrame = 0
  else
    me.oItem.setAnimate(1)
  end if
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

on stepFrame me
  if me.oItem.getAnimate() then
    if me.oItem.getFrame() = 4 then
      me.oItem.iFrame = 0
    end if
  end if
end
