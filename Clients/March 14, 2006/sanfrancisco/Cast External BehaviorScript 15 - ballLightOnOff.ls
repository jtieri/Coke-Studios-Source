on mouseUp me
  ballRect = rect(367, 25, 425, 82)
  if inside(the mouseLoc, ballRect) then
    if sprite(me.spriteNum).member.name = "BallAnim" then
      sprite(me.spriteNum).blend = 0
      sprite(me.spriteNum).member = member("Ball_anim0")
    else
      sprite(me.spriteNum).blend = 100
      sprite(me.spriteNum).member = member("BallAnim")
    end if
  else
    pass()
  end if
end
