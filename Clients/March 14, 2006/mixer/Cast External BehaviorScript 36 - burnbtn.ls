property pID

on new me, id
  pID = id
  return me
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  global ElementMgr, TextMgr
  if sprite(me.spriteNum).pStatus = #down then
    bResult = ElementMgr.getMixer().burnMix(me.pID)
    if not bResult then
      sendAllSprites(#setStatus, "BURN", #up)
      stopEvent()
      return 
    end if
    sendAllSprites(#openCD)
    iMixNum = ElementMgr.getMixer().getMixNumber(me.pID)
    sendAllSprites(#setmixtoburn, iMixNum)
  else
    sendAllSprites(#closeCD)
  end if
  dontPassEvent()
end
