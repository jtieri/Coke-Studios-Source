property iLocation, iLayout, aAssets, aLayouts, sDefaultAsset, iPublicRoomLayoutIndex, sStudioID, sStudioName, foGameServer, bDebug, bEnterStudioViaTeleport, iDestinationId

on new me, _iLocation, _iLayout, _sStudioId, _sStudioName
  bDebug = 1
  me.debug("new StudioMap() " & ", _iLocation:" & _iLayout && ", _iLayout:" & _iLayout && ", _sStudioId:" & _sStudioId && ", _sStudioName:" & _sStudioName)
  me.sStudioID = _sStudioId
  me.sStudioName = _sStudioName
  me.bEnterStudioViaTeleport = 0
  me.iDestinationId = VOID
  me.sDefaultAsset = "cc_studio"
  me.iPublicRoomLayoutIndex = 5
  me.aAssets = []
  me.aAssets.add("london")
  me.aAssets.add("miami")
  me.aAssets.add("mombasa")
  me.aAssets.add("newyork")
  me.aAssets.add("rio")
  me.aAssets.add("seattle")
  me.aAssets.add("sydney")
  me.aAssets.add("tokyo")
  me.aAssets.add("goa")
  me.aAssets.add("alaska")
  me.aAssets.add("moscow")
  me.aAssets.add("redroom")
  me.aAssets.add("sanfrancisco")
  me.aAssets.add("centralpark")
  me.aAssets.add("neworleans")
  me.aAssets.add("mexico")
  me.aAssets.add("atlantis")
  me.aAssets.add("secretroom")
  me.aAssets.add("castingcallroom")
  me.aAssets.add("auditiongold")
  me.aAssets.add("auditiongreen")
  me.aAssets.add("auditionorange")
  me.aAssets.add("auditionred")
  me.aLayouts = []
  me.aLayouts.add("Studio_A")
  me.aLayouts.add("Studio_D")
  me.aLayouts.add("Studio_C")
  me.aLayouts.add("Studio_B")
  me.aLayouts.add("SceneXml")
  me.aLayouts.add("Star_Suite")
  me.aLayouts.add("Studio_E")
  me.aLayouts.add("Studio_F")
  me.aLayouts.add("Studio_G")
  me.aLayouts.add("Personal_Suite")
  me.iLocation = _iLocation
  me.iLayout = _iLayout
  return me
end

on setGameServer me, _foGameServer
  me.foGameServer = _foGameServer
end

on getGameServer me
  return me.foGameServer
end

on isPrivate me
  if me.iLayout = me.iPublicRoomLayoutIndex then
    return 0
  else
    return 1
  end if
end

on isWayneEnt me
  return (me.iLayout >= 7) and (me.iLayout <= 10)
end

on getStudioID me
  return me.sStudioID
end

on getStudioName me
  return me.sStudioName
end

on getWindowName me
  return me.aAssets[me.iLocation]
end

on getLocation me
  return me.iLocation
end

on getAsset me
  me.debug("getAsset() me.iLayout: " & me.iLayout)
  me.debug("aAssets: " & me.aAssets)
  me.debug("iLocation: " & me.iLocation)
  if me.iLayout = me.iPublicRoomLayoutIndex then
    sAsset = me.aAssets[me.iLocation]
    if the runMode = "author" then
      if the platform contains "mac" then
        sPath = the moviePath & "publicrooms:" & sAsset
      else
        sPath = the moviePath & "publicrooms\" & sAsset
      end if
    else
      sPath = the moviePath & "publicrooms/" & sAsset
    end if
    return sPath
  else
    sPath = the moviePath & me.sDefaultAsset
    return sPath
  end if
end

on getSceneXml me
  return me.aLayouts[me.iLayout]
end

on getMapXml me
  if me.iLayout <> me.iPublicRoomLayoutIndex then
    sMapXml = me.getSceneXml() & "_MapXml"
    return sMapXml
  else
    return "MapXml"
  end if
end

on getEntryXml me
  if me.iLayout <> me.iPublicRoomLayoutIndex then
    sMapXml = me.getSceneXml() & "_EntryXml"
    return sMapXml
  else
    return "EntryXml"
  end if
end

on getUseDiagonals me
  if me.iLayout <> me.iPublicRoomLayoutIndex then
    return 0
  else
    return 1
  end if
end

on getAvatarScale me
  if me.iLayout <> me.iPublicRoomLayoutIndex then
    return 100
  else
    return 57
  end if
end

on setEnterStudioViaTeleport me, _iDestinationId
  me.bEnterStudioViaTeleport = 1
  me.iDestinationId = _iDestinationId
end

on cancelEnterStudioViaTeleport me
  me.bEnterStudioViaTeleport = 0
  me.iDestinationId = VOID
end

on getEnterStudioViaTeleport me
  return me.bEnterStudioViaTeleport
end

on getDestinationId me
  return me.iDestinationId
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "StudioMap: " & sMessage
  end if
end
