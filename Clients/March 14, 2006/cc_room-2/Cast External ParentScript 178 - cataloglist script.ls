property pCatalogLevel, pwidth, pheight, pLineSpace, pDisplayLines, pLineDef, pDoubleLines, pScrollIndex, pContentlist, listmember, pPreviousData, pScrollImg, bDebug, pSelectedSong, pSelectedAlbum, pSelectedArtist, pSelectedgenre
global ElementMgr, TextMgr, gMembersToDelete, oDenizenManager

on new me, numwidth, numheight, whichparent
  pwidth = numwidth
  pheight = numheight
  pLineSpace = 14
  pScrollIndex = 1
  pDisplayLines = pheight / pLineSpace
  pCatalogLevel = #Genres
  if member("cataloglist").memberNum < 1 then
    listmember = new(#text)
    listmember.name = "cataloglist"
    append(gMembersToDelete, listmember)
  else
    listmember = member("cataloglist")
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
  if member("catalogdisplay").memberNum < 1 then
    catalogdisplay = new(#bitmap)
    catalogdisplay.name = "catalogdisplay"
    append(gMembersToDelete, catalogdisplay)
  end if
  member("catalogDisplay").image = destimg
  member("catalogDisplay").regPoint = point(0, 0)
end

on updatecontent me
  if the runMode = "author" then
    myList = [#Genres: ["Hip-hop", "Alternative", "Country", "Pop", "Rythm n Blues", "Blues"], #Artists: ["artist name band", "artist name band", "artist name band", "artist name band", "artist name band", "artist name band"], #Albums: ["album", "album", "album", "album", "album", "album"], #songs: ["song 1", "song 2", "song 3", "this is a very very long song name, isn't it?", "song 5", "song 6", "song 7", "song 8", "song 9", "song 10", "song 11", "song 12", "this is another very very long song name, isn't it?", "song 14", "song 15", "song 16", "song 17", "song 18", "song 19", "song 20"]]
    pContentlist = myList[pCatalogLevel]
  end if
  if pPreviousData <> pContentlist then
    createimg(me)
    pScrollIndex = 1
  end if
  listmember = member("cataloglist")
  destimg = image(pwidth, pheight, the colorDepth)
  sourceRect = rect(0, (pScrollIndex - 1) * pLineSpace, pwidth, ((pScrollIndex - 1) * pLineSpace) + pheight)
  destRect = destimg.rect
  destimg.copyPixels(pScrollImg, destRect, sourceRect)
  member("catalogDisplay").image = destimg
  member("catalogDisplay").regPoint = point(0, 0)
end

on createimg me
  pTotalLines = pContentlist.count()
  me.debug("createimg: pContentlist: " && pContentlist)
  listmember = member("cataloglist")
  listmember.text = EMPTY
  listmember.charSpacing = 0
  listmember.fixedLineSpace = pLineSpace
  listmember.font = "Verdana"
  listmember.fontSize = 10
  listmember.alignment = #left
  listmember.antialias = 0
  listmember.tabs = [[#type: #right, #position: 171]]
  addline = 0
  counter = 1
  pLineDef = []
  pDoubleLines = []
  repeat with n = 1 to pTotalLines
    if (pCatalogLevel = #songs) and (the runMode <> "author") then
      myitem = pContentlist[n].songName & TAB & "mp3"
    else
      myitem = pContentlist[n]
    end if
    if pCatalogLevel = #songs then
      listmember.text = listmember.text & myitem & RETURN
    else
      listmember.text = listmember.text & myitem && ">" & RETURN
    end if
    append(pLineDef, counter)
    if listmember.rect.height > ((listmember.text.line.count + addline) * pLineSpace) then
      append(pDoubleLines, (listmember.rect.height / pLineSpace) - 2)
      append(pLineDef, counter)
      addline = addline + (listmember.rect.height / ((listmember.text.line.count + addline) * pLineSpace))
    end if
    counter = counter + 1
  end repeat
  listmember.text = listmember.text.line[1..listmember.text.line.count - 1]
  repeat with n = 1 to pTotalLines
    the itemDelimiter = TAB
    if the runMode <> "author" then
      if pCatalogLevel = #songs then
        if oDenizenManager.bisFTMmember = 0 then
          if pContentlist[n].isFreeUse() = 0 then
            listmember.line[n].color = rgb(128, 128, 128)
          else
            listmember.line[n].item[1].color = rgb(0, 0, 0)
            if pContentlist[n].downloadStatus = "all" then
              listmember.line[n].item[2].color = rgb(0, 0, 0)
            else
              listmember.line[n].item[2].color = rgb(128, 128, 128)
            end if
          end if
        else
          listmember.line[n].color = rgb(0, 0, 0)
        end if
      end if
      next repeat
    end if
    if pCatalogLevel = #songs then
      if (n mod 2) = 0 then
        listmember.line[n].color = rgb(128, 128, 128)
        next repeat
      end if
      listmember.line[n].color = rgb(0, 0, 0)
    end if
  end repeat
  the itemDelimiter = ","
  listmember.boxType = #adjust
  listimg = listmember.image.duplicate()
  pScrollImg = image(pwidth, pTotalLines * pLineSpace, the colorDepth)
  pScrollImg.copyPixels(listimg, listimg.rect, listimg.rect)
  case pCatalogLevel of
    #Genres:
      mytext = EMPTY
    #Artists:
      mytext = "< BACK TO GENRE" & RETURN & pSelectedgenre
    #songs:
      mytext = "< BACK TO ARTIST" & RETURN & pSelectedArtist
  end case
  if mytext <> EMPTY then
    listmember.text = mytext
    listmember.fontSize = 8
    listmember.fixedLineSpace = 8
    listmember.antialias = 1
    listmember.antiAliasThreshold = 0
    listmember.line[1].color = rgb(255, 255, 255)
    listmember.line[2].color = rgb(71, 82, 82)
    backimage = listmember.image.duplicate()
  else
    backimage = image(0, 0, 1)
  end if
  member("cc.jukebox.backbutton").image = backimage
  member("cc.jukebox.backbutton").regPoint = point(0, 0)
  sprite(sendAllSprites(#getIJbackbutton)).width = backimage.width
  sprite(sendAllSprites(#getIJbackbutton)).height = backimage.height
  pPreviousData = pContentlist.duplicate()
  listmember.boxType = #fixed
end

on lineclicked me, linenum
  myLine = pContentlist[linenum]
  case pCatalogLevel of
    #Genres:
      pSelectedgenre = myLine
      pCatalogLevel = #Artists
      me.displayloading()
      if the runMode = "Author" then
        me.updatecontent()
      else
        oDenizenManager.getArtistsByGenre(myLine)
      end if
    #Artists:
      pSelectedArtist = myLine
      pCatalogLevel = #songs
      me.displayloading()
      if the runMode = "Author" then
        me.updatecontent()
      else
        oDenizenManager.getSongsByArtist(myLine)
      end if
  end case
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
    destimage = member("catalogdisplay").image
    destRect = rect(0, mytop, pwidth, mytop + myhilite.height)
    destimage.copyPixels(myhilite, destRect, myhilite.rect, [#ink: 2])
    if pCatalogLevel = #songs then
      pSelectedSong = pContentlist[checklinenum]
      if the runMode = "author" then
        sendAllSprites(#enabledownloadsong)
        sendAllSprites(#enableaddsong)
        sendAllSprites(#enableplaysong)
      else
        if oDenizenManager.bisFTMmember = 0 then
          if pSelectedSong.downloadStatus = "all" then
            sendAllSprites(#enabledownloadsong)
          else
            sendAllSprites(#disabledownloadsong)
            sendAllSprites(#opendrawer)
          end if
          if pSelectedSong.isFreeUse() then
            sendAllSprites(#enableaddsong)
            sendAllSprites(#enableplaysong)
          else
            sendAllSprites(#disableaddsong)
            sendAllSprites(#disableplaysong)
          end if
        else
          sendAllSprites(#enabledownloadsong)
          sendAllSprites(#enableaddsong)
          sendAllSprites(#enableplaysong)
        end if
      end if
    else
      sendAllSprites(#disabledownloadsong)
      sendAllSprites(#disableaddsong)
      sendAllSprites(#disableplaysong)
    end if
  end if
end
