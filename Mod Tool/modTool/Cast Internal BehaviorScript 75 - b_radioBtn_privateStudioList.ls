property pSprite, pAction
global oSearchStudio, oPrivateDisplayManager

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pAction] = [#comment: "Action:", #format: #string, #default: "BEEP", #range: ["BEEP", "nothing", "searchPrivateStudios(me)", "top35PrivateStudios(me)"]]
  return mylist
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
end

on mouseUp me
  do(pAction)
end

on top35PrivateStudios me
  oSearchStudio.pSprite.editable = 0
  oPrivateDisplayManager.pSearch = 0
end

on searchPrivateStudios me
  oSearchStudio.pSprite.editable = 1
  oPrivateDisplayManager.pSearch = 1
end
