property aLoadList, oCallbackObject, mCallbackMethod, bLoading, sID

on new me, _sId
  me.sID = _sId
  me.bLoading = 0
  me.aLoadList = []
  (the actorList).add(me)
  return me
end

on addItem me, sCast, sFile
  oPreloader = script("PreloadCast").new(sFile, sCast, me, #castLoaded)
  me.aLoadList.add(oPreloader)
end

on setLoadList me, aList
  me.aLoadList = aList
end

on start me, _oCallbackObject, _mCallbackMethod
  me.oCallbackObject = _oCallbackObject
  me.mCallbackMethod = _mCallbackMethod
  me.openLoader()
  repeat with oPreloader in me.aLoadList
    oPreloader.preloadCast()
  end repeat
  me.bLoading = 1
end

on stepFrame me
  if not me.bLoading then
    return 
  end if
  iTotal = me.aLoadList.count
  iTotalDone = 0
  iTotalBytesSoFar = 0
  iTotalBytesTotal = 0
  repeat with i = 1 to iTotal
    oPreloader = me.aLoadList[i]
    if oPreloader.bDone then
      iTotalDone = iTotalDone + 1
    end if
    iTotalBytesSoFar = float(iTotalBytesSoFar + oPreloader.iBytesSoFar)
    iTotalBytesTotal = float(iTotalBytesTotal + oPreloader.iBytesTotal)
  end repeat
  if iTotalBytesTotal = 0 then
    iPercentage = 100
  else
    iPercentage = integer(iTotalBytesSoFar / iTotalBytesTotal * 100.0)
  end if
  me.updateLoader(iPercentage)
  if iTotalDone = iTotal then
    me.finish()
  end if
end

on castLoaded me, oPreloader, bSuccess
  if not bSuccess then
    alert("Cast load failed: " & oPreloader.sCastLib)
  end if
end

on finish me
  me.bLoading = 0
  call(me.mCallbackMethod, me.oCallbackObject)
  (the actorList).deleteOne(me)
end

on openLoader me
  getLoader().openWindow()
  me.updateLoader()
end

on closeLoader me
  getLoader().closeWindow()
end

on updateLoader me, iPercentage
  getLoader().displayStatus(me.sID, iPercentage)
end
