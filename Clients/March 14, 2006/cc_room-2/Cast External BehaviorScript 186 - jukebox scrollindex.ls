property enabled
global oStudioManager, ElementMgr

on beginSprite me
  enabled = 0
end

on mouseUp me
  mysong = ElementMgr.oJukebox.getOpenWindow().pScrollingLists.cataloglist.pSelectedSong
  oStudioManager.addToPlayList(mysong)
end

on enableaddsong me
  enabled = 1
  sprite(me.spriteNum).member = member("cc.jukebox.add.btn.active")
end

on disableaddsong me
  enabled = 1
  sprite(me.spriteNum).member = member("cc.jukebox.add.btn.dim")
end
