property ancestor

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  me.oItem.iState = 1
  me.displayState()
  return me
end

on mouseDownEvent me
  me.ancestor.mouseDownEvent()
end

on displayState me
  me.oItem.setFrame(0)
  me.oItem.setAnimate(1)
end
