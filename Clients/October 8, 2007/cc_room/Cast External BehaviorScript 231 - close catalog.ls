property pParentWindow

on new me, parentwindow
  pParentWindow = parentwindow
  return me
end

on mouseUp me
  myheadlessplayer = sendAllSprites(#getheadlessplayer)
  if integerp(myheadlessplayer) then
    if sprite(myheadlessplayer).pMode = #preview then
      sprite(myheadlessplayer).stopSong()
      sprite(myheadlessplayer).pMode = #idle
    end if
  end if
  pParentWindow.closeWindow()
end
