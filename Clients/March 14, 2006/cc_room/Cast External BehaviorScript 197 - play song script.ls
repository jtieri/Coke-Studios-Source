property enabled
global oStudio, ElementMgr, gSoundLevel

on new me
  enabled = 0
  return me
end

on mouseUp me
  if enabled then
    oSongData = ElementMgr.oJukebox.getOpenWindow().pScrollingLists[1].pSelectedSong
    mysongid = integer(ElementMgr.oJukebox.getOpenWindow().pScrollingLists[1].pSelectedSong.songid)
    if ElementMgr.oJukebox.getOpenWindow().pScrollingLists.getPropAt(1) = #cataloglist then
      myheadlessplayer = sendAllSprites(#getheadlessplayer)
      if voidp(myheadlessplayer) then
        myheadlessplayer = ElementMgr.LastUsedSprite()
        puppetSprite(myheadlessplayer, 1)
        sprite(myheadlessplayer).rect = rect(0, 0, 1, 1)
        sprite(myheadlessplayer).member = member("ftm_coke_player")
        sprite(myheadlessplayer).scriptInstanceList = [new(script("headless player script"))]
        updateStage()
        sprite(myheadlessplayer).rect = rect(0, 0, 1, 1)
        updateStage()
      end if
      sprite(myheadlessplayer).stopSong()
      fo_level0 = sprite(myheadlessplayer).getVariable("_root", 0)
      fo_level0.playsong(oSongData.getsongpath())
      fo_level0.setVolume(gSoundLevel)
      sprite(myheadlessplayer).pMode = #preview
    else
      oStudio.sendJukeboxPlay(mysongid)
    end if
  end if
end

on enableplaysong me
  enabled = 1
  myName = sprite(me.spriteNum).member.name
  the itemDelimiter = "."
  myName = myName.item[1..myName.item.count - 1] & ".active"
  sprite(me.spriteNum).member = member(myName)
end

on disableplaysong me
  enabled = 0
  myName = sprite(me.spriteNum).member.name
  the itemDelimiter = "."
  myName = myName.item[1..myName.item.count - 1] & ".dim"
  sprite(me.spriteNum).member = member(myName)
end
