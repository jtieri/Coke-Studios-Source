property enabled
global oDenizenManager, ElementMgr

on new me
  enabled = 0
  return me
end

on mouseUp me
  mysong = ElementMgr.oJukebox.getOpenWindow().pScrollingLists.cataloglist.pSelectedSong.songid
  oDenizenManager.addToPlayList(mysong)
end

on enableaddsong me
  enabled = 1
  myName = sprite(me.spriteNum).member.name
  the itemDelimiter = "."
  myName = myName.item[1..myName.item.count - 1] & ".active"
  sprite(me.spriteNum).member = member(myName)
end

on disableaddsong me
  enabled = 0
  myName = sprite(me.spriteNum).member.name
  the itemDelimiter = "."
  myName = myName.item[1..myName.item.count - 1] & ".dim"
  sprite(me.spriteNum).member = member(myName)
end
