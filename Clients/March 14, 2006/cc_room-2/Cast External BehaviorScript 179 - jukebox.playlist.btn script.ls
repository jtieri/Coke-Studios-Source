global ElementMgr

on mouseUp me
  myheadlessplayer = sendAllSprites(#getheadlessplayer)
  if integerp(myheadlessplayer) then
    if sprite(myheadlessplayer).pMode = #preview then
      sprite(myheadlessplayer).stopSong()
      sprite(myheadlessplayer).pMode = #idle
    end if
  end if
  ElementMgr.oJukebox.openWindow("cc.infinite_jukebox.playlist.window")
end
