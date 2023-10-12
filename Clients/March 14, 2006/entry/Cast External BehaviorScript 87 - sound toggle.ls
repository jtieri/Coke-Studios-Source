property pStatus, pHighVolume
global gSoundLevel, ElementMgr, oStudio

on new me
  pStatus = #enabled
  me.pHighVolume = 230.0
  gSoundLevel = me.pHighVolume
  return me
end

on mouseUp me
  if pStatus = #enabled then
    pStatus = #disabled
    gSoundLevel = 0.0
    sprite(me.spriteNum).pBasename = "cc.bottombtn.soundoff"
  else
    pStatus = #enabled
    gSoundLevel = me.pHighVolume
    sprite(me.spriteNum).pBasename = "cc.bottombtn.sound"
  end if
  me.setSoundVolumes(gSoundLevel)
end

on setSoundVolumes me, theVolume
  repeat with i = 1 to 8
    sound(i).volume = theVolume
  end repeat
  if not voidp(ElementMgr) then
    oSequencer = ElementMgr.getSequencer()
    oSequencer.resetVolume()
  end if
  myheadlessplayer = sendAllSprites(#getheadlessplayer)
  if voidp(myheadlessplayer) = 0 then
    myFO = sprite(myheadlessplayer).getVariable("_root", 0)
    myFO.setVolume(gSoundLevel)
  end if
end
