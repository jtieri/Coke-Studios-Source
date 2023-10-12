property pStatus, pType, pClicked

on new me, type
  pStatus = #up
  pType = type
  return me
end

on mouseDown me
  pClicked = 1
  dontPassEvent()
end

on mouseUp me
  pClicked = 0
  if pStatus = #up then
    sendAllSprites(#setStatus, pType, #up)
    pStatus = #down
    sprite(me.spriteNum).member = member("cc.mixer." & pType & "button.on")
  else
    pStatus = #up
    sprite(me.spriteNum).member = member("cc.mixer." & pType & "button.active")
  end if
end

on mouseWithin me
  global TextMgr
  if (pStatus = #up) or (pType = "BURN") then
    mytext = TextMgr.GetRefText("MIXER_" & pType & "_ROLLOVER")
    member("cc.mixer.infofield.text").text = mytext
  else
    mytext = TextMgr.GetRefText("MIXER_NOW_" & pType & "ING")
    member("cc.mixer.infofield.text").text = mytext
  end if
end

on mouseLeave me
  global TextMgr
  mytext = TextMgr.GetRefText("MIXER_DESC")
  member("cc.mixer.infofield.text").text = mytext
end

on exitFrame me
  if the mouseDown and pClicked then
    sprite(me.spriteNum).member = member("cc.mixer." & pType & "button.pressed")
  end if
end

on setStatus me, whattype, whatstatus
  if whattype = pType then
    pStatus = whatstatus
    if pStatus = #up then
      sprite(me.spriteNum).member = member("cc.mixer." & pType & "button.active")
    else
      sprite(me.spriteNum).member = member("cc.mixer." & pType & "button.on")
    end if
  end if
end
