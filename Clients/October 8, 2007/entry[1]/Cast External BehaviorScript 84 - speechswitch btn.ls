property pTalkMode

on new me
  pTalkMode = #speak
  return me
end

on mouseDown me
  if me.pTalkMode = #sing then
    return 
  end if
  sprite(me.spriteNum).member = member("cc.speechswitch.mousedown")
  if pTalkMode = #speak then
    pTalkMode = #shout
  else
    pTalkMode = #speak
  end if
  stopEvent()
end

on mouseUp me
  if me.pTalkMode = #sing then
    return 
  end if
  sprite(me.spriteNum).member = member("cc.speechswitch." & string(pTalkMode))
end

on getSpeechMode me
  return pTalkMode
end

on setSpeechMode me, speechmode
  pTalkMode = speechmode
  sprite(me.spriteNum).member = member("cc.speechswitch." & string(pTalkMode))
  sprite(me.spriteNum).width = member("cc.speechswitch." & string(pTalkMode)).width
  sprite(me.spriteNum).height = member("cc.speechswitch." & string(pTalkMode)).height
end
