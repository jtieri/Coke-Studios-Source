property pSprite
global oSearchUser, oUserDisplayManager

on beginSprite me
  pSprite = sprite(me.spriteNum)
  oSearchUser = me
  pSprite.member.text = EMPTY
  pSprite.editable = 0
end

on mouseDown me
  pSprite.editable = 1
  oUserDisplayManager.callAlertHilite(0)
end
