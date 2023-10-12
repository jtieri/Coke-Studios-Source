property pLogInUserNameEntrySprite, pLogInPassWordEntrySprite, pVerificationSprite, bDebug
global oLogInManager, oDenizenManager, oModControllerManager, sModScreenName, oStudioManager

on new me, sLogInUserNameEntrySprite
  pLogInUserNameEntrySprite = sLogInUserNameEntrySprite
  me.bDebug = 1
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "oLogInManager: " & sMessage
  end if
end

on submitLogIn me, sVerificationSprite
  me.debug("submitLogIn:sVerificationSprite:" && sVerificationSprite)
  sScreenName = member("userNameLogIn").text
  sPassword = sendAllSprites(#getPassword)
  if (sScreenName = EMPTY) or (sPassword = EMPTY) then
    alert("Must supply a screen name and password")
    return 
  end if
  pVerificationSprite = sVerificationSprite
  oDenizenManager.loginModerator(sScreenName, sPassword)
end

on confirmLogIn me, iError, sScreenName
  me.debug("confirmLogIn:iError:" && iError && "sScreenName:" && sScreenName)
  if not iError then
    sModScreenName = sScreenName
    oStudioManager.getGameServerByStudioID("$LOBBY$")
  else
    alert("ScreenName or Password not valid")
    exit
  end if
end
