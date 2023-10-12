on new me
  return me
end

on mouseWithin me
  global TextMgr
  member("cc.tradinghelptext").text = TextMgr.GetRefText("TRADEE_AGREES")
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  global oStudio
  if the runMode = "author" then
    testval = 1
  else
    testval = 0
  end if
  testval = 0
  if sprite(me.spriteNum).member = member("cc.interface.checkbox.active.off") then
    oStudio.sendAgreeTrade(testval)
  else
    oStudio.sendDisagreeTrade(testval)
  end if
  dontPassEvent()
end

on getrightcheckbox me
  return me.spriteNum
end
