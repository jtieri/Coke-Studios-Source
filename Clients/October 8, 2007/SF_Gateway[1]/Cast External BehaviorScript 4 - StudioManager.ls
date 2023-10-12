property bDebug, bInitialized, bReadyForuse, foStudioManager, fo_level0, aPrivateStudioData, ERROR_TYPE, ARRAY_TYPE, STUDIO_TYPE, iLastPublicStudioUpdate, iLastPrivateStudioUpdate, iCacheTimeLength, aCachedStudioData, STUDIO_TIMER_ID, STUDIO_MODE, NASCENT, PUBLIC, PRIVATE, PERSONAL, SEARCH
global sLanguageSetting, oStudioManager, oDenizenManager, oPossessionManager, oPublicstudioData, ElementMgr, gbTestMode, oSession, gFeatureSet

on beginSprite me
  me.bDebug = 0
  me.bInitialized = 0
  me.bReadyForuse = 0
  me.aPrivateStudioData = []
  oStudioManager = me
  me.ERROR_TYPE = "FlashReturnStatusEnum"
  me.ARRAY_TYPE = "Array"
  me.STUDIO_TYPE = "Studio"
  me.iCacheTimeLength = 10000
  me.aCachedStudioData = []
  me.NASCENT = "NASCENT"
  me.PUBLIC = "PUBLIC"
  me.PRIVATE = "PRIVATE"
  me.PERSONAL = "PERSONAL"
  me.SEARCH = "SEARCH"
  me.STUDIO_MODE = me.NASCENT
  me.STUDIO_TIMER_ID = "STUDIO_TIMER"
  script("_TIMER_").new(400, #Init, me)
end

on getStudioMode me
  return me.STUDIO_MODE
end

on setStudioMode me, sMode
  case sMode of
    me.NASCENT:
      me.STUDIO_MODE = me.NASCENT
    me.PUBLIC:
      me.STUDIO_MODE = me.PUBLIC
    me.PRIVATE:
      me.STUDIO_MODE = me.PRIVATE
    me.PERSONAL:
      me.STUDIO_MODE = me.PERSONAL
    me.SEARCH:
      me.STUDIO_MODE = me.SEARCH
  end case
  me.debug("setStudioMode() sMode: " & sMode & ", STUDIO_MODE: " & me.STUDIO_MODE)
end

on startStudioTimer me
  me.debug("startStudioTimer()")
  me.stopStudioTimer()
  timeout(me.STUDIO_TIMER_ID).new(5000, #processStudioTimer, me)
end

on stopStudioTimer me
  me.debug("stopStudioTimer()")
  timeout(me.STUDIO_TIMER_ID).forget()
end

on processStudioTimer me
  me.debug("processStudioTimer() STUDIO_MODE: " & me.STUDIO_MODE)
  case me.STUDIO_MODE of
    me.NASCENT:
    me.PUBLIC:
      bPublicStudioWindowOpen = ElementMgr.isPublicStudioWindowOpen()
      if bPublicStudioWindowOpen then
        me.getAllPublicStudios()
      else
        me.debug("processStudioTimer() PUBLIC STUDIO WINDOW NOT OPEN")
      end if
    me.PRIVATE:
      bPrivateStudioWindowOpen = ElementMgr.isPrivateStudioWindowOpen()
      if bPrivateStudioWindowOpen then
        me.getAllPrivateStudios()
      else
        me.debug("processStudioTimer() PRIVATE STUDIO WINDOW NOT OPEN")
      end if
    me.PERSONAL:
    me.SEARCH:
  end case
end

on setCallbacks me
  sprite(me.spriteNum).setCallback(me.foStudioManager, "beanCreated", #beanCreated, me)
  sprite(me.spriteNum).setCallback(me.foStudioManager, "getAllPublicStudios_Result", #getAllPublicStudios_Result, me)
  sprite(me.spriteNum).setCallback(me.foStudioManager, "getAllPrivateStudios_Result", #getAllPrivateStudios_Result, me)
  sprite(me.spriteNum).setCallback(me.foStudioManager, "getByOwnerName_Result", #getByOwnerName_Result, me)
  sprite(me.spriteNum).setCallback(me.foStudioManager, "getByStudioId_Result", #getByStudioId_Result, me)
  sprite(me.spriteNum).setCallback(me.foStudioManager, "getGameServerByStudioID_Result", #getGameServerByStudioID_Result, me)
  sprite(me.spriteNum).setCallback(me.foStudioManager, "getByStudioName_Result", #getByStudioName_Result, me)
  sprite(me.spriteNum).setCallback(me.foStudioManager, "getOccupantsByStudioId_Result", #getOccupantsByStudioId_Result, me)
  sprite(me.spriteNum).setCallback(me.foStudioManager, "createStudio_Result", #createStudio_Result, me)
  sprite(me.spriteNum).setCallback(me.foStudioManager, "modifyStudio_Result", #modifyStudio_Result, me)
  sprite(me.spriteNum).setCallback(me.foStudioManager, "deleteStudio_Result", #deleteStudio_Result, me)
  sprite(me.spriteNum).setCallback(me.foStudioManager, "getMixerByScreenName_Result", #getMixerByScreenName_Result, me)
  sprite(me.spriteNum).setCallback(me.foStudioManager, "burnMixToCD_Result", #burnMixToCD_Result, me)
end

on Init me
  me.debug("init()")
  me.foStudioManager = sprite(me.spriteNum).getVariable("_level0.oStudioManager", 0)
  me.fo_level0 = sprite(me.spriteNum).getVariable("_level0", 0)
  me.setCallbacks()
  me.foStudioManager.bDebug = 0
  me.foStudioManager.bTestMode = 0
  if the runMode = "Author" then
    me.bReadyForuse = 1
  else
    me.foStudioManager.createGateway(me.fo_level0.getGatewayConnection())
  end if
  me.bInitialized = 1
  me.startStudioTimer()
end

on beanCreated me, oCaller
  me.debug("beanCreated()")
  me.bReadyForuse = 1
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "StudioManager: " & sMessage
  end if
end

on getAllPublicStudios me
  me.setStudioMode(me.PUBLIC)
  me.debug("getAllPublicStudios() STUDIO_MODE: " & me.STUDIO_MODE)
  if gbTestMode then
    aStudioData = oPublicstudioData.aStudioData
    me.debug("getAllPublicStudios_Result() aStudioData: " & aStudioData)
    if not voidp(ElementMgr) then
      ElementMgr.displayPublicStudios(aStudioData)
    end if
    return 
  end if
  bUseCache = 1
  if not voidp(me.iLastPublicStudioUpdate) then
    iElapsedTime = the milliSeconds - me.iLastPublicStudioUpdate
    if iElapsedTime >= me.iCacheTimeLength then
      bUseCache = 0
    end if
  else
    bUseCache = 0
  end if
  if not bUseCache then
    me.foStudioManager.getAllPublicStudios()
  else
    me.debug("*** CACHED ****: getAllPublicStudios_Result()")
    if not voidp(ElementMgr) then
      ElementMgr.displayPublicStudios(me.aCachedStudioData)
    end if
  end if
end

on getAllPrivateStudios me
  me.setStudioMode(me.PRIVATE)
  me.debug("getAllPrivateStudios() STUDIO_MODE: " & me.STUDIO_MODE)
  if gbTestMode then
    aStudioData = me.getTestStudios()
    me.aPrivateStudioData = aStudioData
    me.debug("getAllPrivateStudios_Result() aStudioData: " & aStudioData)
    if not voidp(ElementMgr) then
      ElementMgr.displayPrivateStudios(aStudioData)
    end if
    return 
  end if
  bUseCache = 1
  if not voidp(me.iLastPrivateStudioUpdate) then
    iElapsedTime = the milliSeconds - me.iLastPrivateStudioUpdate
    me.debug("iElapsedTime: " & iElapsedTime)
    if iElapsedTime >= me.iCacheTimeLength then
      bUseCache = 0
    end if
  else
    bUseCache = 0
  end if
  if not bUseCache then
    me.foStudioManager.getAllPrivateStudios()
  else
    aStudioData = me.aPrivateStudioData
    me.debug("**** CACHED ****: getAllPrivateStudios_Result()")
    if not voidp(ElementMgr) then
      ElementMgr.displayPrivateStudios(aStudioData)
    end if
  end if
end

on getByOwnerName me, sScreenName
  me.setStudioMode(me.PERSONAL)
  me.debug("getByOwnerName() STUDIO_MODE: " & me.STUDIO_MODE)
  if gbTestMode then
    aStudioData = me.getTestStudios()
    me.aPrivateStudioData = aStudioData
    me.debug("getByOwnerName_Result() aStudioData: " & aStudioData)
    if not voidp(ElementMgr) then
      ElementMgr.displayPrivateStudios(aStudioData)
    end if
    return 
  end if
  if voidp(sScreenName) then
    sScreenName = EMPTY
  end if
  me.iLastPrivateStudioUpdate = 0
  me.foStudioManager.getByOwnerName(sScreenName)
end

on getByStudioID me, sStudioID
  me.debug("getByStudioID() " & sStudioID)
  if gbTestMode then
    foGameServer = me.fo_level0.getTestGameServerObject()
    sendAllSprites(#initGetGameServerResult, foGameServer)
    return 
  end if
  me.foStudioManager.getByStudioID(sStudioID)
end

on getGameServerByStudioID me, sStudioID
  me.debug("getGameServerByStudioID() " & sStudioID)
  if gbTestMode then
    foGameServer = me.fo_level0.getTestGameServerObject()
    sendAllSprites(#initGetGameServerResult, foGameServer)
    return 
  end if
  sDNSAndPort = EMPTY
  if not voidp(oSession) then
    if oSession.getConnected() then
      sDNSAndPort = oSession.getServer() & ":" & oSession.getPort()
      if sDNSAndPort.length = 1 then
        sDNSAndPort = EMPTY
      end if
    end if
  end if
  me.foStudioManager.getGameServerByStudioID(sStudioID, sDNSAndPort)
  if the debugPlaybackEnabled then
    put "sStudioID:" && sStudioID && ilk(sStudioID) & RETURN & "sDNSAndPort:" && sDNSAndPort && ilk(sDNSAndPort)
  end if
end

on getByStudioName me, sSearchText
  me.setStudioMode(me.SEARCH)
  me.debug("getByStudioName() STUDIO_MODE: " & me.STUDIO_MODE)
  if gbTestMode then
    aStudioData = me.getTestStudios()
    me.aPrivateStudioData = aStudioData
    me.debug("getByStudioName_Result() aStudioData: " & aStudioData)
    if not voidp(ElementMgr) then
      ElementMgr.displayPrivateStudios(aStudioData)
    end if
    return 
  end if
  if voidp(sSearchText) then
    sSearchText = EMPTY
  end if
  me.iLastPrivateStudioUpdate = 0
  me.foStudioManager.getByStudioName(sSearchText)
end

on getOccupantsByStudioId me, sStudioID
  me.debug("getOccupantsByStudioId() " & sStudioID)
  if gbTestMode then
    aPeople = ["Alan", "Jarod", "Jeff", "Paul", "George", "Nonoche"]
    me.debug("getOccupantsByStudioId_Result() " && aPeople)
    if not voidp(ElementMgr) then
      ElementMgr.displayStudioPeople(aPeople)
    end if
    return 
  end if
  if voidp(sStudioID) then
    sStudioID = EMPTY
  end if
  me.foStudioManager.getOccupantsByStudioId(sStudioID)
end

on getPublicStudioDetail me, sStudioID
  me.debug("getPublicStudioDetail() " & sStudioID)
  aDetail = VOID
  iLength = oPublicstudioData.aStudioData.count
  repeat with i = 1 to iLength
    aStudio = oPublicstudioData.aStudioData[i]
    if aStudio[#studioId] = sStudioID then
      aDetail = aStudio
      exit repeat
    end if
  end repeat
  me.debug("getPublicStudioDetail() " & aDetail)
  if not voidp(ElementMgr) then
    ElementMgr.displayStudioDetail(aDetail)
  end if
end

on getPrivateStudioDetail me, sStudioID
  me.debug("getPrivateStudioDetail() " & sStudioID)
  aDetail = VOID
  iLength = aPrivateStudioData.count
  repeat with i = 1 to iLength
    aStudio = aPrivateStudioData[i]
    if aStudio[#studioId] = sStudioID then
      aDetail = aStudio
      exit repeat
    end if
  end repeat
  me.debug("getPrivateStudioDetail() " & aDetail)
  if not voidp(ElementMgr) then
    ElementMgr.displayStudioDetail(aDetail)
  end if
end

on createStudio me, sScreenName, sStudioName, sDescription, iLayout, iLocation
  me.debug("createStudio() " & sScreenName && sStudioName && sDescription && iLayout && iLocation)
  if voidp(iLayout) then
    iLayout = 1
  end if
  if voidp(iLocation) then
    iLocation = 1
  end if
  if gbTestMode then
    iError = 0
    sStudioName = "Test"
    sStudioID = "Test1"
    me.debug("createStudio_Result()" && sStudioName && sStudioID)
    if not voidp(ElementMgr) then
      ElementMgr.createStudio_Result(iError, sStudioName, sStudioID)
    end if
    return 
  end if
  me.foStudioManager.createStudio(sScreenName, oDenizenManager.getDenizen().getSecret(), sStudioName, sDescription, iLayout, iLocation)
end

on modifyStudio me, sStudioID, sStudioName, sDescription
  me.debug("modifyStudio() " & sStudioID && sStudioName && sDescription)
  if gbTestMode then
    iError = 0
    sStudioName = "Test Name"
    sDescription = "Test Description"
    me.debug("modifyStudio_Result() " && sStudioName && sDescription)
    if not voidp(ElementMgr) then
      ElementMgr.modifyStudio_Result(iError, sStudioName, sDescription)
    end if
    return 
  end if
  me.foStudioManager.modifyStudio(oDenizenManager.getDenizen().getScreenName(), oDenizenManager.getDenizen().getSecret(), sStudioID, sStudioName, sDescription)
end

on deleteStudio me, sStudioID
  me.debug("deleteStudio() " & sStudioID)
  if gbTestMode then
    me.debug("deleteStudio_Result() OK")
    if not voidp(ElementMgr) then
      ElementMgr.deleteStudio_Result(0)
    end if
    return 
  end if
  me.foStudioManager.deleteStudio(oDenizenManager.getDenizen().getScreenName(), oDenizenManager.getDenizen().getSecret(), sStudioID)
end

on getMixerByScreenName me, sScreenName
  me.debug("getMixerByScreenName() " && sScreenName)
  if gbTestMode then
    aRemoteMixer = me.getTestRemoteMixer(sScreenName)
    me.debug("getMixerByScreenName() " && aRemoteMixer)
    iError = 0
    if not voidp(ElementMgr) then
      ElementMgr.getMixerByScreenName_Result(iError, aRemoteMixer)
    end if
    return 
  end if
  me.foStudioManager.getMixerByScreenName(sScreenName, oDenizenManager.getDenizen().getSecret())
end

on burnMixToCD me, sScreenName, iMixNumber
  me.debug("burnMixToCD() " && sScreenName && iMixNumber)
  if voidp(sScreenName) then
    sScreenName = oDenizenManager.getScreenName()
  end if
  if voidp(iMixNumber) then
    iMixNumber = 1
  end if
  if gbTestMode then
    iError = 0
    me.debug("burnMixToCD_Result() " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.burnMixToCD_Result(iError)
    end if
    return 
  end if
  me.foStudioManager.burnMixToCD(sScreenName, oDenizenManager.getDenizen().getSecret(), iMixNumber)
end

on getAllPublicStudios_Result me, oCaller, oResult
  me.debug("getAllPublicStudios_Result()")
  me.iLastPublicStudioUpdate = the milliSeconds
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("getAllPublicStudios_Result() ERROR " & iError)
    return 
  end if
  iLength = oResult.length
  repeat with i = 0 to iLength - 1
    oStudio = oResult[i]
    sStudioID = oStudio.getStudioID()
    iUserCount = integer(oStudio.getCurrentOccupancy())
    iCapacity = integer(oStudio.getMaxOccupancy())
    iLocation = integer(oStudio.getLocation())
    oPublicstudioData.updateStudio(sStudioID, iUserCount, iCapacity, iLocation, EMPTY)
  end repeat
  me.aCachedStudioData = oPublicstudioData.syncWithServer(oResult)
  if not voidp(ElementMgr) then
    ElementMgr.displayPublicStudios(me.aCachedStudioData)
  end if
end

on getAllPrivateStudios_Result me, oCaller, oResult
  me.debug("getAllPrivateStudios_Result() length: " & oResult.length)
  me.iLastPrivateStudioUpdate = the milliSeconds
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("getAllPrivateStudios_Result() ERROR " & iError)
    return 
  end if
  aStudioData = me.getStudiosFromResult(oResult)
  me.debug("getAllPrivateStudios_Result() Result length: " & aStudioData.count)
  me.aPrivateStudioData = aStudioData
  if not voidp(ElementMgr) then
    ElementMgr.displayPrivateStudios(aStudioData)
  end if
end

on getByOwnerName_Result me, oCaller, oResult
  me.debug("getByOwnerName_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("getByOwnerName_Result() ERROR " & iError)
    return 
  end if
  aStudioData = me.getStudiosFromResult(oResult)
  me.debug("getByOwnerName_Result() " & aStudioData)
  me.aPrivateStudioData = aStudioData
  if not voidp(ElementMgr) then
    ElementMgr.displayPrivateStudios(aStudioData)
  end if
end

on getByStudioId_Result me, oCaller, oResult
  me.debug("getByStudioID_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("getByStudioID_Result() ERROR " & iError)
    ElementMgr.getByStudioId_Result(iError, oResult)
    return 
  end if
  ElementMgr.getByStudioId_Result(0, oResult)
end

on getGameServerByStudioID_Result me, oCaller, oResult
  me.debug("getGameServerByStudioID_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("getGameServerByStudioID_Result() ERROR " & iError, 1)
    ElementMgr.alert("ALERT_NO_SERVER_AVAILABLE")
    gotoEntry()
    return 
  end if
  oGameServer = oResult
  me.debug("getGameServerByStudioID_Result() " & oGameServer.toString())
  sendAllSprites(#initGetGameServerResult, oGameServer)
end

on getByStudioName_Result me, oCaller, oResult
  me.debug("getByStudioName_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("getByStudioName_Result() ERROR " & iError)
    return 
  end if
  aStudioData = me.getStudiosFromResult(oResult)
  me.debug("getByStudioName_Result() " & aStudioData)
  me.aPrivateStudioData = aStudioData
  if not voidp(ElementMgr) then
    ElementMgr.displayPrivateStudios(aStudioData)
  end if
end

on getOccupantsByStudioId_Result me, oCaller, oResult
  me.debug("getOccupantsByStudioId_Result()")
  sTypeOf = oResult.getTypeOf()
  me.debug("sTypeOf: " & sTypeOf)
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("getOccupantsByStudioId_Result() ERROR " & iError)
    return 
  end if
  aPeople = []
  iLength = oResult.length
  repeat with i = 0 to iLength - 1
    sName = oResult[i]
    aPeople.add(sName)
  end repeat
  me.debug("getOccupantsByStudioId_Result() " && aPeople)
  if not voidp(ElementMgr) then
    ElementMgr.displayStudioPeople(aPeople)
  end if
end

on createStudio_Result me, oCaller, oResult
  me.debug("createStudio_Result()")
  put "createStudio_Result:" && ilk(oResult) && oResult
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = integer(oResult.getOrdinal())
    me.debug("createStudio_Result() ERROR: " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.createStudio_Result(iError)
    end if
    return 
  end if
  iError = 0
  sStudioName = oResult.getName()
  sStudioID = oResult.getStudioID()
  me.debug("createStudio_Result()" && sStudioName && sStudioID)
  if not voidp(ElementMgr) then
    ElementMgr.createStudio_Result(iError, sStudioName, sStudioID)
  end if
end

on modifyStudio_Result me, oCaller, oResult
  me.debug("modifyStudio_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = integer(oResult.getOrdinal())
    me.debug("modifyStudio_Result() ERROR: " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.modifyStudio_Result(iError)
    end if
    return 
  end if
  iError = 0
  sStudioName = oResult.getName()
  sDescription = oResult.getDescription()
  me.debug("modifyStudio_Result() " && sStudioName && sDescription)
  if not voidp(ElementMgr) then
    ElementMgr.modifyStudio_Result(iError, sStudioName, sDescription)
  end if
end

on deleteStudio_Result me, oCaller, oResult
  me.debug("deleteStudio_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = integer(oResult.getOrdinal())
    me.debug("deleteStudio_Result() ERROR: " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.deleteStudio_Result(iError)
    end if
    if iError = 0 then
      me.debug("deleteStudio_Result() OK")
      oPossessionManager.getBackpack()
    end if
    return 
  end if
end

on startCreateStudio me, sScreenName
  me.debug("startCreateStudio() " & sScreenName)
  if not voidp(ElementMgr) then
    ElementMgr.startCreateStudio_Result(0)
  end if
end

on startModifyStudio me, sScreenName, sStudioID
  me.debug("startModifyStudio() " & sScreenName && sStudioID)
  aStudioData = VOID
  if voidp(me.aPrivateStudioData) then
    return 
  end if
  iLength = me.aPrivateStudioData.count
  repeat with i = 1 to iLength
    aStudio = me.aPrivateStudioData[i]
    if aStudio[#studioId] = sStudioID then
      aStudioData = aStudio
      exit repeat
    end if
  end repeat
  if not voidp(aStudioData) then
    sName = aStudioData[#name]
    sDescription = aStudioData[#description]
    if not voidp(ElementMgr) then
      ElementMgr.startModifyStudio_Result(0, sName, sDescription)
    end if
  end if
end

on getMixerByScreenName_Result me, oCaller, oResult
  me.debug("getMixerByScreenName_Result() " & oResult.toString())
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = integer(oResult.getOrdinal())
    me.debug("getMixerByScreenName_Result() ERROR: " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.getMixerByScreenName_Result(iError)
    end if
    return 
  end if
  iError = 0
  aRemoteMixer = me.createRemoteMixer(oResult)
  me.debug("getMixerByScreenName_Result() " & aRemoteMixer)
  if not voidp(ElementMgr) then
    ElementMgr.getMixerByScreenName_Result(iError, aRemoteMixer)
  end if
end

on burnMixToCD_Result me, oCaller, oResult
  me.debug("burnMixToCD_Result()")
  iError = 0
  if voidp(oResult) or (oResult = VOID) then
    iError = 1
  end if
  me.debug("burnMixToCD_Result() " & iError, 1)
  if not voidp(ElementMgr) then
    ElementMgr.burnMixToCD_Result(iError, oResult)
  end if
end

on createRemoteMixer me, oResult
  aRemoteMixer = [:]
  aRemoteMixer[#blankCDCount] = oResult.getBlankCDCount()
  aRemoteMixer[#sessionId] = oResult.getSessionId()
  aMixes = []
  faMixes = oResult.getMixes()
  repeat with i = 0 to faMixes.length - 1
    foMix = faMixes[i]
    aMix = me.createMix(foMix)
    aMixes.add(aMix)
  end repeat
  aRemoteMixer[#mixes] = aMixes
  return aRemoteMixer
end

on createMix me, foMix
  aMix = [:]
  aMix[#mixid] = integer(foMix.getMixId())
  aMix[#mixNumber] = integer(foMix.getMixNumber())
  aMix[#authorScreenName] = foMix.getOwnerScreenName()
  aMix[#name] = foMix.getMixName()
  sSong = foMix.getSong()
  aMix[#song] = sSong
  return aMix
end

on replaceChar me, sString, sCharToReplace, sReplacementChar
  sNewString = EMPTY
  iCharCount = sString.chars.count
  repeat with i = 1 to iCharCount
    sChar = sString.char[i]
    if sChar = sCharToReplace then
      sNewChar = sReplacementChar
    else
      sNewChar = sChar
    end if
    sNewString = sNewString & sNewChar
  end repeat
  return sNewString
end

on getTestRemoteMixer me, sScreenName
  aRemoteMixer = [:]
  aRemoteMixer[#blankCDCount] = 30
  aMixes = []
  repeat with i = 1 to 2
    aMixes.add(me.createTestMix(sScreenName, i))
  end repeat
  aRemoteMixer[#mixes] = aMixes
  return aRemoteMixer
end

on createTestMix me, sScreenName, iMixNumber
  aTestMix = [:]
  aTestMix[#mixid] = random(1000)
  aTestMix[#mixNumber] = iMixNumber
  aTestMix[#authorScreenName] = sScreenName
  aTestMix[#name] = "Test Mix: " & sScreenName & ": " & iMixNumber
  aTestMix[#song] = "jazzyjeff,4,4,54,^4x4,97,308,countryOne_beatz00,{24,7996,{^Drum kit 2,100,403,shared_trapset00_,{8,15996,{^Delayed,100,355,popTwo_kbd00,{12,21989,{^C'mon Again,100,352,popOne_vocal00,{1,27986,{1,31984,{1,35982,{1,39980,{1,43978,{1,47976,{1,51974,{^Cop Show 2,100,402,popOne_kbd00_,{12,7998,{^Slinky 2,100,406,hipHopOne_kbd00_,{15,0,{^"
  return aTestMix
end

on onStatus me, oCaller, oXml
  me.debug("onStatus()", 1)
end

on getStudiosFromResult me, oResult
  aStudioData = []
  iLength = oResult.length
  repeat with i = 0 to iLength - 1
    oStudio = oResult[i]
    aStudio = me.getStudioFromresult(oStudio)
    aStudioData.add(aStudio)
  end repeat
  return aStudioData
end

on getStudioFromresult me, oResult
  sStudioID = oResult.getStudioID()
  sName = oResult.getName()
  sDescription = oResult.getDescription()
  iUserCount = integer(oResult.getCurrentOccupancy())
  iCapacity = integer(oResult.getMaxOccupancy())
  iLocation = integer(oResult.getLocation())
  iLayout = integer(oResult.getLayout())
  sOwner = oResult.getOwnerName()
  iModifiable = oResult.getIsModifiable()
  iFeatured = oResult.getIsFeatured()
  aStudio = [:]
  aStudio[#studioId] = sStudioID
  aStudio[#name] = sName
  aStudio[#description] = sDescription
  aStudio[#userCount] = iUserCount
  aStudio[#capacity] = iCapacity
  aStudio[#location] = iLocation
  aStudio[#layout] = iLayout
  aStudio[#owner] = sOwner
  aStudio[#modifiable] = iModifiable
  aStudio[#featured] = iFeatured
  return aStudio
end

on getStudioLocation me, sStudioID
  repeat with i = 1 to aPrivateStudioData.count
    aStudioData = aPrivateStudioData[i]
    if aStudioData[#studioId] = sStudioID then
      iLocation = aStudioData[#location]
      return iLocation
    end if
  end repeat
  repeat with i = 1 to oPublicstudioData.aStudioData.count
    aStudioData = oPublicstudioData.aStudioData[i]
    if aStudioData[#studioId] = sStudioID then
      iLocation = aStudioData[#location]
      return iLocation
    end if
  end repeat
end

on getStudioLayout me, sStudioID, iLocation
  repeat with i = 1 to aPrivateStudioData.count
    aStudioData = aPrivateStudioData[i]
    if aStudioData[#studioId] = sStudioID then
      iLayout = aStudioData[#layout]
      return iLayout
    end if
  end repeat
  repeat with i = 1 to oPublicstudioData.aStudioData.count
    aStudioData = oPublicstudioData.aStudioData[i]
    if aStudioData[#studioId] = sStudioID then
      iLayout = aStudioData[#layout]
      return iLayout
    end if
  end repeat
end

on getStudioName me, sStudioID
  repeat with i = 1 to aPrivateStudioData.count
    aStudioData = aPrivateStudioData[i]
    if aStudioData[#studioId] = sStudioID then
      return aStudioData[#name]
    end if
  end repeat
  repeat with i = 1 to oPublicstudioData.aStudioData.count
    aStudioData = oPublicstudioData.aStudioData[i]
    if aStudioData[#studioId] = sStudioID then
      return aStudioData[#name]
    end if
  end repeat
end

on getGatewaySprite me
  return sprite(me.spriteNum)
end

on getTestStudios me
  aStudioData = []
  aStudioData.add([#studioId: "Aslan$1", #name: "1", #description: "test", #userCount: 0, #capacity: 25, #location: 1, #layout: 1, #server: "sfdev1.cokemusi", #owner: "aslan"])
  aStudioData.add([#studioId: "Aslan$2", #name: "2", #description: "test description", #userCount: 0, #capacity: 25, #location: 2, #layout: 2, #server: "sfdev1.cokemusi", #owner: "aslan"])
  aStudioData.add([#studioId: "Aslan$3", #name: "3", #description: "blah", #userCount: 0, #capacity: 25, #location: 1, #layout: 3, #server: "sfdev1.cokemusi", #owner: "aslan"])
  aStudioData.add([#studioId: "Aslan$4", #name: "4", #description: VOID, #userCount: 0, #capacity: 25, #location: 1, #layout: 4, #server: "sfdev1.cokemusi", #owner: "aslan"])
  aStudioData.add([#studioId: "Aslan$5", #name: "5", #description: VOID, #userCount: 0, #capacity: 25, #location: 1, #layout: 4, #server: "sfdev1.cokemusi", #owner: "aslan"])
  aStudioData.add([#studioId: "Aslan$6", #name: "6", #description: VOID, #userCount: 0, #capacity: 25, #location: 1, #layout: 4, #server: "sfdev1.cokemusi", #owner: "aslan"])
  aStudioData.add([#studioId: "Aslan$7", #name: "7", #description: VOID, #userCount: 0, #capacity: 25, #location: 1, #layout: 4, #server: "sfdev1.cokemusi", #owner: "aslan"])
  aStudioData.add([#studioId: "Aslan$8", #name: "8", #description: VOID, #userCount: 0, #capacity: 25, #location: 1, #layout: 4, #server: "sfdev1.cokemusi", #owner: "aslan"])
  aStudioData.add([#studioId: "Aslan$9", #name: "9", #description: VOID, #userCount: 0, #capacity: 25, #location: 1, #layout: 4, #server: "sfdev1.cokemusi", #owner: "aslan"])
  aStudioData.add([#studioId: "Aslan$10", #name: "10", #description: VOID, #userCount: 0, #capacity: 25, #location: 1, #layout: 4, #server: "sfdev1.cokemusi", #owner: "aslan"])
  aStudioData.add([#studioId: "freeble$1", #name: "Studio E", #description: "crib", #userCount: 0, #capacity: 25, #location: 1, #layout: 1, #server: "sfdev1.cokemusi", #owner: "freeble"])
  aStudioData.add([#studioId: "freeble$2", #name: "Studio F", #description: "basement tapes", #userCount: 0, #capacity: 25, #location: 2, #layout: 2, #server: "sfdev1.cokemusi", #owner: "freeble"])
  aStudioData.add([#studioId: "freeble$3", #name: "Studio G", #description: "loft experience", #userCount: 0, #capacity: 25, #location: 1, #layout: 3, #server: "sfdev1.cokemusi", #owner: "freeble"])
  aStudioData.add([#studioId: "freeble$4", #name: "Studio H", #description: "toys in the attic", #userCount: 0, #capacity: 25, #location: 1, #layout: 4, #server: "sfdev1.cokemusi", #owner: "freeble"])
  return aStudioData
end

on getTestStudio me
  return [#studioId: "aslan2", #name: "test", #description: "test", #userCount: 0, #capacity: 25, #location: 1, #layout: 1, #server: "sfdev1.cokemusi", #owner: "aslan"]
end

on getDefaultGameServer me
  return me.fo_level0.getDefaultGameServer()
end
