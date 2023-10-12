property pParentWindow, pStatus, bSearchUserActive, bDebug
global ElementMgr, oDenizenManager

on new me, whichparent
  pParentWindow = whichparent
  pStatus = #idle
  me.bSearchUserActive = 1
  me.bDebug = 0
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "searchuser: " & sMessage
  end if
end

on mouseUp me
  pStatus = #idle
  searchauser(me)
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

on searchauser me
  sSearchText = member("nav_vego_search_field").text
  if sSearchText <> EMPTY then
    if me.bSearchUserActive then
      oDenizenManager.getDenizenByScreenName(sSearchText)
      me.bSearchUserActive = 0
      script("_TIMER_").new(3000, #searchAuser_active, me, 1)
    end if
  end if
end

on searchAuser_active me, bState
  bSearchUserActive = bState
end
