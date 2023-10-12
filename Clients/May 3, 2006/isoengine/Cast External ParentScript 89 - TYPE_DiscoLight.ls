property ancestor, iVShiftMaxMultiplier, iVShiftOffset, aColors, iAnimFrames, iAnimFrame
global oIsoScene

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop
  me.iVShiftMaxMultiplier = 5
  me.iVShiftOffset = 12
  me.iAnimFrames = 10
  me.iAnimFrame = 0
  me.setColors()
  me.ancestor = script("FurnitureItem").new(_sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop)
  me.setInks()
  me.setBlends()
  me.hideLight()
  (the actorList).add(me)
  oIsoScene.oFurniture.addItem(me)
  me.oAction = script("ACTION_" & me.sAction).new(me, me.iState, me.aAttributes)
  return me
end

on setColors me
  me.aColors = [:]
  me.aColors[#red] = rgb(255, 0, 0)
  me.aColors[#blue] = rgb(0, 0, 255)
  me.aColors[#green] = rgb(0, 255, 0)
end

on setState me, _iState
  me.ancestor.setState(_iState)
end

on setAnimate me, _bAnimate
  me.ancestor.setAnimate(_bAnimate)
  if me.bAnimate then
    me.showLight()
  else
    me.hideLight()
  end if
end

on animate me
  if (me.iAnimFrame mod 4) = 0 then
    me.setRandomColor()
    me.setRandomPos()
    me.draw()
  end if
  me.nextFrame()
end

on nextFrame me
  if me.iAnimFrame >= me.iAnimFrames then
    me.iAnimFrame = 0
  else
    me.iAnimFrame = me.iAnimFrame + 1
  end if
end

on setInks me
  me.setDrawOrderAttribute("c", #ink, 0)
  me.setDrawOrderAttribute("d", #ink, 0)
  me.setDrawOrderAttribute("e", #ink, 0)
  me.setDrawOrderAttribute("f", #ink, 0)
end

on setBlends me
  me.setDrawOrderAttribute("c", #blend, 50)
  me.setDrawOrderAttribute("d", #blend, 50)
  me.setDrawOrderAttribute("e", #blend, 50)
  me.setDrawOrderAttribute("f", #blend, 50)
end

on setRandomColor me
  me.setDrawOrderAttribute("c", #bgColor, me.aColors[random(me.aColors.count)])
  me.setDrawOrderAttribute("d", #bgColor, me.aColors[random(me.aColors.count)])
  me.setDrawOrderAttribute("e", #bgColor, me.aColors[random(me.aColors.count)])
  me.setDrawOrderAttribute("f", #bgColor, me.aColors[random(me.aColors.count)])
end

on setRandomPos me
  me.setDrawOrderAttribute("c", #vShift, me.iVShiftOffset * (random(me.iVShiftMaxMultiplier) - 1))
  me.setDrawOrderAttribute("d", #vShift, me.iVShiftOffset * (random(me.iVShiftMaxMultiplier) - 1))
  me.setDrawOrderAttribute("e", #vShift, me.iVShiftOffset * (random(me.iVShiftMaxMultiplier) - 1))
  me.setDrawOrderAttribute("f", #vShift, me.iVShiftOffset * (random(me.iVShiftMaxMultiplier) - 1))
end

on showLight me
  me.setDrawOrderAttribute("c", #visible, 1)
  me.setDrawOrderAttribute("d", #visible, 1)
  me.setDrawOrderAttribute("e", #visible, 1)
  me.setDrawOrderAttribute("f", #visible, 1)
end

on hideLight me
  me.setDrawOrderAttribute("c", #visible, 0)
  me.setDrawOrderAttribute("d", #visible, 0)
  me.setDrawOrderAttribute("e", #visible, 0)
  me.setDrawOrderAttribute("f", #visible, 0)
end
