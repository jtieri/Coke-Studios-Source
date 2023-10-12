property pSeconds, pParentWindow
global TextMgr, oStudio

on new me, parentwindow
  pParentWindow = parentwindow
  pSeconds = 30
  member("cdplayer_time").text = pSeconds && TextMgr.GetRefText("CHOOSE_SONG_SECS")
  timeoutobject = timeout("cdplayer").new(1000, #update, me)
  return me
end

on update me
  pSeconds = pSeconds - 1
  member("cdplayer_time").text = pSeconds && TextMgr.GetRefText("CHOOSE_SONG_SECS")
  if pSeconds <= 0 then
    me.cancelCdTimer()
    oStudio.sendCdStop()
    pParentWindow.closeWindow()
  end if
end

on cancelCdTimer me
  timeout("CDplayer").forget()
end
