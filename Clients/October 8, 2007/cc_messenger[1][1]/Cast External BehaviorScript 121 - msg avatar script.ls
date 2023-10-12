global oStudioMap

on new me
  return me
end

on exitFrame me
  if sprite(me.spriteNum).member <> member("msgavatar") then
    update(me)
  end if
end

on update me
  global oDenizenManager, gMembersToDelete
  if member("msgavatar").memberNum < 1 then
    myMember = new(#bitmap)
    myMember.name = "msgavatar"
    append(gMembersToDelete, myMember)
  end if
  oAvatarImage = oDenizenManager.getAvatarImage()
  iNewHeight = oAvatarImage.height - 30
  oPreviewImage = image(oAvatarImage.width, iNewHeight, 16)
  rSourceRect = rect(0, 0, oAvatarImage.width, iNewHeight)
  rDestRect = oPreviewImage.rect
  oPreviewImage.copyPixels(oAvatarImage, rDestRect, rSourceRect)
  member("msgavatar").image = oPreviewImage
  member("msgavatar").regPoint = point(0, 0)
  sprite(me.spriteNum).member = member("msgavatar")
  sprite(me.spriteNum).bgColor = rgb(255, 255, 255)
  sprite(me.spriteNum).ink = 36
  sprite(me.spriteNum).width = oPreviewImage.width
  sprite(me.spriteNum).height = oPreviewImage.height
end

on mouseDown me
  pass()
end

on mouseUp me
  pass()
end
