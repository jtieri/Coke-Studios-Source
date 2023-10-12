property pname, pDate, pVersion, pElements, prect, pBorder, pSpritelist, pScrollingLists, pCircleAnim, bDebug, aWebLaunchAttributes
global gMembersToDelete, TextMgr, ElementMgr, oStudioManager, oDenizenManager

on new me, data
  me.bDebug = 0
  pScrollingLists = [:]
  pSpritelist = []
  if voidp(data) then
    pname = "default_parent_window"
    prect = rect(0, the stageRight - the stageLeft, 0, the stageBottom - the stageTop)
    pElements = []
  else
    pname = data.name
    prect = data.rect
    put "windows script: data.elements =" && ilk(data.elements)
    pElements = data.elements
  end if
  makedisplay(me)
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "Windows Script: " & sMessage
  end if
end

on makedisplay me
  me.debug("makeDisplay()" && "pName:" && pname && "pElements:" && pElements && "pRect:" && prect)
  if pname contains "nav_" then
    wintitle = "nav_title"
    mytest = 1
    repeat with n = 1 to count(ElementMgr.pOpenWindows)
      if getPropAt(ElementMgr.pOpenWindows, n) contains "entry" then
        mytest = 0
      end if
    end repeat
    if mytest then
      windowstyle = "sanfo_basic.window"
    else
      windowstyle = "sanfo_basic2.window"
    end if
  else
    if pname contains "MODERATOR_HELP" then
      wintitle = "MODERATOR_HELP_TITLE"
      windowstyle = "sanfo_basic.window"
    else
      if pname contains "callsent" then
        wintitle = "ALERT_TITLE"
        windowstyle = "sanfo_basic2.window"
      else
        if pname contains "alert" then
          wintitle = "ALERT_TITLE"
          coversprite = ElementMgr.LastUsedSprite()
          myMember = member("shadow.pixel")
          puppetSprite(coversprite, 1)
          sprite(coversprite).member = myMember
          sprite(coversprite).rect = (the stage).drawRect
          sprite(coversprite).scriptInstanceList = [new(script("blocker"))]
          sprite(coversprite).blend = 50
          append(pSpritelist, coversprite)
          reservedsprites = reservedsprites + 1
          ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
          windowstyle = "cc_modal.window"
        else
          if pname contains "dialog" then
            wintitle = "ALERT_TITLE"
            coversprite = ElementMgr.LastUsedSprite()
            myMember = member("shadow.pixel")
            puppetSprite(coversprite, 1)
            sprite(coversprite).member = myMember
            sprite(coversprite).rect = (the stage).drawRect
            sprite(coversprite).scriptInstanceList = [new(script("blocker"))]
            sprite(coversprite).blend = 50
            append(pSpritelist, coversprite)
            reservedsprites = reservedsprites + 1
            ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
            windowstyle = "cc_modal.window"
          else
            if pname contains "whale" then
              wintitle = "ALERT_TITLE"
              coversprite = ElementMgr.LastUsedSprite()
              myMember = member("shadow.pixel")
              puppetSprite(coversprite, 1)
              sprite(coversprite).member = myMember
              sprite(coversprite).rect = (the stage).drawRect
              sprite(coversprite).scriptInstanceList = [new(script("blocker"))]
              sprite(coversprite).blend = 50
              append(pSpritelist, coversprite)
              reservedsprites = reservedsprites + 1
              ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
              windowstyle = "cc_modal.window"
            else
              if pname contains "balance" then
                windowstyle = "sanfo_full.window"
                wintitle = "BALANCE_TITLE"
              else
                if pname contains "call_for_help" then
                  windowstyle = "sanfo_full.window"
                  wintitle = "HELP_TITLE"
                else
                  if pname contains "catalogue" then
                    windowstyle = "sanfo_full.window"
                    wintitle = "CAT_TITLE"
                  else
                    if pname = "purchase_info" then
                      windowstyle = "sanfo_basic2.window"
                      wintitle = "PURCHASE_TITLE"
                    else
                      if pname = "burn_decision" then
                        windowstyle = "sanfo_basic2.window"
                        wintitle = EMPTY
                      else
                        if pname = "paused" then
                          wintitle = "PAUSED_TITLE"
                          coversprite = ElementMgr.LastUsedSprite()
                          myMember = member("shadow.pixel")
                          puppetSprite(coversprite, 1)
                          sprite(coversprite).member = myMember
                          sprite(coversprite).rect = (the stage).drawRect
                          sprite(coversprite).scriptInstanceList = [new(script("blocker"))]
                          sprite(coversprite).blend = 50
                          append(pSpritelist, coversprite)
                          reservedsprites = reservedsprites + 1
                          ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
                          windowstyle = "cc_modal.window"
                        else
                          if pname contains "cc_cdplayer" then
                            windowstyle = "sanfo_basic2.window"
                            wintitle = "CHOOSE_SONG_TITLE"
                          else
                            if pname contains "cc_trading" then
                              windowstyle = "sanfo_basic2.window"
                              wintitle = "TRADE_TITLE"
                            else
                              if pname = "confirm_texture" then
                                windowstyle = "sanfo_basic2.window"
                                wintitle = "REPLACE_TITLE"
                              else
                                if pname = "delete_item" then
                                  windowstyle = "sanfo_basic2.window"
                                  wintitle = "DELETE_ITEM_TITLE"
                                else
                                  if pname = "cc_editurl" then
                                    windowstyle = "sanfo_full.window"
                                    wintitle = "TITLE_URL"
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
      end if
    end if
  end if
  reservedsprites = count(pElements)
  if voidp(windowstyle) = 0 then
    BGdata = ElementMgr.parsewindow(windowstyle)
    temprect = rect(prect[1], prect[2], prect[3], prect[4])
    BGrenderList = renderBG(me, wintitle, BGdata, temprect)
    if listp(BGrenderList[1]) then
      BGmember = BGrenderList[2]
      myrectlist = BGrenderList[3]
    else
      BGmember = BGrenderList[1]
      myrectlist = BGrenderList[2]
    end if
    mySpriteNum = ElementMgr.LastUsedSprite()
    append(pSpritelist, mySpriteNum)
    puppetSprite(mySpriteNum, 1)
    sprite(mySpriteNum).visible = 1
    sprite(mySpriteNum).color = paletteIndex(255)
    sprite(mySpriteNum).bgColor = paletteIndex(0)
    sprite(mySpriteNum).member = BGmember
    sprite(mySpriteNum).width = BGmember.width
    sprite(mySpriteNum).height = BGmember.height
    sprite(mySpriteNum).blend = 100
    sprite(mySpriteNum).loc = point(prect[1] - member("cc.window.lefttop").width, prect[2] - member("cc.window.lefttop").height)
    sprite(mySpriteNum).ink = 36
    sprite(mySpriteNum).scriptInstanceList = [new(script("windowBG script"), myrectlist, me)]
    reservedsprites = reservedsprites + 1
    ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
    if listp(BGrenderList[1]) then
      myclosebox = BGrenderList[1]
      mySpriteNum = ElementMgr.LastUsedSprite()
      append(pSpritelist, mySpriteNum)
      puppetSprite(mySpriteNum, 1)
      sprite(mySpriteNum).visible = 1
      sprite(mySpriteNum).color = paletteIndex(255)
      sprite(mySpriteNum).bgColor = paletteIndex(0)
      sprite(mySpriteNum).member = myclosebox[1]
      sprite(mySpriteNum).width = member(myclosebox[1]).width
      sprite(mySpriteNum).height = member(myclosebox[1]).height
      baseloc = point(prect[1] - member("cc.window.lefttop").width + member(BGmember).width, prect[2] - member("cc.window.lefttop").height)
      sprite(mySpriteNum).loc = point(baseloc.locH - myclosebox[2].locH, baseloc.locV + myclosebox[2].locV)
      sprite(mySpriteNum).ink = 36
      sprite(mySpriteNum).scriptInstanceList = [new(script("button display status"), mySpriteNum), new(script("closewindow"), me)]
      reservedsprites = reservedsprites + 1
      ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
    end if
  end if
  repeat with n = 1 to count(pElements)
    myelement = pElements[n]
    if myelement.id = "nav_public_rooms_list" then
      addProp(pScrollingLists, #roomlist, new(script("roomlist script"), myelement.width, myelement.height, me))
      mySpriteNum = ElementMgr.LastUsedSprite()
      append(pSpritelist, mySpriteNum)
      puppetSprite(mySpriteNum, 1)
      sprite(mySpriteNum).visible = 1
      sprite(mySpriteNum).color = paletteIndex(255)
      sprite(mySpriteNum).bgColor = paletteIndex(0)
      sprite(mySpriteNum).member = member("roomdisplay")
      sprite(mySpriteNum).locH = myelement.locH + prect[1]
      sprite(mySpriteNum).locV = myelement.locV + prect[2]
      sprite(mySpriteNum).width = myelement.width
      sprite(mySpriteNum).height = myelement.height
      sprite(mySpriteNum).ink = 36
      sprite(mySpriteNum).scriptInstanceList = [new(script("roomdisplay script"), pScrollingLists.roomlist)]
      reservedsprites = reservedsprites + 1
      ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
    else
      if myelement.id = "nav_people_list" then
        addProp(pScrollingLists, #peoplelist, new(script("peoplelist script"), myelement.width, myelement.height))
        mySpriteNum = ElementMgr.LastUsedSprite()
        append(pSpritelist, mySpriteNum)
        puppetSprite(mySpriteNum, 1)
        sprite(mySpriteNum).visible = 1
        sprite(mySpriteNum).color = paletteIndex(255)
        sprite(mySpriteNum).bgColor = paletteIndex(0)
        sprite(mySpriteNum).member = member("peoplelist")
        sprite(mySpriteNum).locH = myelement.locH + prect[1]
        sprite(mySpriteNum).locV = myelement.locV + prect[2]
        sprite(mySpriteNum).width = myelement.width
        sprite(mySpriteNum).height = myelement.height
        sprite(mySpriteNum).ink = 36
      else
        if myelement.id = "nav_private_rooms_list" then
          if member("userdisplay").memberNum < 1 then
            userdisplay = new(#bitmap)
            userdisplay.name = "userdisplay"
            append(gMembersToDelete, userdisplay)
          end if
          addProp(pScrollingLists, #userList, new(script("userlist script"), myelement.width, myelement.height))
          mySpriteNum = ElementMgr.LastUsedSprite()
          append(pSpritelist, mySpriteNum)
          puppetSprite(mySpriteNum, 1)
          sprite(mySpriteNum).visible = 1
          sprite(mySpriteNum).color = paletteIndex(255)
          sprite(mySpriteNum).bgColor = paletteIndex(0)
          sprite(mySpriteNum).member = member("userdisplay")
          sprite(mySpriteNum).locH = myelement.locH + prect[1]
          sprite(mySpriteNum).locV = myelement.locV + prect[2]
          sprite(mySpriteNum).width = myelement.width
          sprite(mySpriteNum).height = myelement.height
          sprite(mySpriteNum).ink = 36
          sprite(mySpriteNum).blend = 100
          sprite(mySpriteNum).scriptInstanceList = [new(script("roomdisplay script"), pScrollingLists.userList)]
        else
          if myelement.id = "console_friends_friendlist" then
            if member("friendsdisplay").memberNum < 1 then
              friendsdisplay = new(#bitmap)
              friendsdisplay.name = "friendsdisplay"
              append(gMembersToDelete, friendsdisplay)
            end if
            addProp(pScrollingLists, #friendslist, new(script("friendslist script"), myelement.width, myelement.height))
            mySpriteNum = ElementMgr.LastUsedSprite()
            append(pSpritelist, mySpriteNum)
            puppetSprite(mySpriteNum, 1)
            sprite(mySpriteNum).visible = 1
            sprite(mySpriteNum).color = paletteIndex(255)
            sprite(mySpriteNum).bgColor = paletteIndex(0)
            sprite(mySpriteNum).member = member("friendsdisplay")
            sprite(mySpriteNum).locH = myelement.locH + prect[1]
            sprite(mySpriteNum).locV = myelement.locV + prect[2]
            sprite(mySpriteNum).width = myelement.width
            sprite(mySpriteNum).height = myelement.height
            sprite(mySpriteNum).ink = 36
            sprite(mySpriteNum).blend = 100
            sprite(mySpriteNum).scriptInstanceList = [new(script("frienddisplay script"), pScrollingLists.friendslist)]
          else
            if myelement.id = "cdplayer_songlist" then
              if member("songsdisplay").memberNum < 1 then
                songsdisplay = new(#bitmap)
                songsdisplay.name = "songsdisplay"
                append(gMembersToDelete, songsdisplay)
              end if
              addProp(pScrollingLists, #songslist, new(script("songslist script"), myelement.width, myelement.height))
              mySpriteNum = ElementMgr.LastUsedSprite()
              append(pSpritelist, mySpriteNum)
              puppetSprite(mySpriteNum, 1)
              sprite(mySpriteNum).visible = 1
              sprite(mySpriteNum).color = paletteIndex(255)
              sprite(mySpriteNum).bgColor = paletteIndex(0)
              sprite(mySpriteNum).member = member("songsdisplay")
              sprite(mySpriteNum).locH = myelement.locH + prect[1]
              sprite(mySpriteNum).locV = myelement.locV + prect[2]
              sprite(mySpriteNum).width = myelement.width
              sprite(mySpriteNum).height = myelement.height
              sprite(mySpriteNum).ink = 36
              sprite(mySpriteNum).blend = 100
              sprite(mySpriteNum).scriptInstanceList = [new(script("songsdisplay script"), pScrollingLists.songslist)]
            else
              if myelement.id = "jukebox_catalog_list" then
                addProp(pScrollingLists, #cataloglist, new(script("cataloglist script"), myelement.width, myelement.height, me))
                mySpriteNum = ElementMgr.LastUsedSprite()
                append(pSpritelist, mySpriteNum)
                puppetSprite(mySpriteNum, 1)
                sprite(mySpriteNum).visible = 1
                sprite(mySpriteNum).color = paletteIndex(255)
                sprite(mySpriteNum).bgColor = paletteIndex(0)
                sprite(mySpriteNum).member = member("catalogdisplay")
                sprite(mySpriteNum).locH = myelement.locH + prect[1]
                sprite(mySpriteNum).locV = myelement.locV + prect[2]
                sprite(mySpriteNum).width = myelement.width
                sprite(mySpriteNum).height = myelement.height
                sprite(mySpriteNum).ink = 36
                sprite(mySpriteNum).scriptInstanceList = [new(script("catalogdisplay script"), pScrollingLists.cataloglist)]
                reservedsprites = reservedsprites + 1
                ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
              else
                if myelement.id = "jukebox_playlist_list" then
                  addProp(pScrollingLists, #playList, new(script("playlist script"), myelement.width, myelement.height, me))
                  mySpriteNum = ElementMgr.LastUsedSprite()
                  append(pSpritelist, mySpriteNum)
                  puppetSprite(mySpriteNum, 1)
                  sprite(mySpriteNum).visible = 1
                  sprite(mySpriteNum).color = paletteIndex(255)
                  sprite(mySpriteNum).bgColor = paletteIndex(0)
                  if member("playlistdisplay").memberNum < 1 then
                    playlistdisplay = new(#bitmap)
                    playlistdisplay.name = "playlistdisplay"
                    append(gMembersToDelete, playlistdisplay)
                  end if
                  sprite(mySpriteNum).member = member("playlistdisplay")
                  sprite(mySpriteNum).locH = myelement.locH + prect[1]
                  sprite(mySpriteNum).locV = myelement.locV + prect[2]
                  sprite(mySpriteNum).width = myelement.width
                  sprite(mySpriteNum).height = myelement.height
                  sprite(mySpriteNum).ink = 36
                  sprite(mySpriteNum).scriptInstanceList = [new(script("playlistdisplay script"), pScrollingLists.playList)]
                  reservedsprites = reservedsprites + 1
                  ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
                else
                  if myelement.id = "texts.items" then
                    if member("itemsdisplay").memberNum < 1 then
                      itemsdisplay = new(#bitmap)
                      itemsdisplay.name = "itemsdisplay"
                      append(gMembersToDelete, itemsdisplay)
                    else
                      itemsdisplay = member("itemsdisplay")
                    end if
                    mySpriteNum = ElementMgr.LastUsedSprite()
                    append(pSpritelist, mySpriteNum)
                    puppetSprite(mySpriteNum, 1)
                    sprite(mySpriteNum).visible = 1
                    sprite(mySpriteNum).member = itemsdisplay
                    sprite(mySpriteNum).width = myelement.width
                    sprite(mySpriteNum).height = myelement.height
                    sprite(mySpriteNum).locH = myelement.locH + prect[1]
                    sprite(mySpriteNum).locV = myelement.locV + prect[2]
                    addProp(pScrollingLists, #itemslist, new(script("itemslist script"), myelement.width, myelement.height))
                  else
                    if myelement.type contains "scrollbar" then
                      mydescription = member(myelement.type & "1.element")
                      case myelement.client of
                        "nav_public_rooms_list":
                          mytarget = pScrollingLists.roomlist
                        "nav_private_rooms_list":
                          mytarget = pScrollingLists.userList
                        "nav_people_list":
                          mytarget = pScrollingLists.peoplelist
                        "console_friends_friendlist":
                          mytarget = pScrollingLists.friendslist
                        "songlist":
                          mytarget = pScrollingLists.songslist
                      end case
                      case myelement.model of
                        1:
                          prefix = "button"
                        3:
                          prefix = "mms"
                      end case
                      mySpriteNum = ElementMgr.LastUsedSprite()
                      append(pSpritelist, mySpriteNum)
                      puppetSprite(mySpriteNum, 1)
                      sprite(mySpriteNum).visible = 1
                      sprite(mySpriteNum).color = paletteIndex(255)
                      sprite(mySpriteNum).bgColor = paletteIndex(0)
                      sprite(mySpriteNum).member = member(prefix & ".scroll.up.passive")
                      sprite(mySpriteNum).width = sprite(mySpriteNum).member.width
                      sprite(mySpriteNum).height = sprite(mySpriteNum).member.height
                      sprite(mySpriteNum).blend = 100
                      sprite(mySpriteNum).locH = myelement.locH + prect[1]
                      sprite(mySpriteNum).locV = myelement.locV + prect[2]
                      sprite(mySpriteNum).ink = 36
                      sprite(mySpriteNum).scriptInstanceList = [new(script("scrollvert top arrow"), mytarget)]
                      sprite(mySpriteNum).pmodel = prefix
                      reservedsprites = reservedsprites + 1
                      ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
                      mySpriteNum = ElementMgr.LastUsedSprite()
                      append(pSpritelist, mySpriteNum)
                      puppetSprite(mySpriteNum, 1)
                      sprite(mySpriteNum).visible = 1
                      sprite(mySpriteNum).color = paletteIndex(255)
                      sprite(mySpriteNum).bgColor = paletteIndex(0)
                      case myelement.model of
                        1:
                          sprite(mySpriteNum).member = member("scrollbar.vertical.active")
                        3:
                          sprite(mySpriteNum).member = member("mms.scrollbar.active")
                      end case
                      sprite(mySpriteNum).blend = 100
                      sprite(mySpriteNum).locH = myelement.locH + prect[1]
                      sprite(mySpriteNum).locV = myelement.locV + prect[2] + member(prefix & ".scroll.up.active").height
                      sprite(mySpriteNum).height = myelement.height - member(prefix & ".scroll.up.passive").height - member(prefix & ".scroll.down.passive").height
                      sprite(mySpriteNum).width = member(prefix & ".scroll.up.active").width
                      sprite(mySpriteNum).ink = 36
                      sprite(mySpriteNum).scriptInstanceList = [new(script("scrollvert scrollbar"), mytarget, mySpriteNum + 2)]
                      sprite(mySpriteNum).pmodel = prefix
                      reservedsprites = reservedsprites + 1
                      ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
                      mySpriteNum = ElementMgr.LastUsedSprite()
                      append(pSpritelist, mySpriteNum)
                      puppetSprite(mySpriteNum, 1)
                      sprite(mySpriteNum).visible = 1
                      sprite(mySpriteNum).color = paletteIndex(255)
                      sprite(mySpriteNum).bgColor = paletteIndex(0)
                      sprite(mySpriteNum).member = member(prefix & ".scroll.down.passive")
                      sprite(mySpriteNum).width = sprite(mySpriteNum).member.width
                      sprite(mySpriteNum).height = sprite(mySpriteNum).member.height
                      sprite(mySpriteNum).blend = 100
                      sprite(mySpriteNum).locH = myelement.locH + prect[1]
                      sprite(mySpriteNum).locV = myelement.locV + prect[2] + myelement.height - member(prefix & ".scroll.down.passive").height
                      sprite(mySpriteNum).ink = 36
                      sprite(mySpriteNum).scriptInstanceList = [new(script("scrollvert bottom arrow"), mytarget)]
                      sprite(mySpriteNum).pmodel = prefix
                      reservedsprites = reservedsprites + 1
                      ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
                      mySpriteNum = ElementMgr.LastUsedSprite()
                      append(pSpritelist, mySpriteNum)
                      puppetSprite(mySpriteNum, 1)
                      sprite(mySpriteNum).visible = 1
                      sprite(mySpriteNum).color = paletteIndex(255)
                      sprite(mySpriteNum).bgColor = paletteIndex(0)
                      sprite(mySpriteNum).member = member(prefix & ".scroll.lift.passive")
                      sprite(mySpriteNum).width = sprite(mySpriteNum).member.width
                      sprite(mySpriteNum).height = sprite(mySpriteNum).member.height
                      sprite(mySpriteNum).blend = 100
                      sprite(mySpriteNum).locH = myelement.locH + prect[1]
                      sprite(mySpriteNum).locV = myelement.locV + prect[2] + member(prefix & ".scroll.up.passive").height
                      sprite(mySpriteNum).ink = 36
                      sprite(mySpriteNum).scriptInstanceList = [new(script("scrollvert slider"), mytarget, mySpriteNum - 2, me)]
                      sprite(mySpriteNum).pmodel = prefix
                      reservedsprites = reservedsprites + 1
                      ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
                    else
                      if (myelement.type = "button") and (myelement.member = "shadow.pixel") then
                        case myelement.model of
                          1:
                            myletter = "a1"
                          2:
                            myletter = "b1"
                          6, 7:
                            myletter = "d" & myelement.model
                          8:
                            myletter = "e1"
                        end case
                        mySpriteNum = ElementMgr.LastUsedSprite()
                        append(pSpritelist, mySpriteNum)
                        puppetSprite(mySpriteNum, 1)
                        sprite(mySpriteNum).visible = 1
                        sprite(mySpriteNum).color = paletteIndex(255)
                        sprite(mySpriteNum).bgColor = paletteIndex(0)
                        if member(myletter & "." & myelement.width & "." & myelement.height & ".active").memberNum < 1 then
                          btnimg = image(myelement.width, myelement.height, 16)
                          leftimg = member("button." & myletter & ".left.active").image.duplicate()
                          midimg = member("button." & myletter & ".middle.active").image.duplicate()
                          rightimg = member("button." & myletter & ".right.active").image.duplicate()
                          destRect = rect(0, 0, leftimg.width, btnimg.height)
                          btnimg.copyPixels(leftimg, destRect, leftimg.rect)
                          destRect = rect(leftimg.width, 0, btnimg.width - rightimg.width, btnimg.height)
                          btnimg.copyPixels(midimg, destRect, midimg.rect)
                          destRect = rect(btnimg.width - rightimg.width, 0, btnimg.width, btnimg.height)
                          btnimg.copyPixels(rightimg, destRect, rightimg.rect)
                          myMember = new(#bitmap)
                          myMember.image = btnimg
                          myMember.regPoint = point(0, 0)
                          myMember.name = myletter & "." & myelement.width & "." & myelement.height & ".active"
                          append(gMembersToDelete, myMember)
                          btnimg = image(myelement.width, myelement.height, 16)
                          leftimg = member("button." & myletter & ".left.pressed").image.duplicate()
                          midimg = member("button." & myletter & ".middle.pressed").image.duplicate()
                          rightimg = member("button." & myletter & ".right.pressed").image.duplicate()
                          destRect = rect(0, 0, leftimg.width, btnimg.height)
                          btnimg.copyPixels(leftimg, destRect, leftimg.rect)
                          destRect = rect(leftimg.width, 0, btnimg.width - rightimg.width, btnimg.height)
                          btnimg.copyPixels(midimg, destRect, midimg.rect)
                          destRect = rect(btnimg.width - rightimg.width, 0, btnimg.width, btnimg.height)
                          btnimg.copyPixels(rightimg, destRect, rightimg.rect)
                          hilitemember = new(#bitmap)
                          hilitemember.image = btnimg
                          hilitemember.regPoint = point(0, 0)
                          hilitemember.name = myletter & "." & myelement.width & "." & myelement.height & ".pressed"
                          append(gMembersToDelete, hilitemember)
                        else
                          myMember = member(myletter & "." & myelement.width & "." & myelement.height & ".active")
                        end if
                        sprite(mySpriteNum).member = myMember
                        sprite(mySpriteNum).locH = myelement.locH + prect[1]
                        sprite(mySpriteNum).locV = myelement.locV + prect[2]
                        sprite(mySpriteNum).width = sprite(mySpriteNum).member.width
                        sprite(mySpriteNum).height = sprite(mySpriteNum).member.height
                        sprite(mySpriteNum).blend = myelement.blend
                        sprite(mySpriteNum).ink = 36
                        if myelement.id = "nav_modify_button" then
                          if member("roomowner").text <> oDenizenManager.getScreenName() then
                            sprite(mySpriteNum).blend = 0
                            bVisible = 0
                            sprite(mySpriteNum).member = member("shadow.pixel")
                          else
                            bVisible = 1
                          end if
                          sprite(mySpriteNum).scriptInstanceList.add(new(script("modifybtn2"), myMember, me, bVisible))
                          sprite(mySpriteNum).visible = bVisible
                        end if
                        reservedsprites = reservedsprites + 1
                        ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite + 1
                        textspritenum = ElementMgr.LastUsedSprite()
                        append(pSpritelist, textspritenum)
                        puppetSprite(textspritenum, 1)
                        sprite(textspritenum).visible = 1
                        sprite(textspritenum).color = paletteIndex(255)
                        sprite(textspritenum).bgColor = paletteIndex(0)
                        myMember = new(#text)
                        append(gMembersToDelete, myMember)
                        myMember.font = "verdana"
                        if (myelement.model = 6) or (myelement.model = 7) then
                          myMember.color = rgb(107, 93, 82)
                        else
                          myMember.color = rgb(202, 211, 213)
                        end if
                        myMember.fontStyle = [#bold]
                        myMember.fontSize = 10
                        myMember.alignment = #center
                        myMember.boxType = #adjust
                        myMember.rect = rect(0, 0, myelement.width, myelement.height)
                        mytext = TextMgr.GetRefText(myelement.key)
                        if stringp(mytext) then
                          myMember.text = mytext
                        end if
                        repeat while charPosToLoc(myMember, 1).locV <> charPosToLoc(myMember, length(myMember.text)).locV
                          myMember.line[1].charSpacing = myMember.line[1].charSpacing - 1
                        end repeat
                        sprite(textspritenum).member = myMember
                        sprite(textspritenum).locH = myelement.locH + prect[1]
                        sprite(textspritenum).locV = myelement.locV + prect[2] + ((myelement.height / 2) - (myMember.rect.height / 2))
                        sprite(textspritenum).width = sprite(mySpriteNum).member.width
                        sprite(textspritenum).height = sprite(mySpriteNum).member.height
                        sprite(textspritenum).blend = 100
                        sprite(textspritenum).ink = 36
                        if myelement.id = "nav_modify_button" then
                          if member("roomowner").text <> oDenizenManager.getScreenName() then
                            sprite(textspritenum).blend = 0
                            bVisible = 0
                            sprite(textspritenum).member = member("shadow.pixel")
                          else
                            bVisible = 1
                          end if
                          sprite(textspritenum).scriptInstanceList.add(new(script("modifybtn"), myMember, bVisible))
                          sprite(textspritenum).visible = bVisible
                        end if
                      else
                        if member(myelement.member).memberNum < 1 then
                          if voidp(gMembersToDelete) then
                            gMembersToDelete = []
                          end if
                          myMember = new(myelement.media)
                          myMember.name = myelement.member
                          append(gMembersToDelete, myMember)
                        end if
                        mySpriteNum = ElementMgr.LastUsedSprite()
                        append(pSpritelist, mySpriteNum)
                        if myelement.id = "nav_circleanim" then
                          pCircleAnim = mySpriteNum
                        end if
                        puppetSprite(mySpriteNum, 1)
                        sprite(mySpriteNum).visible = 1
                        sprite(mySpriteNum).color = paletteIndex(255)
                        sprite(mySpriteNum).bgColor = paletteIndex(0)
                        myMember = member(myelement.member)
                        if (myelement.media = #field) or (myelement.media = #text) then
                          myMember.font = myelement.font
                          if the debugPlaybackEnabled then
                          end if
                          myMember.fontStyle = myelement.fontStyle
                          if the debugPlaybackEnabled then
                          end if
                          myMember.fontSize = myelement.fontSize
                          if the debugPlaybackEnabled then
                          end if
                          myMember.boxType = myelement.boxType
                          if the debugPlaybackEnabled then
                          end if
                          myMember.rect = rect(0, 0, myelement.width, myelement.height)
                          if the debugPlaybackEnabled then
                          end if
                          myMember.editable = myelement.editable
                          if the debugPlaybackEnabled then
                          end if
                          myMember.autoTab = myelement.autoTab
                          if the debugPlaybackEnabled then
                          end if
                          myMember.wordWrap = myelement.wordWrap
                          if the debugPlaybackEnabled then
                          end if
                          myMember.alignment = myelement.alignment
                          if the debugPlaybackEnabled then
                          end if
                          myMember.color = rgb(myelement.txtColor)
                          if the debugPlaybackEnabled then
                          end if
                          if myelement.media = #field then
                            myMember.lineHeight = myelement.lineHeight
                          else
                            if myelement.media = #text then
                              myMember.fixedLineSpace = myelement.fixedLineSpace
                            end if
                          end if
                          myMember.text = TextMgr.GetRefText(myelement.key)
                        end if
                        sprite(mySpriteNum).member = myMember
                        if myelement.member contains "cc.radiobutton.active" then
                          sprite(mySpriteNum).scriptInstanceList = [new(script("radiobtn"), myelement.id, me)]
                        end if
                        sprite(mySpriteNum).locH = myelement.locH + prect[1]
                        sprite(mySpriteNum).locV = myelement.locV + prect[2]
                        sprite(mySpriteNum).ink = myelement.ink
                        sprite(mySpriteNum).blend = myelement.blend
                        sprite(mySpriteNum).width = myelement.width
                        sprite(mySpriteNum).height = myelement.height
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
    addinteractivity(mySpriteNum, myelement.id, me)
  end repeat
  if the debugPlaybackEnabled then
    put "ElementMgr.pLastUsedSprite"
  end if
end

on bringtofront me
  mypos = getPos(ElementMgr.pOpenWindows, me)
  lMarshall = [:]
  repeat with i = 1 to mypos - 1
    lMarshall[ElementMgr.pOpenWindows.getPropAt(i)] = ElementMgr.pOpenWindows[i]
  end repeat
  repeat with i = mypos + 1 to ElementMgr.pOpenWindows.count
    lMarshall[ElementMgr.pOpenWindows.getPropAt(i)] = ElementMgr.pOpenWindows[i]
  end repeat
  lMarshall.addProp(pname, me)
  ElementMgr.pOpenWindows = lMarshall
  basez = 1000000
  counter = 0
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    repeat with m = 1 to count(ElementMgr.pOpenWindows[n].pSpritelist)
      sprite(ElementMgr.pOpenWindows[n].pSpritelist[m]).locZ = basez + counter
      counter = counter + 1
    end repeat
  end repeat
end

on renderBG me, myName, MyData, myRect
  me.debug("renderBG()" && "myName:" && myName && "myData:" && MyData && "myRect:" && myRect)
  the itemDelimiter = "_"
  mywidth = member("cc.window.shadow.lefttop").width + myRect.width + 11 + member("cc.window.shadow.righttop").width
  MemberName = myName.item[1] & "_" & mywidth & "_" & myRect.height
  the itemDelimiter = ","
  if MemberName = "ALERT" then
    if myRect.height = 197 then
      MemberName = "ALERT2"
    end if
  end if
  if member(MemberName).memberNum > 0 then
    myMember = member(MemberName)
    myElements = MyData.elements
    IDlist = [:]
    DefList = []
    originalRect = rect(MyData.rect[1], MyData.rect[2], MyData.rect[3], MyData.rect[4])
    repeat with n in myElements
      if n.member = "closebox.active" then
        append(DefList, [n.member, point(originalRect.right - (originalRect.left + n.locH), n.locV)])
        next repeat
      end if
      if n.member = "cc.window.shadow.lefttop" then
        shadowright = n.locH + n.width
        shadowbottom = n.locV + n.height
      end if
      mystrech = string(n.strech)
      if mystrech contains "strech" then
        if mystrech.char[offset("strech", mystrech) + 6] = "H" then
          if n.member contains "shadow" then
            n.width = myRect.width + 11
          else
            n.width = myRect.width
          end if
          if mystrech.char[offset("strech", mystrech) + 7] = "V" then
            if n.member contains "shadow" then
              n.width = myRect.width + 34
              n.height = myRect.height + 42
            else
              n.height = myRect.height
            end if
          end if
        else
          n.height = myRect.height
        end if
      end if
      if mystrech contains "move" then
        if mystrech.char[offset("move", mystrech) + 4] = "H" then
          if n.member contains "shadow" then
            n.locH = shadowright + myRect.width + 11
          else
            n.locH = member("cc.window.lefttop").width + myRect.width
          end if
          if mystrech.char[offset("move", mystrech) + 5] = "V" then
            if n.member contains "shadow" then
              n.locV = myRect.height + 42 + member("cc.window.shadow.lefttop").height
            else
              n.locV = member("cc.window.lefttop").height + myRect.height
            end if
          end if
        else
          if n.member contains "shadow" then
            n.locV = myRect.height + 42 + member("cc.window.shadow.lefttop").height
          else
            n.locV = member("cc.window.lefttop").height + myRect.height
          end if
        end if
      end if
      destRect = rect(n.locH, n.locV, n.locH + n.width, n.locV + n.height)
      addProp(IDlist, n.id, destRect)
    end repeat
    append(DefList, myMember)
    append(DefList, IDlist)
    return DefList
  else
    myMember = new(#bitmap)
    mywidth = member("cc.window.shadow.lefttop").width + myRect.width + 11 + member("cc.window.shadow.righttop").width
    myMember.name = MemberName
    append(gMembersToDelete, myMember)
    myElements = MyData.elements
    BGimg = image(mywidth, myRect.height + member("cc.window.top").height + member("cc.window.bottom").height + member("cc.window.shadow.rightbottom").height, 32, 0, member("interface palette"))
    BGimg.fill(BGimg.rect, rgb(0, 0, 0))
    BGimg.useAlpha = 1
    BGalpha = image(BGimg.width, BGimg.height, 8, #grayscale)
    BGalpha.fill(BGalpha.rect, rgb(255, 255, 255))
    IDlist = [:]
    DefList = []
    originalRect = rect(MyData.rect[1], MyData.rect[2], MyData.rect[3], MyData.rect[4])
    repeat with n in myElements
      if n.media = #bitmap then
        if n.member = "closebox.active" then
          append(DefList, [n.member, point(originalRect.right - (originalRect.left + n.locH), n.locV)])
          next repeat
        end if
        if n.member = "cc.window.shadow.lefttop" then
          shadowright = n.locH + n.width
          shadowbottom = n.locV + n.height
        end if
        mystrech = string(n.strech)
        if mystrech contains "strech" then
          if mystrech.char[offset("strech", mystrech) + 6] = "H" then
            if n.member contains "shadow" then
              n.width = myRect.width + 11
            else
              n.width = myRect.width
            end if
            if mystrech.char[offset("strech", mystrech) + 7] = "V" then
              if n.member contains "shadow" then
                n.width = myRect.width + 34
                n.height = myRect.height + 42
              else
                n.height = myRect.height
              end if
            end if
          else
            n.height = myRect.height
          end if
        end if
        if mystrech contains "move" then
          if mystrech.char[offset("move", mystrech) + 4] = "H" then
            if n.member contains "shadow" then
              n.locH = shadowright + myRect.width + 11
            else
              n.locH = member("cc.window.lefttop").width + myRect.width
            end if
            if mystrech.char[offset("move", mystrech) + 5] = "V" then
              if n.member contains "shadow" then
                n.locV = myRect.height + 42 + member("cc.window.shadow.lefttop").height
              else
                n.locV = member("cc.window.lefttop").height + myRect.height
              end if
            end if
          else
            if n.member contains "shadow" then
              n.locV = myRect.height + 42 + member("cc.window.shadow.lefttop").height
            else
              n.locV = member("cc.window.lefttop").height + myRect.height
            end if
          end if
        end if
        myitem = member(n.member)
        destRect = rect(n.locH, n.locV, n.locH + n.width, n.locV + n.height)
        sourceRect = myitem.rect
        addProp(IDlist, n.id, destRect)
        if n.id = "shadow" then
          BGalpha.copyPixels(myitem.image.duplicate(), destRect, sourceRect, [#ink: n.ink, #blend: n.blend])
        else
          myimg = myitem.image.duplicate()
          newmatte = myimg.createMatte()
          blacktemp = image(myimg.width, myimg.height, 8, #grayscale)
          blacktemp.fill(blacktemp.rect, rgb(0, 0, 0))
          BGalpha.copyPixels(blacktemp, destRect, sourceRect, [#maskImage: newmatte])
          BGimg.copyPixels(myimg, destRect, sourceRect, [#ink: n.ink])
        end if
        BGimg.setAlpha(BGalpha)
        next repeat
      end if
      if member(n.member).memberNum < 1 then
        newMember = new(n.media)
        newMember.name = n.member
        append(gMembersToDelete, newMember)
      end if
      newMember = member(n.member)
      if n.media = #text then
        newMember.rect = rect(0, 0, BGimg.width, 20)
        newMember.editable = n.editable
        newMember.autoTab = n.autoTab
        newMember.boxType = n.boxType
        newMember.wordWrap = n.wordWrap
        newMember.alignment = n.alignment
        newMember.color = rgb(n.txtColor)
        newMember.font = n.font
        newMember.fontStyle = n.fontStyle
        newMember.fontSize = n.fontSize
        newMember.text = TextMgr.GetRefText(myName) & " "
        myImage = member(newMember).image.duplicate()
        titleimage = image(charPosToLoc(newMember, length(newMember.text)).locH, myImage.height, 32)
        titleimage.copyPixels(myImage, titleimage.rect, titleimage.rect)
        myleft = 0
        destRect = rect(myleft, n.locV, myleft + titleimage.width, n.locV + titleimage.height)
        sourceRect = titleimage.rect
        BGimg.copyPixels(titleimage, destRect, sourceRect, [#ink: 36])
        BGalpha.fill(destRect, rgb(0, 0, 0))
        BGimg.setAlpha(BGalpha)
      end if
    end repeat
    myMember.image = BGimg
    myMember.regPoint = point(0, 0)
    append(DefList, myMember)
    append(DefList, IDlist)
    return DefList
  end if
end

on closeWindow me
  global gCLOSING, bExitToWhaleWash
  if me.pname contains "sanfo_general_alert" then
    if gCLOSING then
      gotoNetPage("javascript:window.close()")
      return 
    end if
  else
    if me.pname contains "whale_wash" then
      if bExitToWhaleWash then
        gotoWhaleWash()
      end if
    end if
  end if
  mypos = getPos(ElementMgr.pOpenWindows, me)
  if mypos < count(ElementMgr.pOpenWindows) then
    repeat with n = mypos + 1 to count(ElementMgr.pOpenWindows)
      repeat with m in ElementMgr.pOpenWindows[n].pSpritelist
        sprite(m).locZ = sprite(m).locZ - count(me.pSpritelist)
      end repeat
    end repeat
  end if
  repeat with n in pSpritelist
    sprite(n).memberNum = -1
    sprite(n).scriptInstanceList = []
    sprite(n).visible = 1
    puppetSprite(n, 0)
  end repeat
  ElementMgr.pLastUsedSprite = ElementMgr.pLastUsedSprite - pSpritelist.count()
  if mypos then
    deleteAt(ElementMgr.pOpenWindows, mypos)
  end if
  pSpritelist = []
  iRect = me.prect
  return iRect
end

on boostup me, num
  repeat with n = 1 to count(pSpritelist)
    mySprite = sprite(pSpritelist[n])
    mySprite.locZ = mySprite.locZ + num
  end repeat
end

on setWebLaunchAttributes me, newAtrArray
  me.webLaunchAttributes = newAtrArray
end

on getWebLaunchAttributes me
  return me.webLaunchAttributes
end
