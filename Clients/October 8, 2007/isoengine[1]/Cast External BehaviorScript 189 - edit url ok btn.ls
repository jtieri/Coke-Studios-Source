property pParentWindow

on new me, oCaller
  pParentWindow = oCaller
  return me
end

on mouseUp me
  global oDenizenManager, oIsoScene
  sScreenName = oDenizenManager.getScreenName()
  sKey = oDenizenManager.getDenizen().getSecret()
  iPosId = oIsoScene.oInfoStand.oItem.getPosId()
  sUrl = member("Enter_url").text
  if not (sUrl starts "http://") then
    sUrl = "http://" & sUrl
  end if
  oDenizenManager.updateBulletinURL(sScreenName, sKey, iPosId, sUrl)
  pParentWindow.closeWindow()
end
