property pSprite, pPublicStudioData, pSelected, pItemNum, pScrolltop, pStudioID, pUserData, pDenizenName, pStudioName, pStudioOwner, pSearch, pSearchText, bDebug
global oUserDisplayManager, oDenizenManager, oSearchUser, ElementMgr, oStudioManager, oCallAlertDisplayManager

on beginSprite me
  pSprite = sprite(me.spriteNum)
  pSprite.member.text = "Loading..."
  oUserDisplayManager = me
  aDefaultUserData = [#error: 0, #denizenName: EMPTY, #mission: EMPTY, #studioId: EMPTY, #studioName: "studioName", #owner: "studioOwner", #lastAccess: newObject("Date"), #denizenLevel: [:], #bought: EMPTY, #owned: EMPTY, #onHand: EMPTY, #influencer: EMPTY, #logInTotal: EMPTY, #exists: 1, #online: 1]
  displayUser(me, aDefaultUserData)
  pScrolltop = pSprite.member.scrollTop
  me.bDebug = 0
  pDenizenName = EMPTY
  pStudioName = EMPTY
  pStudioOwner = EMPTY
  pSearch = 0
  pSearchText = EMPTY
  pUserData = []
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "oUserDisplayManager: " & sMessage
  end if
end

on callAlertHilite me, bCallAlertState
  if bCallAlertState then
    pSearch = 0
    member("searchUser").hilite = 0
    member("callAlert").hilite = 1
  else
    pSearch = 1
    member("searchUser").hilite = 1
    member("callAlert").hilite = 0
  end if
end

on displayExtendedUserInfo me, sDenizenName, sStudioName, sStudioOwner, bIsCallAlert
  me.debug("displayExtendedUserInfo:sDenizenName:" && sDenizenName && "sStudioName:" && sStudioName && "sStudioOwner:" && sStudioOwner && "bIsCallAlert:" && bIsCallAlert)
  if bIsCallAlert then
    pSearch = 0
    member("searchUser").hilite = 0
    member("callAlert").hilite = 1
  else
    pSearch = 1
    member("searchUser").hilite = 1
    member("callAlert").hilite = 0
  end if
  pDenizenName = sDenizenName
  oSearchUser.pSprite.member.text = pDenizenName
  pStudioName = sStudioName
  pStudioOwner = sStudioOwner
  oDenizenManager.getDenizenByScreenName(pDenizenName)
end

on receiveGetByStudioId_Result me, sOwnerName
  me.debug("receiveGetByStudioId_Result:sOwnerName:" && sOwnerName)
  if voidp(pUserData) then
    exit
  end if
  pUserData.owner = sOwnerName
  sStudioNameOwnerString = pUserData.studioName && "[" & pUserData.owner & "]"
  sUserString = "Name: " & pUserData.denizenName & RETURN & "Mission: " & pUserData.mission & RETURN & "Studio: " & sStudioNameOwnerString & RETURN & "Last Access: " & getDateString(me, pUserData.lastAccess)
  pSprite.member.text = sUserString
end

on displayUser me, aUserData, oCaller
  me.debug("displayUser:aUserData:" && aUserData && "oCaller:" && oCaller)
  if aUserData.error <> 0 then
    sUserString = "User not found: " & pDenizenName
    pSprite.member.text = sUserString
    exit
  else
    if not aUserData.exists or (aUserData.exists = EMPTY) then
      sUserString = "User not found: " & pDenizenName
      pSprite.member.text = sUserString
      exit
    else
      if not aUserData.online or (aUserData.online = EMPTY) then
        sStudioNameOwnerString = "User not on-line."
      else
        if aUserData.studioId <> EMPTY then
          oCallAlertDisplayManager.receiveStudioID(aUserData.studioId)
          if aUserData.studioId.char[1] = "$" then
            sStudioNameOwnerString = aUserData.studioName && "[public]"
          else
            oStudioManager.getByStudioID(aUserData.studioId)
            sStudioNameOwnerString = aUserData.studioName && "[" & aUserData.owner & "]"
          end if
        end if
      end if
    end if
  end if
  sUserString = "Name: " & aUserData.denizenName & RETURN & "Mission: " & aUserData.mission & RETURN & "Studio: " & sStudioNameOwnerString & RETURN & "Last Access: " & getDateString(me, aUserData.lastAccess)
  pSprite.member.text = sUserString
  pUserData = aUserData
end

on getDateString me, oLastAccess
  sString = oLastAccess.toString()
  return sString
end

on parseList me, aList
  sString = EMPTY
  repeat with i = 1 to aList.count
    if i <> aList.count then
      put aList[i] & "," after sString
      next repeat
    end if
    put aList[i] after sString
  end repeat
  return sString
end

on booleanToYesNoString me, bBoolean
  case bBoolean of
    1:
      return "Y"
    0:
      return "N"
    otherwise:
      return EMPTY
  end case
end
