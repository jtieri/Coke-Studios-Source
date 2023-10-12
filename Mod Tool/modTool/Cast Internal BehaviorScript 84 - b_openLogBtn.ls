property pActive, pDataType, pStudioID, pStudioName, pStudioOwner, bDebug
global oUserDisplayManager, oCallAlertDisplayManager, aModRoomList, sModScreenName, ElementMgr, aChatLogDisplaySprites, oPublicDisplayManager, oPrivateDisplayManager, oModControllerManager, oStudioByModManager

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pDataType] = [#comment: "ChatLogDisplay data type:", #format: #string, #default: "public", #range: ["callAlert", "user", "public", "private"]]
  return mylist
end

on beginSprite me
  bDebug = 0
  aModRoomList = [:]
  pActive = 0
  pStudioID = EMPTY
end

on mouseUp me
  if not objectp(oStudioByModManager) then
    oStudioByModManager = new(script("StudioByModManager"), sModScreenName)
  end if
  me.debug("mouseUp:oStudioByModManager.aStudioByModList:" && oStudioByModManager.aStudioByModList)
  case pDataType of
    "callAlert":
      if oCallAlertDisplayManager.pCallAlertList.count = 0 then
        beep()
        exit
      else
        sStudioID = oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].studioId
        me.debug("mouseUp:callAlert:studioID" && sStudioID)
      end if
      if sStudioID = EMPTY then
        beep()
        exit
      else
        if oStudioByModManager.checkForOpenStudio(sStudioID) then
          beep()
          exit
        else
          pStudioID = sStudioID
          oStudioByModManager.addStudio(sModScreenName, sStudioID)
        end if
      end if
      pStudioName = oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].studioName
      pStudioOwner = oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].studioOwner
      if pStudioID.char[1] = "$" then
        sStudioType = "public"
        oPublicDisplayManager.pStudioID = pStudioID
        oPublicDisplayManager.pStudioName = pStudioName
        oPublicDisplayManager.pStudioOwner = pStudioOwner
      else
        sStudioType = "private"
        oPrivateDisplayManager.pStudioID = pStudioID
        oPrivateDisplayManager.pStudioName = pStudioName
        oPrivateDisplayManager.pStudioOwner = pStudioOwner
      end if
    "user":
      if oUserDisplayManager.pUserData = [] then
        beep()
        exit
      else
        if (oUserDisplayManager.pUserData.studioId = VOID) or (oUserDisplayManager.pUserData.studioId = EMPTY) or ((oUserDisplayManager.pUserData.studioId contains "$") = 0) then
          beep()
          exit
        else
          sStudioID = oUserDisplayManager.pUserData.studioId
          if oStudioByModManager.checkForOpenStudio(sStudioID) then
            beep()
            exit
          else
            pStudioID = sStudioID
            oStudioByModManager.addStudio(sModScreenName, sStudioID)
            me.debug("mouseUp:user:studioID" && sStudioID)
          end if
        end if
      end if
      me.debug("mouseUp:oUserDisplayManager.pUserData" && oUserDisplayManager.pUserData)
      pStudioName = oUserDisplayManager.pUserData.studioName
      pStudioOwner = oUserDisplayManager.pUserData.owner
      if pStudioID.char[1] = "$" then
        sStudioType = "public"
        oPublicDisplayManager.pStudioID = pStudioID
        oPublicDisplayManager.pStudioName = pStudioName
        oPublicDisplayManager.pStudioOwner = pStudioOwner
      else
        sStudioType = "private"
        oPrivateDisplayManager.pStudioID = pStudioID
        oPrivateDisplayManager.pStudioName = pStudioName
        oPrivateDisplayManager.pStudioOwner = pStudioOwner
      end if
    "public":
      sStudioID = oPublicDisplayManager.pStudioID
      me.debug("mouseUp:public:studioID" && sStudioID)
      if (oPublicDisplayManager.pSelected = 0) or oStudioByModManager.checkForOpenStudio(sStudioID) then
        beep()
        exit
      else
        pStudioID = sStudioID
        oStudioByModManager.addStudio(sModScreenName, sStudioID)
      end if
      pStudioName = oPublicDisplayManager.pStudioName
      pStudioOwner = oPublicDisplayManager.pStudioOwner
      oPublicDisplayManager.deSelectLines()
    "private":
      sStudioID = oPrivateDisplayManager.pStudioID
      me.debug("mouseUp:private:studioID" && sStudioID)
      if (oPrivateDisplayManager.pSelected = 0) or oStudioByModManager.checkForOpenStudio(sStudioID) then
        beep()
        exit
      else
        pStudioID = sStudioID
        oStudioByModManager.addStudio(sModScreenName, sStudioID)
      end if
      pStudioName = oPrivateDisplayManager.pStudioName
      pStudioOwner = oPrivateDisplayManager.pStudioOwner
      oPrivateDisplayManager.deSelectLines()
  end case
  repeat with i = 1 to aChatLogDisplaySprites.count
    pActive = sprite(aChatLogDisplaySprites[i]).scriptInstanceList[2].pActive
    if not pActive then
      oModRoom = oModControllerManager.getControllerBySlot(i)
      aModRoomList.addProp(i, oModRoom)
      aModRoomList.sort()
      oModRoom.openLog(sModScreenName, pStudioID, aModRoomList)
      sprite(aChatLogDisplaySprites[i]).scriptInstanceList[2].pActive = 1
      sprite(aChatLogDisplaySprites[i]).scriptInstanceList[2].pStartChatLog = 1
      sprite(aChatLogDisplaySprites[i]).scriptInstanceList[2].pStudioID = pStudioID
      sprite(aChatLogDisplaySprites[i]).scriptInstanceList[2].pStudioName = pStudioName
      sprite(aChatLogDisplaySprites[i]).scriptInstanceList[2].pStudioOwner = pStudioOwner
      sprite(aChatLogDisplaySprites[i]).scriptInstanceList[2].pDataType = pDataType
      if pDataType = "callAlert" then
        sDataType = sStudioType
      else
        sDataType = pDataType
      end if
      sendAllSprites(#displayOwner, sprite(aChatLogDisplaySprites[i]), sDataType)
      exit
      next repeat
    end if
    nothing()
  end repeat
  beep()
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "b_openLogBtn: " & sMessage
  end if
end
