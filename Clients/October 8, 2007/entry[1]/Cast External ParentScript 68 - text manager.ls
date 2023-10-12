property pText, aValidStudioCharacters, aValidChatCharacters, aValidKeyCodes
global sTextManagerText

on new me
  global sLanguageSetting
  pText = removecomments(sTextManagerText)
  me.aValidStudioCharacters = [" ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "~", "!", "#", "&", "(", ")", "-", "_", "[", "{", "]", "}", ":", "'", ",", ".", "?"]
  me.aValidChatCharacters = [" ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "~", "`", "!", "@", "#", "$", "^", "&", "*", "(", ")", "-", "_", "=", "+", "[", "{", "]", "}", "\", ";", ":", "'", QUOTE, ",", "<", ".", ">", "/", "?"]
  me.aValidKeyCodes = [51, 117, 123, 124]
  return me
end

on isValidStudioKey me, sKey
  return me.aValidStudioCharacters.getPos(sKey) > 0
end

on isValidChatKey me, sKey
  return me.aValidChatCharacters.getPos(sKey) > 0
end

on isValidKeyCode me, iKeyCode
  return me.aValidKeyCodes.getPos(iKeyCode) > 0
end

on GetRefText me, strReference
  mytext = EMPTY
  if strReference = EMPTY then
    return EMPTY
  end if
  the itemDelimiter = "="
  repeat with n = 1 to the number of lines in pText
    if pText.line[n].item[1] = strReference then
      mytext = pText.line[n].item[2]
      exit repeat
    end if
  end repeat
  repeat while offset("\", mytext) > 0
    mychar = offset("\", mytext)
    case mytext.char[mychar + 1] of
      "n":
        delete char mychar + 1 of mytext
        put RETURN after char mychar of mytext
        delete char mychar of mytext
    end case
  end repeat
  return mytext
end

on removecomments data
  global sLanguageSetting
  repeat with n = data.line.count down to 1
    if (data.line[n] = EMPTY) or (data.line[n].char[1] = "[") then
      delete line n of data
    end if
  end repeat
  return data
end

on getsafetytips me
  safetytips = []
  the itemDelimiter = "="
  repeat with n = 1 to the number of lines in pText
    if pText.line[n].item[1] = "SAFETY_TIP" then
      mytext = pText.line[n].item[2]
      append(safetytips, mytext)
    end if
  end repeat
  the itemDelimiter = ","
  return safetytips
end

on getDate me, flashdateobject
  dateformat = me.GetRefText("DATE_FORMAT")
  the itemDelimiter = "/"
  dateList = []
  repeat with n = 1 to dateformat.items.count
    append(dateList, dateformat.item[n])
  end repeat
  the itemDelimiter = "-"
  myyear = integer(flashdateobject.getyear() + 1900)
  mymonth = integer(flashdateobject.getmonth() + 1)
  myday = integer(flashdateobject.getDate())
  destlist = []
  destlist[getPos(dateList, "dd")] = myday
  destlist[getPos(dateList, "mm")] = mymonth
  destlist[getPos(dateList, "yyyy")] = myyear
  NewDate = EMPTY
  repeat with n in destlist
    NewDate = NewDate & n & "/"
  end repeat
  NewDate = NewDate.char[1..length(NewDate) - 1]
  return NewDate
end

on getTime me, flashdateobject
  timeformat = me.GetRefText("TIME_FORMAT")
  if timeformat = "12" then
    the itemDelimiter = ":"
    myhour = integer(flashdateobject.getHours())
    myhour = myhour + 4
    myMinutes = integer(flashdateobject.getminutes())
    if myMinutes < 10 then
      myMinutes = "0" & myMinutes
    end if
    if myhour > 12 then
      myhour = myhour - 12
      mytime = myhour & ":" & string(myMinutes) && "PM"
    else
      mytime = myhour & ":" & string(myMinutes) && "AM"
    end if
  end if
  return mytime
end
