property pLoc

on beginSprite me
  sprite(me.spriteNum).locZ = 16002
  me.pLoc = sprite(me.spriteNum).loc
  me.hide()
end

on show me
  sprite(me.spriteNum).loc = me.pLoc
end

on hide me
  sprite(me.spriteNum).loc = point(-500, -500)
end
