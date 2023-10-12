property aLoadList, oCallbackObject, mCallbackMethod, bLoading, sID, iLoadIndex, bDebug

on new me, _sId
  me.bDebug = 0
  me.debug("new PreloadCasts() " & _sId)
  me.iLoadIndex = 0
  me.sID = _sId
  me.bLoading = 0
  me.aLoadList = []
  (the actorList).add(me)
  return me
end

on addItem me, sCast, sFile
  me.debug("addItem() " & sCast & ", " & sFile)
  oPreloader = script("PreloadCast").new(sFile, sCast, me, #castLoaded)
  me.aLoadList.add(oPreloader)
end

on start me, _oCallbackObject, _mCallbackMethod
  me.debug("start() " & _oCallbackObject & ", " & _mCallbackMethod)
  me.oCallbackObject = _oCallbackObject
  me.mCallbackMethod = _mCallbackMethod
  me.openLoader()
  me.bLoading = 1
  me.nextIndex()
end

on nextIndex me
  me.debug("nextIndex()")
  iNextIndex = me.iLoadIndex + 1
  if iNextIndex > me.aLoadList.count then
    me.finish()
  else
    me.iLoadIndex = iNextIndex
    me.debug("next load index: " & me.iLoadIndex)
    oPreloader = me.aLoadList[me.iLoadIndex]
    oPreloader.preloadCast()
  end if
end

on castLoaded me, oPreloader, bSuccess
  me.debug("castLoaded() " & oPreloader & ", " & bSuccess)
  if not bSuccess then
    alert("Cast load failed: " & oPreloader.sCastLib)
  else
    me.nextIndex()
  end if
end

on finish me
  me.debug("finish()")
  me.bLoading = 0
  me.updateLoader()
  call(me.mCallbackMethod, me.oCallbackObject)
  (the actorList).deleteOne(me)
end

on stepFrame me
  if not me.bLoading then
    return 
  end if
  me.updateLoader()
end

on openLoader me
  getLoader().openWindow()
  me.updateLoader()
end

on closeLoader me
  getLoader().closeWindow()
end

on updateLoader me
  if me.iLoadIndex = 0 then
    return 
  end if
  oPreloader = me.aLoadList[me.iLoadIndex]
  iPercentage = oPreloader.getPercentage()
  sDisplayText = me.sID & " " & me.iLoadIndex & " of " & me.aLoadList.count
  getLoader().displayStatus(sDisplayText, iPercentage)
end

on debug me, sMsg
  if me.bDebug then
    put "PreloadCasts." & sMsg
  end if
end
