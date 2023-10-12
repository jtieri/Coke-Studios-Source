property pTarget

on new me, target
  pTarget = target
  return me
end

on mouseDown me
  stopEvent()
end

on mouseUp me
  iMouseLoc = the mouseLoc
  iMySpriteTop = sprite(me.spriteNum).top
  iMySpriteHeight = sprite(me.spriteNum).height
  iMySpriteRight = sprite(me.spriteNum).right
  iDisplayLines = pTarget.pDisplayLines
  iScrollIndex = pTarget.pScrollIndex
  MyNum = ((iMouseLoc[2] - iMySpriteTop) / (iMySpriteHeight / iDisplayLines)) + iScrollIndex
  if _mouse.doubleClick then
    pTarget.lineclicked(MyNum)
  else
    pTarget.hiliteline(MyNum)
  end if
  stopEvent()
end
