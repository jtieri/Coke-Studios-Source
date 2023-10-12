property pID

on new me, id
  pID = id
  return me
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  global ElementMgr
  if sprite(me.spriteNum).pStatus = #down then
    bResult = ElementMgr.getMixer().playMix(me.pID)
    if not bResult then
      sendAllSprites(#setStatus, "PLAY", #up)
      stopEvent()
      return 
    end if
  else
    ElementMgr.getMixer().stopMix()
  end if
  dontPassEvent()
end
