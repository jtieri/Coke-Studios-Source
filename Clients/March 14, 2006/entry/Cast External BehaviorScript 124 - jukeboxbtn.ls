global oDenizenManager

on new me
  return me
end

on mouseUp me
  global ElementMgr
  if voidp(ElementMgr.oJukebox) then
    oDenizenManager.isFTMmember()
  else
    if voidp(ElementMgr.oJukebox.getOpenWindow()) then
      oDenizenManager.isFTMmember()
    else
      ElementMgr.oJukebox.closeWindow()
    end if
  end if
end
