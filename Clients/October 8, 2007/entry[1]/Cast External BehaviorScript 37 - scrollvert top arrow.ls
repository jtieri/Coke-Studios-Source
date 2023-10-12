property pTarget, pCounter, pClicked, pmodel

on new me, mytarget
  pTarget = mytarget
  return me
end

on mouseDown me
  pCounter = 0
  pClicked = 1
  stopEvent()
end

on mouseWithin me
  if voidp(pTarget) = 0 then
    if the mouseDown and pClicked then
      if pTarget.pTotalLines > pTarget.pDisplayLines then
        sprite(me.spriteNum).member = member("button.scroll.up.pressed")
        if (pCounter mod 2) = 0 then
          if pTarget.pScrollIndex > 1 then
            pTarget.pScrollIndex = pTarget.pScrollIndex - 1
            pTarget.updatecontent()
          end if
        end if
        pCounter = pCounter + 1
      end if
    else
      if pTarget.pTotalLines > pTarget.pDisplayLines then
        sprite(me.spriteNum).member = member("button.scroll.up.active")
      end if
    end if
  end if
end

on exitFrame me
  if voidp(pTarget) = 0 then
    if pTarget.pTotalLines > pTarget.pDisplayLines then
      if sprite(me.spriteNum).member = member("button.scroll.up.passive") then
        sprite(me.spriteNum).member = member("button.scroll.up.active")
      end if
    end if
  end if
end

on mouseLeave me
  if voidp(pTarget) = 0 then
    if pTarget.pTotalLines > pTarget.pDisplayLines then
      sprite(me.spriteNum).member = member("button.scroll.up.active")
    end if
  end if
end

on mouseUp me
  pClicked = 0
end

on mouseUpOutSide me
  pClicked = 0
end
