property bActive
global ElementMgr, oDenizenManager, gFeatureSet

on new me
  me.bActive = 0
  sInvitee = member("nav_v-ego_search_name1").text
  bIsFriend = ElementMgr.getMessengerObject().isFriend(sInvitee)
  bHaveInvited = ElementMgr.getMessengerObject().haveInvited(sInvitee)
  if bIsFriend or bHaveInvited then
    bActive = 0
  end if
  return me
end

on exitFrame me
end

on mouseDown me
  stopEvent()
end

on mouseUp me
  if gFeatureSet.isEnabled(#MESSENGER) then
    sInvitee = member("nav_v-ego_search_name1").text
    sInviter = oDenizenManager.getScreenName()
    if sInvitee = sInviter then
      if not voidp(ElementMgr) then
        ElementMgr.alert("MESSENGER_CANT_INVITE_SELF")
      end if
      return 
    end if
    bIsFriend = ElementMgr.getMessengerObject().isFriend(sInvitee)
    if bIsFriend then
      if not voidp(ElementMgr) then
        ElementMgr.alert("MESSENGER_ALREADY_FRIEND")
      end if
      return 
    end if
    bHaveInvited = ElementMgr.getMessengerObject().haveInvited(sInvitee)
    if bHaveInvited then
      if not voidp(ElementMgr) then
        ElementMgr.alert("MESSENGER_ALREADY_INVITED")
      end if
      return 
    end if
    if not voidp(ElementMgr) then
      ElementMgr.getMessengerObject().addMyInvite(sInvitee)
      ElementMgr.alert("MESSENGER_REQUEST_SENT")
    end if
    oDenizenManager.inviteFriend(sInviter, sInvitee)
    me.bActive = 0
  else
    ElementMgr.alert("FEATURE_DISABLED")
  end if
end
