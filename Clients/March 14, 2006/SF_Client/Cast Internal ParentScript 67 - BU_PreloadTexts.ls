property aLoadList, oCallbackObject, mCallbackMethod, iIndex, bLoading, sID

on new me, _sId
  me.sID = _sId
  me.bLoading = 0
  me.aLoadList = [:]
  me.iIndex = 0
  (the actorList).add(me)
  return me
end

on addItem me, _sId, sFile
  oPreloader = script("PreloadText").new(_sId, sFile, me, #textLoaded)
  me.aLoadList.addProp(_sId, [#file: sFile, #text: EMPTY, #loader: oPreloader])
end

on setLoadList me, aList
  me.aLoadList = aList
end

on start me, _oCallbackObject, _mCallbackMethod
  me.oCallbackObject = _oCallbackObject
  me.mCallbackMethod = _mCallbackMethod
  me.openLoader()
  repeat with aItem in me.aLoadList
    aItem[#loader].preloadText()
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
    oPreloader = me.aLoadList[i][#loader]
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

on loadText me, _iIndex
  sID = me.aLoadList.getPropAt(_iIndex)
  sFile = me.aLoadList[_iIndex][#file]
  oPreload = new(script("PreloadText"))
  oPreload.preloadText(sID, sFile, me, #textLoaded)
end

on textLoaded me, sFile, bSuccess, _sId, sText
  if not bSuccess then
    alert("Text Load Failed: " & sFile)
  end if
  me.aLoadList[_sId][#text] = sText
end

on finish me
  call(me.mCallbackMethod, me.oCallbackObject, me.aLoadList)
  (the actorList).deleteOne(me)
end

on openLoader me
  getLoader().openWindow()
  me.updateLoader()
end

on updateLoader me, iPercentage
  getLoader().displayStatus(me.sID, iPercentage)
end
