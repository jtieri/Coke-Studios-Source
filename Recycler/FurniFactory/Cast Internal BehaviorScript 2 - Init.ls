global oAvatar, oComputer, oDisplay, sInputString, sAvatarString, sScreenName, sTimeString, oIsoScene, oMap, oWhaleWashXML, oMapObject, iSledTrackValue, iBotSquareValue, oSpriteManager

on beginSprite me
  oSpriteManager = script("SpriteManager").new(300, 1500)
  script("DisplayObject").new()
  script("ComputerObject").new()
  oComputer.addToActorList()
  iSledTrackValue = 110
  iBotSquareValue = 200
  oIsoScene = script("isoScene").new()
  oIsoScene.init()
  oWhaleWashXML = newObject("XML")
  oWhaleWashXML.ignoreWhite = 1
  oWhaleWashXML.parseXML(script("hotdog").getMap())
  oPathMap = getNode(oWhaleWashXML, "Pathmap")
  oMapObject = [:]
  oMapObject.setaProp(#rows, integer(oPathMap.attributes.rows))
  oMapObject.setaProp(#cols, integer(oPathMap.attributes.cols))
  templateForRows = []
  repeat with i = 1 to oMapObject.cols
    templateForRows.add(-1)
  end repeat
  oMapObject.setaProp(#oGridVals, [])
  repeat with i = 1 to oMapObject.rows
    oMapObject.oGridVals.add(templateForRows.duplicate())
  end repeat
  oNodes = getNodes(oPathMap, "Node")
  repeat with i = 1 to oNodes.count
    w = integer(oNodes[i].attributes.w)
    r = integer(oNodes[i].attributes.r)
    c = integer(oNodes[i].attributes.c)
    oMapObject.oGridVals[r][c] = w
  end repeat
  iRow = 1
  iCol = 1
  iRows = 5
  iCols = 8
  iNumAvatars = 1
  iSprite = 6
  iShadowSprite = 5
  oLoc = point(20, 200)
  iColOff = 50
  iRowOff = 50
  oAvatar = script("AvatarEngine").new(sAvatarString)
  oAvatar.initSprites(iSprite, iShadowSprite)
  oAvatar.setStartSquare(21, 14)
  (the actorList).add(oAvatar)
  sendAllSprites(#initMachine)
  oComputer.gameBegin()
  updateStage()
end
