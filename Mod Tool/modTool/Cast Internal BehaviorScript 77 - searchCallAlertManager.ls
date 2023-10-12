property pSprite
global oSearchCallAlertManager

on beginSprite me
  pSprite = sprite(me.spriteNum)
  oSearchStudio = me
  pSprite.member.text = EMPTY
  pSprite.editable = 0
end
