property pSprite, pChatLogDisplaySprite, pDataType, pStudioID
global aChatLogDisplaySprites, oPublicDisplayManager, oPrivateDisplayManager, ElementMgr

on beginSprite me
  pSprite = sprite(me.spriteNum)
  pChatLogDisplaySprite = sprite(aChatLogDisplaySprites[aChatLogDisplaySprites.count])
  pSprite.member.text = "studioName"
  pDataType = EMPTY
  pStudioID = EMPTY
end

on displayOwner me, aSprite, sDataType
  if aSprite <> pChatLogDisplaySprite then
    exit
  else
    pDataType = sDataType
    if pDataType = EMPTY then
      sName = "studioName"
    else
      sName = pChatLogDisplaySprite.pStudioName
      pStudioID = pChatLogDisplaySprite.pStudioID
    end if
    pSprite.member.text = sName
  end if
end
