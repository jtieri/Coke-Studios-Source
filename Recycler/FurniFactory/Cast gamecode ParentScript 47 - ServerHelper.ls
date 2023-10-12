property oTimeInput, iMsOffset, oTimeMyStart, aTimeInput, aTimeOffset, iCurMonthDays, iPrevMonthDays
global sInputString, sAvatarString, sScreenName, sTimeString, iLatestScore

on new me, sTimeStringFromServer
  me.setTimeOffset(sTimeStringFromServer)
  return me
end

on setTimeOffset me, sInput
  me.oTimeMyStart = newObject("Date")
  me.oTimeInput = me.convertStringToDateObject(sInput)
  me.iMsOffset = me.oTimeInput.getTime() - me.oTimeMyStart.getTime()
end

on convertStringToDateObject me, sInput
  the itemDelimiter = "="
  sInput = sInput.item[2]
  the itemDelimiter = ":"
  oDateOut = newObject("Date")
  oDateOut.setFullYear(integer(sInput.item[1]))
  oDateOut.setMonth(integer(sInput.item[2]) - 1)
  oDateOut.setDate(integer(sInput.item[3]))
  oDateOut.setHours(integer(sInput.item[4]))
  oDateOut.setMinutes(integer(sInput.item[5]))
  oDateOut.setSeconds(0)
  return oDateOut
end

on convertDateObjectToString me, oInput
  sOut = EMPTY
  sOut = "st=" & me.addLeadingZeroes(integer(oInput.getFullYear()), 4) & ":" & me.addLeadingZeroes(integer(oInput.getMonth() + 1), 2) & ":" & me.addLeadingZeroes(integer(oInput.getDate()), 2) & ":" & me.addLeadingZeroes(integer(oInput.getHours()), 2) & ":" & me.addLeadingZeroes(integer(oInput.getMinutes()), 2)
  return sOut
end

on addLeadingZeroes me, iIn, iLength
  sOut = EMPTY & iIn
  n = iLength - sOut.chars.count
  adder = EMPTY
  repeat with i = 1 to n
    adder = adder & "0"
  end repeat
  sOut = adder & sOut
  return sOut
end

on getDateStringForServerCall me
  od = newObject("Date")
  od.setTime(od.getTime() + me.iMsOffset)
  return me.convertDateObjectToString(od)
end

on getScreenNameStringForServerCall me
  return "theScreenName=" & sScreenName
end

on getScoreStringForServerCall me
  return "theScore=" & integer(script("hotdog").pickle.Decrypt(iLatestScore))
end
