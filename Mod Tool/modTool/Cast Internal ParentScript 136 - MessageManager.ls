property pDenizenName, pStudioName, pAnswerUserEntrySprite, pMessageUserEntrySprite, pCommentToDbEntrySprite, pHoursBannedEntrySprite, pVerificationSprite, pCallID, bDebug
global oMessageManager, oModControllerManager, sModScreenName

on new me, sDenizenName, sStudioName, iCallID
  pDenizenName = sDenizenName
  pStudioName = sStudioName
  pCallID = iCallID
  me.bDebug = 1
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "oLogInManager: " & sMessage
  end if
end

on submitAnswer me, sVerificationSprite
  me.debug("submitAnswer:sVerificationSprite:" && sVerificationSprite)
  pVerificationSprite = sVerificationSprite
  sMessage = pAnswerUserEntrySprite.member.text
  oModControllerManager.getCFHController().sendRespondToCallForHelp(pCallID, 0, sMessage)
  pVerificationSprite.scriptInstanceList[1].bGoFrame = 1
end

on submitMessage me, sVerificationSprite
  me.debug("submitMessage:sVerificationSprite:" && sVerificationSprite)
  pVerificationSprite = sVerificationSprite
  sMessage = pMessageUserEntrySprite.member.text
  oModControllerManager.getCFHController().sendModMessage(pDenizenName, sMessage)
  pVerificationSprite.scriptInstanceList[1].bGoFrame = 1
end

on submitWarn me, sVerificationSprite
  me.debug("submitWarn:sVerificationSprite:" && sVerificationSprite)
  pVerificationSprite = sVerificationSprite
  sMessage = pMessageUserEntrySprite.member.text
  sComment = pCommentToDbEntrySprite.member.text
  oModControllerManager.getCFHController().sendWarnUser(pDenizenName, sMessage, sComment)
  pVerificationSprite.scriptInstanceList[1].bGoFrame = 1
end

on submitBan me, sVerificationSprite
  me.debug("submitBan:sVerificationSprite:" && sVerificationSprite)
  pVerificationSprite = sVerificationSprite
  sMessage = pMessageUserEntrySprite.member.text
  sComment = pCommentToDbEntrySprite.member.text
  if pHoursBannedEntrySprite.member.text = EMPTY then
    alert("Please enter number of hours banned.")
  else
    iHours = float(pHoursBannedEntrySprite.member.text) * 1.0
  end if
  oModControllerManager.getCFHController().sendBanUser(pDenizenName, iHours, sMessage, sComment)
  pVerificationSprite.scriptInstanceList[1].bGoFrame = 1
end
