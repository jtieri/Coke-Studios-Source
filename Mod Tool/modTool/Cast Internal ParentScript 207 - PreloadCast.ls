property sFileToLoad, sCastLib, oCallbackObject, mCallbackMethod, iPercentage, iLoadID, bLoading, bDebug

on new me
  me.bDebug = 0
  me.debug("new()")
  me.bLoading = 0
  (the actorList).add(me)
  return me
end

on preloadCast me, _sFileToLoad, _sCastLib, _oCallbackObject, _mCallbackMethod
  me.debug("preloadCast(" & _sFileToLoad & "," & _sCastLib & "," & _oCallbackObject & "," & _mCallbackMethod & ")")
  sExt = ".cst"
  if the runMode <> "Author" then
    sExt = ".cct"
  end if
  me.sFileToLoad = _sFileToLoad & sExt
  me.sCastLib = _sCastLib
  me.oCallbackObject = _oCallbackObject
  me.mCallbackMethod = _mCallbackMethod
  sExistingFileName = castLib(me.sCastLib).fileName
  if sExistingFileName = me.sFileToLoad then
    me.finished(1)
  else
    me.iLoadID = preloadNetThing(me.sFileToLoad)
    me.bLoading = 1
  end if
end

on fileLoaded me, bSuccess
  me.debug("fileLoaded()")
  if bSuccess then
    castLib(me.sCastLib).fileName = me.sFileToLoad
  end if
  me.finished(bSuccess)
end

on finished me, bSuccess
  call(me.mCallbackMethod, me.oCallbackObject, me.sCastLib, me.sFileToLoad, bSuccess)
  me.removeFromActorList()
end

on stepFrame me
  if not me.bLoading then
    return 
  end if
  aStatus = getStreamStatus(me.iLoadID)
  if netDone(me.iLoadID) then
    me.bLoading = 0
    iError = netError(me.iLoadID)
    if iError <> "OK" then
    end if
    me.fileLoaded(iError = "OK")
  end if
  iBytesSoFar = aStatus[#bytesSoFar]
  iBytesTotal = aStatus[#bytesTotal]
  if iBytesTotal > 0 then
    me.iPercentage = integer(iBytesSoFar / iBytesTotal * 100)
    member("LoadingStatus").text = "Loading " & me.sCastLib && me.iPercentage & "%"
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
