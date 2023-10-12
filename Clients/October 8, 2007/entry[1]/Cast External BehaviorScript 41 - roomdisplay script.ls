property pTarget, pMouseDown

on new me, target
  pTarget = target
  pMouseDown = 0
  return me
end

on mouseDown me
  if rollover(me.spriteNum) then
    pMouseDown = 1
  end if
  stopEvent()
end

on mouseUp me
  if pMouseDown then
    pMouseDown = 0
    iMouseLoc = the mouseLoc
    iMySpriteTop = sprite(me.spriteNum).top
    iMySpriteHeight = sprite(me.spriteNum).height
    iMySpriteRight = sprite(me.spriteNum).right
    iDisplayLines = pTarget.pDisplayLines
    iScrollIndex = pTarget.pScrollIndex
    MyNum = ((iMouseLoc[2] - iMySpriteTop) / (iMySpriteHeight / iDisplayLines)) + iScrollIndex
    if iMouseLoc[1] >= (iMySpriteRight - 20) then
      bGoStudio = 1
    else
      bGoStudio = 0
    end if
    pTarget.roomclicked(MyNum, bGoStudio)
    stopEvent()
  end if
end

on mouseUpOutSide me
  pMouseDown = 0
  stopEvent()
end
