property pSprite, pChatLogDisplaySprite
global aChatLogDisplaySprites

on beginSprite me
  pSprite = sprite(me.spriteNum)
  pSprite.member.text = "U"
  pChatLogDisplaySprite = sprite(aChatLogDisplaySprites[aChatLogDisplaySprites.count])
end

on mouseUp me
  if pChatLogDisplaySprite.scriptInstanceList[2].pActive then
    if pChatLogDisplaySprite.scriptInstanceList[2].pScrollLock = 1 then
      pChatLogDisplaySprite.scriptInstanceList[2].pScrollLock = 0
      pSprite.member.text = "L"
    else
      pChatLogDisplaySprite.scriptInstanceList[2].pScrollLock = 1
      pSprite.member.text = "U"
    end if
  else
    exit
  end if
end
