on setLocZ me, iLocZ
  sprite(me.spriteNum).locZ = iLocZ
end

on setVisible me, bVisible
  sprite(me.spriteNum).visible = bVisible
end

on getVisible me
  return sprite(me.spriteNum).visible
end
