property pSprite, sModsLoggedInPrefix, sTimerID
global oStudioByModManager, oDenizenManager

on beginSprite me
  pSprite = sprite(me.spriteNum)
  me.sModsLoggedInPrefix = "Moderators logged in:"
  pSprite.member.text = me.sModsLoggedInPrefix
  me.sTimerID = "UpdateTimer"
  me.getModsLoggedIn()
  timeout(me.sTimerID).new(30000, #getModsLoggedIn, me)
end

on getModsLoggedIn me
  oDenizenManager.getModeratorsOnline()
end

on displayModsLoggedIn me, aMods
  put "displayModsLoggedIn() " & aMods
  iLength = aMods.count()
  if iLength = 0 then
    return 
  end if
  sModsLoggedIn = EMPTY
  repeat with i = 1 to iLength
    sMod = aMods[i]
    sModsLoggedIn = sModsLoggedIn & sMod
    if i <> iLength then
      sModsLoggedIn = sModsLoggedIn & ", "
    end if
  end repeat
  me.pSprite.member.text = me.sModsLoggedInPrefix && sModsLoggedIn
end
