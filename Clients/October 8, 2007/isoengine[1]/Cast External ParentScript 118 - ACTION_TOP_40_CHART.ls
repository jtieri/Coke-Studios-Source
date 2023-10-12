property ancestor

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  return me
end

on mouseDownEvent me
  if the doubleClick then
    me.launchChart()
  end if
end

on launchChart me, iDate
  global gFeatureSet
  if not gFeatureSet.isEnabled(#CHARTS) then
    put "CHARTS NOT ENABLED"
    return 
  end if
  sType = me.oItem.aAttributes[#type]
  iTime = me.oItem.aAttributes[#time]
  sAuthor = me.oItem.aAttributes[#author]
  sTitle = me.oItem.aAttributes[#title]
  sUrl = "/sf/charts/chart.jsp"
  if not voidp(sType) and not voidp(iTime) then
    sUrl = sUrl & "?" & "type=" & sType & "&" & "time=" & iTime
  end if
  gotoNetPage(sUrl, "Top40Chart")
end
