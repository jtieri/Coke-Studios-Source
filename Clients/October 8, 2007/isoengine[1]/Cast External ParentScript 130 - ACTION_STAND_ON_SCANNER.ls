property ancestor, iLength, iStartTime, bDebug
global oPossessionStudio, oIsoScene, oStudio

on new me, _oItem, aAttributes
  me.bDebug = 1
  me.debug("new()")
  me.ancestor = script("ACTION_STAND_ON").new(_oItem, aAttributes)
  me.iLength = 3000
  me.iStartTime = the milliSeconds
  me.displayState()
  return me
end

on stepFrame me
  if me.oItem.getState() = 0 then
    return 
  end if
  iElapsedTime = the milliSeconds - me.iStartTime
  if iElapsedTime >= me.iLength then
    me.turnOff()
  else
    if me.oItem.getFrame() = 5 then
      me.oItem.setAnimate(0)
    end if
  end if
end

on displayState me
  me.debug("displayState()")
  me.oItem.setFrame(0)
  if me.oItem.getState() = 0 then
    me.oItem.setAnimate(0)
  else
    me.oItem.setAnimate(1)
  end if
  me.debug("displayState() calling draw()")
  me.oItem.draw()
end

on startAnimation me, _bDisplay
  me.debug("startAnimation()")
  me.startTimer()
end

on stopAnimation me, _bDisplay
  me.stopTimer()
end

on startTimer me
  me.iStartTime = the milliSeconds
  me.oItem.setState(1)
end

on stopTimer me
  me.oItem.setState(0)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "isoengine::ACTION_STAND_ON::" & sMessage
  end if
end
