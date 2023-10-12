property myMember, myMemberType, iMaxLength
global TextMgr

on new me
  myMember = member("nav_modify_studio_name")
  myMemberType = #text
  me.iMaxLength = 25
  return me
end

on keyDown me
  Filter(me)
end

on mouseDown me
  stopEvent()
end

on mouseUp me
  stopEvent()
end

on getroomname me
  return me.spriteNum
end

on Filter me
  if (the controlDown and (the keyCode = 9)) or (the commandDown and (the keyCode = 9)) then
    stopEvent()
    return 
  end if
  if the key = TAB then
    pass()
    if the keyboardFocusSprite = 1 then
      roomDesc = sendAllSprites(#getroomdesc)
      the keyboardFocusSprite = roomDesc
    end if
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

on Insert me, theKey
  startChar = the selStart
  if startChar = the selEnd then
    if myMemberType = #field then
      put theKey after char startChar of field myMember
    else
      theText = myMember.text
      put theKey after char startChar of theText
      myMember.text = theText
    end if
  else
    myMember.char[startChar + 1..the selEnd] = theKey
  end if
  set the selEnd to startChar + 1
  set the selStart to startChar + 1
  stopEvent()
end
