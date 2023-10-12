global oIsoScene

on beginSprite me
  sprite(me.spriteNum).member.directToStage = 1
  if not (the movieName contains "Gateway") then
    iWidth = 2
    iHeight = 2
    iWidth = sprite(me.spriteNum).width
    iHeight = sprite(me.spriteNum).height
    sprite(me.spriteNum).width = iWidth
    sprite(me.spriteNum).height = iHeight
    sprite(me.spriteNum).locH = -iWidth - 20
    sprite(me.spriteNum).locV = 0
  end if
  sprite(me.spriteNum).visible = 1
end

on keyDown me
  if not voidp(oIsoScene) then
    oIsoScene.keyDownEvent()
  end if
  pass()
end
