on replaceChar sString, sCharToReplace, sReplacementChar
  sNewString = EMPTY
  iCharCount = sString.chars.count
  repeat with i = 1 to iCharCount
    sChar = sString.char[i]
    if sChar = sCharToReplace then
      sNewChar = sReplacementChar
    else
      sNewChar = sChar
    end if
    sNewString = sNewString & sNewChar
  end repeat
  return sNewString
end

on putQuotesAroundValues sString
  sNewString = EMPTY
  iCharCount = sString.chars.count
  repeat with i = 1 to iCharCount
    sChar = sString.char[i]
    if sChar = ":" then
      sNewString = sNewString & sChar
      sNextChar = sString.char[i + 1]
      if sNextChar <> QUOTE then
        sNewString = sNewString & QUOTE
        next repeat
      end if
    end if
    if (sChar = ",") or (i = iCharCount) then
      sPrevChar = sString.char[i - 1]
      if sPrevChar <> QUOTE then
        sNewString = sNewString & QUOTE
      end if
    end if
    sNewString = sNewString & sChar
  end repeat
  return sNewString
end
