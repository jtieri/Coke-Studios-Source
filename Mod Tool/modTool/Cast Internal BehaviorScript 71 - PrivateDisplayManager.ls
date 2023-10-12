property pSprite, pPrivateStudioData, pTime, pInterval, pSelected, pItemNum, pFrame, pScrolltop, pStudioID, pSearch, bDebug, pSearchText, pSearchEntered, pStudioName, pStudioOwner
global oPrivateDisplayManager, oStudioManager, sModScreenName

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pInterval] = [#comment: "Server query interval (in sec):", #format: #integer, #default: 15]
  return mylist
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
  pSprite.member.text = "Loading..."
  oPrivateDisplayManager = me
  pTime = the timer
  pInterval = pInterval * 60
  pSelected = 0
  pFrame = the frame
  pItemNum = 1
  pScrolltop = pSprite.member.scrollTop
  pSearch = 0
  pSearchText = EMPTY
  bDebug = 0
  pStudioName = EMPTY
  pSearchEntered = 0
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "oPrivateDisplayManager: " & sMessage
  end if
end

on top35Hilite me, bHiliteState
  if bHiliteState then
    pSearch = 0
    member("searchStudio").hilite = 0
    member("top35").hilite = 1
  else
    pSearch = 1
    member("searchStudio").hilite = 1
    member("top35").hilite = 0
  end if
end

on displayPrivate_Mod me, aStudioData
  me.debug("displayPrivate_Mod:aStudioData" && aStudioData)
  pPrivateStudioData = aStudioData.duplicate()
  sDisplayString = EMPTY
  repeat with i = 1 to pPrivateStudioData.count
    sName = pPrivateStudioData[i].name
    sOwner = pPrivateStudioData[i].owner
    iUserCount = pPrivateStudioData[i].userCount
    aModList = pPrivateStudioData[i].mods
    sModList = EMPTY
    if aModList.count <> 0 then
      repeat with m = 1 to aModList.count
        if m = 1 then
          put modLookUp(aModList[m]) after sModList
          next repeat
        end if
        put "," & modLookUp(aModList[m]) after sModList
      end repeat
    end if
    if i = pPrivateStudioData.count then
      sLine = sName & TAB & "[" & sOwner & "]" & TAB & "(" & iUserCount & ")" & sModList
    else
      sLine = sName & TAB & "[" & sOwner & "]" & TAB & "(" & iUserCount & ")" & sModList & RETURN
    end if
    put sLine after sDisplayString
  end repeat
  if aStudioData = [] then
    sDisplayString = "Studio not found"
  end if
  pSprite.member.text = sDisplayString
  if pSelected then
    pSprite.member.fontStyle = [#plain]
    pSprite.member.line[pItemNum].fontStyle = [#underline]
  else
    pSprite.member.fontStyle = [#plain]
  end if
  pSprite.member.scrollTop = pScrolltop
end

on deSelectLines me
  pSelected = 0
  pSprite.member.fontStyle = [#plain]
  pSprite.member.scrollTop = pScrolltop
end

on mouseDown me
  pointClicked = the mouseLoc
  if (pSprite.pointToItem(pointClicked) < 1) or (pPrivateStudioData = []) then
    exit
  end if
  sDefaultItemDelimiter = the itemDelimiter
  the itemDelimiter = RETURN
  pItemNum = pSprite.pointToItem(pointClicked)
  itemText = pSprite.member.item[pItemNum]
  the itemDelimiter = sDefaultItemDelimiter
  pSprite.member.fontStyle = [#plain]
  pSprite.member.line[pItemNum].fontStyle = [#underline]
  pSelected = 1
  pStudioID = pPrivateStudioData[pItemNum].studioId
  pStudioName = pPrivateStudioData[pItemNum].name
  pStudioOwner = pPrivateStudioData[pItemNum].owner
end

on exitFrame me
  if the timer > (pTime + pInterval) then
    pTime = the timer
    pScrolltop = pSprite.member.scrollTop
    if pSearch then
      if pSearchEntered then
        pSprite.member.text = "Searching..."
        updateStage()
        oStudioManager.getByStudioName(pSearchText)
        pSearchEntered = 0
      end if
    else
      oStudioManager.getAllPrivateStudios()
    end if
    if me.bDebug then
      put pPrivateStudioData
    end if
  end if
end
