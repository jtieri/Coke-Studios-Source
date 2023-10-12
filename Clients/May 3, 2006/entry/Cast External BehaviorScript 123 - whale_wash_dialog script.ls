property sButton, bExit
global ElementMgr, bExitToWhaleWash

on new me, callerID, sID
  me.sButton = sID
  if me.sButton contains "OK" then
    me.bExit = 1
  else
    me.bExit = 0
  end if
  return me
end

on mouseUp me
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n) contains "whale_wash" then
      bExitToWhaleWash = me.bExit
      ElementMgr.pOpenWindows[n].closeWindow()
      exit repeat
    end if
  end repeat
end
