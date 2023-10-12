property ancestor, iLength, iStartTime
global oPossessionStudio

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  me.iLength = 10000
  me.iStartTime = the milliSeconds
  me.displayState()
  return me
end

on mouseDownEvent me
  me.ancestor.mouseDownEvent()
  if the doubleClick then
    me.toggleState()
  end if
end

on stepFrame me
  if me.oItem.getState() = 0 then
    return 
  end if
  iElapsedTime = the milliSeconds - me.iStartTime
  if iElapsedTime >= me.iLength then
    me.setOff()
  end if
end

on displayState me
  me.oItem.setFrame(0)
  if me.oItem.getState() = 0 then
    me.oItem.setAnimate(0)
  else
    me.oItem.setAnimate(1)
  end if
end

on toggleState me
  if me.oItem.getState() = 0 then
    me.setOn()
  else
    me.setOff()
  end if
  if not voidp(oPossessionStudio) then
    oPossessionStudio.sendUpdatePossession(me.getItem())
  end if
end

on setOff me
  me.stopTimer()
end

on setOn me
  me.startTimer()
  me.displayState()
end

on startTimer me
  me.iStartTime = the milliSeconds
  me.oItem.setState(1)
end

on stopTimer me
  me.oItem.setState(0)
end
