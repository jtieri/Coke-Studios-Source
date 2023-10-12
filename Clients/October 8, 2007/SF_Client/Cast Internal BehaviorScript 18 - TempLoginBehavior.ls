on beginSprite me
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  global oDenizenManager
  myName = member("inputscreenname").text
  if myName <> EMPTY then
    oDenizenManager.setScreenName(myName)
    oDenizenManager.loginDenizen(myName)
  end if
  dontPassEvent()
end
