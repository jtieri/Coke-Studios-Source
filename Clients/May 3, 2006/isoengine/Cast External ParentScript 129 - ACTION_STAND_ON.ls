property ancestor, bOn, bDebug

on new me, _oItem, aAttributes
  me.bDebug = 1
  me.debug("new()")
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  me.bOn = 0
  return me
end

on standOn me
  me.debug("standOn()", 1)
  if me.bOn then
    return 
  end if
  me.bOn = 1
  me.startAnimation()
end

on turnOff me, bDontSendUpdate
  me.bOn = 0
  me.stopAnimation()
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "isoengine::ACTION_STAND_ON::" & sMessage
  end if
end
