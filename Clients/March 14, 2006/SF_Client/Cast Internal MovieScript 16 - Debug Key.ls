global oDenizenManager

on mouseDown
  if isValidDebugScreenName(externalParamValue("sw1")) then
    if the controlDown and the doubleClick then
      the debugPlaybackEnabled = 1
    end if
  end if
  pass()
end

on doDebug me, sMessage
  put sMessage
end

on isValidDebugScreenName sName
  aValidDebugScreenNames = getValidDebugScreenNames()
  iIndex = aValidDebugScreenNames.getOne(sName)
  return iIndex > 0
end

on getValidDebugScreenNames
  aNames = []
  aNames.add("QnJlbnRob2xpbw==")
  aNames.add("anBlYWs=")
  aNames.add("bWllY2h1cw==")
  aNames.add("RGV2YXN0YXRpbkRhdmU=")
  aNames.add("S2FybA==")
  aNames.add("TWFpcnU=")
  aNames.add("QW1lcmljYW5FeWVEb2w=")
  aNames.add("aGV5bG9va2dtYWls")
  aNames.add("bWllY2h1czc5")
  return aNames
end
