property aLoadList, oCallbackObject, mCallbackMethod, iIndex

on new me
  me.aLoadList = []
  me.iIndex = 0
  return me
end

on addItem me, sCast, sFile
  me.aLoadList.add([#file: sFile, #cast: sCast])
end

on setLoadList me, aList
  me.aLoadList = aList
end

on start me, _oCallbackObject, _mCallbackMethod
  me.oCallbackObject = _oCallbackObject
  me.mCallbackMethod = _mCallbackMethod
  me.iIndex = 0
  me.next()
end

on next me
  iNewIndex = me.iIndex + 1
  if iNewIndex > me.aLoadList.count then
    me.finish()
  else
    me.iIndex = iNewIndex
    me.loadCast(me.iIndex)
  end if
end

on loadCast me, _iIndex
  aItem = me.aLoadList[_iIndex]
  sFile = aItem.file
  sCast = aItem.cast
  oPreload = new(script("PreloadCast"))
  oPreload.preloadCast(sFile, sCast, me, #castLoaded)
end

on castLoaded me, sCast, sFile, bSuccess
  if not bSuccess then
    alert("castLoad failed: " & sCast)
  end if
  me.next()
end

on finish me
  call(me.mCallbackMethod, me.oCallbackObject)
end
