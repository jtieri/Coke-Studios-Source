property aStudioByModList, bDebug
global sModScreenName

on new me, sModName
  aStudioByModList = [:]
  symbolScreenName = symbol(sModName)
  aStudioByModList[symbolScreenName] = []
  me.bDebug = 0
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "oStudioByModManager: " & sMessage
  end if
end

on checkForOpenStudio me, sStudioID
  me.debug("checkForOpenStudio:sStudioID:" && sStudioID)
  symbolScreenName = symbol(sModScreenName)
  if aStudioByModList[symbolScreenName] = VOID then
    aStudioByModList[symbolScreenName] = []
  end if
  repeat with i = 1 to aStudioByModList[symbolScreenName].count
    if (aStudioByModList[symbolScreenName][i] = sStudioID) or (aStudioByModList[symbolScreenName].count = 4) then
      return 1
    end if
  end repeat
  return 0
end

on addStudio me, sModName, sStudioID
  me.debug("addStudio:sModName:" && sModName && "sStudioID:" && sStudioID)
  symbolScreenName = symbol(sModName)
  if aStudioByModList[symbolScreenName] = VOID then
    aStudioByModList.addProp(symbolScreenName, [])
  end if
  repeat with i = 1 to aStudioByModList[symbolScreenName].count
    if aStudioByModList[symbolScreenName][i] = sStudioID then
      exit
    end if
  end repeat
  aStudioByModList[symbolScreenName].add(sStudioID)
end

on deleteStudio me, sModName, sStudioID
  me.debug("deleteStudio:sModName:" && sModName && "sStudioID:" && sStudioID)
  symbolScreenName = symbol(sModName)
  if aStudioByModList[symbolScreenName] = VOID then
    exit
  end if
  aStudioByModList[symbolScreenName].deleteOne(sStudioID)
end
