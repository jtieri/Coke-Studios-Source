property pScrollIndex, pTotalLines, pDisplayLines, pRoomData, pScrollImg, pwidth, pheight, pLineSpace, pLastClicked, pParentWindow, pPreviousData, bDebug
global gMembersToDelete, oStudioManager, TextMgr

on new me, numwidth, numheight, whichparent
  bDebug = 0
  pParentWindow = whichparent
  pLineSpace = 14
  pLastClicked = EMPTY
  pwidth = numwidth
  pheight = numheight
  pRoomData = []
  pScrollImg = image(numwidth, numheight, 8)
  pScrollIndex = 1
  pTotalLines = pRoomData.count()
  pDisplayLines = pheight / pLineSpace
  if member("roomlist").memberNum < 1 then
    listmember = new(#text)
    listmember.name = "roomlist"
    append(gMembersToDelete, listmember)
  else
    listmember = member("roomlist")
  end if
  if member("roomdisplay").memberNum < 1 then
    listdisplay = new(#bitmap)
    listdisplay.name = "roomdisplay"
    append(gMembersToDelete, listdisplay)
  else
    listdisplay = member("roomdisplay")
    mytext = listdisplay.comments
    if mytext <> EMPTY then
      pRoomData = value(mytext.line[1])
      pTotalLines = pRoomData.count()
      pPreviousData = pRoomData.duplicate()
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
  destRect = rect((numwidth / 2) - (textimg.width / 2), (numheight / 2) - (textimg.height / 2), (numwidth / 2) + (textimg.width / 2), (numheight / 2) + (textimg.height / 2))
  defaultimg.copyPixels(textimg, destRect, textimg.rect)
  listdisplay.image = defaultimg
  listdisplay.regPoint = point(0, 0)
  listmember.fontStyle = [#plain]
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "roomlist script: " & sMessage
  end if
end

on displayloading me
  global gMembersToDelete, TextMgr
  if member("roomList").memberNum < 1 then
    listmember = new(#text)
    listmember.name = "roomList"
    append(gMembersToDelete, listmember)
  else
    listmember = member("roomList")
  end if
  listmember.boxType = #fixed
  listmember.color = rgb("#6C472D")
  listmember.fontSize = 10
  listmember.fontStyle = [#bold]
  listmember.rect = rect(0, 0, pwidth - (member("cc.navi.balls.0").width + 5), pLineSpace * 7)
  listmember.font = "Verdana"
  listmember.alignment = #center
  mytext = EMPTY
  displayLines = 7
  repeat with n = 1 to displayLines / 2
    mytext = mytext & RETURN
  end repeat
  mytext = mytext & TextMgr.GetRefText("LOADING")
  repeat with n = 1 to displayLines / 2
    mytext = mytext & RETURN
  end repeat
  listmember.text = mytext
  destimg = image(pwidth, pLineSpace * 7, the colorDepth)
  destimg.copyPixels(listmember.image, destimg.rect, destimg.rect)
  member("roomDisplay").image = destimg
  member("roomDisplay").regPoint = point(0, 0)
end

on createimg me
  global gMembersToDelete
  pTotalLines = pRoomData.count()
  me.debug("createimg: pRoomData: " && pRoomData)
  listmember = member("roomlist")
  pScrollImg = image(pwidth, pTotalLines * pLineSpace, the colorDepth)
  listmember.fontStyle = [#underline]
  listmember.text = EMPTY
  listmember.charSpacing = 0
  listmember.fixedLineSpace = pLineSpace
  listmember.tabs = [[#type: #right, #position: pwidth - member("cc.navi.balls.0").width - 6]]
  repeat with n = 1 to pTotalLines
    myroom = pRoomData[n]
    numbullets = integer(myroom.userCount / (myroom.capacity / 6.0))
    bulletsimg = member("cc.navi.balls." & numbullets).image.duplicate()
    destRect = rect(0, (pLineSpace * (n - 1)) + 5, bulletsimg.width, (pLineSpace * (n - 1)) + bulletsimg.height + 5)
    pScrollImg.copyPixels(bulletsimg, destRect, bulletsimg.rect)
    roomname = myroom.name
    listmember.text = listmember.text & roomname & TAB & "Go!" & RETURN
    myLength = length(roomname)
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
  repeat with n = 1 to listmember.text.lines.count
    myName = listmember.line[n].item[1]
    listmember.line[n].item[1].fontStyle = [#underline]
    listmember.line[n].item[2].fontStyle = [#underline]
  end repeat
  the itemDelimiter = ","
  listmember.boxType = #adjust
  listimg = listmember.image.duplicate()
  destRect = rect(bulletsimg.width + 5, 0, pwidth, pScrollImg.height)
  sourceRect = rect(0, 0, listimg.width, pScrollImg.height)
  pScrollImg.copyPixels(listimg, destRect, sourceRect)
  dotsimg = image(listimg.width, 1, the colorDepth)
  repeat with n = 1 to dotsimg.width / 2
    dotsimg.setPixel(n * 2, 0, rgb(108, 71, 45))
  end repeat
  repeat with n = 1 to listmember.text.lines.count
    sourceRect = dotsimg.rect
    destRect = rect(bulletsimg.width + 5, (pLineSpace * n) - 1, pwidth, pLineSpace * n)
    pScrollImg.copyPixels(dotsimg, destRect, sourceRect, [#ink: 36])
  end repeat
  pPreviousData = pRoomData.duplicate()
  listmember.boxType = #fixed
  if member("scrollimg").memberNum < 1 then
    savemember = new(#bitmap)
    savemember.name = "scrollimg"
    append(gMembersToDelete, savemember)
  else
    savemember = member("scrollimg")
  end if
  savemember.image = pScrollImg
end

on updatecontent me, bForce
  if (pPreviousData <> pRoomData) or (bForce = 1) then
    createimg(me)
    member("roomDisplay").image = pScrollImg
    pScrollIndex = 1
  end if
  listmember = member("roomlist")
  destimg = image(pwidth, pheight, the colorDepth)
  sourceRect = rect(0, (pScrollIndex - 1) * pLineSpace, pwidth, ((pScrollIndex - 1) * pLineSpace) + pheight)
  destRect = destimg.rect
  destimg.copyPixels(pScrollImg, destRect, sourceRect)
  member("roomdisplay").image = destimg
  member("roomdisplay").regPoint = point(0, 0)
end

on roomclicked me, whichnum, bGoStudio
  global oStudioManager, TextMgr, ElementMgr, gMembersToDelete
  if bGoStudio then
    if whichnum <= pRoomData.count then
      displayRoomDetail(me, pRoomData[whichnum])
      goToStudio(pRoomData[whichnum].studioId)
    end if
  else
    if voidp(getaProp(ElementMgr.pOpenWindows, "nav_public_info")) then
      repeat with n = 1 to count(ElementMgr.pOpenWindows)
        if getPropAt(ElementMgr.pOpenWindows, n) contains "nav" then
          MyWindow = ElementMgr.pOpenWindows[n]
          exit repeat
        end if
      end repeat
      myRect = MyWindow.prect
      MyWindow.closeWindow()
      ElementMgr.newwindow("nav_public_info.window", myRect)
    end if
    if whichnum <= count(pRoomData) then
      sRoomId = pRoomData[whichnum].studioId
      if member("roomid").memberNum < 1 then
        myMember = new(#field)
        myMember.name = "roomid"
        append(gMembersToDelete, myMember)
      end if
      member("roomID").text = sRoomId
      repeat with n in ElementMgr.pOpenWindows
        if count(n.pScrollingLists) then
          if voidp(getaProp(n.pScrollingLists, #peoplelist)) = 0 then
            n.pScrollingLists.peoplelist.displayloading()
            oStudioManager.getOccupantsByStudioId(sRoomId)
            exit repeat
          end if
        end if
      end repeat
      oStudioManager.getPublicStudioDetail(sRoomId)
    end if
  end if
end

on displayRoomDetail me, roomdetail
  global oStudioManager, TextMgr, ElementMgr, gMembersToDelete
  if voidp(roomdetail) then
    return 
  end if
  me.debug("roomdetail: " & roomdetail)
  pLastClicked = roomdetail
  mytext = string(pRoomData) & RETURN & string(pScrollIndex) & RETURN & pLastClicked
  member("roomdisplay").comments = mytext
  circleanim = pParentWindow.pCircleAnim
  if voidp(circleanim) = 0 then
    sprite(circleanim).blend = 100
    sprite(circleanim).member = member("nav_circleanim")
    sprite(circleanim).width = member("nav_circleanim").width
    sprite(circleanim).height = member("nav_circleanim").height
    maplocs = [#london: point(108, 15), #miami: point(46, 31), #mombasa: point(142, 49), #newyork: point(54, 24), #rio: point(72, 63), #seattle: point(22, 21), #sydney: point(224, 70), #tokyo: point(213, 27), #goa: point(162, 32), #alaska: point(7, 12), #moscow: point(136, 15), #redroom: point(23, 32), #sanfrancisco: point(19, 27), #centralpark: point(54, 24), #neworleans: point(38, 30), #mexico: point(33, 38), #neptune: point(79, 35), #auditionBLUE: point(23, 32), #auditionGOLD: point(23, 32), #auditionGREEN: point(23, 32), #auditionORANGE: point(23, 32), #auditionRED: point(23, 32), #secretroom: point(54, 24), #comingsoonvenue: point(54, 24), #neworleans: point(38, 24)]
    me.debug("maplocs: " & maplocs, 1)
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
end
