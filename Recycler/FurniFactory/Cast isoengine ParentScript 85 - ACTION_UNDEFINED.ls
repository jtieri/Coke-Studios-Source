property ancestor
global oIsoScene, oPossessionStudio

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  return me
end

on mouseDownEvent me
  return me.ancestor.mouseDownEvent()
end

on use me
end
