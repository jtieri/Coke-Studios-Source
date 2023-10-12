property ancestor

on new me, _oItem, aAttributes
  put "new GoldRecord action"
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  return me
end

on mouseDownEvent me
  put "GoldRecord mouseDown() doubleClick: " & the doubleClick
  if the doubleClick then
    me.launchChart()
  end if
end

on launchChart me, iDate
  global gFeatureSet
  put "launchChart()"
  if not gFeatureSet.isEnabled(#CHARTS) then
    put "CHARTS NOT ENABLED"
    return 
  end if
  gotoNetPage("/sf/charts/chart.jsp", "Top40Chart")
end
