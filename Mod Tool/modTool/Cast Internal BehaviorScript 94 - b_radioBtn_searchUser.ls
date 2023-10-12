property pSprite, pAction
global oSearchUser, oUserDisplayManager

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pAction] = [#comment: "Action:", #format: #string, #default: "BEEP", #range: ["BEEP", "nothing", "userDisplay_callAlert(me)", "userDisplay_search(me)"]]
  return mylist
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
end

on mouseUp me
  do(pAction)
end

on userDisplay_callAlert me
  oSearchUser.pSprite.editable = 0
  oUserDisplayManager.pSearch = 0
end

on userDisplay_search me
  oSearchUser.pSprite.editable = 1
  oUserDisplayManager.pSearch = 1
end
