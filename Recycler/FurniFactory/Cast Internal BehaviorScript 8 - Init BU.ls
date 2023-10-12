global oAvatar, oIsoScene

on beginSprite me
  oIsoScene = script("isoScene").new()
  oIsoScene.init()
  iRow = 1
  iCol = 1
  iRows = 5
  iCols = 8
  iNumAvatars = 1
  iSprite = 120
  iShadowSprite = 121
  oLoc = point(20, 200)
  iColOff = 50
  iRowOff = 50
  if the shiftDown then
    iNumAvatars = 25
  end if
  repeat with i = 1 to iNumAvatars
    oNewLoc = oLoc + point(iColOff * (iCol - 1), iRowOff * (iRow - 1))
    oNewAvatar = new(script("AvatarEngine"))
    oNewAvatar.initSprites(iSprite, iShadowSprite)
    if iNumAvatars = 1 then
      oNewAvatar.setLoc(sendAllSprites(#getInitLoc))
      sendAllSprites(#setVisible, 1)
    else
      oNewAvatar.setLoc(oNewLoc)
      sendAllSprites(#setVisible, 0)
    end if
    if i = 1 then
      oNewAvatar.bDisplayStatus = 1
    end if
    put oNewLoc
    if i = 1 then
      oAvatar = oNewAvatar
    end if
    (the actorList).add(oNewAvatar)
    if (i mod 2) = 0 then
      oNewAvatar.setBodyAction("wlk")
    end if
    iSprite = iSprite + 20
    if iCol = iCols then
      iRow = iRow + 1
      iCol = 1
      next repeat
    end if
    iCol = iCol + 1
  end repeat
  member("AvatarAttributes").text = oAvatar.sDefaultString
end
