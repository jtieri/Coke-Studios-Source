property pScrollIndex, pTotalLines, pDisplayLines, pFriendsData, pScrollImg, pwidth, pheight, pLineSpace, pLastClicked, pParentWindow, pPreviousData, pSelectedFriends

on new me, numwidth, numheight, whichparent
  global gMembersToDelete, oStudioManager, TextMgr
  pParentWindow = whichparent
  pLineSpace = 15
  pLastClicked = EMPTY
  pSelectedFriends = []
  pwidth = numwidth
  pheight = numheight
  pFriendsData = []
  pScrollImg = image(numwidth, numheight, 8)
  pScrollIndex = 1
  pTotalLines = pFriendsData.count()
  pDisplayLines = pheight / pLineSpace
  if member("friendslist").memberNum < 1 then
    listmember = new(#text)
    listmember.name = "friendslist"
    append(gMembersToDelete, listmember)
  else
    listmember = member("friendslist")
  end if
  if member("friendsdisplay").memberNum < 1 then
    listdisplay = new(#bitmap)
    listdisplay.name = "friendsdisplay"
    append(gMembersToDelete, listdisplay)
  else
    listdisplay = member("friendsdisplay")
    mytext = listdisplay.comments
    if mytext <> EMPTY then
      pFriendsData = value(mytext.line[1])
      pTotalLines = pFriendsData.count()
      pPreviousData = pFriendsData.duplicate()
      pScrollImg = member("scrollimg").image.duplicate()
      pScrollIndex = value(mytext.line[2])
      pLastClicked = value(mytext.line[3])
      if (voidp(pLastClicked) = 0) and (pLastClicked <> 0) then
        displayRoomDetail(me, pLastClicked)
      end if
      return me
    end if
  end if
  listmember.boxType = #fixed
  listmember.color = rgb("#6C472D")
  listmember.fontSize = 10
  listmember.fontStyle = [#bold]
  listmember.rect = rect(0, 0, numwidth - member("cc.navi.balls.0").width - 5, numheight)
  listmember.font = "verdana"
  listmember.text = TextMgr.GetRefText("LOADING")
  defaultimg = image(numwidth, numheight, 8)
  textimg = listmember.image.duplicate()
  textimg = textimg.trimWhiteSpace()
  destrect = rect((numwidth / 2) - (textimg.width / 2), (numheight / 2) - (textimg.height / 2), (numwidth / 2) + (textimg.width / 2), (numheight / 2) + (textimg.height / 2))
  defaultimg.copyPixels(textimg, destrect, textimg.rect)
  listdisplay.image = defaultimg
  listdisplay.regPoint = point(0, 0)
  listmember.fontStyle = [#plain]
  return me
end

on createimg me
  global gMembersToDelete, TextMgr
  pTotalLines = pFriendsData.count()
  listmember = member("friendslist")
  if count(pFriendsData) < 1 then
    mytext = TextMgr.GetRefText("MESSENGER_NO_FRIENDS")
    listmember.width = 205
    listmember.text = mytext
    listmember.fontStyle = [#plain]
    listmember.alignment = #Full
    listmember.charSpacing = -1
    pScrollImg = listmember.image.duplicate()
    if member("friendsscrollimg").memberNum < 1 then
      savemember = new(#bitmap)
      savemember.name = "friendsscrollimg"
      append(gMembersToDelete, savemember)
    else
      savemember = member("friendsscrollimg")
    end if
    savemember.image = pScrollImg
  else
    listmember.charSpacing = 0
    listmember.alignment = #left
    pScrollImg = image(pwidth, (pTotalLines * pLineSpace) + 2, the colorDepth)
    listmember.width = 158
    listmember.fontStyle = [#underline]
    listmember.text = EMPTY
    listmember.charSpacing = 0
    listmember.fixedLineSpace = pLineSpace
    listmember.tabs = [[#type: #right, #position: pwidth - 25]]
    if the debugPlaybackEnabled then
      put "friendslist script::createimg(): " && pTotalLines
    end if
    repeat with n = 1 to pTotalLines
      myfriend = pFriendsData[n]
      friendname = myfriend.screenName
      messagesFrom = myfriend.messagesFrom
      listmember.text = listmember.text & friendname && "-" & TAB & messagesFrom && TextMgr.GetRefText("MESSENGER_MSGS") & RETURN
      mylength = length(friendname)
    end repeat
    listmember.text = listmember.text.line[1..listmember.text.line.count - 1]
    repeat with n = 1 to listmember.text.line.count
      mychar = offset(TAB, listmember.text.line[n])
      if mychar > 0 then
        listmember.line[n].char[mychar].fontStyle = [#plain]
      end if
      if the debugPlaybackEnabled then
        if n >= 12 then
          put "friendslist script::createimg(): " && n && pFriendsData[n]
        end if
      end if
    end repeat
    if listmember.rect.height > (pTotalLines * pLineSpace) then
      the itemDelimiter = TAB
      spacings = []
      repeat with n = 1 to listmember.text.line.count
        myref = listmember.line[n].ref.range
        repeat while charPosToLoc(listmember, myref[2]).locV <> charPosToLoc(listmember, myref[1]).locV
          listmember.line[n].item[1].charSpacing = listmember.line[n].item[1].charSpacing - 1
          changeref = [n, listmember.line[n].item[1].charSpacing]
        end repeat
        if voidp(changeref) = 0 then
          append(spacings, changeref)
        end if
      end repeat
      the itemDelimiter = ","
    end if
    the itemDelimiter = TAB
    repeat with n = 1 to pTotalLines
      myname = listmember.line[n].item[1]
      listmember.line[n].item[2].fontStyle = [#underline]
    end repeat
    the itemDelimiter = ","
    listmember.boxType = #adjust
    listmember.rect = rect(0, 0, pwidth - 16, 3000)
    listimg = listmember.image.duplicate()
    destrect = listimg.rect + rect(16, 0, 16, 0)
    sourceRect = listimg.rect
    pScrollImg.copyPixels(listimg, destrect, sourceRect)
    if the debugPlaybackEnabled then
      put "friendslist script::createimg: destrect:" && destrect
      put "friendslist script::createimg: sourcerect:" && sourceRect & RETURN & RETURN
    end if
    dotsimg = image(pwidth - 16, 1, the colorDepth)
    repeat with n = 1 to dotsimg.width / 2
      dotsimg.setPixel(n * 2, 0, rgb(108, 71, 45))
    end repeat
    if the debugPlaybackEnabled then
      put "friendslist script::createimg():" && listmember.text.lines.count && "text lines"
    end if
    repeat with n = 1 to pTotalLines
      sourceRect = dotsimg.rect
      destrect = rect(16, (pLineSpace * n) - 1, pwidth - 16, pLineSpace * n)
      pScrollImg.copyPixels(dotsimg, destrect, sourceRect, [#ink: 36])
      if the debugPlaybackEnabled then
        put "friendslist script::createimg: destrect:" && destrect
        put "friendslist script::createimg: sourcerect:" && sourceRect
      end if
    end repeat
    connected = member("mes_smallbuddy_head").image.duplicate()
    repeat with n = 1 to count(pFriendsData)
      myfriend = pFriendsData[n]
      if myfriend.online then
        decal = rect(4, 6, 4, 6)
        sourceRect = connected.rect
        destrect = rect(0, (n - 1) * 15, connected.width, connected.height + ((n - 1) * 15)) + decal
        pScrollImg.copyPixels(connected, destrect, sourceRect)
      end if
    end repeat
    pPreviousData = pFriendsData.duplicate()
    listmember.boxType = #fixed
    if member("friendsscrollimg").memberNum < 1 then
      savemember = new(#bitmap)
      savemember.name = "friendsscrollimg"
      append(gMembersToDelete, savemember)
    else
      savemember = member("friendsscrollimg")
    end if
    savemember.image = pScrollImg
  end if
  if the debugPlaybackEnabled then
    put "friendslist script::createimg:" && listmember.text.line.count && "lines on" && listmember.height && "pixels"
  end if
end

on updatecontent me
  if pPreviousData <> pFriendsData then
    createimg(me)
  end if
  listmember = member("friendslist")
  destimg = image(pwidth, pheight, the colorDepth)
  sourceRect = rect(0, (pScrollIndex - 1) * pLineSpace, pwidth, ((pScrollIndex - 1) * pLineSpace) + pheight) + rect(0, 2, 0, 2)
  destrect = destimg.rect
  destimg.copyPixels(pScrollImg, destrect, sourceRect)
  member("friendsdisplay").image = destimg
  member("friendsdisplay").regPoint = point(0, 0)
end

on friendclicked me, whichnum, bDisplayCompose
  global oStudioManager, TextMgr, ElementMgr, gMembersToDelete
  if whichnum <= count(pFriendsData) then
    if getPos(pSelectedFriends, pFriendsData[whichnum].screenName) then
      if bDisplayCompose then
        ElementMgr.getMessengerObject().composeMessage()
        return 
      end if
      mycolor = rgb(255, 255, 255)
      deleteAt(pSelectedFriends, getPos(pSelectedFriends, pFriendsData[whichnum].screenName))
      if count(pSelectedFriends) = 0 then
        sendAllSprites(#dimMmsBtns)
      end if
      bDisplayCompose = 0
    else
      mycolor = rgb(153, 102, 51)
      append(pSelectedFriends, pFriendsData[whichnum].screenName)
      member("requestsanfoname").text = pFriendsData[whichnum].screenName
      sMission = pFriendsData[whichnum].mission
      if voidp(sMission) or (sMission = VOID) then
        sMission = EMPTY
      end if
      member("mms_Mission").text = sMission
      aFriendData = pFriendsData[whichnum]
      if aFriendData[#online] then
        sLastSeenInName = pFriendsData[whichnum][#lastSeenInName]
        member("mms_Messages").text = TextMgr.GetRefText("MESSENGER_CURRENTLY") & ":" && sLastSeenInName
      else
        oLastAccess = pFriendsData[whichnum][#lastAccess]
        if voidp(oLastAccess) or (oLastAccess = VOID) or (oLastAccess = "<Null>") then
          member("mms_Messages").text = EMPTY
        else
          member("mms_Messages").text = TextMgr.GetRefText("MESSENGER_LAST_ACCESS") & ":" && TextMgr.getDate(oLastAccess) && TextMgr.getTime(oLastAccess)
        end if
      end if
      sendAllSprites(#plainMmsBtns)
    end if
    pScrollImg.draw(0, ((whichnum - 1) * 15) + 3, 203, ((whichnum - 1) * 15) + 17, mycolor, [#shapeType: #rect])
    updatecontent(me)
    if bDisplayCompose then
      ElementMgr.getMessengerObject().composeMessage()
    end if
  end if
end

on displayRoomDetail me, roomdetail
  global oStudioManager, TextMgr, ElementMgr, gMembersToDelete
  the updateLock = 1
  pLastClicked = roomdetail
  mytext = string(pFriendsData) & RETURN & string(pScrollIndex) & RETURN & pLastClicked
  member("friendsdisplay").comments = mytext
  if voidp(getaProp(ElementMgr.pOpenWindows, "nav_public_start")) = 0 then
    myRect = getaProp(ElementMgr.pOpenWindows, "nav_public_start").prect
    getaProp(ElementMgr.pOpenWindows, "nav_public_start").closeWindow()
    ElementMgr.newwindow("nav_public_info.window", myRect)
  end if
  circleanim = pParentWindow.pCircleAnim
  if voidp(circleanim) = 0 then
    sprite(circleanim).blend = 100
    sprite(circleanim).member = member("nav_circleanim")
    sprite(circleanim).width = member("nav_circleanim").width
    sprite(circleanim).height = member("nav_circleanim").height
    maplocs = [#sydney: point(224, 70), #tokyo: point(213, 26), #goa: point(161, 32), #moscow: point(136, 14), #mombasa: point(142, 49), #london: point(108, 15), #rio: point(72, 62), #newyork: point(54, 24), #miami: point(46, 30), #alaska: point(7, 12), #seattle: point(22, 20), #redroom: point(22, 30), #sanfrancisco: point(22, 30), #centralpark: point(54, 24), #neworleans: point(22, 30), #mexico: point(22, 30), #atlantis: point(70, 32)]
    repeat with n in pParentWindow.pSpritelist
      if sprite(n).member = member("cc.world.map.gfx") then
        mapsprite = n
        exit repeat
      end if
    end repeat
    if maplocs.count >= roomdetail.location then
      sprite(circleanim).loc = sprite(mapsprite).loc + maplocs[roomdetail.location]
    end if
  end if
  member("nav_help_title_public").text = roomdetail.name && "(" & roomdetail.userCount & "/" & roomdetail.capacity & ")"
  member("nav_helptext").text = roomdetail.description
  MyNum = roomdetail.location
  if MyNum < 10 then
    MyNum = "00" & MyNum
  else
    MyNum = "0" & MyNum
  end if
  if member("cc_nav_roomico").memberNum < 1 then
    newMember = new(#bitmap)
    newMember.name = "cc_nav_roomico"
    append(gMembersToDelete, newMember)
  end if
  oIconMember = member("nav_icon_unit" & MyNum)
  if oIconMember.memberNum <> -1 then
    member("cc_nav_roomico").image = oIconMember.image.duplicate()
    member("cc_nav_roomico").regPoint = point(0, 0)
  end if
  the updateLock = 0
end
