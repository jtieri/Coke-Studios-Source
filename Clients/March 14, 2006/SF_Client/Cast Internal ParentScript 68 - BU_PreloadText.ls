property sFileToLoad, oCallbackObject, mCallbackMethod, iBytesSoFar, iBytesTotal, iPercentage, iLoadID, sID, bLoading, bDone, bDebug

on new me, _sId, _sFileToLoad, _oCallbackObject, _mCallbackMethod
  me.bDebug = 0
  me.debug("new()")
  me.bLoading = 0
  me.iPercentage = 0
  me.sFileToLoad = _sFileToLoad
  me.oCallbackObject = _oCallbackObject
  me.mCallbackMethod = _mCallbackMethod
  me.sID = _sId
  (the actorList).add(me)
  me.bDone = 0
  return me
end

on go me
  if the runMode = "author" then
    me.iLoadID = getNetText(me.sFileToLoad)
  else
    me.iLoadID = getNetText(me.sFileToLoad & "?r=" & random(100))
  end if
  me.bLoading = 1
end

on preloadText me
  me.debug("getText()")
  script("_TIMER_").new(100 + random(100), #go, me)
end

on fileLoaded me, bSuccess, sText
  me.debug("fileLoaded()")
  if not bSuccess then
    alert("Text load failed")
  end if
  me.bDone = 1
  call(me.mCallbackMethod, me.oCallbackObject, me.sFileToLoad, bSuccess, me.sID, sText)
  me.removeFromActorList()
end

on stepFrame me
  if not me.bLoading then
    return 
  end if
  if me.bDone then
    return 
  end if
  aStatus = getStreamStatus(me.iLoadID)
  if netDone(me.iLoadID) then
    me.bLoading = 0
    iError = netError(me.iLoadID)
    if iError <> "OK" then
    end if
    sText = netTextResult(me.iLoadID)
    me.fileLoaded(iError = "OK", sText)
  end if
  me.iBytesSoFar = float(aStatus[#bytesSoFar])
  me.iBytesTotal = float(aStatus[#bytesTotal])
  if iBytesTotal > 0 then
    me.iPercentage = integer(iBytesSoFar / iBytesTotal * 100.0)
  end if
end

on removeFromActorList me
  (the actorList).deleteOne(me)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "GetText: " & sMessage
  end if
end
