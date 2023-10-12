global oStudio

on new me
  return me
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  global ElementMgr
  mysong = ElementMgr.getcdplayer().pSelectedSong
  if not voidp(mysong) then
    iPosId = mysong[#posId]
    oStudio.sendCdPlay(iPosId)
    ElementMgr.getcdplayer().closeWindow()
  end if
  dontPassEvent()
end
