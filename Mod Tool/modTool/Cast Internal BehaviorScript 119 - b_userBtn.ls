property pAction, pTargetMarker, pSprite, pAdminMod, bDebug
global oUserDisplayManager, oCallAlertDisplayManager, sModScreenName, oMessageManager, oDenizenManager, oEditAvatarManager, oModControllerManager

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pAdminMod] = [#comment: "Display for AdminMod only?:", #format: #boolean, #default: 0]
  mylist[#pTargetMarker] = [#comment: "Go Target Marker:", #format: #marker, #default: EMPTY]
  mylist[#pAction] = [#comment: "Action:", #format: #string, #default: "BEEP", #range: ["BEEP", "nothing", "go pTargetMarker", "displayUser(me)", "pickUp(me)", "deleteCallAlert(me)", "answer(me)", "changeUserMission(me)", "message(me)", "warn(me)", "ban(me)"]]
  return mylist
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
  if pAdminMod then
    pSprite.visible = 0
  end if
  me.bDebug = 1
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "b_userBtn:" && pAction && ":" && sMessage
  end if
end

on mouseUp me
  do(pAction)
end

on displayUser me
  if oCallAlertDisplayManager.pCallAlertList.count = 0 then
    exit
  end if
  sScreenName = oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].screenName
  sStudioName = oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].studioName
  sStudioOwner = oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].studioOwner
  oUserDisplayManager.displayExtendedUserInfo(sScreenName, sStudioName, sStudioOwner, 1)
end

on pickUp me
  if oCallAlertDisplayManager.pCallAlertList.count = 0 then
    put "exit 1"
    exit
  else
    if oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].isAlert then
      put "exit 2"
      exit
    end if
  end if
  if not oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].isPickedUp then
    iCallID = oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].callID
    repeat with i = 1 to oCallAlertDisplayManager.aCallList.count
      if oCallAlertDisplayManager.aCallList[i].callID = iCallID then
        oCallAlertDisplayManager.aCallList[i].isPickedUp = 1
        oCallAlertDisplayManager.aCallList[i].pickedUpBy = sModScreenName
        exit repeat
      end if
    end repeat
    repeat with i = 1 to oCallAlertDisplayManager.aCallAlertList.count
      if oCallAlertDisplayManager.aCallAlertList[i].callID = iCallID then
        oCallAlertDisplayManager.aCallAlertList[i].isPickedUp = 1
        oCallAlertDisplayManager.aCallAlertList[i].pickedUpBy = sModScreenName
        oCallAlertDisplayManager.displayCallAlert(oCallAlertDisplayManager.pCallAlertList)
        exit repeat
      end if
    end repeat
    me.debug("pickUp:iCallID:" && iCallID)
    oModControllerManager.getCFHController().sendPickUpCallForHelp(iCallID, 0)
  end if
end

on answer me
  if oCallAlertDisplayManager.pCallAlertList.count = 0 then
    put "exit 1"
    exit
  else
    if oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].isAlert then
      put "exit 2"
      exit
    end if
  end if
  pickUp(me)
  iCallID = oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].callID
  sScreenName = oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].screenName
  sStudioName = oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].studioName
  oMessageManager = new(script("MessageManager"), sScreenName, sStudioName, iCallID)
  go(pTargetMarker)
end

on deleteCallAlert me
  if oCallAlertDisplayManager.pCallAlertList.count = 0 then
    exit
  end if
  iCallID = oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].callID
  bIsAlert = oCallAlertDisplayManager.pCallAlertList[oCallAlertDisplayManager.iCallAlertNum].isAlert
  oCallAlertDisplayManager.addDeletedID(iCallID)
  if bIsAlert then
    repeat with i = 1 to oCallAlertDisplayManager.aAlertList.count
      if oCallAlertDisplayManager.aAlertList[i].callID = iCallID then
        oCallAlertDisplayManager.aAlertList.deleteAt(i)
        exit repeat
      end if
    end repeat
  else
    repeat with i = 1 to oCallAlertDisplayManager.aCallList.count
      if oCallAlertDisplayManager.aCallList[i].callID = iCallID then
        oCallAlertDisplayManager.aCallList.deleteAt(i)
        exit repeat
      end if
    end repeat
  end if
  repeat with i = 1 to oCallAlertDisplayManager.aCallAlertList.count
    if oCallAlertDisplayManager.aCallAlertList[i].callID = iCallID then
      oCallAlertDisplayManager.aCallAlertList.deleteAt(i)
      oCallAlertDisplayManager.displayCallAlert(oCallAlertDisplayManager.pCallAlertList)
      exit
    end if
  end repeat
end

on changeUserMission me
  if oUserDisplayManager.pUserData = [] then
    exit
  else
    if oUserDisplayManager.pUserData.denizenName = EMPTY then
      exit
    end if
  end if
  sScreenName = oUserDisplayManager.pUserData.denizenName
  iGender = oUserDisplayManager.pUserData.gender
  sMission = oUserDisplayManager.pUserData.mission
  sAvatarString = oUserDisplayManager.pUserData.avatarString
  me.debug("sScreenName:" && sScreenName && "iGender:" && iGender && "sMission:" && sMission && "sAvatarString:" && sAvatarString)
  oEditAvatarManager = new(script("EditAvatarManager"), sScreenName, iGender, sMission, sAvatarString)
  go(pTargetMarker)
end

on message me
  if oUserDisplayManager.pUserData = [] then
    exit
  else
    if oUserDisplayManager.pUserData.denizenName = EMPTY then
      exit
    end if
  end if
  sScreenName = oUserDisplayManager.pUserData.denizenName
  sStudioName = oUserDisplayManager.pUserData.studioName
  oMessageManager = new(script("MessageManager"), sScreenName, sStudioName)
  go(pTargetMarker)
end

on warn me
  if oUserDisplayManager.pUserData = [] then
    exit
  else
    if oUserDisplayManager.pUserData.denizenName = EMPTY then
      exit
    end if
  end if
  sScreenName = oUserDisplayManager.pUserData.denizenName
  sStudioName = oUserDisplayManager.pUserData.studioName
  oMessageManager = new(script("MessageManager"), sScreenName, sStudioName)
  go(pTargetMarker)
end

on ban me
  if oUserDisplayManager.pUserData = [] then
    exit
  else
    if oUserDisplayManager.pUserData.denizenName = EMPTY then
      exit
    end if
  end if
  sScreenName = oUserDisplayManager.pUserData.denizenName
  sStudioName = oUserDisplayManager.pUserData.studioName
  oMessageManager = new(script("MessageManager"), sScreenName, sStudioName)
  go(pTargetMarker)
end
