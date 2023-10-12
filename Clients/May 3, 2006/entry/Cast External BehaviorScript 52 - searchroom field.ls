on mouseDown me
  nothing()
end

on exitFrame me
  if sprite(me.spriteNum).member.text.lines.count > 1 then
    sprite(me.spriteNum).member.text = sprite(me.spriteNum).member.text.line[1]
    sendAllSprites(#searcharoom)
  end if
end
