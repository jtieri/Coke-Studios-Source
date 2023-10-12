property pChatLogDisplaySprite, bDebug
global ElementMgr, aChatLogDisplaySprites, sModScreenName, aModRoomList, oStudioByModManager

on beginSprite me
  pChatLogDisplaySprite = sprite(aChatLogDisplaySprites[aChatLogDisplaySprites.count])
  me.bDebug = 0
end

on mouseUp me
  if not objectp(oStudioByModManager) then
    me.debug("mouseUp: 1")
    exit
  else
    me.debug("mouseUp: 2")
    sStudioID = pChatLogDisplaySprite.scriptInstanceList[2].pStudioID
    if not oStudioByModManager.checkForOpenStudio(sStudioID) then
      me.debug("mouseUp: 3")
      exit
    else
      me.debug("mouseUp: 4")
      oStudioByModManager.deleteStudio(sModScreenName, sStudioID)
      i = aChatLogDisplaySprites.getPos(pChatLogDisplaySprite.spriteNum)
      oModRoom = aModRoomList.getProp(i)
      oModRoom.closeLog()
      aModRoomList.deleteProp(i)
      pChatLogDisplaySprite.pActive = 0
      pChatLogDisplaySprite.member.scrollTop = pChatLogDisplaySprite.scriptInstanceList[2].pScrolltop
      sendAllSprites(#displayOwner, pChatLogDisplaySprite, EMPTY)
    end if
  end if
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "b_closeLogBtn: " & sMessage
  end if
end
