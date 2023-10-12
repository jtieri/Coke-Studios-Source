property pScrollIndex, pTotalLines, pDisplayLines, pUserData, pScrollImg, pwidth, pheight, pLineSpace, pPreviousData, bDebug

on new me, numwidth, numheight
  global ElementMgr, oStudioManager
  bDebug = 1
  pLineSpace = 14
  pwidth = numwidth
  pheight = numheight
  pScrollImg = image(numwidth, numheight, 8)
  displayloading(me)
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "userlist script: " & sMessage
  end if
end

on displayloading me
  global gMembersToDelete, TextMgr, oStudioManager
  pUserData = []
  pScrollIndex = 1
  pTotalLines = pUserData.count()
  pDisplayLines = pheight / pLineSpace
  if member("userlist").memberNum < 1 then
    listmember = new(#text)
    listmember.name = "userlist"
    append(gMembersToDelete, listmember)
  else
    listmember = member("userlist")
    mytext = listmember.comments
    if mytext <> EMPTY then
      if mytext <> "blocked" then
        pUserData = value(mytext.line[1])
        pScrollIndex = value(mytext.line[2])
        updatecontent(me)
        return me
      end if
    else
    end if
  end if
  listmember.boxType = #adjust
  listmember.color = rgb("#6C472D")
  listmember.fontSize = 10
  listmember.fontStyle = [#bold]
  listmember.rect = rect(0, 0, pwidth, pheight)
  listmember.font = "verdana"
  listmember.alignment = #center
  mytext = EMPTY
  repeat with n = 1 to pDisplayLines / 2
    mytext = mytext & RETURN
  end repeat
  mytext = mytext & TextMgr.GetRefText("LOADING")
  listmember.text = mytext
  destimg = image(pwidth, pheight, the colorDepth)
  destimg.copyPixels(listmember.image.duplicate(), rect(0, 0, pwidth, pheight), rect(0, 0, pwidth, pheight))
  member("userdisplay").image = destimg
  member("userdisplay").regPoint = point(0, 0)
end

on createimg me
  global TextMgr
  listmember = member("userlist")
  listmember.fontStyle = [#plain]
  pTotalLines = pUserData.count()
  listmember.text = EMPTY
  listmember.charSpacing = 0
  listmember.fixedLineSpace = pLineSpace
  listmember.tabs = [[#type: #left, #position: 18], [#type: #right, #position: pwidth - 1]]
  if count(pUserData) = 0 then
    listmember.text = TextMgr.GetRefText("NAV_USER_ST_NO_ROOMS_FOUND")
  else
    repeat with n = 1 to count(pUserData)
      myuser = pUserData[n]
      MyNum = myuser.userCount
      userName = myuser.name
      listmember.text = listmember.text & MyNum & TAB & userName & TAB & "Go!" & RETURN
    end repeat
    repeat while listmember.text.line[listmember.text.line.count] = EMPTY
      listmember.text = listmember.text.line[1..listmember.text.line.count - 1]
    end repeat
  end if
  if listmember.rect.height > (listmember.text.line.count * pLineSpace) then
    the itemDelimiter = TAB
    repeat with n = 1 to listmember.text.line.count
      myref = listmember.line[n].ref.range
      repeat while charPosToLoc(listmember, myref[2]).locV <> charPosToLoc(listmember, myref[1]).locV
        listmember.line[n].item[1].charSpacing = listmember.line[n].item[1].charSpacing - 1
      end repeat
    end repeat
    the itemDelimiter = ","
  end if
  if count(pUserData) then
    the itemDelimiter = TAB
    repeat with n = 1 to count(pUserData)
      me.debug("createimg: pUserData[n]" && pUserData[n])
      me.debug("createimg: listmember.line[n]" && listmember.line[n])
      if (pUserData[n].layout = 6) or (pUserData[n].layout = 10) then
        listmember.line[n].item[2].fontStyle = [#bold, #underline]
        listmember.line[n].item[3].fontStyle = [#bold, #underline]
        listmember.line[n].item[2].color = rgb("0000FF")
        listmember.line[n].item[3].color = rgb(238, 219, 198)
        next repeat
      end if
      listmember.line[n].item[2].fontStyle = [#underline]
      listmember.line[n].item[3].fontStyle = [#underline]
    end repeat
    the itemDelimiter = ","
  end if
  pScrollImg = listmember.image.duplicate()
  if count(pUserData) <> 0 then
    the itemDelimiter = TAB
    dotleft = charPosToLoc(listmember, length(listmember.text.item[1]) + 2).locH
    dotright = charPosToLoc(listmember, length(listmember.text.line[1])).locH
    dotwidth = dotright - dotleft
    the itemDelimiter = ","
    dotsimg = image(dotwidth, 1, the colorDepth)
    repeat with n = 1 to dotwidth / 2
      dotsimg.setPixel(n * 2, 0, rgb(108, 71, 45))
    end repeat
    oStarImage = member("star").image.duplicate()
    repeat with n = 1 to listmember.text.lines.count
      sourceRect = dotsimg.rect
      destRect = rect(dotleft, (pLineSpace * n) - 1, dotright, pLineSpace * n)
      pScrollImg.copyPixels(dotsimg, destRect, sourceRect, [#ink: 36])
      if (pUserData[n].layout = 6) or (pUserData[n].layout = 10) then
        sourceRect = oStarImage.rect
        destRect = rect(dotright - sourceRect[3], (pLineSpace * n) - sourceRect[4], dotright, pLineSpace * n)
        pScrollImg.copyPixels(oStarImage, destRect, sourceRect)
      end if
    end repeat
  end if
  pPreviousData = pUserData.duplicate()
end

on updatecontent me
  if voidp(pUserData) then
    return 
  end if
  if pPreviousData <> pUserData then
    createimg(me)
  end if
  pTotalLines = count(pUserData)
  listmember = member("userlist")
  if pScrollImg.height > pheight then
    destimg = image(pwidth, pheight, the colorDepth)
    sourceRect = rect(0, (pScrollIndex - 1) * pLineSpace, pwidth, ((pScrollIndex - 1) * pLineSpace) + pheight)
    destRect = destimg.rect
    destimg.copyPixels(pScrollImg, destRect, sourceRect)
    member("userdisplay").image = destimg
  else
    destimg = image(pwidth, pheight, the colorDepth)
    sourceRect = pScrollImg.rect
    destimg.copyPixels(pScrollImg, sourceRect, sourceRect)
    member("userdisplay").image = destimg
  end if
  member("userdisplay").regPoint = point(0, 0)
end

on roomclicked me, whichnum, bGoStudio
  global oStudioManager, TextMgr, ElementMgr, gMembersToDelete
  if bGoStudio then
    if whichnum <= pUserData.count then
      goToStudio(pUserData[whichnum].studioId)
    end if
  else
    if voidp(getaProp(ElementMgr.pOpenWindows, "nav_private_info")) then
      repeat with n = 1 to count(ElementMgr.pOpenWindows)
        if getPropAt(ElementMgr.pOpenWindows, n) contains "nav" then
          MyWindow = ElementMgr.pOpenWindows[n]
          exit repeat
        end if
      end repeat
      member("userlist").comments = "blocked"
      myRect = MyWindow.prect
      MyWindow.closeWindow()
      ElementMgr.newwindow("nav_private_info.window", myRect)
      ElementMgr.pOpenWindows.nav_private_info.pScrollingLists.userList.pUserData = pUserData
      ElementMgr.pOpenWindows.nav_private_info.pScrollingLists.userList.pScrollIndex = pScrollIndex
      ElementMgr.pOpenWindows.nav_private_info.pScrollingLists.userList.pTotalLines = pTotalLines
      ElementMgr.pOpenWindows.nav_private_info.pScrollingLists.userList.pDisplayLines = pDisplayLines
      ElementMgr.pOpenWindows.nav_private_info.pScrollingLists.userList.updatecontent()
    end if
    if whichnum <= count(pUserData) then
      sRoomId = pUserData[whichnum].studioId
      if member("userroomid").memberNum < 1 then
        myMember = new(#field)
        myMember.name = "userroomid"
        append(gMembersToDelete, myMember)
      end if
      member("userroomID").text = sRoomId
      oStudioManager.getPrivateStudioDetail(sRoomId)
    end if
  end if
end

on displayRoomDetail me, roomdetail
  global oStudioManager, TextMgr, ElementMgr, gMembersToDelete, oDenizenManager
  mytext = string(pUserData) & RETURN & string(pScrollIndex)
  member("userlist").comments = mytext
  if voidp(getaProp(ElementMgr.pOpenWindows, "nav_private_start")) = 0 then
    if member("roomowner").memberNum < 1 then
      myMember = new(#field)
      myMember.name = "roomowner"
      append(gMembersToDelete, myMember)
    end if
    member("roomowner").text = roomdetail.owner
    member("userlist").comments = "blocked"
    myRect = ElementMgr.pOpenWindows.nav_private_start.prect
    ElementMgr.pOpenWindows.nav_private_start.closeWindow()
    ElementMgr.newwindow("nav_private_info.window", myRect)
    ElementMgr.pOpenWindows.nav_private_info.pScrollingLists.userList.pUserData = pUserData
    ElementMgr.pOpenWindows.nav_private_info.pScrollingLists.userList.pScrollIndex = pScrollIndex
    ElementMgr.pOpenWindows.nav_private_info.pScrollingLists.userList.pTotalLines = pTotalLines
    ElementMgr.pOpenWindows.nav_private_info.pScrollingLists.userList.pDisplayLines = pDisplayLines
    ElementMgr.pOpenWindows.nav_private_info.pScrollingLists.userList.updatecontent()
  end if
  member("nav_help_title_public").text = roomdetail.name && "(" & roomdetail.userCount & "/" & roomdetail.capacity & ")"
  member("nav_ownertext").text = TextMgr.GetRefText("NAV_DTL_DEST_OWNER") && ":" && roomdetail.owner
  member("nav_helptext2").text = string(roomdetail.description)
  if roomdetail.owner <> oDenizenManager.getScreenName() then
    sendAllSprites(#hidemodifybtn)
  else
    me.debug("displayroomdetail:roomdetail:" && roomdetail)
    if (roomdetail.layout = 6) or (roomdetail.layout = 10) then
      sendAllSprites(#hidemodifybtn)
    else
      sendAllSprites(#showmodifybtn)
    end if
  end if
end
