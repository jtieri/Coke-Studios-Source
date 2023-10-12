property myMember, myMemberType, iMaxLength
global TextMgr

on new me
  myMember = member("nav_modify_studio_desc")
  myMemberType = #text
  me.iMaxLength = 168
  return me
end

on mouseDown me
  stopEvent()
end

on mouseUp me
  stopEvent()
end

on keyDown me
  Filter(me)
end

on Filter me
  if (the controlDown and (the keyCode = 9)) or (the commandDown and (the keyCode = 9)) then
    stopEvent()
    return 
  end if
  if the key = TAB then
    roomname = sendAllSprites(#getroomname)
    the keyboardFocusSprite = roomname
  else
    iLength = me.myMember.text.length
    bIsValidKeyCode = TextMgr.isValidKeyCode(the keyCode)
    bIsValidKey = TextMgr.isValidStudioKey(the key)
    if iLength >= me.iMaxLength then
      if bIsValidKeyCode then
        pass()
        return 
      else
        stopEvent()
        return 
      end if
    end if
    if bIsValidKey or bIsValidKeyCode then
      pass()
      return 
    else
      stopEvent()
      return 
    end if
  end if
end
