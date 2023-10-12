property bDebug
global ElementMgr

on new me
  bDebug = 0
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "closeCD" && "member:" && me.memberNum && sMessage
  end if
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  me.debug("mouseUp")
  CDPLAYER = ElementMgr.getcdplayer()
  CDPLAYER.closeWindow()
  dontPassEvent()
end
