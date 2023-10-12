property pSprite, pAction
global oCallAlertDisplayManager

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pAction] = [#comment: "Action:", #format: #string, #default: "BEEP", #range: ["BEEP", "nothing", "prevCall(me)", "nextCall(me)"]]
  return mylist
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
end

on mouseDown me
  do(pAction)
end

on mouseWithin me
  if the stillDown and (the lastClick > (0.5 * 60)) then
    do(pAction)
  end if
end

on prevCall me
  if (oCallAlertDisplayManager.iCallAlertNum - 1) > 0 then
    oCallAlertDisplayManager.iCallAlertNum = oCallAlertDisplayManager.iCallAlertNum - 1
  else
    oCallAlertDisplayManager.iCallAlertNum = oCallAlertDisplayManager.iCallAlertTotalNum
  end if
  oCallAlertDisplayManager.displayCallAlert(oCallAlertDisplayManager.pCallAlertList)
end

on nextCall me
  if (oCallAlertDisplayManager.iCallAlertNum + 1) > oCallAlertDisplayManager.iCallAlertTotalNum then
    oCallAlertDisplayManager.iCallAlertNum = 1
  else
    oCallAlertDisplayManager.iCallAlertNum = oCallAlertDisplayManager.iCallAlertNum + 1
  end if
  oCallAlertDisplayManager.displayCallAlert(oCallAlertDisplayManager.pCallAlertList)
end
