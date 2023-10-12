property ancestor, iRollRandomFrame, iMaxRoll
global oPossessionStudio, oIsoScene

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  iRollRandomFrame = 1
  iMaxRoll = 3
  me.displayState()
  return me
end

on mouseDownEvent me
  me.ancestor.mouseDownEvent()
  if the doubleClick then
    me.triggerRoll()
  end if
end

on displayState me
  case me.oItem.getState() of
    0:
      me.oItem.setAnimate(0)
    1:
      me.oItem.setAnimate(1)
  end case
  me.oItem.setFrame(0)
  me.oItem.setFrame(iRollRandomFrame)
end

on triggerRoll me
  posId = integer(me.getItem().getPosId())
  if not voidp(oPossessionStudio) then
    oPossessionStudio.sendRollRequest(me.iMaxRoll, posId)
  end if
end

on receiveRollResult me, _iRndInteger
  put "ACTION_ANIMATED_DICE receiveRollResult: " & _iRndInteger
  me.iRollRandomFrame = _iRndInteger + 1
  toggleState(me)
  timeout("turnoff").new(10000, #turnOff, me)
end

on turnOff me
  timeout("turnoff").forget()
  me.getItem().setFrame(0)
  me.getItem().setState(0)
end

on toggleState me
  oTmpItem = me.getItem().duplicate()
  if the debugPlaybackEnabled then
    put "Furniture item object duplication"
  end if
  if objectp(oTmpItem) then
    if the debugPlaybackEnabled then
      put "oTmpItem is an object"
    end if
    case me.getItem().getState() of
      0:
        if the debugPlaybackEnabled then
          put "Changing state from 0 to 1"
        end if
        oTmpItem.iState = 1
      1:
        if the debugPlaybackEnabled then
          put "Changing state from 1 to 0"
        end if
        oTmpItem.iState = 0
    end case
    if not voidp(oPossessionStudio) then
      if the debugPlaybackEnabled then
        put "Calling oPossessionStudio.sendUpdatePossession(oTmpItem)"
      end if
      oPossessionStudio.sendUpdatePossession(oTmpItem)
    else
      if the debugPlaybackEnabled then
        put "oPossessionStudio is void"
      end if
    end if
  else
    if the debugPlaybackEnabled then
      put "Error"
    end if
  end if
end
