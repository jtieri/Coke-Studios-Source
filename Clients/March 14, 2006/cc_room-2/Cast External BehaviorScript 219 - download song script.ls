global oDenizenManager, ElementMgr

on new me
  return me
end

on mouseUp me
  if sprite(me.spriteNum).member.name contains "active" then
    ElementMgr.decisiondialog("ALERT_LEAVE_SF", "download song ok")
  end if
end

on enabledownloadsong me
  myName = sprite(me.spriteNum).member.name
  the itemDelimiter = "."
  myName = myName.item[1..myName.item.count - 1] & ".active"
  sprite(me.spriteNum).member = member(myName)
end

on disabledownloadsong me
  myName = sprite(me.spriteNum).member.name
  the itemDelimiter = "."
  myName = myName.item[1..myName.item.count - 1] & ".dim"
  sprite(me.spriteNum).member = member(myName)
end
