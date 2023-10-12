property ancestor, myAttributes, iFlashSprite
global oDenizenManager, ElementMgr, gFeatureSet, oPossessionStudio

on new me, _oItem, iState, _aAttributes
  put "action_popshot received new()"
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, _aAttributes)
  myAttributes = _aAttributes
  me.setAttributes(_aAttributes)
  append(the actorList, me)
  return me
end

on setAttributes me, oAttributes
end

on stepFrame me
  if voidp(iFlashSprite) then
    put "iFlashSprite is void"
    repeat with sP in me.oItem.getSprites()
      if sprite(sP).member.type = #flash then
        iFlashSprite = sP
        put "iFlashSprite =" && iFlashSprite
        exit repeat
      end if
    end repeat
  else
    mylogo = integer(me.oItem.aAttributes[#logoID])
    if sprite(iFlashSprite).frame <> mylogo then
      sprite(iFlashSprite).goToFrame(mylogo)
      sprite(iFlashSprite).stop()
    end if
  end if
end

on mouseDownEvent me
  me.ancestor.mouseDownEvent()
  if the doubleClick then
    me.toggleState()
  end if
end

on displayState me
  put "v-ball displaystate"
  case me.oItem.getState() of
    0:
      me.oItem.setAnimate(0)
    1:
      me.oItem.setAnimate(1)
  end case
  me.oItem.setFrame(0)
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
