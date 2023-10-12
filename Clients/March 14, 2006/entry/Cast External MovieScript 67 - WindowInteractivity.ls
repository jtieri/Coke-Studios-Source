on addinteractivity whatsprite, spriteID, callerID
  case spriteID of
    "entry_info":
      sprite(whatsprite).scriptInstanceList.add(new(script("safety tips")))
    "cc.entry.help":
      sprite(whatsprite).scriptInstanceList.add(new(script("button display status"), whatsprite))
      sprite(whatsprite).scriptInstanceList.add(new(script("call for help btn")))
    "cc.entry.mms":
      sprite(whatsprite).scriptInstanceList.add(new(script("button display status"), whatsprite))
      sprite(whatsprite).scriptInstanceList.add(new(script("messenger")))
      sprite(whatsprite).scriptInstanceList.add(new(script("messenger btn")))
    "nav_search_tab":
      sprite(whatsprite).scriptInstanceList.add(new(script("generictab"), callerID, "nav_search_start.window"))
    "nav_private_tab":
      sprite(whatsprite).scriptInstanceList.add(new(script("generictab"), callerID, "nav_private_start.window"))
    "nav_public_tab":
      if member("roomdisplay").memberNum < 1 then
        sprite(whatsprite).scriptInstanceList.add(new(script("generictab"), callerID, "nav_public_start.window"))
      else
        if (member("roomdisplay").comments.line[3] = EMPTY) or (member("roomdisplay").comments.line[3] = "0") then
          sprite(whatsprite).scriptInstanceList.add(new(script("generictab"), callerID, "nav_public_start.window"))
        else
          sprite(whatsprite).scriptInstanceList.add(new(script("generictab"), callerID, "nav_public_info.window"))
        end if
      end if
    "nav_public_people_tab":
      sprite(whatsprite).scriptInstanceList.add(new(script("generictab"), callerID, "nav_public_people.window"))
    "nav_people_tab":
      sprite(whatsprite).scriptInstanceList.add(new(script("generictab"), callerID, "nav_private_people.window"))
    "nav_public_info_tab":
      sprite(whatsprite).scriptInstanceList.add(new(script("generictab"), callerID, "nav_public_info.window"))
    "nav_private_info_tab":
      sprite(whatsprite).scriptInstanceList.add(new(script("generictab"), callerID, "nav_private_info.window"))
    "nav_priv_popular":
      sprite(whatsprite).scriptInstanceList.add(new(script("activestudios"), callerID))
    "nav_priv_own":
      sprite(whatsprite).scriptInstanceList.add(new(script("mystudios"), callerID))
    "nav_priv_create_own":
      sprite(whatsprite).scriptInstanceList.add(new(script("createroom"), callerID))
    "nav_go_search_button":
      sprite(whatsprite).scriptInstanceList.add(new(script("startsearchroom"), callerID))
    "nav_search_button":
      sprite(whatsprite).scriptInstanceList.add(new(script("searchroom"), callerID))
    "nav_createstudio_cancel", "nav_delete_room_cancel_1", "nav_delete_room_cancel_2":
      sprite(whatsprite).scriptInstanceList.add(new(script("cancelcreateroom"), callerID))
    "nav_delete_room_ok_3":
      sprite(whatsprite).scriptInstanceList.add(new(script("okdeleteroom"), callerID))
    "nav_private_search_field":
      sprite(whatsprite).scriptInstanceList.add(new(script("searchroom field")))
    "nav_createstudio_ok":
      sprite(whatsprite).scriptInstanceList.add(new(script("OKCREATEROOM"), callerID))
    "v-ego_result_figure":
      sprite(whatsprite).scriptInstanceList.add(new(script("vegoResultFigure"), whatsprite))
    "close", "MODERATOR_HELP_CANCEL", "sanfo_decision_cancel":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("closewindow"), callerID)]
    "help_called_cancel":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("closewindow"), callerID)]
      sprite(whatsprite).scriptInstanceList.add(new(script("fake moderator message")))
    "nav_create_roomnamefield":
      sprite(whatsprite).scriptInstanceList.add(new(script("roomname field")))
    "nav_create_roomdescfield":
      sprite(whatsprite).scriptInstanceList.add(new(script("roomdesc field")))
    "nav_modify_roomnamefield":
      sprite(whatsprite).scriptInstanceList.add(new(script("roomname field")))
    "nav_modify_roomdescription_field":
      sprite(whatsprite).scriptInstanceList.add(new(script("roomdesc field")))
    "nav_modifystudio_cancel":
      sprite(whatsprite).scriptInstanceList.add(new(script("cancelcreateroom"), callerID))
    "nav_modify_deleteroom":
      sprite(whatsprite).scriptInstanceList.add(new(script("deleteroom1"), callerID))
    "nav_delete_room_ok_1":
      sprite(whatsprite).scriptInstanceList.add(new(script("deleteroom2"), callerID))
    "nav_delete_room_ok_2":
      sprite(whatsprite).scriptInstanceList.add(new(script("deleteroom3"), callerID))
    "v-ego_search_field":
      sprite(whatsprite).scriptInstanceList.add(new(script("searchuser field")))
    "nav_v-ego_search_button":
      sprite(whatsprite).scriptInstanceList.add(new(script("searchuser"), callerID))
    "nav_modifystudio_ok":
      sprite(whatsprite).scriptInstanceList.add(new(script("okmodifyroom"), callerID))
    "cc.speechswitch.btn":
      sprite(whatsprite).scriptInstanceList.add(new(script("speechswitch btn")))
    "cb.jukebox.btn":
      sprite(whatsprite).scriptInstanceList.add(new(script("button display status"), whatsprite))
      sprite(whatsprite).scriptInstanceList.add(new(script("controlbar btn rollover text"), spriteID))
      sprite(whatsprite).scriptInstanceList.add(new(script("jukeboxbtn")))
    "cb.nav.btn":
      sprite(whatsprite).scriptInstanceList.add(new(script("button display status"), whatsprite))
      sprite(whatsprite).scriptInstanceList.add(new(script("controlbar btn rollover text"), spriteID))
      sprite(whatsprite).scriptInstanceList.add(new(script("navbtn")))
    "cb.mms.btn":
      sprite(whatsprite).scriptInstanceList.add(new(script("button display status"), whatsprite))
      sprite(whatsprite).scriptInstanceList.add(new(script("controlbar btn rollover text"), spriteID))
      sprite(whatsprite).scriptInstanceList.add(new(script("messenger btn")))
    "cb.dbs.btn":
      sprite(whatsprite).scriptInstanceList.add(new(script("button display status"), whatsprite))
      sprite(whatsprite).scriptInstanceList.add(new(script("controlbar btn rollover text"), spriteID))
      sprite(whatsprite).scriptInstanceList.add(new(script("balance btn")))
    "cb.bag.btn":
      sprite(whatsprite).scriptInstanceList.add(new(script("button display status"), whatsprite))
      sprite(whatsprite).scriptInstanceList.add(new(script("controlbar btn rollover text"), spriteID))
      sprite(whatsprite).scriptInstanceList.add(new(script("backpack btn")))
    "cb.cat.btn":
      sprite(whatsprite).scriptInstanceList.add(new(script("button display status"), whatsprite))
      sprite(whatsprite).scriptInstanceList.add(new(script("controlbar btn rollover text"), spriteID))
      sprite(whatsprite).scriptInstanceList.add(new(script("catalogue btn")))
    "cb.snd.btn":
      sprite(whatsprite).scriptInstanceList.add(new(script("button display status"), whatsprite))
      sprite(whatsprite).scriptInstanceList.add(new(script("controlbar btn rollover text"), spriteID))
      sprite(whatsprite).scriptInstanceList.add(new(script("sound toggle")))
    "cb.hlp.btn":
      sprite(whatsprite).scriptInstanceList.add(new(script("button display status"), whatsprite))
      sprite(whatsprite).scriptInstanceList.add(new(script("controlbar btn rollover text"), spriteID))
      sprite(whatsprite).scriptInstanceList.add(new(script("call for help btn")))
    "cc.chatinput.fld":
      sprite(whatsprite).scriptInstanceList.add(new(script("chatinput script")))
    "nav_go_public_button":
      sprite(whatsprite).scriptInstanceList.add(new(script("button display status"), whatsprite))
      sprite(whatsprite).scriptInstanceList.add(new(script("GoToPublicStudioScript")))
    "nav_go_private_button", "nav_gotoyourstudio":
      sprite(whatsprite).scriptInstanceList.add(new(script("button display status"), whatsprite))
      sprite(whatsprite).scriptInstanceList.add(new(script("GoToPrivateStudioScript")))
    "balance_ok_button", "Call_for_help_ok_button":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("closewindow"), callerID)]
    "cc.backpack.bg":
      sprite(whatsprite).scriptInstanceList = [new(script("backpack Window"), callerID)]
    "cc.backpack.closebox":
      sprite(whatsprite).scriptInstanceList = [new(script("close backpack"), callerID)]
    "cc.pack.leftarrow":
      sprite(whatsprite).scriptInstanceList = [new(script("backpack leftarrow"), callerID)]
    "cc.pack.rightarrow":
      sprite(whatsprite).scriptInstanceList = [new(script("backpack rightarrow"), callerID)]
    "cc.backpack.item":
      sprite(whatsprite).scriptInstanceList = [new(script("backpack item script"))]
    "CFH_hyperlink":
      sprite(whatsprite).scriptInstanceList = [new(script("CFH hyperlink"), callerID)]
    "MODERATOR_HELP_SEND":
      sprite(whatsprite).scriptInstanceList = [new(script("help send btn"), callerID), new(script("button display status"), whatsprite)]
    "catalog_next":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("catalogue next"), callerID)]
    "catalog_previous":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("catalogue prev"), callerID)]
    "catalog_wall_bg":
      sprite(whatsprite).scriptInstanceList = [new(script("WallBackground"))]
    "cat_floor_texture":
      sprite(whatsprite).scriptInstanceList = [new(script("GetFloorTextureSprite"))]
    "cat_left_wall_dirt":
      sprite(whatsprite).scriptInstanceList = [new(script("GetLeftWallSprite"))]
    "cat_right_wall_dirt":
      sprite(whatsprite).scriptInstanceList = [new(script("GetrightWallSprite"))]
    "cat_left_wall_texture":
      sprite(whatsprite).scriptInstanceList = [new(script("GetLeftWallTextureSprite"))]
    "cat_right_wall_texture":
      sprite(whatsprite).scriptInstanceList = [new(script("GetrightWallTextureSprite"))]
    "catalog_wall_bg_replace":
      sprite(whatsprite).scriptInstanceList = [new(script("WallBackgroundReplace"))]
    "cat_floor_texture_replace":
      sprite(whatsprite).scriptInstanceList = [new(script("GetFloorTextureSpriteReplace"))]
    "cat_left_wall_dirt_replace":
      sprite(whatsprite).scriptInstanceList = [new(script("GetLeftWallSpriteReplace"))]
    "cat_right_wall_dirt_replace":
      sprite(whatsprite).scriptInstanceList = [new(script("GetrightWallSpriteReplace"))]
    "cat_left_wall_texture_replace":
      sprite(whatsprite).scriptInstanceList = [new(script("GetLeftWallTextureSpriteReplace"))]
    "cat_right_wall_texture_replace":
      sprite(whatsprite).scriptInstanceList = [new(script("GetrightWallTextureSpriteReplace"))]
    "cat_floor_shape_replace":
      sprite(whatsprite).scriptInstanceList = [new(script("GetFloorShapeSpriteReplace"))]
    "confirm_texture_ok":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("replaceOK"), callerID)]
    "DELETE_ITEM_OK":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("deleteok"), callerID)]
    "cat_wall_prev":
      sprite(whatsprite).scriptInstanceList = [new(script("ScrollWallPatternsLeft"))]
    "cat_wall_next":
      sprite(whatsprite).scriptInstanceList = [new(script("ScrollWallPatternsRight"))]
    "cat_walltexture_prev":
      sprite(whatsprite).scriptInstanceList = [new(script("ScrollWallColorsLeft"))]
    "cat_walltexture_next":
      sprite(whatsprite).scriptInstanceList = [new(script("ScrollWallColorsRight"))]
    "cat_floor_prev":
      sprite(whatsprite).scriptInstanceList = [new(script("ScrollFloorPatternsLeft"))]
    "cat_floor_next":
      sprite(whatsprite).scriptInstanceList = [new(script("ScrollFloorPatternsRight"))]
    "cat_floortexture_prev":
      sprite(whatsprite).scriptInstanceList = [new(script("ScrollFloorColorsLeft"))]
    "catfloortexture_next":
      sprite(whatsprite).scriptInstanceList = [new(script("ScrollFloorColorsRight"))]
    "cat_floor_shape":
      sprite(whatsprite).scriptInstanceList = [new(script("GetFloorShapeSprite"))]
    "cat_previewbox":
      sprite(whatsprite).scriptInstanceList = [new(script("catalogue thumbnail"))]
    "cat_buy_1":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("catalogue buy btn script"), 1, callerID)]
    "cat_buy_2":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("catalogue buy btn script"), 2, callerID)]
    "cat_buy_3":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("catalogue buy btn script"), 3, callerID)]
    "cat_buy_4":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("catalogue buy btn script"), 4, callerID)]
    "cat_buy_5":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("catalogue buy btn script"), 5, callerID)]
    "cat_buy_6":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("catalogue buy btn script"), 6, callerID)]
    "cat_buy_7":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("catalogue buy btn script"), 7, callerID)]
    "cat_buy_8":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("catalogue buy btn script"), 8, callerID)]
    "purchase_decision_ok":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("ok_purchase script"), callerID)]
    "console_myhead_image":
      sprite(whatsprite).scriptInstanceList = [new(script("msg avatar script"))]
    "whale_wash_cancel", "whale_wash_ok":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("whale_wash_dialog script"), callerID, spriteID)]
    "console_compose_message_field":
      sprite(whatsprite).scriptInstanceList = [new(script("messengerTextBox"))]
    "drag":
      sprite(whatsprite).scriptInstanceList = [new(script("generic drag window"), callerID)]
    "console_myinfo_messages_link":
      sprite(whatsprite).scriptInstanceList = [new(script("myinfo msg script"))]
    "console_myinfo_requests_link":
      sprite(whatsprite).scriptInstanceList = [new(script("myinfo reqs script"))]
    "nextmessage":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("delete message"))]
    "console.myinfo.button":
      sprite(whatsprite).scriptInstanceList = [new(script("messenger start"), callerID)]
    "console.myfriends.button":
      sprite(whatsprite).scriptInstanceList = [new(script("messenger friends"), callerID)]
    "console_friendrequest_accept":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("accept invite"))]
    "console_getfriendrequest_reject":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("reject invite"))]
    "console_getmessage_reply":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("reply"))]
    "console_compose_cancel":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("cancel reply"))]
    "console_compose_send":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("send msg"))]
    "messenger_friends_compose_button":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("compose"))]
    "messenger_friends_remove_button":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("remove"))]
    "console_getfriendrequest_cancel":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("cancelremove"))]
    "console_friendrequest_remove":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("okremove"))]
    "v-ego_ask_button":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("invite friend"))]
    "mixer_sdpixel":
      sprite(whatsprite).scriptInstanceList = [new(script("blocker"))]
    "mixer_play_1":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "PLAY"), new(script("playbtn"), 1)]
    "mixer_play_2":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "PLAY"), new(script("playbtn"), 2)]
    "mixer_play_3":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "PLAY"), new(script("playbtn"), 3)]
    "mixer_play_4":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "PLAY"), new(script("playbtn"), 4)]
    "mixer_play_5":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "PLAY"), new(script("playbtn"), 5)]
    "mixer_edit_1":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "EDIT"), new(script("editbtn"), 1)]
    "mixer_edit_2":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "EDIT"), new(script("editbtn"), 2)]
    "mixer_edit_3":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "EDIT"), new(script("editbtn"), 3)]
    "mixer_edit_4":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "EDIT"), new(script("editbtn"), 4)]
    "mixer_edit_5":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "EDIT"), new(script("editbtn"), 5)]
    "mixer_burn_1":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "BURN"), new(script("burnbtn"), 1)]
    "mixer_burn_2":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "BURN"), new(script("burnbtn"), 2)]
    "mixer_burn_3":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "BURN"), new(script("burnbtn"), 3)]
    "mixer_burn_4":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "BURN"), new(script("burnbtn"), 4)]
    "mixer_burn_5":
      sprite(whatsprite).scriptInstanceList = [new(script("mixerbtn"), "BURN"), new(script("burnbtn"), 5)]
    "mixer_cdburner":
      sprite(whatsprite).scriptInstanceList = [new(script("cdburner"))]
    "closemixer":
      sprite(whatsprite).scriptInstanceList = [new(script("closemixer"))]
    "BURN_CANCEL":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("cancelburn"), callerID)]
    "BURN_OK":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("OKburn"), callerID)]
    "mixer_unpause":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("closewindow"), callerID), new(script("mixer_unpause"), callerID)]
    "cdtimer":
      sprite(whatsprite).scriptInstanceList = [new(script("cdtimer"), callerID)]
    "playsong":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("songblend")), new(script("playsong"))]
    "cdicon":
      sprite(whatsprite).scriptInstanceList = [new(script("songblend"))]
    "closecd":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("closecd"))]
    "trading_herstuff_1":
      sprite(whatsprite).scriptInstanceList = [new(script("leftslot1"))]
    "trading_herstuff_2":
      sprite(whatsprite).scriptInstanceList = [new(script("leftslot2"))]
    "trading_herstuff_3":
      sprite(whatsprite).scriptInstanceList = [new(script("leftslot3"))]
    "trading_herstuff_4":
      sprite(whatsprite).scriptInstanceList = [new(script("leftslot4"))]
    "trading_herstuff_5":
      sprite(whatsprite).scriptInstanceList = [new(script("leftslot5"))]
    "trading_herstuff_6":
      sprite(whatsprite).scriptInstanceList = [new(script("leftslot6"))]
    "trading_mystuff_1":
      sprite(whatsprite).scriptInstanceList = [new(script("rightSlot1"))]
    "trading_mystuff_2":
      sprite(whatsprite).scriptInstanceList = [new(script("rightSlot2"))]
    "trading_mystuff_3":
      sprite(whatsprite).scriptInstanceList = [new(script("rightSlot3"))]
    "trading_mystuff_4":
      sprite(whatsprite).scriptInstanceList = [new(script("rightSlot4"))]
    "trading_mystuff_5":
      sprite(whatsprite).scriptInstanceList = [new(script("rightSlot5"))]
    "trading_mystuff_6":
      sprite(whatsprite).scriptInstanceList = [new(script("rightSlot6"))]
    "trading_cancel":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("closetrader"))]
    "trading_confirm_check":
      sprite(whatsprite).scriptInstanceList = [new(script("rightcheckbox"))]
    "trading_buddycheck_image":
      sprite(whatsprite).scriptInstanceList = [new(script("leftcheckbox"))]
    "wall_ok":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("buy wall"))]
    "floor_ok":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("buy floor"))]
    "WFprev":
      sprite(whatsprite).scriptInstanceList = [new(script("WFpreview script"))]
    "WFreplace":
      sprite(whatsprite).scriptInstanceList = [new(script("WFreplace script"))]
    "dispense_item_close":
      sprite(whatsprite).scriptInstanceList = [new(script("closewindow"), callerID)]
    "launch_web_close":
      sprite(whatsprite).scriptInstanceList = [new(script("closewindow"), callerID)]
    "launch_web_launch":
      sprite(whatsprite).scriptInstanceList = [new(script("launchURL"), callerID)]
    "cc.jukebox.catalog.playlist.btn":
      sprite(whatsprite).scriptInstanceList = [new(script("jukebox.playlist.btn script"))]
    "cc.jukebox.playlist.catalog.btn":
      sprite(whatsprite).scriptInstanceList = [new(script("jukebox.catalog.btn script"))]
    "cc.jukebox.add.btn":
      sprite(whatsprite).scriptInstanceList = [new(script("add song script"))]
    "cc.jukebox.download.btn":
      sprite(whatsprite).scriptInstanceList = [new(script("download song script"))]
    "cc.jukebox.remove.btn":
      sprite(whatsprite).scriptInstanceList = [new(script("remove song script"))]
    "cc.jukebox.player.play.btn":
      sprite(whatsprite).scriptInstanceList = [new(script("play song script"))]
    "cc.jukebox.catalog.drawer":
      sprite(whatsprite).scriptInstanceList = [new(script("catalogue drawer script"))]
    "cc.jukebox.catalog.drawer.btn":
      sprite(whatsprite).scriptInstanceList = [new(script("catalogue drawer button script"))]
    "cc.jukebox.playback.close":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("close playback"), callerID)]
    "cc.jukebox.catalog.close":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("close catalog"), callerID)]
    "cc.jukebox.player.scrollbar":
      sprite(whatsprite).scriptInstanceList = [new(script("jukebox scrollbar script"))]
    "cc.jukebox.scrollhead":
      sprite(whatsprite).scriptInstanceList = [new(script("jukebox scrollhead script"), callerID)]
    "cc.jukebox.backbutton":
      sprite(whatsprite).scriptInstanceList = [new(script("jukebox back button"), callerID)]
    "sanfo_decision_ok":
      sprite(whatsprite).scriptInstanceList = [new(script("button display status"), whatsprite), new(script("dialog ok button script")), new(script("closewindow"), callerID)]
    "cc.jukebox.player.help.btn":
      sprite(whatsprite).scriptInstanceList = [new(script("jukebox help btn"))]
  end case
end

on makewindowdescription
  repeat with n = 2 to 28
    myList = [:]
    addProp(myList, #member, sprite(n).member.name)
    addProp(myList, #media, sprite(n).member.type)
    addProp(myList, #locH, sprite(n).locH)
    addProp(myList, #locV, sprite(n).locV)
    addProp(myList, #ink, sprite(n).ink)
    addProp(myList, #blend, sprite(n).blend)
    addProp(myList, #width, sprite(n).width)
    addProp(myList, #height, sprite(n).height)
    if (sprite(n).member.type = #field) or (sprite(n).member.type = #text) then
      addProp(myList, #editable, sprite(n).member.editable)
      addProp(myList, #autoTab, sprite(n).member.autoTab)
      addProp(myList, #boxType, sprite(n).member.boxType)
      addProp(myList, #wordWrap, sprite(n).member.wordWrap)
      addProp(myList, #alignment, sprite(n).member.alignment)
      addProp(myList, #txtColor, sprite(n).member.color.hexString())
      addProp(myList, #font, sprite(n).member.font)
      addProp(myList, #fontStyle, sprite(n).member.fontStyle)
      addProp(myList, #fontSize, sprite(n).member.fontSize)
    end if
    if sprite(n).member.type = #field then
      addProp(myList, #lineHeight, sprite(n).member.lineHeight)
      addProp(myList, #type, "text")
    else
      if sprite(n).member.type = #text then
        addProp(myList, #fixedLineSpace, sprite(n).member.fixedLineSpace)
        addProp(myList, #type, "text")
      else
        addProp(myList, #type, "piece")
      end if
    end if
    addProp(myList, #id, EMPTY)
    addProp(myList, #key, EMPTY)
    addProp(myList, #streched, #fixed)
    put myList
  end repeat
end
