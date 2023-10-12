property pScrollIndex, pTotalLines, pDisplayLines, pUserData, pScrollImg, pwidth, pheight, pLineSpace

on new me, numwidth, numheight
  pLineSpace = 14
  pwidth = numwidth
  pheight = numheight
  pScrollImg = image(numwidth, numheight, 8)
  displayloading(me)
  return me
end

on displayloading me
  global gMembersToDelete, TextMgr
  pUserData = []
  pScrollIndex = 1
  pTotalLines = pUserData.count()
  pDisplayLines = pheight / pLineSpace
  if member("peopleList").memberNum < 1 then
    listmember = new(#text)
    listmember.name = "peopleList"
    append(gMembersToDelete, listmember)
  else
    listmember = member("peopleList")
  end if
  listmember.boxType = #fixed
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
end

on updatecontent me
  pTotalLines = pUserData.count()
  listmember = member("peopleList")
  listmember.fontStyle = [#plain]
  listmember.alignment = #left
  listmember.text = EMPTY
  listmember.charSpacing = 0
  listmember.fixedLineSpace = pLineSpace
  if (pUserData = [EMPTY]) or (pUserData = []) then
    mytext = EMPTY
    repeat with n = 1 to pDisplayLines / 2
      mytext = mytext & RETURN
    end repeat
    mytext = mytext & "Nobody"
    listmember.text = mytext
    listmember.alignment = #center
    listmember.fontStyle = [#italic]
  else
    maxlimit = min(pDisplayLines, pUserData.count())
    repeat with n = 1 to maxlimit
      myuser = pUserData[n + pScrollIndex - 1]
      listmember.text = listmember.text & myuser & RETURN
    end repeat
    listmember.text = listmember.text.line[1..listmember.text.line.count - 1]
    repeat with n = 1 to listmember.text.line.count
      mychar = offset(TAB, listmember.text.line[n])
      if mychar > 0 then
        listmember.line[n].char[mychar].fontStyle = [#plain]
      end if
    end repeat
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
  end if
end

on roomclicked me, whichnum
  global oStudioManager, TextMgr, ElementMgr
  if whichnum <= count(pUserData) then
    sRoomId = pUserData[whichnum].studioId
    oStudioManager.getPublicStudioDetail(sRoomId)
    roomdetail = value(member("lingooutput").text)
    the updateLock = 1
    if voidp(getaProp(ElementMgr.pOpenWindows, "nav_public_start")) = 0 then
      myRect = getaProp(ElementMgr.pOpenWindows, "nav_public_start").prect
      getaProp(ElementMgr.pOpenWindows, "nav_public_start").closeWindow()
      ElementMgr.newwindow("nav_public_info.window", myRect)
      ElementMgr.pOpenWindows.nav_public_info.pScrollingLists.roomlist.pUserData = pUserData
      ElementMgr.pOpenWindows.nav_public_info.pScrollingLists.roomlist.pScrollIndex = pScrollIndex
      ElementMgr.pOpenWindows.nav_public_info.pScrollingLists.roomlist.pTotalLines = pTotalLines
      ElementMgr.pOpenWindows.nav_public_info.pScrollingLists.roomlist.pDisplayLines = pDisplayLines
      updateStage()
    end if
    member("nav_help_title_public").text = roomdetail.name && "(" & roomdetail.userCount & "/" & roomdetail.capacity & ")"
    member("nav_helptext").text = roomdetail.description
    mylocs = ["london", "miami", "mombasa", "newyork", "rio", "seattle", "sydney", "tokyo", "goa", "alaska", "moscow", "redroom"]
    MyNum = getPos(mylocs, roomdetail.location)
    if MyNum < 10 then
      MyNum = "00" & MyNum
    else
      MyNum = "0" & MyNum
    end if
    member("cc_nav_roomico").image = member("nav_icon_unit" & MyNum).image.duplicate()
    member("cc_nav_roomico").regPoint = point(0, 0)
    the updateLock = 0
  end if
end
