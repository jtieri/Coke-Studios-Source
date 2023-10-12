property pSprite, pDataType
global oMessageManager

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pDataType] = [#comment: "Data Type:", #format: #string, #default: "answerUser", #range: ["answerUser", "messageToUser", "warnToUser", "warnToDb", "banToUser", "banToDb", "hoursBanned"]]
  return mylist
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
  pSprite.member.text = EMPTY
  case pDataType of
    "answerUser":
      oMessageManager.pAnswerUserEntrySprite = pSprite
    "messageToUser":
      oMessageManager.pMessageUserEntrySprite = pSprite
    "warnToUser":
      oMessageManager.pMessageUserEntrySprite = pSprite
    "warnToDb":
      oMessageManager.pCommentToDbEntrySprite = pSprite
    "banToUser":
      oMessageManager.pMessageUserEntrySprite = pSprite
    "banToDb":
      oMessageManager.pCommentToDbEntrySprite = pSprite
    "hoursBanned":
      oMessageManager.pHoursBannedEntrySprite = pSprite
  end case
end
