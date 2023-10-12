property pParentWindow, pType, iPosId, iWallTexture, iWallColor, iFloorTexture, iFloorColor

on new me, parentwindow
  pParentWindow = parentwindow
  return me
end

on mouseUp me
  global oPossessionStudio
  if pType = #wall then
    oPossessionStudio.replaceWall(iPosId, iWallTexture, iWallColor)
  else
    oPossessionStudio.replaceFloor(iPosId, iFloorTexture, iFloorColor)
  end if
  pParentWindow.closeWindow()
end

on getokreplace me
  return me.spriteNum
end
