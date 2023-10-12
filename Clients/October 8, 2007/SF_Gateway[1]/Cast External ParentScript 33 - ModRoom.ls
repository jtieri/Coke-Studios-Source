property bDebug, foRoom, bInARoom, oSession, oController

on new me, _oSession, _oController
  me.bDebug = 1
  me.bInARoom = 0
  me.oSession = _oSession
  me.oController = _oController
  return me
end

on setRoomObject me, _foRoom
  me.debug("setRoomObject() " & _foRoom)
  me.foRoom = _foRoom
  me.setCallbacks()
end

on setCallbacks me
  sprite(me.oSession.getFlashSprite()).setCallback(me.foRoom, "roomEntered", #roomEntered, me)
  sprite(me.oSession.getFlashSprite()).setCallback(me.foRoom, "roomEnterFailed", #roomEnterFailed, me)
  sprite(me.oSession.getFlashSprite()).setCallback(me.foRoom, "roomExited", #roomExited, me)
  sprite(me.oSession.getFlashSprite()).setCallback(me.foRoom, "exception", #exception, me)
  sprite(me.oSession.getFlashSprite()).setCallback(me.foRoom, "participantEntered", #participantEntered, me)
  sprite(me.oSession.getFlashSprite()).setCallback(me.foRoom, "participantExited", #participantExited, me)
  sprite(me.oSession.getFlashSprite()).setCallback(me.foRoom, "participantEjected", #participantEjected, me)
  sprite(me.oSession.getFlashSprite()).setCallback(me.foRoom, "receiveCallForHelp", #receiveCallForHelp, me)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "ModRoom: " & sMessage
  end if
end

on setInARoom me, bState
  me.bInARoom = bState
end

on getInARoom me
  return me.bInARoom
end

on getRoomID me
  if not voidp(me.foRoom) then
    return me.foRoom.getRoomID()
  end if
end

on sendEnterRoom me
  me.debug("sendEnterRoom()")
  if me.oSession.bTestMode then
    return 
  end if
  sGroupId = me.foRoom.MODERATORS_GROUP
  me.foRoom.sendEnterRoom(sGroupId)
  return 1
end

on sendExitRoom me
  me.debug("sendExitRoom() ")
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendExitRoom()
end

on sendPickUpCallForHelp me, iID, bIsAlert
  me.debug("sendPickUpCallForHelp() " & iID && bIsAlert, 1)
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendPickUpCallForHelp(iID, bIsAlert)
end

on sendRespondToCallForHelp me, iID, bIsAlert, sResponse
  me.debug("sendPickUpCallForHelp() " & iID && bIsAlert && sResponse, 1)
  if oSession.bTestMode then
    return 
  end if
  if voidp(sResponse) or (sResponse = EMPTY) then
    alert("Must supply a response")
    return 
  end if
  me.foRoom.sendRespondToCallForHelp(iID, bIsAlert, sResponse)
end

on sendModMessage me, sScreenName, sMessage
  me.debug("sendModMessage() " & sScreenName && sMessage, 1)
  if oSession.bTestMode then
    return 
  end if
  if voidp(sScreenName) then
    if voidp(sMessage) then
      alert("Must supply a screen name")
    end if
    return 
  end if
  if voidp(sMessage) or (sMessage = EMPTY) then
    alert("Must supply a message")
    return 
  end if
  me.foRoom.sendModMessage(sScreenName, sMessage)
end

on sendBanUser me, sScreenName, iInterval, sMessage, sComment
  me.debug("sendBanUser() " & sScreenName && iInterval && sMessage && sComment)
  if oSession.bTestMode then
    return 
  end if
  if voidp(sScreenName) then
    if voidp(sMessage) then
      alert("Must supply a screen name")
    end if
    return 
  end if
  if voidp(sMessage) or (sMessage = EMPTY) then
    alert("Must supply a message")
    return 
  end if
  if voidp(sComment) then
    sComment = EMPTY
  end if
  me.foRoom.sendBanUser(sScreenName, iInterval, sMessage, sComment)
end

on sendWarnUser me, sScreenName, sMessage, sComment
  me.debug("sendWarnUser() " & sScreenName && sMessage && sComment)
  if voidp(sScreenName) then
    if voidp(sMessage) then
      alert("Must supply a screen name")
    end if
    return 
  end if
  if voidp(sMessage) or (sMessage = EMPTY) then
    alert("Must supply a message")
    return 
  end if
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendWarnUser(sScreenName, sMessage, sComment)
end

on receiveCallForHelp me, oCaller, iCallID, bIsAlert, sScreenName, sStudioName, sStudioOwner, sMessage, bIsPickedUp, sPickedUpBy
  global oCallAlertDisplayManager
  put "receiveCallForHelp()"
  me.debug("receiveCallForHelp()")
  me.debug("iCallID: " & iCallID)
  me.debug("bIsAlert: " & bIsAlert)
  me.debug("sScreenName: " & sScreenName)
  me.debug("sStudioName: " & sStudioName)
  me.debug("sStudioOwner: " & sStudioOwner)
  me.debug("sMessage: " & sMessage)
  me.debug("bIsPickedUp: " & bIsPickedUp)
  me.debug("sPickedUpBy: " & sPickedUpBy)
  aCallForHelp = [:]
  aCallForHelp[#callID] = iCallID
  aCallForHelp[#isAlert] = bIsAlert
  aCallForHelp[#screenName] = sScreenName
  aCallForHelp[#studioName] = sStudioName
  aCallForHelp[#studioOwner] = sStudioOwner
  aCallForHelp[#message] = sMessage
  aCallForHelp[#isPickedUp] = bIsPickedUp
  aCallForHelp[#pickedUpBy] = sPickedUpBy
  oCallAlertDisplayManager.receiveStudioCallAlert(aCallForHelp)
end

on roomEntered me, oCaller, sRoomId
  me.debug("roomEntered() " && sRoomId)
  me.setInARoom(1)
  me.oController.roomEntered(sRoomId)
end

on roomEnterFailed me, oCaller, sRoomId, iReasonId, sReason
  me.debug("roomEnterFailed() " && sRoomId && string(iReasonId) && sReason)
  iReasonId = integer(iReasonId)
  sMessage = EMPTY
  case iReasonId of
    9000:
      sMessage = "Room does not exist"
  end case
  me.setInARoom(0)
  me.oController.roomEnterFailed(sRoomId, iReasonId, sMessage)
end

on roomExited me, oCaller, sRoomId
  me.debug("roomExited() " && sRoomId)
  me.setInARoom(0)
  me.oSession.removeRoom(sRoomId)
  me.oController.roomExited(sRoomId)
end

on exception me, oCaller, iReasonId, sReason, sMsgId
  me.debug("exception() " & sReason)
  me.oController.exception(iReasonId)
end

on participantEntered me, oCaller, sName
  me.debug("participantEntered() " & sName)
end

on participantExited me, oCaller, sName
  me.debug("participantExited() " & sName)
end

on participantEjected me, oCaller, sName
  me.debug("participantEjected() " & sName)
end
