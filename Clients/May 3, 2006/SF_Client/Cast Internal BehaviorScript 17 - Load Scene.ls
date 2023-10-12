property sID
global oStudioMap, oSession, ElementMgr, oStudio, oPossessionStudio, oIsoScene, oStudioManager, oDenizenManager, oRoom

on beginSprite me
  put "--> ENTERING STUDIO **"
  me.sID = EMPTY
  bEnterStudioViaTeleport = oStudioMap.getEnterStudioViaTeleport()
  iDestinationId = VOID
  if bEnterStudioViaTeleport then
    iDestinationId = oStudioMap.getDestinationId()
  end if
  if bEnterStudioViaTeleport and not voidp(iDestinationId) then
    oPossessionStudio.sendEnterStudioViaTeleporter(iDestinationId)
  else
    oStudio.sendEnterStudio()
  end if
end

on initStudioEntered me, sStudioID, sStudioName, iLocation, iLayout, sOwner, iSequenceRate
  put "--> STUDIO ENTERED: " & sStudioID && sStudioName && iLocation && iLayout && sOwner && iSequenceRate
  put "*****************" & RETURN
  oStudioMap = script("StudioMap").new(iLocation, iLayout, sStudioID, sStudioName)
  initIsoScene(oStudioMap)
  oIsoScene.setSequenceRate(iSequenceRate)
end

on initTestAvatar me
  oAvatar = new(script("IsoAvatar"), oDenizenManager.getScreenName(), oStudioMap.getAvatarScale())
  oAvatar.iLayer = 3
  oEntryXml = oIsoScene.getEntryXml()
  oUpdateNode = getNode(oEntryXml.firstChild, "AV")
  if not voidp(oUpdateNode) then
    iXPos = integer(oUpdateNode.attributes.x)
    iYPos = integer(oUpdateNode.attributes.y)
    iZPos = integer(oUpdateNode.attributes.z)
    iDir = integer(oUpdateNode.attributes.d)
    sAction = oUpdateNode.attributes.act
    oAvatar.moveToRowCol(iXPos, iZPos)
    oAvatar.faceDirection(iDir)
  end if
  oMoveNode = getNode(oEntryXml.firstChild, "AV_MV")
  if not voidp(oMoveNode) then
    iXPos = integer(oMoveNode.attributes.x)
    iYPos = integer(oMoveNode.attributes.y)
    iZPos = integer(oMoveNode.attributes.z)
    oSquare = oIsoScene.oGrid.getSquareByRowCol(iXPos, iZPos)
    oAvatar.findPath(oSquare)
  end if
end

on exitFrame me
  go(the frame)
end

on initLoggedIn me
end

on initExitRoom me
  put "--> EXITING ROOM"
  me.sID = "Exiting Studio"
  oRoom.sendExitRoom()
end

on initRoomExited me, sStudioID
  put "--> room EXITED"
  if oSession.getConnected() then
    me.initDisconnect()
  end if
end

on initDisconnect me
  put "--> DISCONNECTING"
  me.sID = "Disconnecting"
  oSession.disconnect()
end

on initLoggedOut me
  put "--> LOGGED OUT"
  gotoEntry()
end
