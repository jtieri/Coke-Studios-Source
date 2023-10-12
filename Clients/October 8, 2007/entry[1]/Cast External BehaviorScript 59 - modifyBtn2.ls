property pParentWindow, pClicked, previousmember, bVisible

on new me, myMember, myparent, _bVisible
  previousmember = myMember
  pParentWindow = myparent
  pClicked = 0
  me.bVisible = _bVisible
  return me
end

on hidemodifybtn me
  me.bVisible = 0
  sprite(me.spriteNum).visible = me.bVisible
  sprite(me.spriteNum).blend = 0
  sprite(me.spriteNum).member = member("shadow.pixel")
end

on showmodifybtn me
  me.bVisible = 1
  sprite(me.spriteNum).visible = me.bVisible
  sprite(me.spriteNum).blend = 100
  sprite(me.spriteNum).member = previousmember
end

on mouseDown me
  modifyDown(me)
  stopEvent()
end

on modifyDown me
  pClicked = 1
end

on mouseWithin me
  modifywithin(me)
end

on modifywithin me
  myName = sprite(me.spriteNum).member.name
  if (myName contains "shadow") = 0 then
    if the mouseDown and pClicked then
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
  end if
end

on mouseUp me
  modifyUp(me)
end

on mouseUpOutSide me
  modifyupoutside(me)
end

on modifyupoutside me
  pClicked = 0
end

on modifyUp me
  global ElementMgr, oDenizenManager, oStudioManager
  pClicked = 0
  sStudioID = member("userroomID").text
  sScreenName = oDenizenManager.getScreenName()
  oStudioManager.startModifyStudio(sScreenName, sStudioID)
end

on mouseLeave me
  modifyleave(me)
end

on modifyleave me
  myName = sprite(me.spriteNum).member.name
  the itemDelimiter = "."
  myName = myName.item[1..myName.items.count - 1] & ".active"
  the itemDelimiter = ","
  if member(myName).memberNum > 0 then
    sprite(me.spriteNum).member = member(myName)
  end if
end
