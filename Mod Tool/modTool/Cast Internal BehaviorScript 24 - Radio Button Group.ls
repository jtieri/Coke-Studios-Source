property spriteNum, myDefault, ourID, ourGroupList, mySprite, myButtonMember, myname

on getBehaviorDescription me
  return "RADIO BUTTON GROUP" & RETURN & RETURN & "Select a group of radio button sprites and drop this behavior onto one of them. " & "You will be asked to give a unique ID to the group so that its members can recognise each other." & RETURN & RETURN & "When the movie is running, switching one button in the group ON will switch all the others OFF. " & "By default, the button in the lowest sprite channel will be ON. " & "You can however set which button is on by default by opening the Behavior Parameters dialog for that button and setting 'Default status of button: on'. " & "If more than one button is selected as default, then the 'default' button in the highest channel will be chosen. " & "All other buttons in the same group will be switched off." & RETURN & RETURN & "If you wish the behavior to preserve the radio button selection then choose 'Default status of button: auto' for ALL the buttons in the group. " & "This will prompt the behavior to convert the hilited button to a checkBox on endSprite. " & "When the user returns to the section containing the radioButton group, the behavior will set the checkBox back to a radioButton, and use that button as the default hilite. " & "If you save the cast containing the buttons at the end of the session, the default values will even be preserved when the user quits your application." & RETURN & RETURN & "The behavior returns the currently selected button in response to a call with the following syntax:" & RETURN & RETURN & "  sendAllSprites (#RadioGroup_SelectedButton, 'UniqueID')" & RETURN & RETURN & "See the 'Notes for Developers' in the script itself for more details." & RETURN & RETURN & "PERMITTED MEMBER TYPE:" & RETURN & "Button members" & RETURN & RETURN & "PARAMETERS:" & RETURN & RETURN & "* Radio group ID" & RETURN & RETURN & "Give the same unique ID to all members of a group. " & " The easiest way to do this is to select all the Radio Buttons in the Score or on the Stage, then drop this behavior onto one of them. " & " The Behavior Parameters dialog will open only once and all sprites will receive the same initial parameters." & RETURN & RETURN & "* Button acts as default for the group (TRUE | FALSE)" & RETURN & RETURN & "Using a unique ID allows you to have more than one Radio Button group on the Stage at any one time, each acting independently of the others" & RETURN & RETURN & "PUBLIC METHODS:" & RETURN & "=> Obtain the name, number and sprite number of the selected button in the group" & RETURN & RETURN & "ASSOCIATED BEHAVIOR:" & RETURN & "+ Multistate Toggle Button" & RETURN & "Gives you similar features using graphic members."
end

on getBehaviorTooltip me
  return "Drop this behavior on a group of Radio Buttons to ensure that only one button in the group can be on at a time." & RETURN & RETURN & "You can create several independent Radio Button groups on the Stage. " & "To do so, give each group a unique ID." & RETURN & RETURN & "Place the default selected button in the lowest channel, or select a specific button in the group to act as default."
end

on beginSprite me
  Initialize(me)
end

on mouseUp me
  Toggle(me)
end

on endSprite me
  SaveSetting(me)
  ourGroupList.deleteOne(me)
end

on Initialize me
  mySprite = sprite(me.spriteNum)
  myButtonMember = mySprite.member
  memberType = myButtonMember.type
  case memberType of
    #button:
    otherwise:
      ErrorAlert(me, #invalidMember, memberType)
  end case
  if myButtonMember.buttonType <> #radioButton then
    myButtonMember.buttonType = #radioButton
    myButtonMember.hilite = 1
  else
    myButtonMember.hilite = 0
  end if
  myname = myButtonMember.text
  if myname = EMPTY then
    myname = myButtonMember.name
    if myname = EMPTY then
      myname = myButtonMember.member
    end if
  end if
  ourGroupList = []
  sendAllSprites(#RadioGroup_RollCall, ourID, ourGroupList)
  if ourGroupList.count() = 1 then
    myButtonMember.hilite = 1
  else
    case myDefault of
      "On":
        call(#RadioGroup_Toggle, ourGroupList, 0)
        myButtonMember.hilite = 1
      "Automatic":
        if myButtonMember.hilite then
          call(#RadioGroup_Toggle, ourGroupList, 0)
          myButtonMember.hilite = 1
        end if
    end case
  end if
end

on Toggle me
  if myButtonMember.hilite then
    call(#RadioGroup_Toggle, ourGroupList, 0, me)
  else
    myButtonMember.hilite = 1
  end if
end

on SaveSetting me
  if myDefault = "Automatic" then
    if myButtonMember.hilite then
      myButtonMember.buttonType = #checkBox
    end if
  end if
end

on RadioGroup_RollCall me, groupID, groupList
  if groupID = ourID then
    ourGroupList = groupList
    ourGroupList.append(me)
  end if
end

on RadioGroup_Toggle me, whichState, callingBehavior
  if callingBehavior = me then
    exit
  end if
  if myButtonMember.hilite = whichState then
    exit
  end if
  myButtonMember.hilite = whichState
end

on RadioGroup_SelectedButton me, propListOrString
  if not myButtonMember.hilite then
    exit
  end if
  if stringp(propListOrString) then
    if propListOrString <> ourID then
      exit
    end if
  end if
  groupNumber = ourGroupList.getPos(me)
  data = [:]
  data.addProp(#name, myname)
  data.addProp(#number, groupNumber)
  data.addProp(#sprite, spriteNum)
  if ilk(propListOrString) <> #propList then
    return data
  else
    propListOrString.addProp(ourID, data)
    return propListOrString
  end if
end

on substituteStrings me, parentString, childStringList
  i = childStringList.count()
  repeat while i
    tempString = EMPTY
    dummyString = childStringList.getPropAt(i)
    replacement = childStringList[i]
    lengthAdjust = dummyString.char.count - 1
    repeat while 1
      position = offset(dummyString, parentString)
      if not position then
        parentString = tempString & parentString
        exit repeat
        next repeat
      end if
      if position <> 1 then
        tempString = tempString & parentString.char[1..position - 1]
      end if
      tempString = tempString & replacement
      delete parentString.char[1..position + lengthAdjust]
    end repeat
    i = i - 1
  end repeat
  return parentString
end

on ErrorAlert me, theError, data
  behaviorName = string(me)
  delete word 1 of behaviorName
  delete char -30001 of behaviorName
  delete char -30001 of behaviorName
  case ilk(data) of
    #symbol:
      data = "#" & data
  end case
  case theError of
    #invalidMember:
      terror1 = "BEHAVIOR ERROR: Frame ^0, Sprite ^1"
      terror1 = substituteStrings(me, terror1, ["^0": the frame, "^1": the currentSpriteNum])
      terror2 = "Behavior ^0 only functions with Button Members."
      terror2 = substituteStrings(me, terror2, ["^0": behaviorName])
      terror3 = "Current member type = ^0"
      terror3 = substituteStrings(me, terror3, ["^0": data])
      alert(terror1 & RETURN & RETURN & terror2 & RETURN & RETURN & terror3)
      halt()
  end case
end

on isOKToAttach me, aSpriteType, aSpriteNum
  tisok = 0
  if aSpriteType = #graphic then
    if sprite(aSpriteNum).member.type = #button then
      tisok = 1
    end if
  end if
  return tisok
end

on getPropertyDescriptionList me
  return [#ourID: [#comment: "ID string for the radio button group", #format: #string, #default: "RadioGroup" & the currentSpriteNum], #myDefault: [#comment: "Default status of button" & RETURN & "(may be overriden: see notes).", #format: #string, #range: ["Off", "On", "Automatic"], #default: "Off"]]
end
