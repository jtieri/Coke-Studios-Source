property sID, iPercentage
global oDenizenManager, ElementMgr

on beginSprite me
  ElementMgr.closeAllWindows()
  me.sID = "Checking Status"
  me.openLoader()
  me.iPercentage = 100
  script("_TIMER_").new(3000, #getStatus, me)
end

on exitFrame me
  me.updateLoader()
  go(the frame)
end

on getStatus me
  oDenizenManager.getStatus()
end

on studiosOpen me
  script("_TIMER_").new(500, #goNext, me)
end

on goNext me
  go(#next)
end

on studiosClosed me
  ElementMgr.alert("ALERT_STATE_CLOSED")
end

on studiosFull me
  ElementMgr.alert("ALERT_STATE_FULL")
end

on openLoader me
  getLoader().openWindow()
  me.updateLoader()
end

on closeLoader me
  getLoader().closeWindow()
end

on updateLoader me
  getLoader().displayStatus(me.sID, me.iPercentage)
end
