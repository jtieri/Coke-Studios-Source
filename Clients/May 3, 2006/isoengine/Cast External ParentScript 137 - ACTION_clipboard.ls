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
    me.launchChart()
  end if
end

on launchChart me
  global gFeatureSet
  if not gFeatureSet.isEnabled(#CHARTS) then
    put "CHARTS NOT ENABLED"
    return 
  end if
  sUrl = "/sf/charts/chart.jsp?type=ai"
  gotoNetPage(sUrl, "Top40Chart")
end
