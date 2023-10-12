property bDebug, iTimeDefaultDuration, iTime, bCountdown, iMilliseconds, bPaused
global oComputer, oDisplay, oAvatar

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "oComputer.oTimer:" && sMessage
  end if
end

on new me
  init(me)
  me.debug("new()")
  (the actorList).add(me)
  return me
end

on init me
  me.bDebug = 1
  me.bPaused = 1
  me.iTimeDefaultDuration = 60.0
  me.setTime(60.0)
  me.iMilliseconds = the milliSeconds
  oDisplay.sendDisplay("Computer", me.getTime())
end

on reset me
  me.stopTiming()
  me.init()
end

on startTiming me
  me.iMilliseconds = the milliSeconds
  me.bPaused = 0
end

on stopTiming me
  me.bPaused = 1
end

on getTime me
  return me.iTime
end

on setTime me, iNewTime
  me.iTime = iNewTime
end

on destroy me
  (the actorList).deleteOne(me)
  repeat with i = (the actorList).count down to 1
    if (the actorList)[i] = me then
      (the actorList).deleteAt(i)
    end if
  end repeat
  me = VOID
end

on stepFrame me
  if not me.bPaused then
    me.iTime = me.iTime - ((the milliSeconds - me.iMilliseconds) / 1000.0)
    me.iMilliseconds = the milliSeconds
    if me.getTime() <= 0 then
      me.setTime(0.0)
      oDisplay.sendDisplay("Computer", me.getTime())
      me.stopTiming()
      oComputer.gameTimerZeroed()
    else
      oDisplay.sendDisplay("Computer", me.getTime())
    end if
  end if
end
