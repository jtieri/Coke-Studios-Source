property pStatus, pParentWindow
global gFeatureSet, ElementMgr

on new me, whichparent
  pParentWindow = whichparent
  pStatus = #idle
  return me
end

on mouseDown me
  if not gFeatureSet.isEnabled(#PRIVATE_STUDIOS) then
    ElementMgr.alert("FEATURE_DISABLED")
    return 
  end if
  pStatus = #clicked
  stopEvent()
end

on mouseUp me
  global oStudioManager, ElementMgr
  pStatus = #idle
  member("userlist").comments = "blocked"
  pParentWindow.pScrollingLists.userList.displayloading()
  oStudioManager.getAllPrivateStudios()
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
