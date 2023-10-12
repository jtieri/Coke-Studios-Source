property ancestor

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_TOP_40_CHART").new(_oItem, aAttributes)
  return me
end

on mouseDownEvent me
  me.ancestor.mouseDownEvent()
  if the doubleClick then
    me.ancestor.launchChart()
  end if
end
