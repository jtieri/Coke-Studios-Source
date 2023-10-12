property pTarget, pScrollbar, pCounter, pStatus, pParent, pDecal, pmodel

on new me, mytarget, myscrollbar, myparent
  pTarget = mytarget
  pScrollbar = myscrollbar
  pStatus = #idle
  pParent = myparent
  return me
end

on exitFrame me
  global ElementMgr
  if voidp(pTarget) = 0 then
    if (pStatus = #idle) and (sprite(pParent.pSpritelist[1]).pStatus <> #drag) then
      if pTarget.pTotalLines > pTarget.pDisplayLines then
        sprite(me.spriteNum).member = member(pmodel & ".scroll.lift.active")
        sprite(me.spriteNum).locV = sprite(pScrollbar).top + ((sprite(pScrollbar).height - sprite(me.spriteNum).height) / float(pTarget.pTotalLines - pTarget.pDisplayLines) * (pTarget.pScrollIndex - 1))
      else
        sprite(me.spriteNum).locV = sprite(pScrollbar).top
      end if
    else
      if pStatus = #drag then
        sprite(me.spriteNum).member = member(pmodel & ".scroll.lift.pressed")
        myloc = the mouseV + pDecal
        myloc = max(sprite(pScrollbar).top, myloc)
        myloc = min(sprite(pScrollbar).bottom - sprite(me.spriteNum).height, myloc)
        sprite(me.spriteNum).locV = myloc
        myindex = ((the mouseV + pDecal - sprite(pScrollbar).top) / ((sprite(pScrollbar).height - sprite(me.spriteNum).height) / float(pTarget.pTotalLines - pTarget.pDisplayLines))) + 1
        myindex = integer(myindex)
        myindex = max(1, myindex)
        myindex = min(pTarget.pTotalLines - pTarget.pDisplayLines + 1, myindex)
        pTarget.pScrollIndex = myindex
        pTarget.updatecontent()
      end if
    end if
  end if
end

on mouseDown me
  if voidp(pTarget) = 0 then
    if pTarget.pTotalLines > pTarget.pDisplayLines then
      pCounter = 0
      pStatus = #drag
      pDecal = sprite(me.spriteNum).locV - (the clickLoc).locV
    end if
  end if
  stopEvent()
end

on mouseUp me
  pStatus = #idle
end

on mouseUpOutSide me
  pStatus = #idle
end
