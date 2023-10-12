global gFeatureSet, ElementMgr

on new me
  return me
end

on mouseUp me
  global ElementMgr
  oMessenger = ElementMgr.getMessengerObject()
  if not voidp(oMessenger.getOpenWindow()) then
    oMessenger.closeWindow()
  else
    if gFeatureSet.isEnabled(#MESSENGER) then
      oMessenger.openMyInfo()
    else
      ElementMgr.alert("FEATURE_DISABLED")
    end if
  end if
end

on setMessengerBlink me, bState
  if bState then
    sprite(me.spriteNum).setStatus(#blink)
  else
    sprite(me.spriteNum).setStatus(#idel)
  end if
end
