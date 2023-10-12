property pDefList, pStatus, pWindowObject, pDecalList, pRectDecal, bDebug
global ElementMgr

on new me, rectlist, windowobject
  bDebug = 0
  pDefList = rectlist
  pStatus = #idle
  pWindowObject = windowobject
  me.debug("new()" && "pDefList:" && pDefList && "pStatus:" && pStatus && "pWindowObject:" && pWindowObject)
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "windowBG script: " & sMessage
  end if
end

on mouseDown me
  repeat with n = 1 to count(pDefList)
    if inside(the clickLoc - point(sprite(me.spriteNum).left, sprite(me.spriteNum).top), pDefList[n]) then
      case getPropAt(pDefList, n) of
        "drag":
          if getPos(ElementMgr.pOpenWindows, pWindowObject) < count(ElementMgr.pOpenWindows) then
            pWindowObject.bringtofront()
          end if
          pDecalList = []
          repeat with n in pWindowObject.pSpritelist
            append(pDecalList, the clickLoc - sprite(n).loc)
          end repeat
          oldrect = pWindowObject.prect
          pRectDecal = rect(oldrect[1], oldrect[2], oldrect[3], oldrect[4]) - rect(sprite(me.spriteNum).left, sprite(me.spriteNum).top, sprite(me.spriteNum).left, sprite(me.spriteNum).top)
          pStatus = #drag
          exit repeat
        otherwise:
          stopEvent()
      end case
    end if
  end repeat
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
  if pStatus = #drag then
    pointloc = the mouseLoc
    if ((pointloc - pDecalList[1]).locH + sprite(me.spriteNum).width) > (the stage).rect.width then
      pointloc.locH = (the stage).rect.width - sprite(me.spriteNum).width + pDecalList[1].locH
    else
      if (pointloc - pDecalList[1]).locH < 0 then
        pointloc.locH = pDecalList[1].locH
      end if
    end if
    if ((pointloc - pDecalList[1]).locV + sprite(me.spriteNum).height) > (the stage).rect.height then
      pointloc.locV = (the stage).rect.height - sprite(me.spriteNum).height + pDecalList[1].locV
    else
      if (pointloc - pDecalList[1]).locV < 0 then
        pointloc.locV = pDecalList[1].locV
      end if
    end if
    repeat with n = 1 to count(pWindowObject.pSpritelist)
      delta = pDecalList[n]
      sprite(pWindowObject.pSpritelist[n]).loc = pointloc - delta
    end repeat
  end if
end
