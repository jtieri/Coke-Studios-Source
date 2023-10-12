property pSprite, pDataType
global ElementMgr, oEditStudioManager

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pDataType] = [#comment: "Data Type:", #format: #string, #default: "studioName", #range: ["studioName", "studioDescription"]]
  return mylist
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
  if pDataType = "studioName" then
    pSprite.member.text = ElementMgr.aStudioDetailData.name
    oEditStudioManager.pStudioNameEditSprite = pSprite
  else
    pSprite.member.text = ElementMgr.aStudioDetailData.description
    oEditStudioManager.pStudioDescEditSprite = pSprite
  end if
end
