property pChatLogDisplaySprite, pStudioNameEditSprite, pStudioDescEditSprite, pStudioID, pVerificationSprite, sStudioName, bDebug
global oStudioManager, ElementMgr, aChatLogDisplaySprites, oEditStudioManager

on new me, sChatLogDisplaySprite, sStudioID
  pChatLogDisplaySprite = sChatLogDisplaySprite
  pStudioID = sStudioID
  me.bDebug = 0
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "oEditStudioManager: " & sMessage
  end if
end

on editStudioDetail me, sVerificationSprite
  me.debug("editStudioDetail:sVerificationSprite:" && sVerificationSprite)
  pVerificationSprite = sVerificationSprite
  sStudioName = pStudioNameEditSprite.member.text
  sDescription = pStudioDescEditSprite.member.text
  oStudioManager.modifyStudio(pStudioID, sStudioName, sDescription)
end

on receiveModifyStudioResult me, iError, sStudioName, sDescription
  me.debug("receiveModifyStudioResult:iError:" && iError && "sStudioName:" && sStudioName && "sDescription:" && sDescription)
  if not iError then
    pVerificationSprite.scriptInstanceList[1].bGoFrame = 1
    pChatLogDisplaySprite.scriptInstanceList[2].pStudioName = me.sStudioName
    sendAllSprites(#displayOwner, pChatLogDisplaySprite, "private")
  else
    alert("Error:" && iError)
  end if
end
