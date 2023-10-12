property pSprite, bState
global oCallAlertDisplayManager

on beginSprite me
  pSprite = sprite(me.spriteNum)
  me.bState = 1
end

on mouseUp me
  if me.bState then
    me.bState = 0
    pSprite.member = "speakerBtnOff"
    oCallAlertDisplayManager.bSoundOn = 0
  else
    me.bState = 1
    pSprite.member = "speakerBtnOn"
    oCallAlertDisplayManager.bSoundOn = 1
  end if
end
