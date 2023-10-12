property pSongsData, pwidth, pheight, pLineSpace, pScrollImg, pScrollIndex, pTotalLines, pDisplayLines, pPreviousData, bDebug
global TextMgr, gMembersToDelete, ElementMgr

on new me, numwidth, numheight
  bDebug = 0
  pwidth = numwidth
  pheight = numheight
  pLineSpace = 14
  pScrollImg = image(numwidth, numheight, 8)
  displayloading(me)
  me.debug("new()")
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "songsList script: " & sMessage
  end if
end

on updatecontent me
  if pPreviousData <> pSongsData then
    createimg(me)
  end if
  listmember = member("songslist")
  destimg = image(pwidth, pheight, the colorDepth)
  sourceRect = rect(0, (pScrollIndex - 1) * pLineSpace, pwidth, ((pScrollIndex - 1) * pLineSpace) + pheight)
  destRect = destimg.rect
  destimg.copyPixels(pScrollImg, destRect, sourceRect)
  member("songsdisplay").image = destimg
  member("songsdisplay").regPoint = point(0, 0)
end

on createimg me
  listmember = member("songslist")
  pTotalLines = pSongsData.count()
  listmember.text = EMPTY
  listmember.charSpacing = 0
  listmember.fixedLineSpace = pLineSpace
  listmember.alignment = #left
  repeat with n = 1 to count(pSongsData)
    mysong = pSongsData[n + pScrollIndex - 1]
    songName = mysong.name
    listmember.text = listmember.text & songName & RETURN
  end repeat
  listmember.text = listmember.text.line[1..listmember.text.line.count - 1]
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
  pScrollImg = listmember.image.duplicate()
  pPreviousData = pSongsData.duplicate()
end

on displayloading me
  pSongsData = []
  pScrollIndex = 1
  pTotalLines = pSongsData.count()
  pDisplayLines = pheight / pLineSpace
  if member("songsList").memberNum < 1 then
    listmember = new(#text)
    listmember.name = "songsList"
    append(gMembersToDelete, listmember)
  else
    listmember = member("songsList")
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
  mytext = mytext & TextMgr.GetRefText("CHOOSE_SONG_LOADING")
  listmember.text = mytext
  if member("songsdisplay").memberNum < 1 then
    listdisplay = new(#bitmap)
    listdisplay.name = "songsdisplay"
    append(gMembersToDelete, listdisplay)
  else
    listdisplay = member("songsdisplay")
  end if
  defaultimg = image(pwidth, pheight, 8)
  textimg = listmember.image.duplicate()
  textimg = textimg.trimWhiteSpace()
  destRect = rect((pwidth / 2) - (textimg.width / 2), (pheight / 2) - (textimg.height / 2), (pwidth / 2) + (textimg.width / 2), (pheight / 2) + (textimg.height / 2))
  defaultimg.copyPixels(textimg, destRect, textimg.rect)
  listdisplay.image = defaultimg
  listdisplay.regPoint = point(0, 0)
end

on songclicked me, whichnum
  if (whichnum < 1) or (whichnum > pSongsData.count) then
    return 
  end if
  mysong = pSongsData[whichnum]
  member("cdplayer_songname").text = TextMgr.GetRefText("CHOOSE_SONG_NAME") & ":" & mysong.name
  member("cdplayer_author").text = TextMgr.GetRefText("CHOOSE_SONG_AUTHOR") & ":" & mysong.author
  sendAllSprites(#songclicked)
  ElementMgr.getcdplayer().pSelectedSong = mysong
end
