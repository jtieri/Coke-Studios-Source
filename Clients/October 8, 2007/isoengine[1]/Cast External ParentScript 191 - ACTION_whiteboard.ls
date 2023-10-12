property ancestor, myAttributes
global oDenizenManager, ElementMgr, gFeatureSet

on new me, _oItem, iState, _aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, _aAttributes)
  myAttributes = _aAttributes
  append(the actorList, me)
  return me
end

on stepFrame me
  if (sprite(me.oItem.iSprite).member.type = #flash) and (voidp(me.oItem) = 0) then
    if me.oItem.bDragging then
      sprite(me.oItem.iSprite).setVariable("whiteboard", " ")
    else
      if (sprite(me.oItem.iSprite).getVariable("whiteboard") <> me.oItem.aAttributes[#message]) and (me.oItem.bDragging = 0) then
        sprite(me.oItem.iSprite).setVariable("whiteboard", me.oItem.aAttributes[#message])
      end if
    end if
  end if
end
