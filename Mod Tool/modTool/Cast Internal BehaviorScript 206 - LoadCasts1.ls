property bInit
global bPreloadCasts

on beginSprite me
  me.bInit = 0
end

on init me
  if bPreloadCasts then
    p = script("PreloadCasts").new()
    p.addItem("Gateway", the moviePath & "SF_Gateway")
    p.addItem("Entry", the moviePath & "entry")
    p.start(me, #finished)
  else
    me.finished()
  end if
end

on exitFrame me
  if not me.bInit then
    me.bInit = 1
    me.init()
  end if
  go(the frame)
end

on finished me
  put "load casts 1 finished"
  go(#next)
end
