property iMaxLength
global oIsoScene, TextMgr

on new me
  global ochat, ElementMgr
  if voidp(ochat) then
    MyNum = ElementMgr.LastUsedSprite()
    ochat = new(script("chatrenderer"), MyNum, 1000000)
  else
    ochat.showChat()
  end if
  me.iMaxLength = 65
  return me
end

on exitFrame me
end

on keyDown me
  me.Filter()
end

on Filter me
  iLength = sprite(me.spriteNum).member.text.length
  bIsValidKeyCode = TextMgr.isValidKeyCode(the keyCode)
  bIsValidKey = TextMgr.isValidChatKey(the key)
  oLoc = sprite(me.spriteNum).member.charPosToLoc(iLength)
  bIsValidPos = oLoc.locH <= 317
  if (the controlDown and (the keyCode = 9)) or (the commandDown and (the keyCode = 9)) then
    stopEvent()
    return 
  end if
  if (the key = RETURN) or (the key = ENTER) then
    me.sendChat(sprite(me.spriteNum).member.text)
    stopEvent()
    return 
  end if
  if (iLength >= me.iMaxLength) or not bIsValidPos then
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
end

on sendChat me, sMessage
  global ochat, oDenizenManager, oStudio
  if sMessage = EMPTY then
    return 
  end if
  if sMessage = " " then
    return 
  end if
  sprite(me.spriteNum).member.text = EMPTY
  myspeechmode = string(sendAllSprites(#getSpeechMode))
  oStudio.sendStudioChat(sMessage, myspeechmode)
  if myspeechmode = "shout" then
    sendAllSprites(#setSpeechMode, #speak)
  end if
end
