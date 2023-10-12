property iFPS, iFPSTimer, iFPSTimerLength, iCurTool, iDir
global oComputer

on new me
  me.iFPS = 8
  me.iFPSTimer = the milliSeconds
  me.iFPSTimerLength = 1000 / me.iFPS
  me.iCurTool = 10
  me.iDir = -1
  (the actorList).add(me)
  return me
end

on stepFrame me
  if (me.iCurTool = 11) and (me.iDir = 1) then
    me.destroy()
  else
    if me.iFPS > 0 then
      iElapsedTime = the milliSeconds - me.iFPSTimer
      if iElapsedTime >= me.iFPSTimerLength then
        if (me.iDir = -1) and (me.iCurTool = 0) then
          me.iDir = 1
          me.iCurTool = 1
        end if
        if me.iDir = -1 then
          oComputer.pickUpTool(me.iCurTool)
        else
          oComputer.dropOffTool(me.iCurTool)
        end if
        me.iCurTool = me.iCurTool + me.iDir
        me.iFPSTimer = the milliSeconds
        return 1
      end if
    end if
  end if
  return 0
end

on destroy me
  (the actorList).deleteOne(me)
end
