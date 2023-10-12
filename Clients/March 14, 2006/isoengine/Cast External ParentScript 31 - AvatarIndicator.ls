property oAvatar, sSmallMember, sLargeMember, iSpriteToFollow, bActive, iVOffset, iSprite
global oIsoScene, oStudioMap

on new me, _oAvatar
  me.oAvatar = _oAvatar
  me.iSpriteToFollow = me.oAvatar.getSprite()
  me.bActive = 1
  me.iVOffset = -6
  me.sLargeMember = "puppet_hilite_h"
  me.sSmallMember = "puppet_hilite_sh"
  me.createSprite()
  (the actorList).add(me)
  return me
end

on stepFrame me
  if not me.bActive then
    return 
  end if
  me.display()
end

on display me
  oLoc = me.getDisplayPoint()
  bVisible = 1
  oMapNode = oIsoScene.oMap.getNode(me.oAvatar.oSquare.iRow, me.oAvatar.oSquare.iCol)
  if not voidp(oMapNode) then
    iWeight = oMapNode.w
    if iWeight = oIsoScene.oMap.oPathfinder.W_ENTER then
      bVisible = 0
    end if
  end if
  sprite(me.iSprite).locH = oLoc.locH
  sprite(me.iSprite).locV = oLoc.locV
  sprite(me.iSprite).locZ = sprite(me.iSpriteToFollow).locZ
  sprite(iSprite).visible = bVisible
end

on createSprite me
  if oStudioMap.isPrivate() then
    sMember = me.sLargeMember
  else
    sMember = me.sSmallMember
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

on destroyItem me
  oIsoScene.oSpriteManager.returnPooledSprites([me.iSprite])
  (the actorList).deleteOne(me)
  me = VOID
end
