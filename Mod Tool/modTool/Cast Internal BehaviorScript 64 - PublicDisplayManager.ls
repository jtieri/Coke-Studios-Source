property pSprite, pPublicStudioData, pTime, pInterval, pSelected, pItemNum, pFrame, pScrolltop, pStudioID, bDebug, pStudioName, pStudioOwner
global oPublicDisplayManager, oStudioManager, sModScreenName

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pInterval] = [#comment: "Server query interval (in sec):", #format: #integer, #default: 15]
  return mylist
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
  pSprite.member.text = "Loading..."
  oPublicDisplayManager = me
  pTime = the timer
  pInterval = pInterval * 60
  pSelected = 0
  pFrame = the frame
  pItemNum = 1
  pScrolltop = pSprite.member.scrollTop
  me.bDebug = 0
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "oPublicDisplayManager: " & sMessage
  end if
end

on displayPublic_Mod me, aStudioData
  me.debug("displayPublic_Mod:aStudioData" && aStudioData)
  pPublicStudioData = aStudioData.duplicate()
  sDisplayString = EMPTY
  repeat with i = 1 to pPublicStudioData.count
    sName = pPublicStudioData[i].name
    iUserCount = pPublicStudioData[i].userCount
    aModList = pPublicStudioData[i].mods
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
    if i = pPublicStudioData.count then
      sLine = sName & TAB & "(" & iUserCount & ")" & sModList
    else
      sLine = sName & TAB & "(" & iUserCount & ")" & sModList & RETURN
    end if
    put sLine after sDisplayString
  end repeat
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
  if pSprite.pointToItem(pointClicked) < 1 then
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
  pStudioID = pPublicStudioData[pItemNum].studioId
  pStudioName = pPublicStudioData[pItemNum].name
  pStudioOwner = pPublicStudioData[pItemNum].owner
end

on exitFrame me
  if the timer > (pTime + pInterval) then
    pTime = the timer
    pScrolltop = pSprite.member.scrollTop
    oStudioManager.getAllPublicStudios()
  end if
end
