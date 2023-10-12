property pChatLogDisplaySprite
global aChatLogDisplaySprites, oStudioManager, oEditStudioManager

on beginSprite me
  pChatLogDisplaySprite = sprite(aChatLogDisplaySprites[aChatLogDisplaySprites.count])
end

on mouseUp me
  if pChatLogDisplaySprite.scriptInstanceList[2].pActive then
    if pChatLogDisplaySprite.scriptInstanceList[2].pStudioID.char[1] <> "$" then
      sStudioID = pChatLogDisplaySprite.scriptInstanceList[2].pStudioID
      oStudioManager.getPrivateStudioDetail(sStudioID)
      oEditStudioManager = new(script("EditStudioManager"), pChatLogDisplaySprite, sStudioID)
      go("changeStudio")
    else
      alert("This is a PUBLIC studio. PUBLIC studios cannot be edited.")
    end if
  end if
end
