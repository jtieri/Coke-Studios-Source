property pSprite

on beginSprite me
  pSprite = sprite(me.spriteNum)
  pSprite.member.text = "Current time is:"
end
