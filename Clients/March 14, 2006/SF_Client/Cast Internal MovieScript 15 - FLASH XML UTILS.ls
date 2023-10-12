on getNode oXml, sNodeName
  aChildren = oXml.childNodes
  repeat with i = 0 to aChildren.length - 1
    oNode = aChildren[i]
    if oNode.nodeName = sNodeName then
      return oNode
    end if
  end repeat
end

on getNodes oXml, sNodeName
  aNodes = []
  aChildren = oXml.childNodes
  repeat with i = 0 to aChildren.length - 1
    oNode = aChildren[i]
    if oNode.nodeName = sNodeName then
      aNodes.add(oNode)
    end if
  end repeat
  return aNodes
end

on stripChars sString, aStripChars
  sNewString = EMPTY
  iLength = sString.chars.count
  repeat with i = 1 to iLength
    sTestChar = sString.char[i]
    iTestCharNum = charToNum(sTestChar)
    bAddChar = 1
    repeat with iCharNum in aStripChars
      if iTestCharNum = iCharNum then
        bAddChar = 0
        exit repeat
      end if
    end repeat
    if bAddChar then
      sNewString = sNewString & sTestChar
    end if
  end repeat
  sNewString = stripEdgeQuotes(sNewString)
  return sNewString
end

on stripEdgeQuotes sString
  if sString.char[1] = QUOTE then
    delete sString.char[1]
  end if
  iLength = sString.chars.count
  if sString.char[iLength] = QUOTE then
    delete sString.char[iLength]
  end if
  return sString
end

on stripChar sString, iCharNum
  sNewString = EMPTY
  repeat with i = 1 to sString.chars.count
    sTestChar = sString.char[i]
    iTestCharNum = charToNum(sTestChar)
    if iTestCharNum = iCharNum then
      next repeat
      next repeat
    end if
    sNewString = sNewString & sTestChar
  end repeat
  return sNewString
end
