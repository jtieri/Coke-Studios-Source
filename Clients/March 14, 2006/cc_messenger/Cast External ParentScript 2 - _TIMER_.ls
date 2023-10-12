property iStartTime, iTimeOut, oTargetObject, hTargetHandler, oArg1, oArg2, oArg3, oArg4, oArg5, bHandled

on new me, _iTimeOut, _hTargetHandler, _oTargetObject, _oArg1, _oArg2, _oArg3, _oArg4, _oArg5
  me.iStartTime = the milliSeconds
  me.iTimeOut = _iTimeOut
  me.oTargetObject = _oTargetObject
  me.hTargetHandler = _hTargetHandler
  me.oArg1 = _oArg1
  me.oArg2 = _oArg2
  me.oArg3 = _oArg3
  me.oArg4 = _oArg4
  me.oArg5 = _oArg5
  me.bHandled = 0
  (the actorList).add(me)
  return me
end

on stepFrame me
  if not me.bHandled then
    if (the milliSeconds - me.iStartTime) >= me.iTimeOut then
      me.bHandled = 1
      me.destroy()
      me.fireTarget()
    end if
  end if
end

on fireTarget me
  call(me.hTargetHandler, me.oTargetObject, me.oArg1, me.oArg2, me.oArg3, me.oArg4, me.oArg5)
end

on destroy me
  (the actorList).deleteOne(me)
end
