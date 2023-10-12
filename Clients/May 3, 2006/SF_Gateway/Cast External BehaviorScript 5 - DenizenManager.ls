property bDebug, bInitialized, bReadyForuse, foDenizenManager, aPrivateStudioData, fo_level0, ERROR_TYPE, ARRAY_TYPE, STUDIO_TYPE, sUserScreenName, sDefaultScreenName, foDenizen, bIsModerator, bisFTMmember, foLoginServlet, foStatusServlet, iCokesDrank, foBackpack, plNetworkErrors, sUrl, iNetID, iTries, aGenders
global sLanguageSetting, oDenizenManager, oPossessionManager, ElementMgr, gbTestMode, TextMgr, gFeatureSet, oStudio, oLoader

on beginSprite me
  me.iCokesDrank = 0
  me.bDebug = 0
  me.bInitialized = 0
  me.bReadyForuse = 0
  aGenders = [[#name: "UNDEFINED", #abbreviation: EMPTY], [#name: "MALE", #abbreviation: "M"], [#name: "FEMALE", #abbreviation: "F"], [#name: "UNSPECIFIED", #abbreviation: "?"]]
  me.ERROR_TYPE = "FlashReturnStatusEnum"
  me.ARRAY_TYPE = "Array"
  me.STUDIO_TYPE = "Studio"
  me.sUserScreenName = VOID
  me.sDefaultScreenName = TextMgr.GetRefText("LOCAL_SCREEN_NAME")
  me.bIsModerator = 0
  oDenizenManager = me
  createNetworkErrorArray(me)
  script("_TIMER_").new(500, #Init, me)
end

on Init me
  me.debug("init()")
  me.foDenizenManager = sprite(me.spriteNum).getVariable("_level0.oDenizenManager", 0)
  me.foLoginServlet = sprite(me.spriteNum).getVariable("_level0.oLoginServlet", 0)
  me.foStatusServlet = sprite(me.spriteNum).getVariable("_level0.oStatusServlet", 0)
  me.setCallbacks()
  me.fo_level0 = sprite(me.spriteNum).getVariable("_level0", 0)
  me.foDenizenManager.bDebug = 0
  me.foDenizenManager.bTestMode = 0
  if the runMode = "Author" then
    me.bReadyForuse = 1
  else
    me.foDenizenManager.createGateway(me.fo_level0.getGatewayConnection())
  end if
  me.bInitialized = 1
end

on getGenderOrdinal me, sGender
  repeat with i = 1 to aGenders.count
    if (sGender = aGenders[i].name) or (sGender = aGenders[i].abbreviation) then
      return i - 1
    end if
  end repeat
  return -1
end

on setCallbacks me
  sprite(me.spriteNum).setCallback(me.foLoginServlet, "getScreenName_Result", #getLoginScreenName_Result, me)
  sprite(me.spriteNum).setCallback(me.foStatusServlet, "getStatus_Result", #getStatus_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "beanCreated", #beanCreated, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "loginDenizen_Result", #loginDenizen_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "loginModerator_Result", #loginModerator_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "logoutDenizen_Result", #logoutDenizen_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "modifyDenizen_Result", #modifyDenizen_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getDenizenByScreenName_Result", #getDenizenByScreenName_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getDenizenBalance_Result", #getDenizenBalance_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "isModerator_Result", #isModerator_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getModeratorsOnline_Result", #getModeratorsOnline_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getExtendedDenizenInfo_Result", #getExtendedDenizenInfo_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getMessenger2_Result", #getMessenger2_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getOnlineFriends_Result", #getOnlineFriends_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getMessages_Result", #getMessages_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getInvites_Result", #getInvites_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getFriends_Result", #getFriends_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "sendMessage_Result", #sendMessage_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "removeMessage_Result", #removeMessage_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "rejectInvitation_Result", #rejectInvitation_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "acceptInvitation_Result", #acceptInvitation_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "inviteFriend_Result", #inviteFriend_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "removeFriends_Result", #removeFriends_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getGenres_result", #getgenres_result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getArtistsByGenre_Result", #getArtistsByGenre_result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getSongsByArtist_Result", #getSongsByArtist_result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getPlaylist_Result", #getPlaylist_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "addToPlaylist_Result", #addToPlaylist_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "removeFromPlaylist_Result", #removeFromPlaylist_Result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "isFtmMember_result", #isFtmMember_result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getAvailableTokens_result", #getAvailableTokens_result, me)
  sprite(me.spriteNum).setCallback(me.foDenizenManager, "getTip_Result", #getTip_Result, me)
end

on beanCreated me
  me.debug("beanCreated()")
  me.bReadyForuse = 1
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "DenizenManager: " & sMessage
  end if
end

on decodeString me, sEncodedString
  return me.fo_level0.oEncoder.decode(sEncodedString)
end

on encodeString me, sDecodedString
  return me.fo_level0.oEncoder.encode(sDecodedString)
end

on getStatus me
  put RETURN & RETURN
  put "***************************"
  put "--> RETRIEVING STATUS **"
  me.debug("getStatus()")
  if gbTestMode then
    me.getStatus_Result(0, 0, 2000, "Open")
    return 
  end if
  me.foStatusServlet.getStatus(the milliSeconds)
end

on getLoginScreenName me
  me.debug("getLoginScreenName()")
  if gbTestMode then
    me.loginDenizen_Result()
    return 
  end if
  me.foLoginServlet.getScreenName()
end

on loginDenizen me, sSessionID
  put RETURN & RETURN
  put "******************************"
  put "--> LOGIN DENIZEN: " & sSessionID
  me.debug("loginDenizen() " & sSessionID)
  if gbTestMode then
    me.loginDenizen_Result()
    return 
  end if
  sUrl = sprite(me.spriteNum).getVariable("_level0.sDefaultLoginDenizenServer", 0)
  iTries = 0
  if stringp(sUrl) then
    sUrl = sUrl & "?sid" & urlEncode([EMPTY: sSessionID])
    iNetID = getNetText(sUrl)
  end if
end

on exitFrame me
  if not voidp(iNetID) then
    if netDone(iNetID) then
      sXMLstream = netTextresult(iNetID)
      if (netError(iNetID) <> "OK") or (sXMLstream = EMPTY) or (sXMLstream = RETURN) or (sXMLstream = (" " & RETURN)) or (sXMLstream = (RETURN & " ")) then
        if iTries < 3 then
          iNetID = VOID
          iNetID = getNetText(sUrl)
          iTries = iTries + 1
          if the debugPlaybackEnabled then
            put "Network error: the XML stream for the denizen login was empty."
            put "Trying again: attempt #" & iTries & RETURN & "Connecting..."
          end if
        else
          ElementMgr.alert("ALERT_GENERIC")
          iNetID = VOID
        end if
      else
        me.foDenizenManager.loginDenizen(sXMLstream)
        iNetID = VOID
      end if
    end if
  end if
end

on createNetworkErrorArray me
  me.plNetworkErrors = [:]
  me.plNetworkErrors.addProp(4, "Bad MOA class. The required network or nonnetwork Xtra extensions are improperly installed or not installed at all.")
  me.plNetworkErrors.addProp(5, "Bad MOA Interface.")
  me.plNetworkErrors.addProp(6, "Bad URL or Bad MOA class. The required network or nonnetwork Xtra extensions are improperly installed or not installed at all.")
  me.plNetworkErrors.addProp(20, "Internal error. Returned by netError() in the Netscape browser if the browser detected a network or internal error.")
  me.plNetworkErrors.addProp(4146, "Connection could not be established with the remote host.")
  me.plNetworkErrors.addProp(4149, "Data supplied by the server was in an unexpected format.")
  me.plNetworkErrors.addProp(4150, "Unexpected early closing of connection.")
  me.plNetworkErrors.addProp(4154, "Operation could not be completed due to timeout.")
  me.plNetworkErrors.addProp(4155, "Not enough memory available to complete the transaction.")
  me.plNetworkErrors.addProp(4156, "Protocol reply to request indicates an error in the reply.")
  me.plNetworkErrors.addProp(4157, "Transaction failed to be authenticated.")
  me.plNetworkErrors.addProp(4159, "Invalid URL.")
  me.plNetworkErrors.addProp(4164, "Could not create a socket.")
  me.plNetworkErrors.addProp(4165, "Requested object could not be found (URL may be incorrect).")
  me.plNetworkErrors.addProp(4166, "Generic proxy failure.")
  me.plNetworkErrors.addProp(4167, "Transfer was intentionally interrupted by client.")
  me.plNetworkErrors.addProp(4242, "Download stopped by netAbort(url).")
  me.plNetworkErrors.addProp(4836, "Download stopped for an unknown reason, possibly a network error, or the download was abandoned.")
end

on loginModerator me, sScreenName, sPassword
  me.debug("loginModerator() " & sScreenName && sPassword)
  if gbTestMode then
    script("_TIMER_").new(1000, #loginModerator_Result, ElementMgr, 0)
    return 
  end if
  me.foDenizenManager.loginModerator(sScreenName, sPassword)
end

on logoutDenizen me, sScreenName
  me.debug("logoutDenizen()")
  if gbTestMode then
    me.logoutDenizen_Result()
    return 
  end if
  me.foDenizenManager.logoutDenizen(sScreenName, me.getDenizen.getSecret())
end

on modifyDenizen me, sScreenName, iGender, sAvatarMission, sAvatarString
  me.debug("modifyDenizen() " && sScreenName && iGender && sAvatarMission && sAvatarString)
  if gbTestMode then
    me.debug("modifyDenizen_Result(0)")
    if not voidp(ElementMgr) then
      ElementMgr.modifyDenizen_Result(0)
    end if
    return 
  end if
  me.foDenizenManager.modifyDenizen(sScreenName, iGender, sAvatarMission, sAvatarString)
end

on getDenizenByScreenName me, sScreenName
  me.debug("getDenizenByScreenName()")
  if gbTestMode then
    iError = 0
    sScreenName = sScreenName
    oLastAccess = newObject("Date")
    sLastSeenIn = "Some Room"
    sLastSeenInName = "Some room"
    sAvatarMission = "to test"
    sAvatarString = "hr=003/238,238,238&hd=001/245,226,203&ey=004/245,226,203&fc=001/245,226,203&bd=001/245,226,203&lh=001/245,226,203&rh=001/245,226,203&ch=001/238,238,238&ls=002/238,238,238&rs=002/238,238,238&lg=001/127,102,64&sh=001/194,123,56"
    bOnline = 1
    bExists = 1
    iGender = 1
    me.debug("getDenizenByScreenName_Result()  screenName: " & sScreenName & ", lastAccess: " & oLastAccess & ", lastSeen: " & sLastSeenIn & ", avatarMission: " & sAvatarMission & ", sAvatarString: " & sAvatarString & ", bOnline: " & bOnline & ", bExists: " & bExists & ", sLastSeenInName: " & sLastSeenInName & ", iGender: " & iGender)
    if not voidp(ElementMgr) then
      ElementMgr.getDenizenByScreenName_Result(iError, sScreenName, oLastAccess, sLastSeenIn, sAvatarMission, sAvatarString, bOnline, bExists, sLastSeenInName, iGender)
    end if
    return 
  end if
  me.foDenizenManager.getDenizenByScreenName(sScreenName)
end

on getDenizenBalance me, sScreenName
  me.debug("getDenizenBalance() " & sScreenName)
  if gbTestMode then
    iError = 0
    iBalance = random(1000) + 1000
    me.debug("getDenizenBalance_Result() iError: " & iError & ", iBalance: " & iBalance)
    if not voidp(ElementMgr) then
      ElementMgr.getDenizenBalance_Result(iError, iBalance)
    end if
    return 
  end if
  me.foDenizenManager.getDenizenBalance(sScreenName, me.getDenizen().getSecret())
end

on isModerator me, sScreenName
  if gbTestMode then
    me.bIsModerator = 1
    return 
  end if
  me.foDenizenManager.isModerator(sScreenName, me.getDenizen().getSecret())
end

on getModeratorsOnline me
  me.debug("getModeratorsOnline() ", 1)
  me.foDenizenManager.getModeratorsOnline(me.getDenizen().getScreenName(), me.getDenizen().getSecret())
end

on getOnlineFriends me, aToScreenNameList
  me.debug("getOnlineFriends_Result() " & aToScreenNameList)
  if gbTestMode then
    return 
  end if
  faToScreenNameList = newObject("Array")
  repeat with _sScreenName in aToScreenNameList
    faToScreenNameList.push(_sScreenName)
  end repeat
  me.foDenizenManager.getOnlineFriends(me.getScreenName(), me.getDenizen().getSecret(), faToScreenNameList)
end

on getMessenger me, sScreenName, iFriendListSize, iEnemyListSize, iInviteListSize, iMessageListSize
  me.debug("getMessenger() " && sScreenName && iFriendListSize && iEnemyListSize && iInviteListSize && iMessageListSize, 1)
  put "Parameters:" & RETURN
  put "sScreenName:" && sScreenName
  put "iFriendListSize: " && iFriendListSize
  put "iEnemyListSize:" && iEnemyListSize
  put "iInviteListSize:" && iInviteListSize
  put "iMessageListSize:" && iMessageListSize
  if not gFeatureSet.isEnabled(#MESSENGER) then
    return 
  end if
  if voidp(sScreenName) then
    sScreenName = me.getScreenName()
  end if
  iFriendListSize = 50
  iEnemyListSize = 1
  iInviteListSize = 20
  iMessageListSize = 50
  if gbTestMode then
    iError = 0
    iEnemyCount = 1
    iFriendCount = 2
    iInviteCount = 3
    iTotalMessageCount = 4
    aFriends = me.getTestFriends()
    aEnemies = me.getTestDenizens()
    aInvites = me.getTestDenizens()
    aMessages = me.getTestMessages()
    me.debug("getMessenger_Result()" && iError && iEnemyCount && iFriendCount && iInviteCount && iTotalMessageCount && aFriends && aEnemies && aInvites && aMessages)
    if not voidp(ElementMgr) then
      ElementMgr.getMessenger_Result(iError, iFriendCount, iEnemyCount, iInviteCount, iTotalMessageCount, aFriends, aEnemies, aInvites, aMessages)
    end if
  end if
  me.foDenizenManager.getMessenger(sScreenName, me.getDenizen().getSecret(), iFriendListSize, iEnemyListSize, iInviteListSize, iMessageListSize)
end

on sendMessage me, sFromScreenName, aToScreenNameList, sMessage
  me.debug("sendMessage() " & sFromScreenName && aToScreenNameList)
  if gbTestMode then
    iError = 0
    me.debug("sendMessage_Result() iError: " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.sendMessage_Result(iError)
    end if
    return 
  end if
  if not voidp(oStudio) then
    oStudio.sendMessage(sFromScreenName, aToScreenNameList, sMessage)
  end if
end

on removeMessage me, sSender, sRecipient, sMessageHash
  me.debug("removeMessage() " & sSender && sRecipient && sMessageHash)
  if gbTestMode then
    iError = 0
    me.debug("removeMessage_Result() iError: " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.removeMessage_Result(iError)
    end if
    return 
  end if
  if not voidp(oStudio) then
    oStudio.removeMessage(sSender, sRecipient, sMessageHash)
  end if
end

on rejectInvitation me, sInviter, sInvitee
  me.debug("rejectInvitation() " & sInviter && sInvitee, 1)
  if gbTestMode then
    iError = 0
    me.debug("rejectInvitation_Result() iError: " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.rejectInvitation_Result(iError)
    end if
    return 
  end if
  if not voidp(oStudio) then
    oStudio.rejectInvitation(sInvitee)
  end if
end

on acceptInvitation me, sInviter, sInvitee
  me.debug("acceptInvitation() " & sInviter && sInvitee)
  if gbTestMode then
    iError = 0
    me.debug("acceptInvitation_Result() iError: " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.acceptInvitation_Result(iError)
    end if
    return 
  end if
  if not voidp(oStudio) then
    oStudio.acceptInvitation(sInviter, sInvitee)
  end if
end

on inviteFriend me, sInviter, sInvitee
  me.debug("inviteFriend() " & sInviter && sInvitee)
  if sInviter = sInvitee then
    return 
  end if
  if sInvitee = me.getScreenName() then
    alert("CAN'T INVITE INVITEE")
    return 
  end if
  if gbTestMode then
    iError = 0
    me.debug("inviteFriend_Result() iError: " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.inviteFriend_Result(iError)
    end if
    return 
  end if
  if not voidp(oStudio) then
    oStudio.inviteFriend(sInviter, sInvitee)
  end if
end

on removeFriends me, sScreenName, aRemoveList
  me.debug("removeFriends() " & sScreenName && aRemoveList)
  if gbTestMode then
    iError = 0
    me.debug("removeFriends_Result() iError: " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.removeFriends_Result(iError)
    end if
    return 
  end if
  if not voidp(oStudio) then
    oStudio.removeFriends(sScreenName, aRemoveList)
  end if
end

on getExtendedDenizenInfo me, sScreenName
  me.debug("getExtendedDenizenInfo() " & sScreenName)
  if gbTestMode then
    iError = 0
    sAvatarMission = "Consume as much Coke as possible"
    aLevelList = [#messages: 33, #kicks: 14, #bans: 10]
    iPossessions_purchased = 25
    iPossessions_total = 47
    iPossessions_backpack = 19
    bInfluencer = 1
    iLogInTotal = 79
    me.debug("getExtendedDenizenInfo_Result() screenName: " & sScreenName & ", avatarMission: " & sAvatarMission & ", levelList: " & aLevelList & ", possessions_purchased: " & iPossessions_purchased & ", possessions_total: " & iPossessions_total & ", possessions_backpack: " & iPossessions_backpack & ", influencer: " & bInfluencer & ", logInTotal: " & iLogInTotal)
    if not voidp(ElementMgr) then
      ElementMgr.getExtendedDenizenInfo_Result(iError, sScreenName, sAvatarMission, aLevelList, iPossessions_purchased, iPossessions_total, iPossessions_backpack, bInfluencer, iLogInTotal)
    end if
    return 
  end if
  me.foDenizenManager.getExtendedDenizenInfo(sScreenName)
end

on getStatus_Result me, oCaller, iError, iUserCount, iCapacity, sStatus, foServerDateTime
  global gCLOSING
  if the runMode <> "author" then
    put "--> RECEIVED STATUS RESULT: " & iError && iUserCount && iCapacity && sStatus && foServerDateTime.toString()
  end if
  put "*******************************" & RETURN
  if sStatus = "O" then
    sendAllSprites(#studiosOpen)
    return 
  end if
  if sStatus = "C" then
    sendAllSprites(#studiosClosed)
    gCLOSING = 1
    return 
  end if
  if sStatus = "F" then
    sendAllSprites(#studiosFull)
    gCLOSING = 1
    return 
  end if
end

on getLoginScreenName_Result me, oCaller, iError, sLoginScreenName
  me.debug("getLoginScreenName_Result() " & iError && sLoginScreenName)
  if iError <> 0 then
    me.debug("** DID NOT GET SCREEN NAME FROM COOKIE **")
    sPrefName = getPref("sfsn")
    if not voidp(sPrefName) and not (sPrefName = EMPTY) then
      me.setScreenName(sPrefName)
      oScreenNameMember = member("inputScreenName")
      if oScreenNameMember.memberNum <> -1 then
        oScreenNameMember.text = sPrefName
      end if
    end if
    script("_TIMER_").new(500, #gotoLogin, me)
    return 
  end if
  if iError = 0 then
    me.setScreenName(sLoginScreenName)
    oScreenNameMember = member("inputScreenName")
    if oScreenNameMember.memberNum <> -1 then
      oScreenNameMember.text = sLoginScreenName
    end if
    script("_TIMER_").new(700, #gotoLogin, me)
  end if
end

on gotoLogin me
  me.debug("gotoLogin() " & me.getScreenName())
  put "DenizenManager.gotologin()"
  go(#next)
end

on loginDenizen_Result me, oCaller, oResult
  global gCLOSING
  put "Director DenizenManager::loginDenizen_Result()"
  if gbTestMode then
    me.setScreenName(me.sDefaultScreenName)
    script("_TIMER_").new(1000, #loginUser_Result, ElementMgr, 0, 2, 1)
    return 
  end if
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("loginDenizen_Result() ERROR " & iError)
    script("_TIMER_").new(1000, #loginUser_Result, ElementMgr, iError)
    return 
  end if
  sNewScreenName = oResult.getScreenName()
  put "** RECEIVED LOGIN DENIZEN RESULT: " & sNewScreenName
  put "********************************" & RETURN
  me.setScreenName(sNewScreenName)
  setPref("sfsn", me.getScreenName())
  me.setDenizen(oResult)
  bIsBanned = oResult.getIsBanned()
  if bIsBanned then
    gCLOSING = 1
    ElementMgr.alert("ALERT_BANNED")
    return 
  end if
  if not voidp(ElementMgr) then
    script("_TIMER_").new(1000, #loginUser_Result, ElementMgr, 0, 2, 1)
  end if
  script("_TIMER_").new(1000, #isModerator, me, me.getScreenName())
  script("_TIMER_").new(1000, #getBackpack, oPossessionManager, me.getScreenName())
end

on loginModerator_Result me, oCaller, oResult
  me.debug("loginModerator_Result()")
  iError = 0
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("loginModerator_Result() ERROR " & iError)
  else
    me.setDenizen(oResult)
    if the debugPlaybackEnabled then
      put "oResult.getSecret():" && oResult.getSecret()
    end if
    sprite(me.spriteNum).setVariable("_level0.sSecret", oResult.getSecret())
  end if
  script("_TIMER_").new(1000, #loginModerator_Result, ElementMgr, iError)
end

on logoutDenizen_Result me, oCaller, oResult
  me.debug("logoutDenizen_Result()")
  if gbTestMode then
    return 
  end if
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("logoutDenizen_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.logoutDenizen_Result(iError)
    end if
    return 
  end if
  if not voidp(ElementMgr) then
    ElementMgr.logoutDenizen_Result(0)
  end if
end

on modifyDenizen_Result me, oCaller, oResult
  me.debug("modifyDenizen_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("modifyDenizen_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.modifyDenizen_Result(iError)
    end if
    return 
  end if
  me.debug("modifyDenizen_Result() result: " & oResult.toString())
  if not voidp(ElementMgr) then
    ElementMgr.modifyDenizen_Result(0)
  end if
end

on getDenizenByScreenName_Result me, oCaller, oResult
  me.debug("getDenizenByScreenName_Result()")
  sErrorType = oResult.getTypeOf()
  me.debug("sErrorType: " & sErrorType)
  if oResult.getTypeOf() = me.ERROR_TYPE then
    me.debug("error")
    iError = oResult.getOrdinal()
    me.debug("getDenizenByScreenName_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.getDenizenByScreenName_Result(iError)
    end if
    return 
  end if
  iError = 0
  sScreenName = oResult.getScreenName()
  me.debug("sScreenName: " & sScreenName)
  oLastAccess = oResult.getLastAccess()
  me.debug("oLastAccess: " & oLastAccess.toString())
  sLastSeenIn = oResult.getLastSeenIn()
  me.debug("sLastSeenIn: " & sLastSeenIn)
  sLastSeenInName = oResult.getLastSeenInName()
  me.debug("sLastSeenInName: " & sLastSeenInName)
  sAvatarMission = oResult.getMissionStatement()
  me.debug("sAvatarMission: " & sAvatarMission)
  sAvatarString = oResult.getAvatarDefinition()
  me.debug("sAvatarString: " & sAvatarString)
  iGender = me.getGenderOrdinal(oResult.getGender())
  me.debug("iGender: " & iGender)
  bOnline = oResult.getIsOnline()
  me.debug("bOnline: " & bOnline)
  bExists = 1
  me.debug("getDenizenByScreenName_Result()  screenName: " & sScreenName & ", lastAccess: " & oLastAccess & ", lastSeenIn: " & sLastSeenIn & ", avatarMission: " & sAvatarMission & ", sAvatarString: " & sAvatarString & ", bOnline: " & bOnline & ", lastSeenInName: " & sLastSeenInName & ", Gender: " & iGender)
  if not voidp(ElementMgr) then
    ElementMgr.getDenizenByScreenName_Result(iError, sScreenName, oLastAccess, sLastSeenIn, sAvatarMission, sAvatarString, bOnline, bExists, sLastSeenInName, iGender)
  end if
end

on getDenizenBalance_Result me, oCaller, oResult
  me.debug("getDenizenBalance_Result()")
  resultData = integer(oResult)
  if voidp(integer(resultData)) then
    iError = 1
    iBalance = 0
  else
    iError = 0
    iBalance = integer(oResult)
  end if
  me.debug("getDenizenBalance_Result() " & iError && iBalance)
  if not voidp(ElementMgr) then
    ElementMgr.getDenizenBalance_Result(iError, iBalance)
  end if
end

on isModerator_Result me, oCaller, oResult
  me.debug("isModerator_Result()")
  sErrorType = oResult.getTypeOf()
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    if iError = 0 then
      me.bIsModerator = 1
    else
      me.bIsModerator = 0
    end if
    me.debug("isModerator: " & me.bIsModerator)
  end if
end

on getModeratorsOnline_Result me, oCaller, oResult
  me.debug("getModeratorsOnline_Result() ", 1)
  me.debug("getModeratorsOnline_Result()" & oResult.toString(), 1)
  aMods = []
  iLength = oResult.length
  if iLength > 0 then
    repeat with i = 0 to iLength - 1
      sMod = oResult[i]
      aMods.add(sMod)
    end repeat
  end if
  me.debug("getModeratorsOnline_Result() aMods: " & aMods, 1)
  ElementMgr.getModeratorsOnline_Result(aMods)
end

on getOnlineFriends_Result me, oCaller, oResult
  me.debug("getOnlineFriends_Result() " & oResult)
  iLength = oResult.length
  me.debug("iLength: " & iLength)
  faFriends = oResult
  aFriends = []
  if not voidp(faFriends) and (faFriends <> VOID) then
    repeat with i = 0 to faFriends.length - 1
      oFriend = faFriends[i]
      aFriend = me.getDenizenPropList(oFriend)
      if voidp(aFriend[#screenName]) then
        next repeat
      end if
      aFriend[#messagesFrom] = integer(oFriend.getMessagesFrom())
      aFriends.add(aFriend)
    end repeat
  end if
  me.debug("aFriends: " & aFriends)
  ElementMgr.getMessengerObject().updateFriendsStatus(aFriends)
end

on getMessenger2_Result me, oCaller, oResult
  me.debug("getMessenger2_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("getMessenger_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.getMessenger_Result(iError, [:])
    end if
    return 
  end if
  iError = 0
  iEnemyCount = integer(oResult.getTotalEnemyCount())
  iFriendCount = integer(oResult.getTotalFriendCount())
  iInviteCount = integer(oResult.getTotalInviteCount())
  iTotalMessageCount = integer(oResult.getTotalMessageCount())
  me.debug("iEnemyCount: " & iEnemyCount)
  me.debug("iFriendCount: " & iFriendCount)
  me.debug("iInviteCount: " & iInviteCount)
  me.debug("iTotalMessageCount: " & iTotalMessageCount)
  aEnemies = []
  faFriends = oResult.getFriends()
  aFriends = []
  if not voidp(faFriends) and (faFriends <> VOID) then
    repeat with i = 0 to faFriends.length - 1
      oFriend = faFriends[i]
      aFriend = me.getDenizenPropList(oFriend)
      if voidp(aFriend[#screenName]) then
        next repeat
      end if
      aFriend[#messagesFrom] = integer(oFriend.getMessagesFrom())
      aFriends.add(aFriend)
    end repeat
  end if
  me.debug("aFriends: " & aFriends)
  faInvites = oResult.getInvites()
  aInvites = []
  if not voidp(faInvites) and (faInvites <> VOID) then
    repeat with i = 0 to faInvites.length - 1
      oDenizen = faInvites[i]
      aDenizen = me.getDenizenPropList(oDenizen)
      if voidp(aDenizen[#screenName]) then
        next repeat
      end if
      aInvites.add(aDenizen)
    end repeat
  end if
  me.debug("aInvites: " & aInvites)
  faMessages = oResult.getMessages()
  aMessages = []
  if not voidp(faMessages) and (faMessages <> VOID) then
    repeat with i = 0 to faMessages.length - 1
      oMessage = faMessages[i]
      aMessage = me.getMessagePropList(oMessage)
      if voidp(aMessage[#recipient]) then
        next repeat
      end if
      aMessages.add(aMessage)
    end repeat
  end if
  me.debug("aMessages: " & aMessages)
  if not voidp(ElementMgr) then
    ElementMgr.getMessenger_Result(iError, iFriendCount, iEnemyCount, iInviteCount, iTotalMessageCount, aFriends, aEnemies, aInvites, aMessages)
  end if
end

on sendMessage_Result me, oCaller, oResult
  me.debug("sendMessage_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("sendMessage_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.sendMessage_Result(iError)
    end if
    return 
  end if
  iError = 0
  if not voidp(ElementMgr) then
    ElementMgr.sendMessage_Result(iError)
  end if
end

on removeMessage_Result me, oCaller, oResult
  me.debug("removeMessage_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("removeMessage_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.removeMessage_Result(iError)
    end if
    return 
  end if
  iError = 0
  if not voidp(ElementMgr) then
    ElementMgr.removeMessage_Result(iError)
  end if
end

on rejectInvitation_Result me, oCaller, oResult
  me.debug("rejectInvitation_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("rejectInvitation_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.rejectInvitation_Result(iError)
    end if
    return 
  end if
  iError = 0
  if not voidp(ElementMgr) then
    ElementMgr.rejectInvitation_Result(iError)
  end if
end

on acceptInvitation_Result me, oCaller, oResult
  me.debug("acceptInvitation_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("acceptInvitation_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.acceptInvitation_Result(iError)
    end if
    return 
  end if
  iError = 0
  if not voidp(ElementMgr) then
    ElementMgr.acceptInvitation_Result(iError)
  end if
end

on inviteFriend_Result me, oCaller, oResult
  me.debug("inviteFriend_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("inviteFriend_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.inviteFriend_Result(iError)
    end if
    return 
  end if
  iError = 0
  if not voidp(ElementMgr) then
    ElementMgr.inviteFriend_Result(iError)
  end if
end

on removeFriends_Result me, oCaller, oResult
  me.debug("removeFriends_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("removeFriend_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.removeFriends_Result(iError)
    end if
    return 
  end if
  iError = 0
  if not voidp(ElementMgr) then
    ElementMgr.removeFriends_Result(iError)
  end if
end

on getExtendedDenizenInfo_Result me, oCaller, oResult
  me.debug("getExtendedDenizenInfo_Result()")
  sErrorType = oResult.getTypeOf()
  me.debug("sErrorType: " & sErrorType)
  if oResult.getTypeOf() = me.ERROR_TYPE then
    me.debug("error")
    iError = oResult.getOrdinal()
    me.debug("getExtendedDenizenInfo_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.getExtendedDenizenInfo_Result(iError)
    end if
    return 
  end if
  iError = 0
  sScreenName = oResult.getScreenName()
  me.debug("sScreenName: " & sScreenName)
  sAvatarMission = oResult.getMissionStatement()
  me.debug("sAvatarMission: " & sAvatarMission)
  aLevelList = oResult.getLevelList()
  me.debug("aLevelList: " & aLevelList)
  iPossessions_purchased = oResult.getPossessions_purchased()
  me.debug("iPossessions_purchased: " & iPossessions_purchased)
  iPossessions_total = oResult.getPossessions_total()
  me.debug("iPossessions_total: " & iPossessions_total)
  iPossessions_backpack = oResult.getPossessions_backpack()
  me.debug("iPossessions_backpack: " & iPossessions_backpack)
  bInfluencer = oResult.getIsInfluencer()
  me.debug("bInfluencer: " & bInfluencer)
  iLogInTotal = oResult.getLogInTotal()
  me.debug("iLogInTotal: " & iLogInTotal)
  me.debug("getExtendedDenizenInfo_Result() screenName: " & sScreenName & ", avatarMission: " & sAvatarMission & ", levelList: " & aLevelList & ", possessions_purchased: " & iPossessions_purchased & ", possessions_total: " & iPossessions_total & ", possessions_backpack: " & iPossessions_backpack & ", influencer: " & bInfluencer & ", logInTotal: " & iLogInTotal)
  if not voidp(ElementMgr) then
    ElementMgr.getExtendedDenizenInfo_Result(iError, sScreenName, sAvatarMission, aLevelList, iPossessions_purchased, iPossessions_total, iPossessions_backpack, bInfluencer, iLogInTotal)
  end if
end

on onStatus me, oCaller, oXml
  me.debug("onStatus()", 1)
end

on getGatewaySprite me
  return sprite(me.spriteNum)
end

on isMod me
  return me.bIsModerator
end

on setScreenName me, sName
  me.sUserScreenName = sName
end

on getScreenName me
  return me.sUserScreenName
end

on setDenizen me, _foDenizen
  me.foDenizen = _foDenizen
end

on getDenizen me
  return me.foDenizen
end

on getMissionStatement me
  if not voidp(me.foDenizen) then
    sMission = me.foDenizen.getMissionStatement()
    if voidp(sMission) then
      sMission = EMPTY
    end if
    return sMission
  else
    return EMPTY
  end if
  return "Todo: get real mission statment"
end

on getAvatarImage me
  oDenizen = me.getDenizen()
  if not voidp(oDenizen) then
    sAttributes = oDenizen.getAvatarDefinition()
  end if
  oMember = member("AvatarEngine")
  if oMember.memberNum < 0 then
    return 
  end if
  oAvatar = script("AvatarEngine").new(sAttributes, 100, 1)
  oPreviewImage = oAvatar.getPreviewImage()
  return oPreviewImage
end

on getDenizenAvatarImage me, sAttributes
  oMember = member("AvatarEngine")
  if oMember.memberNum < 0 then
    return 
  end if
  oAvatar = script("AvatarEngine").new(sAttributes, 100, 1)
  oPreviewImage = oAvatar.getPreviewImage()
  return oPreviewImage
end

on getTestDenizens me
  aProps = []
  aProps.add([#screenName: "Aslan", #gender: 1, #avatarDefinition: "TODO", #mission: "To rock your world", #online: 1, #lastAccess: newObject("Date"), #lastSeenIn: "Aslan2", #lastSeenInName: "TheLion"])
  aProps.add([#screenName: "Jarod", #gender: 1, #avatarDefinition: "TODO", #mission: "To rock your world", #online: 0, #lastAccess: newObject("Date"), #lastSeenIn: "Aslan2", #lastSeenInName: "TheLion"])
  aProps.add([#screenName: "Mark", #gender: 1, #avatarDefinition: "TODO", #mission: "To rock your world", #online: 1, #lastAccess: newObject("Date"), #lastSeenIn: "Aslan2", #lastSeenInName: "TheLion"])
  aProps.add([#screenName: "Paul", #gender: 1, #avatarDefinition: "TODO", #mission: "To rock your world", #online: 0, #lastAccess: newObject("Date"), #lastSeenIn: "Aslan2", #lastSeenInName: "TheLion"])
  aProps.add([#screenName: "George", #gender: 1, #avatarDefinition: "TODO", #mission: "To rock your world", #online: 1, #lastAccess: newObject("Date"), #lastSeenIn: "Aslan2", #lastSeenInName: "TheLion"])
  return aProps
end

on getTestFriends me
  aProps = me.getTestDenizens()
  repeat with i = 1 to aProps.count
    aProps[i][#messagesFrom] = random(10)
  end repeat
  return aProps
end

on getTestMessages me
  aMessages = []
  aMessages.add([#sender: "Aslan", #recipient: "Aslan", #message: "Hi I'm Aslan", #date: newObject("Date")])
  aMessages.add([#sender: "Jarod", #recipient: "Aslan", #message: "Hi I'm Jarod", #date: newObject("Date")])
  aMessages.add([#sender: "Mark", #recipient: "Aslan", #message: "Hi I'm Mark", #date: newObject("Date")])
  aMessages.add([#sender: "Paul", #recipient: "Aslan", #message: "Hi I'm Paul", #date: newObject("Date")])
  aMessages.add([#sender: "George", #recipient: "Aslan", #message: "Hi I'm George", #date: newObject("Date")])
  return aMessages
end

on getMessagePropList me, oRC
  aProps = [:]
  aProps[#recipient] = oRC.getRecipient()
  aProps[#sender] = oRC.getSender()
  aProps[#message] = oRC.getText()
  aProps[#sentOn] = oRC.getSentOn()
  aProps[#messageHash] = oRC.getMessageHash()
  return aProps
end

on getDenizenPropList me, oDenizen
  aProps = [:]
  aProps[#screenName] = oDenizen.getScreenName()
  aProps[#avatarDefinition] = oDenizen.getAvatarDefinition()
  iGender = me.getGenderOrdinal(oDenizen.getGender())
  aProps[#gender] = iGender
  aProps[#mission] = oDenizen.getMissionStatement()
  aProps[#lastSeenIn] = oDenizen.getLastSeenIn()
  aProps[#lastSeenInName] = oDenizen.getLastSeenInName()
  aProps[#lastAccess] = oDenizen.getLastAccess()
  aProps[#online] = oDenizen.getIsOnline()
  return aProps
end

on getCokesDrank me
  return me.iCokesDrank
end

on setCokesDrank me, i
  me.iCokesDrank = i
end

on getBackpack me
  return me.foBackpack
end

on setBackPack me, _foBackPack
  me.foBackpack = _foBackPack
end

on getEnvironment me
  sEnv = me.fo_level0.getEnvironment()
  return sEnv
end

on isFTMmember me
  me.foDenizenManager.isFTMmember(me.getDenizen().getScreenName(), me.getDenizen().getSecret())
end

on getGenres me
  me.foDenizenManager.getGenres(me.getDenizen().getScreenName(), me.getDenizen().getSecret())
end

on getArtistsByGenre me, whatgenre
  me.foDenizenManager.getArtistsByGenre(me.getDenizen().getScreenName(), me.getDenizen().getSecret(), whatgenre)
end

on getSongsByArtist me, whatartist
  me.foDenizenManager.getSongsByArtist(me.getDenizen().getScreenName(), me.getDenizen().getSecret(), whatartist)
end

on getPlaylist me
  me.foDenizenManager.getPlaylist(me.getDenizen().getScreenName(), me.getDenizen().getSecret())
end

on addToPlayList me, mysongid
  me.foDenizenManager.addToPlayList(me.getDenizen().getScreenName(), me.getDenizen().getSecret(), mysongid)
end

on removeFromPlaylist me, mysongid
  me.foDenizenManager.removeFromPlaylist(me.getDenizen().getScreenName(), me.getDenizen().getSecret(), mysongid)
  me.foDenizenManager.getPlaylist(me.getDenizen().getScreenName(), me.getDenizen().getSecret())
end

on getAvailableTokens me
  me.foDenizenManager.getAvailableTokens(me.getDenizen().getScreenName(), me.getDenizen().getSecret())
end

on getAvailableTokens_result me, oCaller, oResult
  member("cc.jukebox.tokennum").text = "Tokens left:" && integer(oResult)
end

on isFtmMember_result me, oCaller, oResult
  me.debug("isFTMmember_result()")
  sErrorType = oResult.getTypeOf()
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    if iError = 0 then
      me.bisFTMmember = 1
    else
      bisFTMmember = 0
    end if
    me.debug("isFTMmember: " & me.bisFTMmember)
    put "isFTMmember_result :" && me.bisFTMmember
    ElementMgr.openJukebox()
    ElementMgr.oJukebox.isFTMmember = me.bisFTMmember
  end if
end

on getgenres_result me, oCaller, oResult
  mygenres = oStudio.convertFlashArrayToDirectorList(oResult)
  if getPropAt(ElementMgr.oJukebox.getOpenWindow().pScrollingLists, 1) = #cataloglist then
    ElementMgr.oJukebox.getOpenWindow().pScrollingLists.cataloglist.pContentlist = mygenres
    ElementMgr.oJukebox.getOpenWindow().pScrollingLists.cataloglist.updatecontent()
  end if
end

on getArtistsByGenre_result me, oCaller, oResult
  myartists = oStudio.convertFlashArrayToDirectorList(oResult)
  ElementMgr.oJukebox.getOpenWindow().pScrollingLists.cataloglist.pContentlist = myartists
  ElementMgr.oJukebox.getOpenWindow().pScrollingLists.cataloglist.updatecontent()
end

on getSongsByArtist_result me, oCaller, oResult
  mysongs = oStudio.convertFlashArrayToDirectorList(oResult)
  ElementMgr.oJukebox.getOpenWindow().pScrollingLists.cataloglist.pContentlist = mysongs
  ElementMgr.oJukebox.getOpenWindow().pScrollingLists.cataloglist.updatecontent()
end

on getPlaylist_Result me, oCaller, oResult
  mysongs = oStudio.convertFlashArrayToDirectorList(oResult)
  if getPropAt(ElementMgr.oJukebox.getOpenWindow().pScrollingLists, 1) = #playList then
    ElementMgr.oJukebox.getOpenWindow().pScrollingLists.playList.pContentlist = mysongs
    ElementMgr.oJukebox.getOpenWindow().pScrollingLists.playList.updatecontent()
  end if
end

on addToPlaylist_Result me, oCaller, oResult
  case oResult of
    0:
      ElementMgr.alert("ALERT_IJ_0")
    1:
      ElementMgr.alert("ALERT_IJ_1")
    2:
      ElementMgr.alert("ALERT_IJ_2")
    3:
      ElementMgr.alert("ALERT_IJ_3")
    4:
      ElementMgr.alert("ALERT_IJ_4")
    5:
      ElementMgr.alert("ALERT_IJ_5")
  end case
end

on removeFromPlaylist_Result me, oCaller, oResult
  case oResult of
    0:
      ElementMgr.oJukebox.getOpenWindow().pScrollingLists.playList.updatecontent()
    1:
      ElementMgr.alert("ALERT_IJ_1")
    2:
      ElementMgr.alert("ALERT_IJ_2")
    3:
      ElementMgr.alert("ALERT_IJ_3")
    4:
      ElementMgr.alert("ALERT_IJ_4")
  end case
end

on getTip_Result me, oCaller, oResult
  put "getTip_Result(): Tip of the day - oResult:" && ilk(oResult) && oResult
  member("Tip").text = oResult
end
