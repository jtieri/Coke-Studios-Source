global ElementMgr

on getdrawerbutton me
  return me.spriteNum
end

on mouseUp me
  ElementMgr.decisiondialog("ALERT_LEAVE_SF", "go to FTM ok")
end
