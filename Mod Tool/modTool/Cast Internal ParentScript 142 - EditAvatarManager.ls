property pAvatarMissionEditSprite, pVerificationSprite, aAvatarData, bDebug
global oEditAvatarManager, oUserDisplayManager, oDenizenManager

on new me, sScreenName, iGender, sMission, sAvatarString
  aAvatarData = [:]
  aAvatarData[#denizenName] = sScreenName
  aAvatarData[#gender] = iGender
  aAvatarData[#mission] = sMission
  aAvatarData[#avatarString] = sAvatarString
  me.bDebug = 0
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "oEditAvatarManager: " & sMessage
  end if
end

on editAvatarDetail me, sVerificationSprite
  me.debug("editAvatarDetail:sVerificationSprite:" && sVerificationSprite)
  pVerificationSprite = sVerificationSprite
  me.aAvatarData.mission = pAvatarMissionEditSprite.member.text
  oDenizenManager.modifyDenizen(me.aAvatarData.denizenName, me.aAvatarData.gender, me.aAvatarData.mission, me.aAvatarData.avatarString)
end

on receiveModifyDenizenResult me, iError, sScreenName, sAvatarMission
  me.debug("receiveModifyDenizenResult:iError:" && iError && "sScreenName:" && sScreenName && "sAvatarMission:" && sAvatarMission)
  if not iError then
    pVerificationSprite.scriptInstanceList[1].bGoFrame = 1
    oUserDisplayManager.pUserData.mission = me.aAvatarData.mission
    oUserDisplayManager.displayUser(oUserDisplayManager.pUserData)
  else
    alert("ERROR:modifyDenizen(): " && iError)
  end if
end
