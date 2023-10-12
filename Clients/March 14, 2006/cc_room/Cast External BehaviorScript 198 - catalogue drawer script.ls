property mybutton, pStatus
global ElementMgr

on opendrawer me
  mybutton = sendAllSprites(#getdrawerbutton)
  pStatus = #open
end

on closedrawer me
  pStatus = #close
end

on exitFrame me
  if pStatus = #open then
    mylocv = ElementMgr.oJukebox.getOpenWindow().prect[2] + 41
    destloch = ElementMgr.oJukebox.getOpenWindow().prect[1] + 244
    increment = (destloch - sprite(me.spriteNum).locH) / 10.0
    if increment < 0.5 then
      sprite(me.spriteNum).locH = destloch
      sprite(mybutton).locH = sprite(mybutton).locH + 200
      pStatus = #idle
    else
      sprite(me.spriteNum).locH = sprite(me.spriteNum).locH + increment
    end if
    sprite(me.spriteNum).locV = mylocv
  else
    if pStatus = #close then
      mylocv = ElementMgr.oJukebox.getOpenWindow().prect[2] + 41
      destloch = ElementMgr.oJukebox.getOpenWindow().prect[1] + 44
      increment = (destloch - sprite(me.spriteNum).locH) / 20.0
      if increment < 0.5 then
        sprite(me.spriteNum).locH = destloch
        pStatus = #idle
      else
        sprite(me.spriteNum).locH = sprite(me.spriteNum).locH + increment
      end if
    end if
  end if
end
