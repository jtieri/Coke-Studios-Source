property pSprite, pChatLogDisplaySprite, pDataType, pStudioID
global aChatLogDisplaySprites, oPublicDisplayManager, oPrivateDisplayManager, ElementMgr

on beginSprite me
  pSprite = sprite(me.spriteNum)
  pChatLogDisplaySprite = sprite(aChatLogDisplaySprites[aChatLogDisplaySprites.count])
  pSprite.member.text = "[studioOwner]"
  pDataType = EMPTY
  pStudioID = EMPTY
end

on displayOwner me, aSprite, sDataType
  if aSprite <> pChatLogDisplaySprite then
    exit
  else
    pDataType = sDataType
    if pDataType = EMPTY then
      sOwner = "studioOwner"
      pStudioID = EMPTY
    else
      if pDataType = "private" then
        sOwner = pChatLogDisplaySprite.pStudioOwner
      else
        sOwner = "public"
      end if
      pStudioID = pChatLogDisplaySprite.pStudioID
    end if
    sOwner = "[" & sOwner & "]"
    pSprite.member.text = sOwner
  end if
end
