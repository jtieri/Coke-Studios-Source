global gMembersToDelete, sLanguageSetting, oIsoScene, bPreloadCasts, gCLOSING, oSession, ElementMgr, oStudioManager, oStudioMap, oDenizenManager

on prepareMovie
  member("Tip").text = EMPTY
  clearGlobals()
  if the runMode = "author" then
    castlist = ["internal", "entry", "cc_interface[1]", "cc_navigator[1]", "sf_gateway", "chatengine", "cc_room", "cc_furniture_small", "cc_catalogue[1]", "cc_messenger[1]", "avatarengine", "cc_furniture[1]", "isoengine", "soundlibrary", "people", "cc_items[1]", "sequencer", "mixer"]
    repeat with n = 2 to count(castlist)
      castLib(n).fileName = the moviePath & castlist[n] & ".cst"
    end repeat
  end if
  the actorList = []
  sLanguageSetting = "English"
  gMembersToDelete = []
  bPreloadCasts = 1
  gCLOSING = 0
  if the runMode <> "author" then
    the alertHook = script("SystemError")
  end if
  set the exitLock to 1
end

on startMovie
end

on stopMovie
  global oDenizenManager
  if not voidp(oDenizenManager) then
    oDenizenManager.logoutDenizen(oDenizenManager.getScreenName())
  end if
  if not voidp(oSession) then
    if oSession.getConnected() then
      oSession.disconnect()
    end if
  end if
  if the runMode = "Author" then
    repeat with i = 1 to the lastChannel
      puppetSprite(i, 0)
    end repeat
    if voidp(gMembersToDelete) = 0 then
      repeat with n in gMembersToDelete
        erase(member(n))
      end repeat
    end if
    repeat with n = 2 to the number of castLibs
      castLib(n).fileName = the moviePath & "Empty.cst"
    end repeat
  end if
  clearGlobals()
  the actorList = []
  pass()
end

on eraseMembers
  if the runMode = "Author" then
    if voidp(gMembersToDelete) = 0 then
      repeat with n in gMembersToDelete
        erase(member(n))
      end repeat
    end if
  end if
end

on getLoader
  global oLoader
  if voidp(oLoader) then
    oLoader = script("_LOADER_").new()
  end if
  return oLoader
end

on resetCasts bForce
  if (the runMode = "Author") and not (the shiftDown) then
    sEmpty = the moviePath & "Empty.cst"
    iLength = the number of castLibs
    repeat with i = 1 to iLength
      oCastLib = castLib(i)
      if voidp(bForce) then
        if (oCastLib.name = "Entry") or (oCastLib.name = "Gateway") or (oCastLib.name = "IsoEngine") or (oCastLib.name = "Messenger") then
          next repeat
        end if
      end if
      if oCastLib.name = "Internal" then
        next repeat
      end if
      oCastLib.fileName = sEmpty
    end repeat
  end if
end

on goToStudio sStudioID
  oDenizenManager.foDenizenManager.getTip()
  ElementMgr.closeAllWindows()
  if not voidp(oIsoScene) then
    oIsoScene.destroyScene()
  end if
  iLocation = oStudioManager.getStudioLocation(sStudioID)
  iLayout = oStudioManager.getStudioLayout(sStudioID, iLocation)
  sStudioName = oStudioManager.getStudioName(sStudioID)
  if sStudioID starts "$SYSTEM$" then
    put "calling doTrackingCokeStudios in Browser"
    sParamString = "javascript:doTrackingCokeStudios('cokestudios.room.enter', '" & sStudioID & "')"
    put "sParamString: " & sParamString
    gotoNetPage(sParamString)
  end if
  oStudioMap = script("StudioMap").new(iLocation, iLayout, sStudioID, sStudioName)
  go("EnterStudio")
end

on gotoEntry
  oDenizenManager.foDenizenManager.getTip()
  ElementMgr.closeAllWindows()
  if not voidp(oIsoScene) then
    oIsoScene.destroyScene()
  end if
  iLocation = 1
  iLayout = 1
  sStudioID = "$LOBBY$"
  sStudioName = "Front Door"
  oStudioMap = script("StudioMap").new(iLocation, iLayout, sStudioID, sStudioName)
  go("EnterLobby")
end
