property oRemoteControlCamera

on new me, iSprite, oController
  me.oRemoteControlCamera = script("RemoteControlCamera").new(iSprite)
  me.oRemoteControlCamera.init()
  return me
end

on destroy me
  me.oRemoteControlCamera.destroy()
end
