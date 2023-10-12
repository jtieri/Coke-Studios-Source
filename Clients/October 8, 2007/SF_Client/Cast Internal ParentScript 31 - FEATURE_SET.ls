property sData, aFeatures, bDebug

on new me, _sData
  me.bDebug = 1
  me.sData = _sData
  me.Init()
  me.initExternal(_sData)
  if me.bDebug then
    put me.toString()
  end if
  return me
end

on Init me
  me.aFeatures = [:]
  me.aFeatures[#MESSENGER] = 1
  me.aFeatures[#CHECK_DECIBELS] = 1
  me.aFeatures[#BACKPACK] = 1
  me.aFeatures[#CATALOG] = 1
  me.aFeatures[#PURCHASING] = 1
  me.aFeatures[#TRADING] = 1
  me.aFeatures[#PERFORMANCE] = 1
  me.aFeatures[#VOTING] = 1
  me.aFeatures[#FURNITURE_MOVE] = 1
  me.aFeatures[#FURNITURE_PICKUP] = 1
  me.aFeatures[#FURNITURE_PUTDOWN] = 1
  me.aFeatures[#FURNITURE_DELETE] = 1
  me.aFeatures[#FURNITURE_ROTATE] = 1
  me.aFeatures[#FURNITURE_USE] = 1
  me.aFeatures[#CALL_FOR_HELP] = 1
  me.aFeatures[#DANCING] = 1
  me.aFeatures[#TELEPORTING] = 1
  me.aFeatures[#MIXER] = 1
  me.aFeatures[#CDPLAYER] = 1
  me.aFeatures[#DRINK_DISPENSER] = 1
  me.aFeatures[#CHARTS] = 1
  me.aFeatures[#ITEM_DISPENSER] = 1
end

on isEnabled me, symbolFeature
  iEnabled = me.aFeatures[symbolFeature]
  if voidp(iEnabled) then
    return 0
  end if
  if iEnabled = 1 then
    return 1
  end if
  if iEnabled = 0 then
    return 0
  end if
end

on initExternal me, sData
  if me.bDebug then
    put "FEATURE_SET.initExternal() sData: " & sData
  end if
  if voidp(sData) then
    return 
  end if
  if sData = EMPTY then
    return 
  end if
  iLineCount = sData.lines.count
  if iLineCount = 0 then
    return 
  end if
  sOldDelimiter = the itemDelimiter
  the itemDelimiter = "="
  repeat with i = 1 to iLineCount
    sLine = sData.line[i]
    if voidp(sLine) then
      next repeat
    end if
    if sLine = EMPTY then
      next repeat
    end if
    sFeature = sLine.item[1]
    if sFeature = EMPTY then
      next repeat
    end if
    sValue = sLine.item[2]
    symbolFeature = symbol(sFeature)
    iEnabled = integer(sValue)
    me.aFeatures[symbolFeature] = iEnabled
  end repeat
end

on toString me
  s = "[FEATURE_SET]" & RETURN
  iCount = me.aFeatures.count()
  repeat with i = 1 to iCount
    symbolFeature = me.aFeatures.getPropAt(i)
    iEnabled = me.aFeatures[i]
    s = s & symbolFeature & "=" & iEnabled & RETURN
  end repeat
  return s
end

on getData me
  return me.sData
end
