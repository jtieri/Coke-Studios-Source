property bInit
global ElementMgr, bPreloadCasts

on beginSprite me
  me.bInit = 0
end

on Init me
  if bPreloadCasts then
    p = script("PreloadCasts").new("Loading Coke Studios")
    p.addItem("Navigator", the moviePath & "cc_navigator[1]")
    p.addItem("People", the moviePath & "people")
    p.addItem("AvatarEngine", the moviePath & "avatarengine")
    p.addItem("Messenger", the moviePath & "cc_messenger[1]")
    p.start(me, #finished)
  else
    me.finished()
  end if
end

on exitFrame me
  if not me.bInit then
    me.bInit = 1
    me.Init()
  end if
  go(the frame)
end

on finished me
  getLoader().closeWindow()
  gotoEntry()
end
