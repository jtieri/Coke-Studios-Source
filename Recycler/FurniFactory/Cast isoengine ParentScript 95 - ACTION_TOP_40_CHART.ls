property ancestor

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  return me
end

on mouseDownEvent me
  me.ancestor.mouseDownEvent()
  if the doubleClick then
    me.launchChart()
  end if
end

on launchChart me, iDate
  gotoNetPage("http://www.cokemusic.com", "Top40Chart")
end
