global ElementMgr, oStudioManager, sLanguageSetting, aChatLogDisplaySprites, sModScreenName, oSearchStudio, oPrivateDisplayManager, oSearchUser, oUserDisplayManager, oModControllerManager, sVersion

on startMovie
  clearGlobals()
  the actorList = []
  sLanguageSetting = "English"
  new(script("ElementMgr"))
  aChatLogDisplaySprites = []
  oModControllerManager = script("ModControllerManager").new()
  sVersion = "1.77"
  set the keyDownScript to "trapKeyDown"
  set the exitLock to 1
end

on stopMovie
  clearGlobals()
  the actorList = []
end

on rightMouseDown
  nothing()
end

on trapKeyDown
  case the keyCode of
    53:
      nothing()
  end case
end
