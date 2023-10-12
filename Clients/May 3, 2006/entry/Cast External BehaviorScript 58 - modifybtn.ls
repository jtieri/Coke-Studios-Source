property previousmember, bVisible

on new me, myMember, _bVisible
  previousmember = myMember
  me.bVisible = _bVisible
  return me
end

on hidemodifybtn me
  me.bVisible = 0
  sprite(me.spriteNum).visible = me.bVisible
  sprite(me.spriteNum).blend = 0
  sprite(me.spriteNum).member = member("shadow.pixel")
end

on showmodifybtn me
  me.bVisible = 1
  sprite(me.spriteNum).visible = me.bVisible
  sprite(me.spriteNum).blend = 100
  sprite(me.spriteNum).member = previousmember
end

on mouseDown me
  sendAllSprites(#modifyDown)
  stopEvent()
end

on mouseUp me
  sendAllSprites(#modifyUp)
end

on mouseWithin me
  sendAllSprites(#modifywithin)
end

on mouseUpOutSide me
  sendAllSprites(#modifyupoutside)
end

on mouseLeave me
  sendAllSprites(#modifyleave)
end
