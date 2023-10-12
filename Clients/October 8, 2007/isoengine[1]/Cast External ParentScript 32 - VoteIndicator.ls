property iStartTime, iTimeLength, iSpriteToFollow, bActive, iVOffset, iSprite, bState
global oIsoScene

on new me, _bState, _iSpriteToFollow
  me.bState = _bState
  me.iSpriteToFollow = _iSpriteToFollow
  me.iStartTime = the milliSeconds
  me.iTimeLength = 10000
  me.bActive = 1
  me.iVOffset = 0
  me.createSprite()
  (the actorList).add(me)
  oIsoScene.oVoteItems.addItem(me)
  return me
end

on stepFrame me
  if not me.bActive then
    return 
  end if
  iElapsedTime = the milliSeconds - me.iStartTime
  if iElapsedTime >= me.iTimeLength then
    me.bActive = 0
    oIsoScene.oVoteItems.removeItem(me)
    return 
  end if
  me.display()
end

on display me
  oLoc = me.getDisplayPoint()
  sprite(me.iSprite).locH = oLoc.locH
  sprite(me.iSprite).locV = oLoc.locV
  sprite(me.iSprite).locZ = sprite(me.iSpriteToFollow).locZ
end

on createSprite me
  sMember = "cc.thumbicon.up"
  if not me.bState then
    sMember = "cc.thumbicon.down"
  end if
  oLoc = me.getDisplayPoint()
  aProps = [#member: sMember, #x: oLoc.locH, #y: oLoc.locV, #ink: 8]
  me.iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
end

on getDisplayPoint me
  iRight = sprite(me.iSpriteToFollow).right
  iLeft = sprite(me.iSpriteToFollow).left
  iTop = sprite(me.iSpriteToFollow).top
  iLocH = iLeft + ((iRight - iLeft) / 2)
  iLocV = iTop + me.iVOffset
  oLoc = point(iLocH, iLocV)
  return oLoc
end

on destroy me
  oIsoScene.oSpriteManager.returnPooledSprites([me.iSprite])
  (the actorList).deleteOne(me)
  me = VOID
end
