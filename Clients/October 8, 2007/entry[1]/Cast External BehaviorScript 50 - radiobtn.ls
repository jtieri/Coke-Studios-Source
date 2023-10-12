property pID, pParentWindow, pGroupID

on new me, id, myparent
  pID = id
  pParentWindow = myparent
  the itemDelimiter = "_"
  pGroupID = pID.item[1..pID.items.count - 1]
  the itemDelimiter = ","
  return me
end

on mouseUp me
  groupBtn = []
  repeat with n in pParentWindow.pSpritelist
    if sprite(n).member.name contains "cc.radiobutton." then
      if sprite(n).pID contains pGroupID then
        append(groupBtn, n)
      end if
    end if
  end repeat
  repeat with n in groupBtn
    sprite(n).member = member("cc.radiobutton.active.off")
  end repeat
  sprite(me.spriteNum).member = member("cc.radiobutton.active.on")
end
