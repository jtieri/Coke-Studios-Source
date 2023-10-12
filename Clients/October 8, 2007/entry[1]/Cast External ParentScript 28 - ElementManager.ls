property pOpenWindows, pLastUsedSprite, oMessenger, oSequencer, oMixer, oCdplayer, oTrader, oJukebox, oLoader, bDebug, pSelectedCatId, pSelectedAttributes
global oStudioManager, oDenizenManager, oCatalogManager, oPossessionManager, oSession, oRoom, oStudio, oStudioMap, oIsoScene, TextMgr, ElementMgr, oRoomServlet, oUserServlet, gMembersToDelete, sLanguageSetting, sCatalogText, ochat, gFeatureSet

on new me
  bDebug = 0
  pOpenWindows = [:]
  pLastUsedSprite = 1
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "ElementManager: " & sMessage
  end if
end

on newwindow me, description, whichrect
  me.debug("newWindow()" && "description:" && description && "whichRect:" && whichrect, 1)
  if description = "nav_private" then
    if not gFeatureSet.isEnabled(#PRIVATE_STUDIOS) then
      ElementMgr.alert("FEATURE_DISABLED")
      return 
    end if
  end if
  MyData = me.parsewindow(description)
  if voidp(whichrect) = 0 then
    MyData.rect = whichrect
  end if
  MyWindow = getaProp(pOpenWindows, MyData.name)
  if voidp(MyWindow) = 0 then
    MyWindow.bringtofront()
  else
    MyWindow = new(script("Windows Script"), MyData)
    addProp(pOpenWindows, MyData.name, MyWindow)
    MyWindow.boostup(1000000)
    MyWindow.bringtofront()
  end if
  if description contains "nav_public" then
    pOpenWindows[MyData.name].pScrollingLists.roomlist.displayloading()
    oStudioManager.getAllPublicStudios()
  else
    if description contains "nav_private" then
      if member("userlist").memberNum > 0 then
        if (member("userlist").comments <> "blocked") and (member("userlist").comments <> EMPTY) then
          if count(pOpenWindows[MyData.name].pScrollingLists) then
            pOpenWindows[MyData.name].pScrollingLists.userList.pUserData = value(member("userlist").comments.line[1])
            pOpenWindows[MyData.name].pScrollingLists.userList.pScrollIndex = value(member("userlist").comments.line[2])
            pOpenWindows[MyData.name].pScrollingLists.userList.updatecontent()
          end if
        else
          if member("userlist").comments <> "blocked" then
            oStudioManager.getAllPrivateStudios()
          end if
        end if
      else
        oStudioManager.getAllPrivateStudios()
      end if
    end if
  end if
  if description contains "people" then
    if MyData.name contains "public" then
      sRoomId = pOpenWindows[MyData.name].pScrollingLists.roomlist.pLastClicked.studioId
      oStudioManager.getOccupantsByStudioId(sRoomId)
    else
      if the runMode = "Author" then
        sRoomId = EMPTY
      else
        sRoomId = field("userroomID")
      end if
      oStudioManager.getOccupantsByStudioId(sRoomId)
    end if
  end if
  if description contains "jukebox.catalog" then
    pOpenWindows[MyData.name].pScrollingLists.cataloglist.displayloading()
    if the runMode = "author" then
      pOpenWindows[MyData.name].pScrollingLists.cataloglist.updatecontent()
    else
      oDenizenManager.getGenres()
    end if
  else
    if description contains "jukebox.playlist" then
      pOpenWindows[MyData.name].pScrollingLists.playList.displayloading()
      if the runMode = "author" then
        pOpenWindows[MyData.name].pScrollingLists.playList.updatecontent()
      else
        oDenizenManager.getPlaylist()
      end if
    else
      if description contains "jukebox.playback" then
        pOpenWindows[MyData.name].pScrollingLists.playList.displayloading()
        if the runMode = "author" then
          pOpenWindows[MyData.name].pScrollingLists.playList.updatecontent()
        else
          oDenizenManager.getPlaylist()
        end if
      end if
    end if
  end if
  me.bringAlertToFront()
  return MyWindow
end

on parsewindow me, description
  me.debug("parseWindow()" && "description:" && description)
  oXml = newObject("XML")
  oXml.ignoreWhite = 1
  oXml.parseXML(member(description).text)
  oWindow = getNode(oXml, "window")
  oName = getNode(oWindow, "name")
  oDAte = getNode(oWindow, "date")
  oVersion = getNode(oWindow, "version")
  oElements = getNode(oWindow, "elements")
  oRect = getNode(oWindow, "rect")
  oBorder = getNode(oWindow, "border")
  aStripChars = [9, 10, 13]
  if not voidp(oName) then
    sName = stripChars(oName.firstChild.nodeValue, aStripChars)
  end if
  if not voidp(oDAte) then
    sDate = stripChars(oDAte.firstChild.nodeValue, aStripChars)
  end if
  if not voidp(oVersion) then
    sVersion = stripChars(oVersion.firstChild.nodeValue, aStripChars)
  end if
  if not voidp(oElements) then
    sElements = stripChars(oElements.firstChild.nodeValue, aStripChars)
  end if
  if not voidp(oRect) then
    sRect = stripChars(oRect.firstChild.nodeValue, aStripChars)
  end if
  if not voidp(oBorder) then
    sBorder = stripChars(oBorder.firstChild.nodeValue, aStripChars)
  end if
  myName = sName
  myElements = []
  sOldDelimiter = the itemDelimiter
  the itemDelimiter = "]"
  iLength = sElements.items.count
  repeat with i = 1 to iLength
    sElement = sElements.item[i] & "]"
    aElement = value(sElement)
    if not voidp(aElement) then
      myElements.add(aElement)
      next repeat
    end if
    if sElement contains "[" then
      sElement = sElements.item[i] & "]" & sElements.item[i + 1] & "]"
      aElement = value(sElement)
      if not voidp(aElement) then
        myElements.add(aElement)
      end if
      next repeat
    end if
  end repeat
  the itemDelimiter = sOldDelimiter
  myRect = value(sRect)
  return [#name: myName, #elements: myElements, #rect: myRect]
end

on cleanupdata myString
  repeat while myString contains TAB
    mychar = offset(TAB, myString)
    delete char mychar of myString
  end repeat
  repeat with n = myString.line.count down to 1
    if myString.line[n] = EMPTY then
      delete line n of myString
      next repeat
    end if
    myLine = line n of myString
  end repeat
  repeat while myString.char[length(myString)] = " "
    delete char length(myString) of myString
  end repeat
  if (myString.char[1] = QUOTE) and (myString.char[length(myString)] = QUOTE) then
    delete char length(myString) of myString
    delete char 1 of myString
  end if
  return myString
end

on displayPublicStudios me, aRoomData
  repeat with n in pOpenWindows
    if count(n.pScrollingLists) then
      if voidp(getaProp(n.pScrollingLists, #roomlist)) = 0 then
        n.pScrollingLists.roomlist.pRoomData = aRoomData
        n.pScrollingLists.roomlist.updatecontent()
        exit
      end if
    end if
  end repeat
end

on displayStudioDetail me, aDetail
  repeat with n in pOpenWindows
    if count(n.pScrollingLists) then
      if voidp(getaProp(n.pScrollingLists, #roomlist)) = 0 then
        n.pScrollingLists.roomlist.displayRoomDetail(aDetail)
        exit
        next repeat
      end if
      if voidp(getaProp(n.pScrollingLists, #userList)) = 0 then
        n.pScrollingLists.userList.displayRoomDetail(aDetail)
        exit
      end if
    end if
  end repeat
end

on displayPrivateStudios me, aRoomData
  repeat with n in pOpenWindows
    if count(n.pScrollingLists) then
      if voidp(getaProp(n.pScrollingLists, #userList)) = 0 then
        n.pScrollingLists.userList.pUserData = aRoomData
        n.pScrollingLists.userList.updatecontent()
        exit
      end if
    end if
  end repeat
end

on displayStudioPeople me, aPeople
  repeat with n in pOpenWindows
    if count(n.pScrollingLists) then
      if voidp(getaProp(n.pScrollingLists, #peoplelist)) = 0 then
        n.pScrollingLists.peoplelist.pUserData = aPeople
        n.pScrollingLists.peoplelist.updatecontent(1)
        exit
      end if
    end if
  end repeat
end

on LastUsedSprite me
  repeat with n = 751 to the lastChannel
    if sprite(n).memberNum < 1 then
      pLastUsedSprite = n
      return n
    end if
  end repeat
end

on alert me, textID, textID2, bDialogWindow
  me.debug("alert()" && "textID:" && textID && "textID2:" && textID2)
  if bDialogWindow then
    me.newwindow("whale_wash_dialog.window")
    me.debug("textmgr.getreftext(textID):" && TextMgr.GetRefText(textID))
    member("entry_alertext").text = TextMgr.GetRefText(textID)
  else
    if voidp(textID2) then
      me.newwindow("sanfo_general_alert.window")
      member("entry_alertext").text = TextMgr.GetRefText(textID)
    else
      me.newwindow("sanfo_general_alert_extralong.window")
      mymessage = TextMgr.GetRefText(textID2)
      if voidp(mymessage) or (mymessage = EMPTY) then
        member("bold_alert_text").text = TextMgr.GetRefText(textID)
        member("entry_bigalertext22").text = textID2
      else
        member("bold_alert_text").text = TextMgr.GetRefText(textID)
        member("entry_bigalertext22").text = mymessage
      end if
    end if
  end if
  sParamString = EMPTY
  if (textID = "ALERT_GENERIC") or (textID2 = "ALERT_GENERIC") then
    sParamString = "Problem with the server"
  else
    if (textID = "ALERT_FULL") or (textID2 = "ALERT_FULL") then
      sParamString = "Room is currently full"
    else
      if (textID = "ALERT_BANNED") or (textID2 = "ALERT_BANNED") then
        sParamString = "Temporarily banned"
      else
        if (textID = "ALERT_STATE_CLOSED") or (textID2 = "ALERT_STATE_CLOSED") then
          sParamString = "CS is now closed"
        else
          if (textID = "ALERT_STATE_FULL") or (textID2 = "ALERT_STATE_FULL") then
            sParamString = "CS is currently full"
          else
            if (textID = "ALERT_NO_CONNECTION") or (textID2 = "ALERT_NO_CONNECTION") then
              sParamString = "No connection with server"
            else
              if (textID = "ALERT_DROPPED_CONNECTION") or (textID2 = "ALERT_DROPPED_CONNECTION") then
                sParamString = "Connection dropped"
              else
                if (textID = "ALERT_USER_NOT_FOUND") or (textID2 = "ALERT_USER_NOT_FOUND") then
                  sParamString = "Could not authenticate user"
                else
                  if (textID = "ALERT_DUPLICATE_LOGIN") or (textID2 = "ALERT_DUPLICATE_LOGIN") then
                    sParamString = "Connection lost - duplicate login"
                  else
                    if (textID = "ALERT_ROOM_NOT_EXIST") or (textID2 = "ALERT_ROOM_NOT_EXIST") then
                      sParamString = "Room does not exist"
                    else
                      if (textID = "ALERT_MAX_ITEMS_EXCEEDED") or (textID2 = "ALERT_MAX_ITEMS_EXCEEDED") then
                        sParamString = "Max items exceeded"
                      else
                        if (textID = "ALERT_NO_BLANK_CDS") or (textID2 = "ALERT_NO_BLANK_CDS") then
                          sParamString = "No blank CDs"
                        else
                          if (textID = "ALERT_NO_SERVER_AVAILABLE") or (textID2 = "ALERT_NO_SERVER_AVAILABLE") then
                            sParamString = "Problem locating this studio"
                          else
                            if (textID = "ALERT_INVALID_SCREEN_NAME") or (textID2 = "ALERT_INVALID_SCREEN_NAME") then
                              sParamString = "Name with invalid characters"
                            end if
                          end if
                        end if
                      end if
                    end if
                  end if
                end if
              end if
            end if
          end if
        end if
      end if
    end if
  end if
  if sParamString <> EMPTY then
    sParamString = "javascript:doTrackingCokeStudios('cokestudios.error.alert', '" & sParamString & "')"
    put "sParamString: " & sParamString
    gotoNetPage(sParamString)
  end if
  me.getLoader().closeWindow()
end

on decisiondialog me, textID, okbuttonscript
  me.newwindow("sanfo_decision_dialog.window")
  member("entry_bigalertext").text = TextMgr.GetRefText(textID)
  updateStage()
  okbutton = sendAllSprites(#getokbutton)
  append(sprite(okbutton).scriptInstanceList, new(script(okbuttonscript)))
end

on URLdialog me, textID, myURL
  me.newwindow("sanfo_decision_dialog.window")
  member("entry_bigalertext").text = TextMgr.GetRefText(textID)
  updateStage()
  okbutton = sendAllSprites(#getokbutton)
  append(sprite(okbutton).scriptInstanceList, new(script("go to URL ok"), myURL))
end

on startCreateStudio_Result me, iError, sStudioID
  case iError of
    0:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_createroom.window", myRect)
    1:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_private_start.window", myRect)
      me.alert("ALERT_GENERIC")
    6:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_private_start.window", myRect)
      me.alert("ALERT_GENERIC")
    9:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_private_start.window", myRect)
      myscreenname = oDenizenManager.getScreenName()
      oStudioManager.getByOwnerName(myscreenname)
      me.alert("ALERT_OVER_LIMIT")
  end case
end

on createStudio_Result me, iError, sStudioName, sStudioID
  global gMembersToDelete
  case iError of
    0:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_roomready.window", myRect)
      member("nav_studio_own_createdname").text = sStudioName
      if member("userroomid").memberNum < 1 then
        myMember = new(#field)
        myMember.name = "userroomid"
        append(gMembersToDelete, myMember)
      end if
      member("userroomid").text = sStudioID
    1:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_createroom.window", myRect)
      me.alert("ALERT_GENERIC")
    6:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_createroom.window", myRect)
      me.alert("ALERT_GENERIC")
    7:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_createroom.window", myRect)
      me.alert("ALERT_ST_NAME_LANG")
    8:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_createroom.window", myRect)
      me.alert("ALERT_ST_DESC_LANG")
    9:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_private_start.window", myRect)
      myscreenname = oDenizenManager.getScreenName()
      oStudioManager.getByOwnerName(myscreenname)
      me.alert("ALERT_OVER_LIMIT")
  end case
end

on startModifyStudio_Result me, iError, sStudioName, sStudioDescription
  case iError of
    0:
      myRect = me.pOpenWindows.nav_private_info.prect
      me.pOpenWindows.nav_private_info.closeWindow()
      me.newwindow("nav_private_modify.window", myRect)
      member("nav_modify_studio_name").text = sStudioName
      member("nav_modify_studio_desc").text = string(sStudioDescription)
    1, 2, 3:
      me.alert("ALERT_GENERIC")
  end case
end

on deleteStudio_Result me, iError
  case iError of
    0:
      myRect = me.pOpenWindows.nav_private_modify_delete2.prect
      me.pOpenWindows.nav_private_modify_delete2.closeWindow()
      me.newwindow("nav_private_modify_delete3.window", myRect)
    1, 2, 3:
      myRect = me.pOpenWindows.nav_private_modify_delete2.prect
      me.pOpenWindows.nav_private_modify_delete2.closeWindow()
      me.newwindow("nav_private_start.window", myRect)
      me.alert("ALERT_GENERIC")
    17:
      myRect = me.pOpenWindows.nav_private_modify_delete2.prect
      me.pOpenWindows.nav_private_modify_delete2.closeWindow()
      me.newwindow("nav_private_start.window", myRect)
      me.alert("ALERT_STUDIO_NOT_EMPTY")
  end case
end

on getDenizenByScreenName_Result me, iError, sScreenName, sLastAccess, sLastSeen, sAvatarMission, sAvatarString, bOnline, bExists, sLastSeenInName
  case iError of
    0:
      if not bExists then
        if voidp(getaProp(me.pOpenWindows, #nav_search_results)) = 0 then
          myRect = me.pOpenWindows.nav_search_results.prect
          me.pOpenWindows.nav_search_results.closeWindow()
          me.newwindow("nav_search_start.window", myRect)
        end if
        member("nav_v-ego_search_starttext").text = TextMgr.GetRefText("NAV_VEGOS_NOT_FOUND")
        member("nav_v-ego_desc").text = EMPTY
      else
        if voidp(getaProp(me.pOpenWindows, #nav_search_results)) = 1 then
          myRect = me.pOpenWindows.nav_search_start.prect
          me.pOpenWindows.nav_search_start.closeWindow()
          me.newwindow("nav_search_results.window", myRect)
        end if
        member("nav_v-ego_search_name1").text = sScreenName
        if sAvatarMission <> VOID then
          member("nav_v-ego_search_motto").text = sAvatarMission
        else
          member("nav_v-ego_search_motto").text = EMPTY
        end if
        oPreviewImage = oDenizenManager.getDenizenAvatarImage(sAvatarString)
        member("nav_v-ego_result_dummyfigure").image = oPreviewImage
        if not bOnline then
          member("nav_v-ego_search_lastlocation").text = TextMgr.GetRefText("NAV_VEGOS_CURRENTLY")
          member("nav_v-ego_search_Location_name").text = TextMgr.GetRefText("NAV_VEGOS_OFFLINE")
        else
          member("nav_v-ego_search_lastlocation").text = TextMgr.GetRefText("NAV_VEGOS_LAST_SEEN")
          if voidp(sLastSeen) or (sLastSeen = EMPTY) or (sLastSeen = "$LOBBY$") then
            myloc = TextMgr.GetRefText("NAV_VEGOS_LOBBY")
          else
            bIsFriend = me.getMessengerObject().isFriend(sScreenName)
            bIsPublic = sLastSeen starts "$SYSTEM$"
            if bIsFriend then
              myloc = sLastSeenInName
            else
              if bIsPublic then
                myloc = "Public Studio"
              else
                myloc = "Private Studio"
              end if
            end if
          end if
          member("nav_v-ego_search_Location_name").text = myloc
        end if
        if sLastAccess <> VOID then
          member("nav_v-ego_search_name2").text = TextMgr.GetRefText("NAV_VEGOS_LAST_ACCESS")
          the itemDelimiter = " "
          NewDate = TextMgr.getDate(sLastAccess)
          mytime = TextMgr.getTime(sLastAccess)
          outputdate = NewDate && mytime
          member("nav_v-ego_search_name3").text = outputdate
        end if
      end if
    1:
      if voidp(getaProp(me.pOpenWindows, #nav_search_results)) = 0 then
        myRect = me.pOpenWindows.nav_search_results.prect
        me.pOpenWindows.nav_search_results.closeWindow()
        me.newwindow("nav_search_start.window", myRect)
      end if
      member("nav_v-ego_search_starttext").text = TextMgr.GetRefText("NAV_VEGOS_NOT_FOUND")
      member("nav_v-ego_desc").text = EMPTY
    2:
      if voidp(getaProp(me.pOpenWindows, #nav_search_results)) = 0 then
        myRect = me.pOpenWindows.nav_search_results.prect
        me.pOpenWindows.nav_search_results.closeWindow()
        me.newwindow("nav_search_start.window", myRect)
      end if
      member("nav_v-ego_search_starttext").text = TextMgr.GetRefText("NAV_VEGOS_NOT_FOUND")
      member("nav_v-ego_desc").text = EMPTY
  end case
end

on modifyStudio_Result me, iError, sStudioName
  case iError of
    0:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_private_start.window", myRect)
      member("userlist").comments = "blocked"
      ElementMgr.pOpenWindows.nav_private_start.pScrollingLists.userList.displayloading()
      oStudioManager.getAllPrivateStudios()
    1:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_private_modify.window", myRect)
      me.alert("ALERT_GENERIC")
    6:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_private_modify.window", myRect)
      me.alert("ALERT_GENERIC")
    7:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_private_modify.window", myRect)
      me.alert("ALERT_ST_NAME_LANG")
    8:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_private_modify.window", myRect)
      me.alert("ALERT_ST_DESC_LANG")
    9:
      myRect = ElementMgr.pOpenWindows.nav_loadnewroom.prect
      ElementMgr.pOpenWindows.nav_loadnewroom.closeWindow()
      ElementMgr.newwindow("nav_private_modify.window", myRect)
      myscreenname = oDenizenManager.getScreenName()
      oStudioManager.getByOwnerName(myscreenname)
      me.alert("ALERT_OVER_LIMIT")
  end case
end

on loginUser_Result me, iError, iState, iStatus, bNewUser
  me.debug("loginUser_Result()" && "iError:" && iError && "iState:" && iState && "iStatus:" && iStatus && "bNewUser:" && bNewUser)
  repeat with n = 2 to 6
    sprite(n).scriptInstanceList = []
    sprite(n).memberNum = -1
    puppetSprite(n, 0)
  end repeat
  case iError of
    0:
      case iStatus of
        1:
          case iState of
            1:
              me.alert("ALERT_STATE_CLOSED")
            2:
              go("LoadCasts2")
            3:
              me.alert("ALERT_STATE_FULL")
          end case
        2:
          me.alert("ALERT_BANNED")
      end case
    1:
      me.alert("ALERT_GENERIC")
    2:
      me.alert("ALERT_INVALID_SCREEN_NAME")
  end case
end

on loginModerator_Result me, iError
  me.debug("loginModerator_Result() " & iError, 1)
end

on connectionFailed me, iReasonId
  me.debug("connectionfailed():iReasonID" && iReasonId, 1)
  case iReasonId of
    5:
      me.alert("ALERT_NO_CONNECTION")
    otherwise:
      me.alert("ALERT_GENERIC")
  end case
end

on loginFailed me, iReasonId
  me.debug("loginFailed():iReasonID" && iReasonId, 1)
  case iReasonId of
    8956:
      me.alert("ALERT_USER_NOT_FOUND")
    8957:
      me.alert("ALERT_DUPLICATE_LOGIN")
    8950:
      me.alert("ALERT_STATE_FULL")
    otherwise:
      me.alert("ALERT_GENERIC")
  end case
end

on lostConnection me
  me.alert("ALERT_DROPPED_CONNECTION")
end

on roomEnterFailed me, sRoomId, iReasonId
  me.debug("roomEnterFailed():sRoomID" && sRoomId && "iReasonID:" && iReasonId, 1)
  case iReasonId of
    9000:
      me.alert("ALERT_ROOM_NOT_EXIST")
    9008:
      gotoEntry()
      me.alert("ALERT_FULL")
    otherwise:
      me.alert("ALERT_GENERIC")
  end case
end

on bringAlertToFront me
  repeat with n = count(me.pOpenWindows) down to 1
    _oWindow = me.pOpenWindows[n]
    _sWindowName = _oWindow.pname
    if _sWindowName starts "sanfo_general_alert" then
      _oWindow.bringtofront()
    end if
  end repeat
end

on closeAllWindows me
  repeat with n = count(me.pOpenWindows) down to 1
    _oWindow = me.pOpenWindows[n]
    _sWindowName = _oWindow.pname
    if _sWindowName starts "sanfo_general_alert" then
      next repeat
    end if
    _oWindow.closeWindow()
  end repeat
  if not voidp(ochat) then
    ochat.hideChat()
  end if
end

on getDenizenBalance_Result me, iError, iBalance
  case iError of
    0:
      myString = TextMgr.GetRefText("BALANCE_DISPLAY")
      myword = "{balance}"
      mypos = offset(myword, myString)
      myString = myString.char[1..mypos - 1] & iBalance & myString.char[mypos + length(myword)..length(myString)]
      member("balance_decibels").text = myString
    1:
      myString = TextMgr.GetRefText("BALANCE_DISPLAY_FAILED")
      member("balance_decibels").text = myString
  end case
end

on getPossessionsInBackpack_Result me, iError, aItems, iCurrentPage, iTotalPages, iTotalItems, iCds
  cdsentence = TextMgr.GetRefText("USER_ITEMS_CDS")
  charpos = offset("{CDs}", cdsentence)
  delete char charpos to charpos + 4 of cdsentence
  if charpos = 1 then
    cdsentence = string(iCds) & cdsentence
  else
    put string(iCds) after char charpos - 1 of cdsentence
  end if
  member("cc.pack.empty.cds").text = cdsentence
  repeat with n = 1 to count(pOpenWindows)
    if getPropAt(pOpenWindows, n) = "cc_backpack" then
      sprite(pOpenWindows[n].pSpritelist[2]).pItems = aItems
      sprite(pOpenWindows[n].pSpritelist[2]).pcurrentpage = iCurrentPage
      sprite(pOpenWindows[n].pSpritelist[2]).pIndex = iCurrentPage
      sprite(pOpenWindows[n].pSpritelist[2]).pTotalPages = iTotalPages
      sprite(pOpenWindows[n].pSpritelist[2]).pTotalItems = iTotalItems
      sprite(pOpenWindows[n].pSpritelist[2]).updatedisplay()
      exit repeat
    end if
  end repeat
end

on cataloguepages me
  global sLanguageSetting, sCatalogText
  mytext = sCatalogText
  the itemDelimiter = "="
  catpages = []
  repeat with n = 1 to the number of lines in mytext
    if mytext.line[n].item[1] = "PAGE" then
      append(catpages, value(mytext.line[n].item[2]))
    end if
  end repeat
  return catpages
end

on getcatalogueitems me, whatpageID
  global sLanguageSetting, sCatalogText
  mytext = sCatalogText
  the itemDelimiter = "="
  catitems = []
  repeat with n = 1 to the number of lines in mytext
    if mytext.line[n].item[1] = "ITEM" then
      myitem = value(mytext.line[n].item[2])
      if voidp(whatpageID) then
        append(catitems, myitem)
        next repeat
      end if
      if myitem[#catId] = whatpageID then
        append(catitems, myitem)
      end if
    end if
  end repeat
  return catitems
end

on getProductList_Result me, iError, aProdList
  case iError of
    0:
      if voidp(getaProp(pOpenWindows, #catalogue_pagedynamic)) = 0 then
        me.pOpenWindows.catalogue_pagedynamic.pScrollingLists.itemslist.pitemsData = aProdList
        me.pOpenWindows.catalogue_pagedynamic.pScrollingLists.itemslist.updatecontent()
      end if
  end case
end

on prePurchaseItem_Result me, iError, iBalance, iPrice, sProdID, aAttributes
  global TextMgr
  if not voidp(iBalance) and not voidp(iPrice) then
    if integerp(iBalance) and integerp(iPrice) then
      if iBalance < iPrice then
        me.alert("ALERT_INSUFFICIENT_BALANCE")
        return 
      end if
    end if
  end if
  case iError of
    0:
      repeat with n in pOpenWindows
        if count(n.pScrollingLists) then
          if voidp(getaProp(n.pScrollingLists, #itemslist)) = 0 then
            if voidp(sProdID) = 0 then
              itemslist = me.pOpenWindows.catalogue_pagedynamic.pScrollingLists.itemslist.pItemsList
              repeat with myitem in itemslist
                if myitem[#prodID] = sProdID then
                  myName = myitem[#name]
                  exit repeat
                end if
              end repeat
            else
              myName = "this item"
            end if
            exit repeat
          end if
        end if
      end repeat
      if voidp(sProdID) then
        return 
      end if
      me.newwindow("purchase_info.window")
      purchasetitle = TextMgr.GetRefText("PURCHASE_PRICE")
      mychar = offset("{item}", purchasetitle)
      delete char mychar to mychar + 5 of purchasetitle
      put myName & " " into char mychar of purchasetitle
      mychar = offset("{price}", purchasetitle)
      delete char mychar to mychar + 6 of purchasetitle
      put iPrice & " " into char mychar of purchasetitle
      member("purchase_bold_alert_text").text = purchasetitle
      secondline = TextMgr.GetRefText("PURCHASE_BALANCE")
      mychar = offset("{balance}", secondline)
      delete char mychar to mychar + 8 of secondline
      put iBalance & " " into char mychar of secondline
      member("purchase_bigalertext").text = secondline
      me.pSelectedCatId = sProdID
      me.pSelectedAttributes = aAttributes
  end case
end

on purchaseItem_Result me, iError, aPossessions
  case iError of
    0:
      oBackPack = oDenizenManager.getBackpack()
      if not voidp(oBackPack) then
        oBackPack.addPossessions(aPossessions, 1)
      end if
      repeat with n = 1 to count(pOpenWindows)
        if getPropAt(pOpenWindows, n) = "cc_backpack" then
          sprite(pOpenWindows[n].pSpritelist[2]).pIndex = 1
          myscreenname = oDenizenManager.getScreenName()
          oBackPack = oDenizenManager.getBackpack()
          if not voidp(oBackPack) then
            oPossessionManager.getPossessionsInBackpack(myscreenname, 1, 25)
            pOpenWindows[n].bringtofront()
          end if
          exit repeat
          next repeat
        end if
        if n = count(pOpenWindows) then
          me.newwindow("cc.backpack.window")
          exit repeat
        end if
      end repeat
    1:
      me.alert("ALERT_INSUFFICIENT_BALANCE")
  end case
end

on getSequencer me
  oMember = member("Sequencer")
  if oMember.memberNum < 0 then
    return VOID
  end if
  if voidp(me.oSequencer) then
    me.oSequencer = script("Sequencer").new()
  end if
  return me.oSequencer
end

on getMessengerObject me
  if voidp(me.oMessenger) then
    me.oMessenger = script("_MESSENGER_").new()
  end if
  return me.oMessenger
end

on getMessenger_Result me, iError, iFriendCount, iEnemyCount, iInviteCount, iTotalMessageCount, aFriends, aEnemies, aInvites, aMessages
  me.debug("getMessenger_Result()" && "iError:" && iError && "iFriendCount:" && iFriendCount && "iEnemyCount:" && iEnemyCount && "iInviteCount:" && iInviteCount && "iTotalMessageCount:" && iTotalMessageCount && "aFriends:" && aFriends && "aEnemies:" && aEnemies && "aInvites:" && aInvites && "aMessages:" && aMessages)
  case iError of
    0:
      me.getMessengerObject().updateData(iFriendCount, iEnemyCount, iInviteCount, iTotalMessageCount, aFriends, aEnemies, aInvites, aMessages)
  end case
end

on sendMessage_Result me, iError
  global ElementMgr, oDenizenManager
  case iError of
    18:
      me.alert("ALERT_MESSENGER_LANG")
    otherwise:
      me.debug("** sendMessage_Result() ERROR: " & iError)
  end case
end

on removeMessage_Result me, iError
  case iError of
    0:
    otherwise:
      me.debug("** removeMessage_Result() ERROR: " & iError)
  end case
end

on rejectInvitation_Result me, iError
  global oDenizenManager
  me.debug("** rejectInvitation_Result() ERROR: " & iError)
  case iError of
    0:
  end case
end

on acceptInvitation_Result me, iError
  global oDenizenManager
  case iError of
    0:
      oDenizenManager.getMessenger()
  end case
end

on removeFriends_Result me, iError
  case iError of
    0:
  end case
end

on inviteFriend_Result me, iError
  nothing()
end

on openmixer me
  if not voidp(me.oMixer) then
    me.oMixer.closeWindow()
  end if
  me.oMixer = script("_MIXER_").new()
  oStudioManager.getMixerByScreenName(oDenizenManager.getScreenName())
  return me.oMixer
end

on getMixer me
  return me.oMixer
end

on getMixerByScreenName_Result me, iError, aRemoteMixer
  case iError of
    0:
      me.oMixer.pMixerData = aRemoteMixer
      me.oMixer.updatecontent()
  end case
end

on burnMixToCD_Result me, iError, aPossessions
  case iError of
    0:
      me.openmixer()
      me.alert("BURN_CD_BURNT")
      oBackPack = oDenizenManager.getBackpack()
      if not voidp(oBackPack) then
        oBackPack.addPossessions(aPossessions, 1)
        oBackPack.incrementNumberOfBlankCds(-aPossessions.length)
        oPossessionManager.getPossessionsInBackpack(oDenizenManager.getScreenName(), 1, 25)
      end if
  end case
end

on opencdplayer me
  me.debug("openCdPlayer()")
  if not voidp(me.oCdplayer) then
    me.oCdplayer.closeWindow()
  end if
  me.oCdplayer = script("_CDPLAYER_").new()
  oPossessionManager.getBurnedCDsInBackPack(oDenizenManager.getScreenName())
  return me.oCdplayer
end

on closeCdPlayer me
  me.debug("closeCdPlayer()")
  if voidp(me.oCdplayer) then
    return 
  end if
  me.oCdplayer.closeWindow()
end

on getcdplayer me
  me.debug("getCdPlayer()")
  return me.oCdplayer
end

on getBurnedCdsInBackpack_Result me, iError, aCds
  me.debug("getBurnedCdsInBackpack_Result()" & "iError: " & iError & "aCds: " & aCds)
  case iError of
    0:
      if aCds.count = 0 then
        oStudio.sendCdStop()
        me.alert("NOCD_TITLE", "NOCD_DESC")
      else
        me.oCdplayer.getOpenWindow().pScrollingLists.songslist.pSongsData = aCds
        me.oCdplayer.getOpenWindow().pScrollingLists.songslist.updatecontent()
      end if
  end case
end

on openJukebox me
  me.debug("openjukebox()")
  if not voidp(me.oJukebox) then
    me.oJukebox.closeWindow()
  end if
  me.oJukebox = script("_JUKEBOX_").new()
  return me.oJukebox
end

on openjukeboxplayer me
  if not voidp(me.oJukebox) then
    me.oJukebox.closeWindow()
  end if
  me.oJukebox = script("_JUKEBOX_").new()
  me.oJukebox.openWindow("cc.infinite_jukebox.playback.window")
end

on closeJukebox me
  me.debug("closeJukebox()")
  if voidp(me.oJukebox) then
    return 
  end if
  me.oJukebox.closeWindow()
end

on getJukebox me
  me.debug("getJukebox()")
  return me.oJukebox
end

on getLoader me
  if voidp(me.oLoader) then
    me.oLoader = script("_Loader_").new()
  end if
  return me.oLoader
end

on opentrader me
  if not voidp(me.oTrader) then
    me.oTrader.closeWindow()
  end if
  me.oTrader = script("_TRADER_").new()
  return me.oTrader
end

on getTrader me
  return me.oTrader
end

on cancelTrade me
  if not voidp(me.oTrader) then
    me.oTrader.closeWindow()
    me.oTrader = VOID
  end if
end

on displayTrade me, lContent
  if voidp(me.oTrader) then
    oIsoScene.dropSelectedItem(1)
    me.opentrader()
  end if
  me.oTrader.displayWindow(VOID, lContent)
end

on displayVoteResults me, sAuthorScreenName, iThumbsUp, iThumbsDown, iDecibelsAwarded
  myphrase = TextMgr.GetRefText("THUMBS_UP_VOTES")
  mychar = offset("{voteupnum}", myphrase)
  delete char mychar to mychar + length("{voteupnum}") - 1 of myphrase
  put iThumbsUp & " " into char mychar of myphrase
  mytext = myphrase & RETURN
  myphrase = TextMgr.GetRefText("THUMBS_DOWN_VOTES")
  mychar = offset("{votedownnum}", myphrase)
  delete char mychar to mychar + length("{votedownnum}") - 1 of myphrase
  put iThumbsDown & " " into char mychar of myphrase
  mytext = mytext & myphrase & RETURN & RETURN
  myphrase = TextMgr.GetRefText("DECIBEL_RESULT")
  mychar = offset("{numdecibel}", myphrase)
  delete char mychar to mychar + length("{numdecibel}") - 1 of myphrase
  put iDecibelsAwarded & " " into char mychar of myphrase
  mytext = mytext & myphrase
  me.alert("RESULTS_TITLE", mytext)
end

on displayDrinkCoke me, iPoints
  capwindow = me.newwindow("cc_capdecibels.window")
  captimer = new(script("captimer"), capwindow)
  mytext = TextMgr.GetRefText("DRINK_COKE")
  mychar = offset("{points}", mytext)
  delete char mychar to mychar + (length("{points}") - 1) of mytext
  put iPoints & " " into char mychar of mytext
  member("cc.capdecibel.text").text = mytext
  me.debug("text member: " & member("cc.capdecibel.text"), 1)
end

on displayWallReplace me, iPosId, iWallTexture, iWallColor, iFloorTexture, iFloorColor
  global TextMgr
  me.newwindow("confirm_texture.window")
  updateStage()
  sendAllSprites(#setfloor, iFloorTexture, iFloorColor)
  sendAllSprites(#setwalls, iWallTexture, iWallColor)
  sendAllSprites(#displayPattern)
  member("cc.confirm.texture").text = TextMgr.GetRefText("REPLACE_WALL")
  okbutton = sendAllSprites(#getokreplace)
  sprite(okbutton).pType = #wall
  sprite(okbutton).iPosId = iPosId
  sprite(okbutton).iWallTexture = iWallTexture
  sprite(okbutton).iWallColor = iWallColor
end

on displayFloorReplace me, iPosId, iWallTexture, iWallColor, iFloorTexture, iFloorColor
  global TextMgr
  me.newwindow("confirm_texture.window")
  updateStage()
  sendAllSprites(#setfloor, iFloorTexture, iFloorColor)
  sendAllSprites(#setwalls, iWallTexture, iWallColor)
  sendAllSprites(#displayPattern)
  member("cc.confirm.texture").text = TextMgr.GetRefText("REPLACE_FLOOR")
  okbutton = sendAllSprites(#getokreplace)
  sprite(okbutton).pType = #floor
  sprite(okbutton).iPosId = iPosId
  sprite(okbutton).iFloorTexture = iFloorTexture
  sprite(okbutton).iFloorColor = iFloorColor
end

on updatefloor me, iFloorTexture, iFloorColor
  aPatterns = [:]
  sAssetCast = "Catalogue"
  oPatternMember = member("cat_floorpattern_patterns_index", sAssetCast)
  sPatternText = oPatternMember.text
  repeat with i = 1 to sPatternText.lines.count
    sPatternLine = sPatternText.line[i]
    aPatternList = value(sPatternLine)
    sPatternName = aPatternList.name
    sColorField = aPatternList.field
    aColors = []
    oColorsMember = member(sColorField, sAssetCast)
    sColorsText = oColorsMember.text
    repeat with ii = 1 to sColorsText.lines.count
      sColorLine = sColorsText.line[ii]
      aColorsList = value(sColorLine)
      aColors.add(aColorsList)
    end repeat
    aPatterns.addProp(sPatternName, aColors)
  end repeat
  iFloorShapeSprite = sendAllSprites(#getFloorShapeSpritereplace)
  iFloorTextureSprite = sendAllSprites(#getFloorTextureSpriteReplace)
  aColorData = aPatterns[iFloorTexture][iFloorColor]
  sprite(iFloorShapeSprite).member.fillColor = aColorData.startcolor
  sprite(iFloorShapeSprite).member.endColor = aColorData.endColor
  sprite(iFloorShapeSprite).blend = aColorData.shapeBlend
  sprite(iFloorTextureSprite).member.palette = member("cat_floor_" & aColorData.palette, sAssetCast)
  sprite(iFloorShapeSprite).color = aColorData.texturecolor
  sprite(iFloorTextureSprite).blend = aColorData.textureBlend
end

on updatewalls me, iPatternIndex, iColorIndex
  sAssetCast = "Catalogue"
  iLeftWallSprite = sendAllSprites(#getLeftWallSpriteReplace)
  iRightWallSprite = sendAllSprites(#getRightWallSpriteReplace)
  iLeftWallTextureSprite = sendAllSprites(#getLeftWallTextureSpriteReplace)
  iRightWallTextureSprite = sendAllSprites(#getRightWallTextureSpriteReplace)
  iWallBackgroundsprite = sendAllSprites(#getWallBackgroundSpritereplace)
  aPatterns = [:]
  oPatternMember = member("cat_wallpattern_patterns_index", sAssetCast)
  sPatternText = oPatternMember.text
  repeat with i = 1 to sPatternText.lines.count
    sPatternLine = sPatternText.line[i]
    aPatternList = value(sPatternLine)
    sPatternName = aPatternList.name
    sColorField = aPatternList.field
    aColors = []
    oColorsMember = member(sColorField, sAssetCast)
    sColorsText = oColorsMember.text
    repeat with ii = 1 to sColorsText.lines.count
      sColorLine = sColorsText.line[ii]
      aColorsList = value(sColorLine)
      aColors.add(aColorsList)
    end repeat
    aPatterns.addProp(sPatternName, aColors)
  end repeat
  aColorData = aPatterns[iPatternIndex][iColorIndex]
  if aColorData.dirtStyle = 1 then
    sprite(iLeftWallSprite).member = member("cat_left_wall_1_b_0_0_0", sAssetCast)
    sprite(iRightWallSprite).member = member("cat_right_wall_1_b_0_0_0", sAssetCast)
  end if
  if aColorData.dirtStyle = 2 then
    sprite(iLeftWallSprite).member = member("cat_left_wall_2_b_0_0_0", sAssetCast)
    sprite(iRightWallSprite).member = member("cat_right_wall_2_b_0_0_0", sAssetCast)
  end if
  sprite(iLeftWallSprite).color = aColorData.color
  sprite(iRightWallSprite).color = aColorData.color
  sprite(iLeftWallSprite).bgColor = aColorData.bgColor
  sprite(iRightWallSprite).bgColor = aColorData.bgColor
  sprite(iLeftWallSprite).blend = aColorData.dirtBlend
  sprite(iRightWallSprite).blend = aColorData.dirtBlend
  sprite(iLeftWallTextureSprite).member.palette = member("cat_left_wall_" & aColorData.palette, sAssetCast)
  sprite(iRightWallTextureSprite).member.palette = member("cat_right_wall_" & aColorData.palette, sAssetCast)
  sprite(iLeftWallTextureSprite).blend = aColorData.textureBlend
  sprite(iRightWallTextureSprite).blend = aColorData.textureBlend
end

on displayDeleteConfirm me, iPosId
  me.newwindow("delete_item.window")
  updateStage()
  oksprite = sendAllSprites(#getdeleteok)
  if voidp(oksprite) then
    alert("can't find delete ok sprite")
  else
    sprite(oksprite).iPosId = iPosId
  end if
end

on mouseIsOverBackpack me
  iBackpackSprite = sendAllSprites(#getBackpackBackgroundSprite)
  if voidp(iBackpackSprite) then
    return 0
  end if
  return rollover(iBackpackSprite)
end

on mouseIsOverWindow me
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    repeat with m = 1 to count(ElementMgr.pOpenWindows[n].pSpritelist)
      iSprite = ElementMgr.pOpenWindows[n].pSpritelist[m]
      if rollover(iSprite) then
        return 1
      end if
    end repeat
  end repeat
  return 0
end

on exception me, sMessage
end

on getByStudioId_Result iError, foStudio
end

on dispenseItem_Result me, iError, aPossessions
  me.debug("dispensePoster_Result() iError: " & iError & " aPossessions.toString(): " & aPossessions.toString(), 1)
  capwindow = me.newwindow("cc_dispenseitem_success.window")
  if iError = 1 then
    oBackPack = oDenizenManager.getBackpack()
    if not voidp(oBackPack) then
      oBackPack.addPossessions(aPossessions, 1)
    end if
    mytext = TextMgr.GetRefText("DISPENSE_ITEM_SUCCESS")
  else
    mytext = TextMgr.GetRefText("DISPENSE_ITEM_FAIL")
  end if
  member("cc.dispenseitem.text").text = mytext
end

on isPublicStudioWindowOpen me
  repeat with n = count(me.pOpenWindows) down to 1
    _oWindow = me.pOpenWindows[n]
    _sWindowName = _oWindow.pname
    if _sWindowName starts "nav_public" then
      return 1
    end if
  end repeat
  return 0
end

on isPrivateStudioWindowOpen me
  repeat with n = count(me.pOpenWindows) down to 1
    _oWindow = me.pOpenWindows[n]
    _sWindowName = _oWindow.pname
    if _sWindowName starts "nav_private" then
      return 1
    end if
  end repeat
  return 0
end

on getOpenWindowNames me
  aList = []
  if voidp(me.pOpenWindows) then
    return aList
  end if
  iOpenWindowCount = count(me.pOpenWindows)
  if iOpenWindowCount = 0 then
    return aList
  end if
  repeat with n = count(me.pOpenWindows) down to 1
    _oWindow = me.pOpenWindows[n]
    _sWindowName = _oWindow.pname
    aList.add(_sWindowName)
  end repeat
  return aList
end
