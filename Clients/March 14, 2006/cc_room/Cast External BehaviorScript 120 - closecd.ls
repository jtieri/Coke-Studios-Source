property bDebug
global oStudio, ElementMgr

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
  ElementMgr.getcdplayer().closeWindow()
  oStudio.sendCdStop()
  dontPassEvent()
end
