property pSprite
global oMessageManager

on beginSprite me
  pSprite = sprite(me.spriteNum)
  pSprite.member.text = oMessageManager.pDenizenName
end
