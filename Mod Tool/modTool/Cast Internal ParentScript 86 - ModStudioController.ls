property bOpeningLog, oSession, sModScreenName, bDebug, iSlot, sStudioID, sChatLog, sColor_speak, sColor_foul, sColor_mute
global oStudioManager, oCallAlertDisplayManager, TextMgr, oChatDisplayManager, aChatLogDisplaySprites, gbTestMode, oModSessionManager

on new me, _iSlot
  me.bDebug = 1
  me.debug("new()")
  me.bOpeningLog = 0
  me.iSlot = _iSlot
  me.sColor_speak = "000000"
  me.sColor_foul = "FF0000"
  me.sColor_mute = "0000FF"
  return me
end

on exitFrame me
  if not voidp(me.oSession) then
    me.oSession.exitFrame()
  end if
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "ModStudioController: " & me.iSlot & ": " & sMessage
  end if
end

on receiveGameServerNotification me, foGameServer
  if not me.bOpeningLog then
    return 
  end if
  me.bOpeningLog = 0
  me.debug("receiveGameServerNotification() " & me.iSlot && foGameServer.toString())
  sDNS = foGameServer.getDNS()
  iPort = 9000
  me.oSession = oModSessionManager.getSession(sDNS, iPort)
  me.oSession.addController(me)
  if oSession.getConnected() then
    me.oSession.enterRoom(me.sStudioID, me)
  else
    if oSession.getConnecting() then
      alert("Session is currently connecting...")
      return 
    else
      me.oSession.connect(me.sModScreenName)
    end if
  end if
end

on openLog me, _sModScreenName, _sStudioId, aModRoomList
  me.debug("openLog() " & me.iSlot & ", " & _sModScreenName & ", " & _sStudioId)
  iSprite = aChatLogDisplaySprites[iSlot]
  sprite(iSprite).setController(me)
  me.sModScreenName = _sModScreenName
  me.sStudioID = _sStudioId
  me.bOpeningLog = 1
  oStudioManager.getGameServerByStudioID(me.sStudioID)
end

on closeLog me
  me.debug("closeLog() ")
  iSprite = aChatLogDisplaySprites[iSlot]
  sprite(iSprite).setController(VOID)
  me.oSession.exitRoom(me.sStudioID)
end

on loggedIn me
  me.debug("loggedIn()")
  me.oSession.enterRoom(me.sStudioID, me)
end

on loggedOut me
  me.debug("loggedOut()")
end

on connectionFailed me, iReasonId
  me.debug("connectionFailed() " & iReasonId)
end

on loginFailed me, iReasonId, sMessage
  me.debug("loginFailed() " & iReasonId && sMessage)
  alert("loginFailed() " && iReasonId && sMessage)
end

on lostConnection me
  me.debug("lostConnection()")
  alert("lostConnection()")
end

on exception me, iReasonId
  me.debug("exception() " & iReasonId)
end

on notify me, sMessage
  me.debug("notify() " & sMessage)
end

on roomEntered me, sRoomId
  me.debug("roomEntered()")
  oDateObj = newObject("Date")
  me.sChatLog = "<-------------------OPENED" && "(" & oDateObj.toString() & ")" & "------------------->"
  sprite(aChatLogDisplaySprites[me.iSlot]).member.text = me.sChatLog
end

on roomEnterFailed me, sRoomId, iReasonId, sMessage
  me.debug("roomEnterFailed()")
  alert("roomEnterFailed()" && sRoomId && iReasonId && sMessage)
end

on roomExited me, sRoomId
  me.debug("roomExited()")
  me.oSession.removeController(me)
  oDateObj = newObject("Date")
  sCloseString = RETURN & "<-------------------CLOSED" && "(" & oDateObj.toString() & ")" & "------------------->" & RETURN & "inactive log"
  sCurrentChatString = me.sChatLog
  put sCloseString after sCurrentChatString
  me.sChatLog = sCurrentChatString
  sprite(aChatLogDisplaySprites[me.iSlot]).member.text = me.sChatLog
end

on receiveStudioChat me, sAvatarName, sMessage, iSpeechMode
  me.debug("receiveStudioChat()" && sAvatarName && sMessage && iSpeechMode)
  sCurrentChatString = me.sChatLog
  case iSpeechMode of
    0:
      sSpeechModeChar = EMPTY
      oStyle = [#plain]
      oColor = rgb(me.sColor_speak)
    1:
      sSpeechModeChar = EMPTY
      oStyle = [#plain]
      oColor = rgb(me.sColor_speak)
    2:
      sSpeechModeChar = "*"
      oStyle = [#bold]
      oColor = rgb(me.sColor_speak)
    3:
      sSpeechModeChar = "$"
      oStyle = [#italic]
      oColor = rgb(me.sColor_speak)
    4:
      sSpeechModeChar = "%"
      oStyle = [#plain]
      oColor = rgb(me.sColor_foul)
    5:
      sSpeechModeChar = "^"
      oStyle = [#plain]
      oColor = rgb(me.sColor_mute)
  end case
  sNewChatString = sAvatarName & ":" && sSpeechModeChar && sMessage
  put RETURN & sNewChatString after sCurrentChatString
  me.sChatLog = sCurrentChatString
  sprite(aChatLogDisplaySprites[me.iSlot]).member.text = me.sChatLog
  iLineCount = sprite(aChatLogDisplaySprites[me.iSlot]).member.line.count
  sprite(aChatLogDisplaySprites[me.iSlot]).member.line[iLineCount].fontStyle = oStyle
  sprite(aChatLogDisplaySprites[me.iSlot]).member.line[iLineCount].color = oColor
  sprite(aChatLogDisplaySprites[me.iSlot]).scriptInstanceList[2].scrollDisplay()
end

on receiveStudioTestChat me, iLineMax, iChatType
  if sprite(aChatLogDisplaySprites[iSlot]).member.text = "active log" then
    sprite(aChatLogDisplaySprites[iSlot]).member.text = EMPTY
  end if
  iLineCount = sprite(aChatLogDisplaySprites[iSlot]).member.line.count
  case iChatType of
    1:
      repeat with i = 1 to iLineMax
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].fontStyle = [#plain]
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].color = rgb(me.sColor_speak)
        sNewString = RETURN & "aslan: This is regular chat" & i
        put sNewString after the member of sprite(aChatLogDisplaySprites[iSlot])
      end repeat
    2:
      repeat with i = 1 to iLineMax
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].fontStyle = [#bold]
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].color = rgb(me.sColor_speak)
        sNewString = RETURN & "bubba: HEY PPL, WHASSUP?!"
        put sNewString after the member of sprite(aChatLogDisplaySprites[iSlot])
      end repeat
    3:
      repeat with i = 1 to iLineMax
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].fontStyle = [#italic]
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].color = rgb(me.sColor_speak)
        sNewString = RETURN & "freeble: Singing in the rain..."
        put sNewString after the member of sprite(aChatLogDisplaySprites[iSlot])
      end repeat
    4:
      repeat with i = 1 to iLineMax
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].fontStyle = [#plain]
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].color = rgb(me.sColor_foul)
        sNewString = RETURN & "deBaser: Gimme green you shitheads..."
        put sNewString after the member of sprite(aChatLogDisplaySprites[iSlot])
      end repeat
    5:
      repeat with i = 1 to iLineMax
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].fontStyle = [#bold]
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].color = rgb(me.sColor_foul)
        sNewString = RETURN & "bubba: HEY PPL WHO IS DA SHIZNIT MOFO?!!!..."
        put sNewString after the member of sprite(aChatLogDisplaySprites[iSlot])
      end repeat
    6:
      repeat with i = 1 to iLineMax
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].fontStyle = [#italic]
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].color = rgb(me.sColor_foul)
        sNewString = RETURN & "freeble: Fuckin' singing in the goddamn rain..."
        put sNewString after the member of sprite(aChatLogDisplaySprites[iSlot])
      end repeat
    7:
      repeat with i = 1 to iLineMax
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].fontStyle = [#plain]
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].color = rgb(me.sColor_speak)
        sNewString = RETURN & "aslan: This is regular chat" & i
        put sNewString after the member of sprite(aChatLogDisplaySprites[iSlot])
        i = i + 1
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].fontStyle = [#bold]
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].color = rgb(me.sColor_speak)
        sNewString = RETURN & "bubba: BRING DA NOIZE!"
        put sNewString after the member of sprite(aChatLogDisplaySprites[iSlot])
        i = i + 1
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].fontStyle = [#italic]
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].color = rgb(me.sColor_speak)
        sNewString = RETURN & "freeble: Singing in the rain..."
        put sNewString after the member of sprite(aChatLogDisplaySprites[iSlot])
        i = i + 1
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].fontStyle = [#plain]
        sprite(aChatLogDisplaySprites[iSlot]).member.line[i + iLineCount].color = rgb(me.sColor_foul)
        sNewString = RETURN & "deBaser: Gimme green you shitheads..."
        put sNewString after the member of sprite(aChatLogDisplaySprites[iSlot])
      end repeat
  end case
end
