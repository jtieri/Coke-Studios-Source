property sFileToLoad, oCallbackObject, mCallbackMethod, iPercentage, iLoadID, sID, bLoading, bDebug

on new me
  me.bDebug = 0
  me.debug("new()")
  me.bLoading = 0
  (the actorList).add(me)
  return me
end

on preloadText me, _sId, _sFileToLoad, _oCallbackObject, _mCallbackMethod
  me.debug("getText(" & _sFileToLoad & "," & _oCallbackObject & "," & _mCallbackMethod & ")")
  me.sFileToLoad = _sFileToLoad
  me.oCallbackObject = _oCallbackObject
  me.mCallbackMethod = _mCallbackMethod
  me.sID = _sId
  me.iLoadID = getNetText(me.sFileToLoad)
  me.bLoading = 1
end

on fileLoaded me, bSuccess, sText
  me.debug("fileLoaded()")
  if bSuccess then
    nothing()
  end if
  call(me.mCallbackMethod, me.oCallbackObject, me.sFileToLoad, bSuccess, me.sID, sText)
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
    sText = netTextresult(me.iLoadID)
    me.fileLoaded(iError = "OK", sText)
  end if
  iBytesSoFar = aStatus[#bytesSoFar]
  iBytesTotal = aStatus[#bytesTotal]
  if iBytesTotal > 0 then
    me.iPercentage = integer(iBytesSoFar / iBytesTotal * 100)
    member("LoadingStatus").text = "Loading " & me.sID && me.iPercentage & "%"
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
