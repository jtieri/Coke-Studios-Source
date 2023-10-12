property iBeat, iLoopCount

on new me, _iBeat, _iLoopCount
  me.iBeat = _iBeat
  me.iLoopCount = _iLoopCount
  return me
end

on getBeat me
  return me.iBeat
end

on getLoopCount me
  return me.iLoopCount
end
