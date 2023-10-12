property oRemoteControlCamera

on new me, iSprite, oController
  me.oRemoteControlCamera = script("RemoteControlCamera").new(iSprite)
  me.oRemoteControlCamera.Init()
  return me
end

on startPerformance me
  me.oRemoteControlCamera.startPerformance()
end

on stopPerformance me
  me.oRemoteControlCamera.stopPerformance()
end

on destroy me
  me.oRemoteControlCamera.destroy()
end
