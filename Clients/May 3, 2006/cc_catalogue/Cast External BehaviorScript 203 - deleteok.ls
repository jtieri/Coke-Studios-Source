property pParentWindow, iPosId

on new me, parentwindow
  pParentWindow = parentwindow
  return me
end

on mouseUp me
  global oPossessionStudio
  oPossessionStudio.deleteItem(iPosId)
  pParentWindow.closeWindow()
end

on getdeleteok me
  return me.spriteNum
end
