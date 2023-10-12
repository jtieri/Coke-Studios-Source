property enabled, pStatus, myscrollbar, pParentWindow
global ElementMgr

on new me, parentwindow
  pStatus = #idle
  pParentWindow = parentwindow
  enabled = 0
  return me
end

on enablescrollhead me
  enabled = 1
  sprite(me.spriteNum).blend = 100
end

on disablescrollhead me
  enabled = 0
  sprite(me.spriteNum).blend = 0
end

on exitFrame me
  myList = pParentWindow.pScrollingLists[1]
  if myList.pDisplayLines < count(myList.pContentlist) then
    enablescrollhead(me)
  else
    disablescrollhead(me)
  end if
  if pStatus = #scroll then
    if the mouseV < (sprite(myscrollbar).top + (sprite(me.spriteNum).height / 2)) then
      myloc = sprite(myscrollbar).top
    else
      if the mouseV > (sprite(myscrollbar).bottom - (sprite(me.spriteNum).height / 2)) then
        myloc = sprite(myscrollbar).bottom - sprite(me.spriteNum).height
      else
        myloc = the mouseV - (sprite(me.spriteNum).height / 2)
      end if
    end if
    totalheight = count(myList.pContentlist) - myList.pDisplayLines
    myList.pScrollIndex = integer(float(totalheight) / (sprite(myscrollbar).height - sprite(me.spriteNum).height) * (myloc - (sprite(myscrollbar).top + (sprite(me.spriteNum).height / 2)))) + 1
    myList.updatecontent()
    sprite(me.spriteNum).locV = myloc
  end if
end

on mouseDown me
  if enabled then
    pStatus = #scroll
    repeat with n in pParentWindow.pSpritelist
      sendSprite(n, #disableaddsong)
      sendSprite(n, #disableremovesong)
      sendSprite(n, #disableplaysong)
      sendSprite(n, #disabledownloadsong)
    end repeat
  end if
  if voidp(myscrollbar) then
    repeat with n in pParentWindow.pSpritelist
      myscrollbar = sendSprite(n, #getscrollbar)
      if voidp(myscrollbar) = 0 then
        exit repeat
      end if
    end repeat
  end if
end

on mouseUp me
  pStatus = #idle
end

on mouseUpOutSide me
  pStatus = #idle
end
