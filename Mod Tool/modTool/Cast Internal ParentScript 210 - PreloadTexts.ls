property aLoadList, oCallbackObject, mCallbackMethod, iIndex

on new me
  me.aLoadList = [:]
  me.iIndex = 0
  return me
end

on addItem me, sID, sFile
  me.aLoadList.addProp(sID, [#file: sFile, #text: EMPTY])
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
    me.loadText(me.iIndex)
  end if
end

on loadText me, _iIndex
  sID = me.aLoadList.getPropAt(_iIndex)
  sFile = me.aLoadList[_iIndex][#file]
  oPreload = new(script("PreloadText"))
  oPreload.preloadText(sID, sFile, me, #textLoaded)
end

on textLoaded me, sFile, bSuccess, sID, sText
  if not bSuccess then
    alert("Text Load Failed: " & sFile)
  end if
  me.aLoadList[sID][#text] = sText
  me.next()
end

on finish me
  call(me.mCallbackMethod, me.oCallbackObject, me.aLoadList)
end
