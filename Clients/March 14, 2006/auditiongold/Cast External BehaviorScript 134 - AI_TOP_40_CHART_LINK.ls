on mouseDown me
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
