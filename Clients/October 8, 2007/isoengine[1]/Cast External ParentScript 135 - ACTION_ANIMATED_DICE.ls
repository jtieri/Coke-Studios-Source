property ancestor, iLength, iStartTime, iRollLength, iRollStartTime, iRollStartFrame, iRollEndFrame, iRollRandomFrame, iMaxRoll
global oIsoScene, oPossessionStudio

on new me, _oItem, aAttributes
  put "new ACTION_ANIMATED_DICE action"
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  me.iLength = 3000
  me.iStartTime = the milliSeconds
  me.oItem.iFrame = 0
  me.displayState()
  me.iRollLength = 2000
  me.iRollStartFrame = 1
  me.iRollEndFrame = 2
  me.iRollRandomFrame = 1
  case me.oItem.sImageBase of
    "rndpodiumrect", "rnddisplayrect":
      me.iMaxRoll = 10
    "rndpodiumoval", "rnddisplayoval":
      me.iMaxRoll = 6
    otherwise:
      me.iMaxRoll = 6
  end case
  return me
end

on mouseDownEvent me
  put "ACTION_ANIMATED_DICE mouseDown() doubleClick: " & the doubleClick
  me.ancestor.mouseDownEvent()
  put "ACTION_ANIMATED_DICE mouseDown() about to test doubleclick"
  if the doubleClick then
    me.triggerRoll()
  end if
  put "ACTION_ANIMATED_DICE mouseDown() end"
end

on triggerRoll me
  posId = integer(me.getItem().getPosId())
  put "ACTION_ANIMATED_DICE triggerRoll: maxroll=" & me.iMaxRoll & ", posID=" & posId
  if not voidp(oPossessionStudio) then
    oPossessionStudio.sendRollRequest(me.iMaxRoll, posId)
  end if
end

on receiveRollResult me, _iRndInteger
  put "ACTION_ANIMATED_DICE receiveRollResult: " & _iRndInteger
  me.iRollRandomFrame = _iRndInteger + 1 + me.iRollEndFrame
  me.startRoll()
end

on startRoll me
  me.startRollTimer()
  me.displayState()
end

on stopRoll me
  me.stopRollTimer()
  me.oItem.setFrame(me.iRollRandomFrame)
end

on startRollTimer me
  me.iRollStartTime = the milliSeconds
  me.oItem.iFrame = 0
  me.oItem.setState(1)
end

on stopRollTimer me
  me.oItem.setState(0)
end

on stepFrame me
  if me.oItem.getState() = 0 then
    me.displayState()
  else
    iElapsedTime = the milliSeconds - me.iRollStartTime
    if iElapsedTime >= me.iRollLength then
      me.stopRoll()
    else
      if me.oItem.getFrame() >= me.iRollEndFrame then
        me.oItem.iFrame = me.iRollStartFrame - 1
        me.displayState()
      end if
    end if
  end if
end

on displayState me
  if me.oItem.getState() = 0 then
    me.oItem.setAnimate(0)
  else
    me.oItem.setAnimate(1)
  end if
end
