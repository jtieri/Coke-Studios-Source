property oItem
global oIsoScene

on new me, _oItem, aAttributes
  me.oItem = _oItem
  me.setAttributes(aAttributes)
  return me
end

on mouseDownEvent me
  return 1
end

on getItem me
  return me.oItem
end

on stepFrame me
end

on displayState me
end

on setAttributes me, aAttributes
end

on use me
end
