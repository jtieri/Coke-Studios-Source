global oIsoScene

on initIsoScene oStudioMap
  oSceneXml = newObject("XML")
  oSceneXml.ignoreWhite = 1
  sSceneMember = oStudioMap.getSceneXml()
  sSceneXml = member(sSceneMember).text
  oSceneXml.parseXML(sSceneXml)
  oMapXml = newObject("XML")
  oMapXml.ignoreWhite = 1
  sMapMember = oStudioMap.getMapXml()
  sMapXml = member(sMapMember).text
  oMapXml.parseXML(sMapXml)
  oEntryXml = newObject("XML")
  oEntryXml.ignoreWhite = 1
  sEntryMember = oStudioMap.getEntryXml()
  sEntryXml = member(sEntryMember).text
  oEntryXml.parseXML(sEntryXml)
  iStartTime = the milliSeconds
  oIsoScene = new(script("IsoScene"))
  oIsoScene.init(oSceneXml, oMapXml, oEntryXml)
  iEndTime = the milliSeconds
end

on clearDynamicMembers
  repeat with i = 1 to the number of castMembers of castLib "IsoEngine"
    oMember = member(i, "IsoEngine")
    sName = oMember.name
    if sName contains "_DYNAMIC_" then
      oMember.erase()
    end if
  end repeat
end

on mouseDown
  if not voidp(oIsoScene) then
    oIsoScene.mouseDownEvent(the doubleClick)
  end if
  pass()
end

on resetGridDisplay
  member("GridDisplay").image = image(1, 1, 8)
end
