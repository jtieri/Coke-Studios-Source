property pwidth, pheight, pLineSpace, pDisplayLines, pLineDef, pDoubleLines, pScrollIndex, pContentlist, listmember, pPreviousData, pScrollImg, bDebug, pSelectedSong
global ElementMgr, TextMgr, gMembersToDelete, oDenizenManager

on new me, numwidth, numheight, whichparent
  pwidth = numwidth
  pheight = numheight
  pLineSpace = 14
  pScrollIndex = 1
  pDisplayLines = pheight / pLineSpace
  if member("playlist").memberNum < 1 then
    listmember = new(#text)
    listmember.name = "playlist"
    append(gMembersToDelete, listmember)
  else
    listmember = member("playlist")
  end if
  displayloading(me)
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "cataloglist script: " & sMessage
  end if
end

on displayloading me
  displayLines = 13
  listmember.boxType = #fixed
  listmember.color = rgb("#3B3B3B")
  listmember.fontSize = 10
  listmember.fontStyle = [#bold]
  listmember.rect = rect(0, 0, pwidth, pLineSpace * displayLines)
  listmember.font = "Verdana"
  listmember.alignment = #center
  mytext = EMPTY
  repeat with n = 1 to displayLines / 2
    mytext = mytext & RETURN
  end repeat
  mytext = mytext & TextMgr.GetRefText("LOADING")
  repeat with n = 1 to displayLines / 2
    mytext = mytext & RETURN
  end repeat
  listmember.text = mytext
  destimg = image(pwidth, pLineSpace * displayLines, the colorDepth)
  destimg.copyPixels(listmember.image, destimg.rect, destimg.rect)
  member("catalogDisplay").image = destimg
  member("catalogDisplay").regPoint = point(0, 0)
end

on updatecontent me
  if the runMode = "author" then
    pContentlist = ["song 1", "this is a very very long song name, isn't it?", "song 5"]
  end if
  if pPreviousData <> pContentlist then
    createimg(me)
    pScrollIndex = 1
  end if
  destimg = image(pwidth, pheight, the colorDepth)
  sourceRect = rect(0, (pScrollIndex - 1) * pLineSpace, pwidth, ((pScrollIndex - 1) * pLineSpace) + pheight)
  destRect = destimg.rect
  destimg.copyPixels(pScrollImg, destRect, sourceRect)
  member("playlistDisplay").image = destimg
  member("playlistDisplay").regPoint = point(0, 0)
end

on createimg me
  pTotalLines = pContentlist.count()
  me.debug("createimg: pContentlist: " && pContentlist)
  listmember.text = EMPTY
  listmember.charSpacing = 0
  listmember.fixedLineSpace = pLineSpace
  listmember.font = "Verdana"
  listmember.alignment = #left
  addline = 0
  counter = 1
  pLineDef = []
  pDoubleLines = []
  repeat with n = 1 to pTotalLines
    if the runMode = "author" then
      myitem = pContentlist[n]
    else
      myitem = pContentlist[n].songName
    end if
    listmember.text = listmember.text & myitem & RETURN
    append(pLineDef, counter)
    if listmember.rect.height > ((listmember.text.line.count + addline) * pLineSpace) then
      append(pDoubleLines, (listmember.rect.height / pLineSpace) - 2)
      append(pLineDef, counter)
      addline = addline + (listmember.rect.height / ((listmember.text.line.count + addline) * pLineSpace))
    end if
    counter = counter + 1
  end repeat
  listmember.text = listmember.text.line[1..listmember.text.line.count - 1]
  the itemDelimiter = ","
  listmember.boxType = #adjust
  listimg = listmember.image.duplicate()
  pScrollImg = image(pwidth, listmember.height, the colorDepth)
  pScrollImg.copyPixels(listimg, listimg.rect, listimg.rect)
  pPreviousData = pContentlist.duplicate()
  listmember.boxType = #fixed
end

on lineclicked me, linenum
  myLine = pContentlist[linenum]
end

on hiliteline me, linenum
  if linenum > count(pLineDef) then
    return 
  end if
  checklinenum = pLineDef[linenum]
  if checklinenum <= count(pContentlist) then
    me.updatecontent()
    if getPos(pDoubleLines, linenum) then
      myhilite = image(pwidth, pLineSpace * 2, the colorDepth)
    else
      if getPos(pDoubleLines, linenum - 1) then
        linenum = linenum - 1
        myhilite = image(pwidth, pLineSpace * 2, the colorDepth)
      else
        myhilite = image(pwidth, pLineSpace, the colorDepth)
      end if
    end if
    mytop = (linenum - pScrollIndex) * pLineSpace
    myhilite.fill(myhilite.rect, rgb(0, 0, 0))
    destimage = member("playlistdisplay").image
    destRect = rect(0, mytop, pwidth, mytop + myhilite.height)
    destimage.copyPixels(myhilite, destRect, myhilite.rect, [#ink: 2])
    pSelectedSong = pContentlist[checklinenum]
    sendAllSprites(#enableplaysong)
    sendAllSprites(#enableremovesong)
  end if
end
