property pSelectedSong, bDebug, pLastCatalogList, pLastCatalogImg, pLastPlaylistList, pLastPlaylistImg, pCatalogLevel, isFTMmember
global ElementMgr, oPossessionManager, oDenizenManager, oStudio

on new me
  bDebug = 0
  me.openWindow("cc.infinite_jukebox.catalog.window")
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "_JUKEBOX_: " & sMessage
  end if
end

on openWindow me, sID, oArg
  me.debug("openWindow()" && "sId:" && sID && "oArg:" && oArg)
  myRect = me.closeWindow()
  MyWindow = ElementMgr.newwindow(sID, myRect)
  ElementMgr.oJukebox = me
  me.displayWindow(MyWindow, oArg)
end

on closeWindow me
  me.debug("closeWindow()")
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n) contains "jukebox" then
      MyWindow = ElementMgr.pOpenWindows[n]
      exit repeat
    end if
  end repeat
  if voidp(MyWindow) then
    return 
  end if
  iLastRect = MyWindow.closeWindow()
  ElementMgr.oJukebox = VOID
  me = VOID
  return iLastRect
end

on getOpenWindow me
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n) contains "jukebox" then
      MyWindow = ElementMgr.pOpenWindows[n]
      return MyWindow
      exit repeat
    end if
  end repeat
end

on displayWindow me, MyWindow, oArg
  me.debug("displayWindow()")
end
