property bDebug, foRoom, bInARoom
global oSession, oRoom, oStudio, ElementMgr, oDenizenManager

on beginSprite me
  me.bDebug = 0
  me.bInARoom = 0
  oRoom = me
end

on setRoomObject me, _foRoom
  me.debug("setRoomObject() " & _foRoom)
  me.foRoom = _foRoom
  me.setCallbacks()
end

on setCallbacks me
  sprite(me.spriteNum).setCallback(me.foRoom, "roomEntered", #roomEntered, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "roomEnterFailed", #roomEnterFailed, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "roomExited", #roomExited, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "exception", #exception, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "participantEntered", #participantEntered, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "participantExited", #participantExited, me)
  sprite(me.spriteNum).setCallback(me.foRoom, "participantEjected", #participantEjected, me)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "Room: " & sMessage
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

on sendEnterRoom me, sRoomId
  me.debug("sendEnterRoom() " && sRoomId)
  if me.getInARoom() then
    return 0
  end if
  _foRoom = oSession.createStudio(sRoomId)
  if voidp(_foRoom) then
    return 0
  end if
  if oSession.bTestMode then
    return 
  end if
  me.foRoom.sendEnterRoom()
  return 1
end

on sendExitRoom me, sRoomId
  me.debug("sendExitRoom() " && sRoomId)
  if oSession.bTestMode then
    return 
  end if
  oSequencer = ElementMgr.getSequencer()
  if not voidp(oSequencer) then
    oSequencer.stop()
  end if
  oStudio.getcdplayer().reset()
  me.stopjukebox()
  me.foRoom.sendExitRoom()
end

on roomEntered me, oCaller, sRoomId
  me.debug("roomEntered() " && sRoomId)
  me.setInARoom(1)
  sendAllSprites(#initRoomEntered, sRoomId)
end

on roomEnterFailed me, oCaller, sRoomId, iReasonId, sReason
  me.debug("roomEnterFailed() " && sRoomId && string(iReasonId) && sReason, 1)
  iReasonId = integer(iReasonId)
  me.setInARoom(0)
  if not voidp(ElementMgr) then
    ElementMgr.roomEnterFailed(sRoomId, iReasonId)
  end if
end

on roomExited me, oCaller, sRoomId
  me.debug("roomExited() " && sRoomId)
  me.setInARoom(0)
  sendAllSprites(#initRoomExited, sRoomId)
end

on exception me, oCaller, iReasonId, sReason, sMsgId
  me.debug("exception() " & sReason)
end

on participantEntered me, oCaller, sName
  me.debug("participantEntered() " & sName)
end

on participantExited me, oCaller, sName
  me.debug("participantExited() " & sName)
end

on participantEjected me, oCaller, sReason
  global gCLOSING, TextMgr
  me.debug("participantEjected() " & sReason, 1)
  me.setInARoom(0)
  me.stopSequencer()
  me.stopjukebox()
  if sReason = "duplicateLogin" then
    gCLOSING = 1
    ElementMgr.alert("ALERT_DUPLICATE_LOGIN")
    oSession.disconnect()
    return 
  end if
  if sReason = "ban" then
    gCLOSING = 1
  end if
  if sReason = "entry" then
    put "EJECTED FROM STUDIO, GOING TO ENTRY "
    gotoEntry()
    return 
  end if
  me.eject()
end

on stopSequencer me
  oSequencer = ElementMgr.getSequencer()
  if not voidp(oSequencer) then
    oSequencer.stop()
  end if
end

on stopjukebox me
  myheadlessplayer = sendAllSprites(#getheadlessplayer)
  if voidp(myheadlessplayer) = 0 then
    sprite(myheadlessplayer).stopSong()
  end if
end

on eject me
  me.debug("eject() ", 1)
  me.setInARoom(0)
  me.stopSequencer()
  me.stopjukebox()
  sendAllSprites(#initRoomExited, me.getRoomID())
end

on getGatewaySprite me
  return sprite(me.spriteNum)
end
