property pParentWindow, pStatus
global ElementMgr

on new me, whichparent
  pParentWindow = whichparent
  pStatus = #idle
  return me
end

on mouseUp me
  if pStatus = #clicked then
    pStatus = #idle
    the updateLock = 1
    myRect = pParentWindow.prect
    pParentWindow.closeWindow()
    member("userlist").comments = "blocked"
    ElementMgr.newwindow("nav_private_start_search.window", myRect)
    updateStage()
    the updateLock = 0
  end if
end

on mouseDown me
  pStatus = #clicked
  stopEvent()
end

on mouseUpOutSide me
  pStatus = #idle
end

on mouseWithin me
  myName = sprite(me.spriteNum).member.name
  if (pStatus = #clicked) and the mouseDown then
    the itemDelimiter = "."
    myName = myName.item[1..myName.items.count - 1] & ".pressed"
    the itemDelimiter = ","
    sprite(me.spriteNum).member = member(myName)
  else
    the itemDelimiter = "."
    myName = myName.item[1..myName.items.count - 1] & ".active"
    the itemDelimiter = ","
    sprite(me.spriteNum).member = member(myName)
  end if
end

on mouseLeave me
  myName = sprite(me.spriteNum).member.name
  the itemDelimiter = "."
  myName = myName.item[1..myName.items.count - 1] & ".active"
  the itemDelimiter = ","
  sprite(me.spriteNum).member = member(myName)
end
