property pStartChatLog, pFontStyle, pDeselectLineNum, pSprite, pPublicStudioData, pTime, pSelected, pItemNum, pFrame, pScrolltop, pDisplayLines, pActive, pDataType, pStudioList, pStudioID, pStudioName, pStudioOwner, pReceive, oController, bDebug, pSpriteWidth, pScrollLock, pBrowseScrolltop
global oUserDisplayManager, aChatLogDisplaySprites, ElementMgr, sModScreenName

on beginSprite me
  aChatLogDisplaySprites.add(me.spriteNum)
  pSprite = sprite(me.spriteNum)
  pSprite.member.text = "inactive log"
  pTime = the timer
  pSelected = 0
  pFrame = the frame
  pScrolltop = pSprite.member.scrollTop
  pDisplayLines = pSprite.height / pSprite.member.fixedLineSpace
  pActive = 0
  pDataType = EMPTY
  pStudioName = EMPTY
  pStudioOwner = EMPTY
  pStartChatLog = 0
  pDeselectLineNum = EMPTY
  pReceive = 1
  pSpriteWidth = pSprite.width - 16
  pScrollLock = 1
  me.bDebug = 0
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "b_ChatLogDisplay:aChatLogDisplaySprites[me.spriteNum]:" && aChatLogDisplaySprites[me.spriteNum] & sMessage
  end if
end

on mouseUp me
  if the doubleClick then
    exit
  end if
  pointClicked = the mouseLoc
  if pSprite.pointToItem(pointClicked) < 1 then
    exit
  end if
  sDefaultItemDelimiter = the itemDelimiter
  the itemDelimiter = RETURN
  pItemNum = pSprite.pointToItem(pointClicked)
  sChatLine = pSprite.member.item[pItemNum]
  if (sChatLine contains "<-------------------") or ((sChatLine contains ":") = 0) then
    exit
  end if
  deSelectLine(me)
  the itemDelimiter = sDefaultItemDelimiter
  pFontStyle = pSprite.member.line[pItemNum].fontStyle
  underlineStyle = pFontStyle.duplicate()
  if underlineStyle = [#plain] then
    underlineStyle = []
  end if
  underlineStyle.add(#underline)
  pSprite.member.line[pItemNum].fontStyle = underlineStyle
  pSelected = 1
  pDeselectLineNum = pItemNum
  sDenizenName = parseChatLine(me, sChatLine)
  oUserDisplayManager.displayExtendedUserInfo(sDenizenName, pStudioName, pStudioOwner, 0)
end

on deSelectLine me
  if pDeselectLineNum <> EMPTY then
    pSelected = 0
    pSprite.member.line[pDeselectLineNum].fontStyle = pFontStyle
    exit
  else
    repeat with i = 1 to aChatLogDisplaySprites.count
      if aChatLogDisplaySprites[i] <> me.spriteNum then
        if sprite(aChatLogDisplaySprites[i]).pDeselectLineNum <> EMPTY then
          sprite(aChatLogDisplaySprites[i]).pSelected = 0
          sprite(aChatLogDisplaySprites[i]).member.line[sprite(aChatLogDisplaySprites[i]).pDeselectLineNum].fontStyle = sprite(aChatLogDisplaySprites[i]).pFontStyle
          sprite(aChatLogDisplaySprites[i]).pDeselectLineNum = EMPTY
        end if
      end if
    end repeat
  end if
end

on parseChatLine me, sChatString
  sChar = offset(":", sChatString)
  sScreenName = sChatString.char[1..sChar - 1]
  return sScreenName
end

on scrollDisplay me
  me.debug("scrollDisplay():pActive:" && pActive && "pScrolltop:" && pScrolltop && "pScrollLock:" && pScrollLock)
  if pActive then
    if pSprite.member.line.count > pDisplayLines then
      pScrolltop = (pSprite.member.line.count - pDisplayLines) * pSprite.member.fixedLineSpace
      if pScrollLock then
        pSprite.member.scrollTop = pScrolltop
      else
        pSprite.member.scrollTop = pBrowseScrolltop
      end if
    end if
  end if
end

on exitFrame me
  if pActive then
    if pStartChatLog then
      pSprite.member.text = "active log"
      pStartChatLog = 0
    end if
    if not pScrollLock then
      pBrowseScrolltop = pSprite.member.scrollTop
    end if
  end if
end

on setController me, _oController
  me.oController = _oController
end

on getController me
  return me.oController
end

on initGetGameServerResult me, foGameServer
  if voidp(me.oController) then
    return 
  end if
  me.debug("b_ChatLogDisplay: initGameGameServerResult() " & foGameServer.toString())
  me.oController.receiveGameServerNotification(foGameServer)
end
