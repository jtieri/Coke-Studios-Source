property pSprite, pAction
global oCallAlertDisplayManager

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pAction] = [#comment: "Action:", #format: #string, #default: "BEEP", #range: ["BEEP", "nothing", "displayCalls(me)", "displayAlerts(me)", "displayBoth(me)"]]
  return mylist
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
end

on mouseUp me
  do(pAction)
end

on displayCalls me
  oCallAlertDisplayManager.pCallAlertList = oCallAlertDisplayManager.aCallList
  oCallAlertDisplayManager.displayCallAlert(oCallAlertDisplayManager.pCallAlertList)
end

on displayAlerts me
  oCallAlertDisplayManager.pCallAlertList = oCallAlertDisplayManager.aAlertList
  oCallAlertDisplayManager.displayCallAlert(oCallAlertDisplayManager.pCallAlertList)
end

on displayBoth me
  oCallAlertDisplayManager.pCallAlertList = oCallAlertDisplayManager.aCallAlertList
  oCallAlertDisplayManager.displayCallAlert(oCallAlertDisplayManager.pCallAlertList)
end
