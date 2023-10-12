property pParentWindow, pStatus, bSearchRoomActive, bDebug
global ElementMgr, oStudioManager

on new me, whichparent
  pParentWindow = whichparent
  pStatus = #idle
  bSearchRoomActive = 1
  me.bDebug = 0
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "searchroom: " & sMessage
  end if
end

on mouseUp me
  pStatus = #idle
  searcharoom(me)
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

on searcharoom me
  sSearchText = member("nav_prv_search_field").text
  if sSearchText <> EMPTY then
    if bSearchRoomActive then
      myRect = pParentWindow.prect
      pParentWindow.closeWindow()
      member("userlist").comments = "blocked"
      ElementMgr.newwindow("nav_private_start.window", myRect)
      ElementMgr.pOpenWindows.nav_private_start.pScrollingLists.userList.displayloading()
      oStudioManager.getByStudioName(sSearchText)
      the updateLock = 0
      me.bSearchRoomActive = 0
      script("_TIMER_").new(3000, #searchAroom_active, me, 1)
    end if
  end if
end

on searchAroom_active me, bState
  bSearchRoomActive = bState
end
