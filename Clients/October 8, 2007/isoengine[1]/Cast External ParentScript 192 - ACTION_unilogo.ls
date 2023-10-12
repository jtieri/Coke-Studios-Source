property ancestor, myAttributes, mylogo
global oDenizenManager, ElementMgr, gFeatureSet

on new me, _oItem, iState, _aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, _aAttributes)
  myAttributes = _aAttributes
  me.setAttributes(_aAttributes)
  append(the actorList, me)
  return me
end

on stepFrame me
  if (sprite(me.oItem.iSprite).member.type = #flash) and (voidp(me.oItem) = 0) then
    mylogo = me.oItem.aAttributes[#logoID] + 1
    if sprite(me.oItem.iSprite).frame <> mylogo then
      sprite(me.oItem.iSprite).goToFrame(mylogo)
      sprite(me.oItem.iSprite).stop()
    end if
  end if
end
