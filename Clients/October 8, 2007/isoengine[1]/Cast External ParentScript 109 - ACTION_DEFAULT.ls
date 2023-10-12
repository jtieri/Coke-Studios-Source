property oItem
global oIsoScene, gFeatureSet

on new me, _oItem, aAttributes
  me.oItem = _oItem
  me.setAttributes(aAttributes)
  put "set default action script attributes..."
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
  if not gFeatureSet.isEnabled(#FURNITURE_USE) then
    return 
  end if
end
