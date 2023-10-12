property enabled
global oDenizenManager, ElementMgr

on new me
  enabled = 0
  return me
end

on mouseUp me
  if enabled then
    mysong = ElementMgr.oJukebox.getOpenWindow().pScrollingLists.playList.pSelectedSong.songid
    oDenizenManager.removeFromPlaylist(mysong)
  end if
end

on enableremovesong me
  enabled = 1
  sprite(me.spriteNum).member = member("cc.jukebox.player.remove.btn.active")
end

on disableremovesong me
  enabled = 1
  sprite(me.spriteNum).member = member("cc.jukebox.player.remove.btn.dim")
end
