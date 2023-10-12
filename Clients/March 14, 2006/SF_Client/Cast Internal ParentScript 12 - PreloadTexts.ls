property aLoadList, oCallbackObject, mCallbackMethod, iLoadIndex, bLoading, sID, bDebug, oCurrentPreloader

on new me, _sId
  me.bDebug = 0
  me.debug("new PreloadTexts() " & _sId)
  me.sID = _sId
  me.iLoadIndex = 0
  me.bLoading = 0
  me.aLoadList = [:]
  (the actorList).add(me)
  return me
end

on addItem me, _sId, sFile
  me.debug("addItem() " & _sId & ", " & sFile)
  oPreloader = script("PreloadText").new(_sId, sFile, me, #textLoaded)
  me.aLoadList.addProp(_sId, [#file: sFile, #text: EMPTY, #loader: oPreloader])
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
    me.aLoadList[me.iLoadIndex][#loader].preloadText()
  end if
end

on textLoaded me, sFile, bSuccess, _sId, sText
  me.debug("textLoaded() " & sFile & ", " & bSuccess & ", " & _sId)
  if not bSuccess then
    alert("text load failed: " & sFile)
  else
    me.aLoadList[_sId][#text] = sText
    me.nextIndex()
  end if
end

on finish me
  me.debug("finish()")
  call(me.mCallbackMethod, me.oCallbackObject, me.aLoadList)
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

on updateLoader me
  if me.iLoadIndex = 0 then
    return 
  end if
  oPreloader = me.aLoadList[me.iLoadIndex][#loader]
  if voidp(oPreloader) then
    return 
  end if
  iPercentage = oPreloader.getPercentage()
  sDisplayText = me.sID & " " & me.iLoadIndex & " of " & me.aLoadList.count
  getLoader().displayStatus(sDisplayText, iPercentage)
end

on debug me, sMsg
  if me.bDebug then
    put "PreloadTexts." & sMsg
  end if
end
