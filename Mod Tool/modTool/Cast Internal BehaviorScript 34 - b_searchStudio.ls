property pSprite
global oSearchStudio, oPrivateDisplayManager

on beginSprite me
  pSprite = sprite(me.spriteNum)
  oSearchStudio = me
  pSprite.member.text = EMPTY
  pSprite.editable = 0
end

on mouseDown me
  pSprite.editable = 1
  oPrivateDisplayManager.top35Hilite(0)
end
