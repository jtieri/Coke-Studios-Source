property spriteNum, getPDLError, myCharacters, myCase, myCaseChange, myAllowRETURN, myBeepMode, myMember, myMemberType, myLowercaseAccents, myUPPERCASEAccents

on getBehaviorDescription me
  return "FILTER INPUT CHARACTERS" & RETURN & RETURN & "Enter the appropriate characters in the Behavior Parameters dialog (Don't forget to take the space character into account)." & RETURN & RETURN & "This behavior can also be used to force the case of input characters. " & "It can handle all standard accents... " & "if the font you are using can display them." & RETURN & RETURN & "The option to 'correct case automatically' can be used to override the Caps Lock." & RETURN & RETURN & "You can choose to convert letters automatically to either upper or lower case, or you can accept a mix of upper and lower case characters and limit input to those particular letters in that particular case (select the 'case as entered' option)." & RETURN & RETURN & "PERMITTED MEMBER TYPES:" & RETURN & "Field and Text members" & RETURN & RETURN & "PARAMETERS:" & RETURN & "* Accepted characters" & RETURN & "* Correct case automatically? (TRUE | FALSE)" & RETURN & "* Allow RETURN and ENTER characters?" & RETURN & "* Beep if input character is invalid? (TRUE | FALSE)"
end

on getBehaviorTooltip me
  return "Use with Field and Text members." & RETURN & RETURN & "Limit the characters that the user can type into a Text or Field member. " & "Invalid characters do not appear (a system beep may be provoked instead). " & "Option: automatically convert accepted characters to the chosen case."
end

on resolve prop
  case prop of
    myAllowRETURN:
      choiceslist = ["yes", "no"]
      lookup = [#Yes, #No]
    otherwise:
      nothing()
  end case
  return lookup[findPos(choiceslist, prop)]
end

on beginSprite me
  myAllowRETURN = resolve(myAllowRETURN)
  Initialize(me)
end

on keyDown me
  Filter(me)
end

on Initialize me
  myMember = sprite(me.spriteNum).member
  case myAllowRETURN of
    #Yes:
      put RETURN & ENTER after myCharacters
  end case
  if the platform contains "Macintosh" then
    myUPPERCASEAccents = ["Á", "À", "Â", "Ä", "Ã", "Å", "Ç", "É", "È", "Ê", "Ë", "Í", "Ì", "Î", "Ï", "Ñ", "Ó", "Ò", "Ô", "Ö", "Õ", "Ú", "Ù", "Û", "Ü", "Æ", "Ø", "Ÿ"]
    myLowercaseAccents = ["á", "à", "â", "ä", "ã", "å", "ç", "é", "è", "ê", "ë", "í", "ì", "î", "ï", "ñ", "ó", "ò", "ô", "ö", "õ", "ú", "ù", "û", "ü", "æ", "ø", "ÿ"]
  else
    if the platform contains "Windows" then
      myUPPERCASEAccents = ["Á", "À", "Â", "Ä", "Ã", "Å", "Ç", "É", "È", "Ê", "Ë", "Í", "Ì", "Î", "Ï", "Ñ", "Ó", "Ò", "Ô", "Ö", "Õ", "Ú", "Ù", "Û", "Ü", "Æ", "Ø", "Ÿ"]
      myLowercaseAccents = ["á", "à", "â", "ä", "ã", "å", "ç", "é", "è", "ê", "ë", "í", "ì", "î", "ï", "ñ", "ó", "ò", "ô", "ö", "õ", "ú", "ù", "û", "ü", "æ", "ø", "ÿ"]
    end if
  end if
  myCharacters = GetCharacterList(me, myCharacters)
  myMember.editable = 1
end

on Filter me
  if [48, 51, 117, 115, 116, 119, 121, 123, 124, 125, 126].getPos(the keyCode) then
    pass()
  end if
  theKey = the key
  if myCharacters.getPos(theKey) then
    pass()
  else
    if myCaseChange then
      theKey = ChangeCase(me, theKey)
      if myCharacters.getPos(theKey) then
        Insert(me, theKey)
        exit
      end if
    end if
    if myBeepMode then
      beep()
    end if
    stopEvent()
  end if
end

on Insert me, theKey
  startChar = the selStart
  if startChar = the selEnd then
    if myMemberType = #field then
      put theKey after char startChar of field myMember
    else
      theText = myMember.text
      put theKey after char startChar of theText
      myMember.text = theText
    end if
  else
    myMember.char[startChar + 1..the selEnd] = theKey
  end if
  set the selEnd to startChar + 1
  set the selStart to startChar + 1
  stopEvent()
end

on GetCharacterList me, theString
  characterList = []
  charCount = theString.char.count
  repeat with i = 1 to charCount
    theChar = theString.char[1]
    delete theString.char[1]
    if characterList.getPos(theChar) then
      next repeat
    end if
    case myCase of
      "UPPERCASE and lowercase":
        otherCase = ChangeCase(me, theChar)
        if (otherCase < theChar) or (otherCase > theChar) then
          if not characterList.getPos(otherCase) then
            characterList.append(otherCase)
          end if
        end if
      "UPPERCASE ONLY":
        theChar = ChangeCase(me, theChar, #upper)
      "lowercase only":
        theChar = ChangeCase(me, theChar, #lower)
    end case
    characterList.append(theChar)
  end repeat
  return characterList
end

on ChangeCase me, theChar, lowerOrUPPER
  asciiCode = charToNum(theChar)
  case lowerOrUPPER of
    #lower, #upper:
    otherwise:
      if asciiCode > 90 then
        lowerOrUPPER = #upper
      else
        lowerOrUPPER = #lower
      end if
  end case
  case lowerOrUPPER of
    #upper:
      accent = myLowercaseAccents.getPos(theChar)
      if accent then
        theChar = myUPPERCASEAccents[accent]
      else
        if (asciiCode > 96) and (asciiCode < 123) then
          theChar = numToChar(asciiCode - 32)
        end if
      end if
    #lower:
      accent = myUPPERCASEAccents.getPos(theChar)
      if accent then
        theChar = myLowercaseAccents[accent]
      else
        if (asciiCode > 64) and (asciiCode < 91) then
          theChar = numToChar(asciiCode + 32)
        end if
      end if
  end case
  return theChar
end

on isOKToAttach me, aSpriteType, aSpriteNum
  case aSpriteType of
    #graphic:
      return getPos([#field, #text], sprite(aSpriteNum).member.type) <> 0
    #script:
      return 0
  end case
end

on getPropertyDescriptionList me
  if not (the currentSpriteNum) then
    exit
  end if
  return [#myCharacters: [#comment: "Accepted characters", #format: #string, #default: "abcdefghijklmnopqrstuvwxyz 0123456789"], #myCase: [#comment: EMPTY, #format: #string, #range: ["UPPERCASE and lowercase", "UPPERCASE ONLY", "lowercase only", "case as entered above"], #default: "UPPERCASE and lowercase"], #myCaseChange: [#comment: "Correct case automatically?", #format: #boolean, #default: 1], #myAllowRETURN: [#comment: "Allow RETURN and ENTER characters?", #format: #string, #range: ["yes", "no"], #default: "yes"], #myBeepMode: [#comment: "Beep if input character is invalid?", #format: #boolean, #default: 1]]
end
