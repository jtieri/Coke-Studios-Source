property sID, iPercentage, bInit
global oDenizenManager, ElementMgr

on beginSprite me
  me.bInit = 0
  me.sID = "Loading Coke Studios"
  me.iPercentage = 100
end

on Init me
  me.openLoader()
  sEncodedScreenName = externalParamValue("sw1")
  sKey = EMPTY
  sSessionID = externalParamValue("sw2")
  sDecodedScreenName = oDenizenManager.decodeString(sEncodedScreenName)
  put "sEncodedScreenName: " & sEncodedScreenName
  put "sDecodedScreenName: " & sDecodedScreenName
  put "sKey: " & sKey
  put "sDecodedScreenName: " & sDecodedScreenName
  put "sSessionID: " & sSessionID
  oDenizenManager.setScreenName(sDecodedScreenName)
  oDenizenManager.loginDenizen(sSessionID)
end

on exitFrame me
  if not me.bInit then
    me.bInit = 1
    me.Init()
  end if
  go(the frame)
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
