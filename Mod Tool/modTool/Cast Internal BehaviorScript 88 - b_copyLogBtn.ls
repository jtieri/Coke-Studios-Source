property pChatLogDisplaySprite
global aChatLogDisplaySprites

on beginSprite me
  pChatLogDisplaySprite = sprite(aChatLogDisplaySprites[aChatLogDisplaySprites.count])
end

on mouseUp me
  member("copyToClipBoard").text = pChatLogDisplaySprite.member.text
  member("copyToClipBoard").copyToClipboard()
end
