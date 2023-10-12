property pTarget
global ElementMgr

on new me, target
  pTarget = target
  return me
end

on mouseDown me
  stopEvent()
end

on mouseUp me
  MyNum = ((the mouseV - sprite(me.spriteNum).top) / (sprite(me.spriteNum).height / pTarget.pDisplayLines)) + pTarget.pScrollIndex
  pTarget.friendclicked(MyNum, the doubleClick)
  stopEvent()
end
