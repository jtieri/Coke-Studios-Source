property ancestor

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_TOGGLE_STATE").new(_oItem, aAttributes)
  me.displayState()
  return me
end

on mouseDownEvent me
  me.ancestor.mouseDownEvent()
end
