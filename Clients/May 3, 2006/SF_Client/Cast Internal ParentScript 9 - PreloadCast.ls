property sFileToLoad, sCastLib, oCallbackObject, mCallbackMethod, iLoadID, iBytesSoFar, iBytesTotal, iPercentage, bLoading, bDone, bDebug
global oLoader

on new me, _sFileToLoad, _sCastLib, _oCallbackObject, _mCallbackMethod
  me.bDebug = 0
  me.debug("new()")
  me.bLoading = 0
  me.bDone = 0
  me.iBytesSoFar = 0
  me.iBytesTotal = 0
  me.iPercentage = 0
  sExt = ".cst"
  if the runMode <> "Author" then
    sExt = ".cct"
  end if
  me.sFileToLoad = _sFileToLoad & sExt
  me.sCastLib = _sCastLib
  me.oCallbackObject = _oCallbackObject
  me.mCallbackMethod = _mCallbackMethod
  (the actorList).add(me)
  return me
end

on getPercentage me
  return me.iPercentage
end

on go me
  sExistingFileName = castLib(me.sCastLib).fileName
  if sExistingFileName = me.sFileToLoad then
    me.finished(1)
  else
    me.iLoadID = preloadNetThing(me.sFileToLoad)
    me.bLoading = 1
  end if
end

on preloadCast me
  me.debug("preloadCast()")
  script("_TIMER_").new(100 + random(100), #go, me)
end

on fileLoaded me, bSuccess
  me.debug("fileLoaded()")
  if bSuccess then
    castLib(me.sCastLib).fileName = me.sFileToLoad
  end if
  me.bLoading = 0
  me.finished(bSuccess)
end

on finished me, bSuccess
  me.bDone = 1
  call(me.mCallbackMethod, me.oCallbackObject, me, bSuccess)
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
      alert("iError: " & iError)
    end if
    me.fileLoaded(iError = "OK")
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
    put "PreloadCast: " & sMessage
  end if
end
