property pSprite, pAction, pTargetMarker, sKeysAllowed, sFilterType, iCharLimit, aKeyCodeList, sPassword
global oUserDisplayManager, oPrivateDisplayManager, oEditStudioManager, oDenizenManager

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#sFilterType] = [#comment: "Filter type:", #format: #string, #default: "search", #range: ["search", "name", "description", "password", "message", "hours"]]
  mylist[#iCharLimit] = [#comment: "Char limit(14,30,etc.):", #format: #integer, #default: 14]
  mylist[#pTargetMarker] = [#comment: "Marker to go to:", #format: #marker, #default: EMPTY]
  mylist[#pAction] = [#comment: "Action:", #format: #string, #default: "BEEP", #range: ["BEEP", "go pTargetMarker", "searchPrivateStudio(me)", "searchUser(me)", "editUserMissionMessage(me)", "editStudioMessage(me)", "logInMessage(me)", "nothing"]]
  return mylist
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
  case me.sFilterType of
    "search":
      me.sKeysAllowed = member("filterKeys_search").text
      pSprite.member.text = EMPTY
    "name":
      me.sKeysAllowed = member("filterKeys_name").text
    "description":
      me.sKeysAllowed = member("filterKeys_desc").text
    "password":
      me.sKeysAllowed = member("filterKeys_pass").text
      pSprite.member.text = EMPTY
      me.sPassword = EMPTY
    "message":
      me.sKeysAllowed = member("filterKeys_message").text
    "hours":
      me.sKeysAllowed = member("filterKeys_hours").text
  end case
  me.aKeyCodeList = [48, 51, 117, 115, 116, 119, 121, 123, 124, 125, 126]
end

on getPassword me
  return me.sPassword
end

on keyDown me
  if (me.sKeysAllowed contains the key) or me.aKeyCodeList.getPos(the keyCode) then
    if (pSprite.member.text.char.count = me.iCharLimit) and (me.aKeyCodeList.getPos(the keyCode) = 0) then
      stopEvent()
    else
      if me.sFilterType = "password" then
        if me.sKeysAllowed contains the key then
          sBulletText = EMPTY
          k = the key
          put k after sPassword
          repeat with i = 1 to sPassword.char.count
            put "*" after sBulletText
          end repeat
          pSprite.member.text = sBulletText
        else
          if the keyCode = 51 then
            sBulletText = EMPTY
            if me.sPassword.char.count > 1 then
              me.sPassword = me.sPassword.char[1..me.sPassword.char.count - 1]
            else
              me.sPassword = EMPTY
            end if
            repeat with i = 1 to sPassword.char.count
              put "*" after sBulletText
            end repeat
            pSprite.member.text = sBulletText
          else
            if the keyCode = 117 then
              me.sPassword = EMPTY
              pSprite.member.text = EMPTY
            else
              stopEvent()
            end if
          end if
        end if
      else
        pass()
      end if
    end if
  else
    if the key = RETURN then
      if me.sFilterType = "message" then
        pass()
      else
        do(pAction)
      end if
    else
      stopEvent()
    end if
  end if
end

on searchPrivateStudio me
  oPrivateDisplayManager.pSearchText = pSprite.member.text
  oPrivateDisplayManager.pSearchEntered = 1
end

on searchUser me
  sDenizenName = pSprite.member.text
  sStudioName = "studioName"
  sStudioOwner = "studioOwner"
  oDenizenManager.getDenizenByScreenName(sDenizenName)
  oUserDisplayManager.displayExtendedUserInfo(sDenizenName, sStudioName, sStudioOwner, 0)
end

on editUserMissionMessage me
  sendAllSprites(#editUserMission)
end

on editStudioMessage me
  sendAllSprites(#editStudio)
end

on logInMessage me
  sendAllSprites(#logIn)
end
