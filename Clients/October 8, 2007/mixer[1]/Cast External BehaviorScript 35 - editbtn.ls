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
    bResult = ElementMgr.getMixer().editMix(me.pID)
    if not bResult then
      sendAllSprites(#setStatus, "EDIT", #up)
      stopEvent()
      return 
    end if
    sprite(me.spriteNum).pStatus = #up
    sprite(me.spriteNum).member = member("cc.mixer.editbutton.active")
  end if
  dontPassEvent()
end
