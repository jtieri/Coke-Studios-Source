property pTarget, bDebug

on new me, target
  bDebug = 0
  pTarget = target
  me.debug("new()" && "pTarget:" && pTarget)
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "songsDisplay script: " & sMessage
  end if
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  MyNum = ((the mouseV - sprite(me.spriteNum).top) / (sprite(me.spriteNum).height / pTarget.pDisplayLines)) + pTarget.pScrollIndex
  pTarget.songclicked(MyNum)
  dontPassEvent()
end
