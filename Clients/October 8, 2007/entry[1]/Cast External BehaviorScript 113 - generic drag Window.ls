property pWindowObject, pDecalList, pRectDecal, pStatus, pCustomData

on new me, windowobject
  pWindowObject = windowobject
  pStatus = #idle
  pCustomData = [:]
  return me
end

on mouseDown me
  global ElementMgr
  if pStatus = #idle then
    if getPos(ElementMgr.pOpenWindows, pWindowObject) < count(ElementMgr.pOpenWindows) then
      pWindowObject.bringtofront()
    end if
    pDecalList = [:]
    repeat with n in pWindowObject.pSpritelist
      addProp(pDecalList, n, the clickLoc - sprite(n).loc)
    end repeat
    oldrect = pWindowObject.prect
    pRectDecal = rect(oldrect[1], oldrect[2], oldrect[3], oldrect[4]) - rect(sprite(me.spriteNum).left, sprite(me.spriteNum).top, sprite(me.spriteNum).left, sprite(me.spriteNum).top)
    pStatus = #drag
  end if
  stopEvent()
end

on mouseUp me
  if pStatus = #drag then
    pWindowObject.prect[1] = sprite(me.spriteNum).left + pRectDecal[1]
    pWindowObject.prect[2] = sprite(me.spriteNum).top + pRectDecal[2]
    pWindowObject.prect[3] = sprite(me.spriteNum).left + pRectDecal[3]
    pWindowObject.prect[4] = sprite(me.spriteNum).top + pRectDecal[4]
  end if
  pStatus = #idle
  stopEvent()
end

on mouseUpOutSide me
  if pStatus = #drag then
    pWindowObject.prect[1] = sprite(me.spriteNum).left + pRectDecal[1]
    pWindowObject.prect[2] = sprite(me.spriteNum).top + pRectDecal[2]
    pWindowObject.prect[3] = sprite(me.spriteNum).left + pRectDecal[3]
    pWindowObject.prect[4] = sprite(me.spriteNum).top + pRectDecal[4]
  end if
  pStatus = #idle
  stopEvent()
end

on exitFrame me
  global oDenizenManager
  if pStatus = #drag then
    pointloc = the mouseLoc
    if ((pointloc - getaProp(pDecalList, me.spriteNum)).locH + sprite(me.spriteNum).width) > (the stage).rect.width then
      pointloc.locH = (the stage).rect.width - sprite(me.spriteNum).width + getaProp(pDecalList, me.spriteNum).locH
    else
      if (pointloc - getaProp(pDecalList, me.spriteNum)).locH < 0 then
        pointloc.locH = getaProp(pDecalList, me.spriteNum).locH
      end if
    end if
    if ((pointloc - getaProp(pDecalList, me.spriteNum)).locV + sprite(me.spriteNum).height) > (the stage).rect.height then
      pointloc.locV = (the stage).rect.height - sprite(me.spriteNum).height + getaProp(pDecalList, me.spriteNum).locV
    else
      if (pointloc - getaProp(pDecalList, me.spriteNum)).locV < 0 then
        pointloc.locV = getaProp(pDecalList, me.spriteNum).locV
      end if
    end if
    repeat with n = 1 to count(pWindowObject.pSpritelist)
      delta = pDecalList[n]
      sprite(pWindowObject.pSpritelist[n]).loc = pointloc - delta
    end repeat
  end if
end
