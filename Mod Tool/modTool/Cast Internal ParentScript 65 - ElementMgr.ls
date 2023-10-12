property pPublicStudioData, pPrivateStudioData, pModList, aUserData, aStudioDetailData, bDebug
global ElementMgr, oPublicDisplayManager, oPrivateDisplayManager, oStudioManager, oUserDisplayManager, oDenizenManager, oSession, oEditStudioManager, oLogInManager, sModScreenName

on new me
  pModList = []
  ElementMgr = me
  me.bDebug = 0
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "ModTool: ElementMgr: " & sMessage
  end if
end

on displayPublicStudios me, aPublicStudioData
  me.debug("displayPublicStudios:aPublicStudioData:" && aPublicStudioData)
  pPublicStudioData = aPublicStudioData.duplicate()
  repeat with i = 1 to pPublicStudioData.count
    pPublicStudioData[i][#mods] = []
  end repeat
  repeat with m = 1 to pModList.count
    repeat with i = 1 to pPublicStudioData.count
      if pModList[m].studioId = pPublicStudioData[i].studioId then
        pPublicStudioData[i][#mods] = pModList[m].mods
      end if
    end repeat
  end repeat
  oPublicDisplayManager.displayPublic_Mod(pPublicStudioData)
end

on displayPrivateStudios me, aPrivateStudioData
  me.debug("displayPrivateStudios:aPrivateStudioData:" && aPrivateStudioData)
  pPrivateStudioData = aPrivateStudioData.duplicate()
  repeat with i = 1 to pPrivateStudioData.count
    pPrivateStudioData[i][#mods] = []
  end repeat
  repeat with m = 1 to pModList.count
    repeat with i = 1 to pPrivateStudioData.count
      if pModList[m].studioId = pPrivateStudioData[i].studioId then
        pPrivateStudioData[i][#mods] = pModList[m].mods
      end if
    end repeat
  end repeat
  oPrivateDisplayManager.displayPrivate_Mod(pPrivateStudioData)
end

on createModList me, sModName, sStudioID
  me.debug("createModList:sModName:" && sModName && "sStudioID:" && sStudioID)
  repeat with i = 1 to pModList.count
    if pModList[i].studioId = sStudioID then
      pModList[i].mods.add(sModName)
      return 
    end if
  end repeat
  aNewStudioList = [:]
  aNewStudioList[#studioId] = sStudioID
  aNewStudioList[#mods] = []
  aNewStudioList.mods.add(sModName)
  pModList.add(aNewStudioList)
end

on startModStudio me, sModName, sStudioID
  me.debug("startModStudio:sModName:" && sModName && "sStudioID:" && sStudioID)
  createModList(me, sModName, sStudioID)
end

on stopModStudio me, sModName, sStudioID
  me.debug("stopModStudio:sModName:" && sModName && "sStudioID:" && sStudioID)
  repeat with i = 1 to pModList.count
    if pModList[i].studioId = sStudioID then
      pModList[i][#mods].deleteOne(sModName)
    end if
  end repeat
end

on getDenizenByScreenName_Result me, iError, sScreenName, oLastAccess, sLastSeenIn, sAvatarMission, sAvatarString, bOnline, bExists, sLastSeenInName, iGender
  me.debug("getDenizenByScreenName_Result:iError:" && iError && "sScreenName:" && sScreenName && "oLastAccess:" && oLastAccess && "sLastSeenIn:" && sLastSeenIn && "sAvatarMission:" && sAvatarMission && "sAvatarString:" && sAvatarString && "bOnline:" && bOnline && "bExists:" && bExists && "sLastSeenInName:" && sLastSeenInName && "iGender:" && iGender)
  aUserData = [:]
  aUserData[#error] = iError
  aUserData[#denizenName] = sScreenName
  if oLastAccess = VOID then
    oLastAccess = EMPTY
  end if
  aUserData[#lastAccess] = oLastAccess
  aUserData[#mission] = sAvatarMission
  aUserData[#avatarString] = sAvatarString
  aUserData[#online] = bOnline
  aUserData[#exists] = bExists
  aUserData[#gender] = iGender
  aUserData[#studioId] = sLastSeenIn
  aUserData[#studioName] = sLastSeenInName
  aUserData[#owner] = "studioOwner"
  repeat with i = 1 to aUserData.count
    if voidp(aUserData[i]) then
      aUserData[i] = EMPTY
    end if
  end repeat
  if the frameLabel = "logIn" then
    nothing()
  else
    oUserDisplayManager.displayUser(aUserData, me)
  end if
end

on loginModerator_Result me, iError
  me.debug("loginModerator_Result:iError:" && iError)
  put "loginModerator_Result() " & iError
  oLogInManager.confirmLogIn(iError, member("userNameLogIn").text)
end

on getExtendedDenizenInfo_Result me, iError, sScreenName, sAvatarMission, aLevelList, iPossessions_purchased, iPossessions_total, iPossessions_backpack, bInfluencer, iLogInTotal
  me.debug("getExtendedDenizenInfo_Result:iError:" && iError && "sScreenName:" && sScreenName && "sAvatarMission:" && sAvatarMission && "aLevelList:" && aLevelList && "iPossessions_purchased:" && iPossessions_purchased && "iPossessions_total:" && iPossessions_total && "iPossessions_backpack:" && iPossessions_backpack && "bInfluencer:" && bInfluencer && "iLogInTotal:" && iLogInTotal)
  aUserData = [:]
  aUserData[#denizenName] = sScreenName
  aUserData[#mission] = sAvatarMission
  aUserData[#studioName] = "studioName"
  aUserData[#owner] = "studioOwner"
  aUserData[#denizenLevel] = aLevelList
  aUserData[#bought] = iPossessions_purchased
  aUserData[#owned] = iPossessions_total
  aUserData[#onHand] = iPossessions_backpack
  aUserData[#influencer] = bInfluencer
  aUserData[#logInTotal] = iLogInTotal
  oUserDisplayManager.displayUser(aUserData)
end

on displayStudioDetail me, aStudio
  me.debug("displayStudioDetail:aStudio:" && aStudio)
  repeat with i = 1 to aStudio.count
    if voidp(aStudio[i]) then
      aStudio[i] = EMPTY
    end if
  end repeat
  aStudioDetailData = aStudio
end

on modifyStudio_Result me, iError, sStudioName, sDescription
  me.debug("modifyStudio_Result:iError:" && iError && "sStudioName:" && sStudioName && "sDescription:" && sDescription)
  case iError of
    0:
    (-1):
      alert("Failed: " & iError)
    (-6):
      alert("User not found: " & iError)
    (-7):
      alert("Name has foul language: " & iError)
    (-8):
      alert("Description has foul language: " & iError)
    (-9):
      alert("User has 6 or more studios: " & iError)
    otherwise:
      alert("Failed: exception error.")
  end case
  oEditStudioManager.receiveModifyStudioResult(iError, sStudioName, sDescription)
end

on getByStudioId_Result me, iError, foStudio
  me.debug("getByStudioId_Result:iError:" && iError && "foStudio:" && foStudio)
  if iError <> 0 then
    alert("Error: getByStudioID:" && iError)
  end if
  sOwnerName = foStudio.getOwnerName()
  me.debug("getByStudioId_Result:sOwnerName:" && sOwnerName)
  oUserDisplayManager.receiveGetByStudioId_Result(sOwnerName)
end

on getModeratorsOnline_Result me, aMods
  me.debug("getModeratorsOnline_Result() aMods: " & aMods, 1)
  sendAllSprites(#displayModsLoggedIn, aMods)
end

on isPublicStudioWindowOpen me
  return 0
end

on isPrivateStudioWindowOpen me
  return 0
end

on getOpenWindowNames me
  aList = []
  return aList
end
