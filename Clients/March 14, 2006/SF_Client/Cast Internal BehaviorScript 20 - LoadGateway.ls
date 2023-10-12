property sID, iPercentage
global oStudioManager, oDenizenManager, oCatalogManager, oPossessionManager

on beginSprite me
  me.sID = "Loading Coke Studios"
  me.iPercentage = 100
  me.openLoader()
end

on exitFrame me
  bSMReady = oStudioManager.bReadyForuse
  bDMReady = oDenizenManager.bReadyForuse
  bCMReady = oCatalogManager.bReadyForuse
  bPMReady = oPossessionManager.bReadyForuse
  sStats = "Loading Session Beans" & RETURN
  sStats = sStats & "StudioManager: " & bSMReady & RETURN
  sStats = sStats & "DenizenManager: " & bDMReady & RETURN
  sStats = sStats & "CatalogManager: " & bCMReady & RETURN
  sStats = sStats & "PossessionManager: " & bPMReady & RETURN
  if bSMReady and bDMReady and bCMReady and bPMReady then
    me.closeLoader()
    go(#next)
  else
    go(the frame)
  end if
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
