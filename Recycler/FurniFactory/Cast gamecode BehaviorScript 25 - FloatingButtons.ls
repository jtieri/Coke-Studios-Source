on beginSprite me
  sprite(me.spriteNum).locZ = 16002
end

on mouseEnter me
  the itemDelimiter = "-"
  sprite(me.spriteNum).member = member(sprite(me.spriteNum).member.name.item[1] & "-ov")
  the itemDelimiter = ","
end

on mouseLeave me
  the itemDelimiter = "-"
  sprite(me.spriteNum).member = member(sprite(me.spriteNum).member.name.item[1] & "-up")
  the itemDelimiter = ","
end

on mouseUpOutSide me
  the itemDelimiter = "-"
  sprite(me.spriteNum).member = member(sprite(me.spriteNum).member.name.item[1] & "-up")
  the itemDelimiter = ","
end
