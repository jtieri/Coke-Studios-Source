property pSprite, pAction, pTargetMarker, bGoFrame
global oStudioManager, ElementMgr, aChatLogDisplaySprites, oEditStudioManager, oEditAvatarManager, oCallAlertManager, oLogInManager, oMessageManager

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pTargetMarker] = [#comment: "Go Target Marker:", #format: #marker, #default: EMPTY]
  mylist[#pAction] = [#comment: "Action:", #format: #string, #default: "BEEP", #range: ["BEEP", "nothing", "go pTargetMarker", "editStudio(me)", "editUserMission(me)", "answerCall(me)", "messageToUser(me)", "warnToUser(me)", "banToUser(me)", "logIn(me)"]]
  return mylist
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
  bGoFrame = 0
end

on mouseUp me
  do(pAction)
end

on editStudio me
  oEditStudioManager.editStudioDetail(pSprite)
end

on editUserMission me
  oEditAvatarManager.editAvatarDetail(pSprite)
end

on answerCall me
  oMessageManager.submitAnswer(pSprite)
end

on messageToUser me
  oMessageManager.submitMessage(pSprite)
end

on warnToUser me
  oMessageManager.submitWarn(pSprite)
end

on banToUser me
  oMessageManager.submitBan(pSprite)
end

on logIn me
  oLogInManager.submitLogIn(pSprite)
end

on exitFrame me
  if bGoFrame then
    go(pTargetMarker)
  end if
end
