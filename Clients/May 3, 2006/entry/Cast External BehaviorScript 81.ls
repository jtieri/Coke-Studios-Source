on exitFrame me
  if member(sprite(me.spriteNum).member).text.lines.count > 1 then
    member(sprite(me.spriteNum).member).text = member(sprite(me.spriteNum).member).text.line[1]
    sendSprite(3, #mouseUp)
  end if
end
