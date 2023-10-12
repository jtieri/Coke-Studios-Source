property pSprite, pDataType
global oUserDisplayManager, oEditAvatarManager

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pDataType] = [#comment: "Data Type:", #format: #string, #default: "avatarMission", #range: ["avatarMission", "avatarName"]]
  return mylist
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
  if pDataType = "avatarMission" then
    pSprite.member.text = oUserDisplayManager.pUserData.mission
    oEditAvatarManager.pAvatarMissionEditSprite = pSprite
  else
    pSprite.member.text = oUserDisplayManager.pUserData.denizenName
  end if
end
