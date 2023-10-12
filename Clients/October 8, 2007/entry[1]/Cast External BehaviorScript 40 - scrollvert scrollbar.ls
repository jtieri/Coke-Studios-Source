property pTarget, pCounter, pSlider, pClicked, pmodel

on new me, mytarget, myslider
  pTarget = mytarget
  pSlider = myslider
  return me
end

on exitFrame me
  global ElementMgr
  if voidp(pTarget) = 0 then
    if the mouseDown and pClicked then
      if pmodel = "mms" then
        sprite(me.spriteNum).member = member("mms.scrollbar.pressed")
      else
        sprite(me.spriteNum).member = member("scrollbar.vertical.pressed")
      end if
      myindex = pTarget.pScrollIndex
      if (pClicked = 1) and ((the clickLoc).locV > sprite(pSlider).locV) then
        myindex = pTarget.pScrollIndex + pTarget.pDisplayLines
      else
        if (pClicked = 2) and ((the clickLoc).locV < sprite(pSlider).locV) then
          myindex = pTarget.pScrollIndex - pTarget.pDisplayLines
        end if
      end if
      myindex = max(myindex, 1)
      myindex = min(pTarget.pTotalLines - pTarget.pDisplayLines + 1, myindex)
      pTarget.pScrollIndex = myindex
      pTarget.updatecontent()
    else
      if pmodel = "mms" then
        sprite(me.spriteNum).member = member("mms.scrollbar.active")
      else
        sprite(me.spriteNum).member = member("scrollbar.vertical.active")
      end if
    end if
  end if
end

on mouseDown me
  pCounter = 0
  if voidp(pTarget) = 0 then
    if pTarget.pTotalLines > pTarget.pDisplayLines then
      if (the clickLoc).locV > sprite(pSlider).locV then
        pClicked = 1
      else
        if (the clickLoc).locV < sprite(pSlider).locV then
          pClicked = 2
        end if
      end if
    else
      pClicked = 0
    end if
  end if
  stopEvent()
end

on mouseUp me
  pClicked = 0
end

on mouseUpOutSide me
  pClicked = 0
end
