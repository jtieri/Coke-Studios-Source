global ElementMgr

on new me
  return me
end

on mouseUp me
  myURL = ElementMgr.oJukebox.getOpenWindow().pScrollingLists.cataloglist.pSelectedSong.downloadURL
  gotoNetPage(myURL, "_new")
end
