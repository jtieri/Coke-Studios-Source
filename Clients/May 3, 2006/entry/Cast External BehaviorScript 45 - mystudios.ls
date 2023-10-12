property pStatus, pParentWindow

on new me, whichparent
  pParentWindow = whichparent
  pStatus = #idle
  return me
end

on mouseDown me
  pStatus = #clicked
  stopEvent()
end

on mouseUp me
  global oStudioManager, oDenizenManager, ElementMgr
  pStatus = #idle
  member("userlist").comments = "blocked"
  pParentWindow.pScrollingLists.userList.displayloading()
  myscreenname = oDenizenManager.getScreenName()
  oStudioManager.getByOwnerName(myscreenname)
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
    updateStage()
  else
    the itemDelimiter = "."
    myName = myName.item[1..myName.items.count - 1] & ".active"
    the itemDelimiter = ","
    sprite(me.spriteNum).member = member(myName)
    updateStage()
  end if
end

on mouseLeave me
  myName = sprite(me.spriteNum).member.name
  the itemDelimiter = "."
  myName = myName.item[1..myName.items.count - 1] & ".active"
  the itemDelimiter = ","
  sprite(me.spriteNum).member = member(myName)
end
