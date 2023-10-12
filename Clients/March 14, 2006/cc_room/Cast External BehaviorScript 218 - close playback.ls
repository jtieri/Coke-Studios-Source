property pParentWindow

on new me, parentwindow
  pParentWindow = parentwindow
  return me
end

on mouseUp me
  global oStudio
  oStudio.sendJukeboxStop()
  pParentWindow.closeWindow()
end
