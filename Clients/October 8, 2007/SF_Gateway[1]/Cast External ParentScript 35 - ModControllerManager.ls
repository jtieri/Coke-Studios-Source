property aControllers, iNumControllers, bDebug, oCFHController

on new me
  me.bDebug = 1
  me.iNumControllers = 5
  me.setControllers()
  return me
end

on getCFHController me
  if voidp(me.oCFHController) then
    me.oCFHController = script("ModCFHController").new()
  end if
  return me.oCFHController
end

on setControllers me
  me.aControllers = []
  repeat with i = 1 to me.iNumControllers
    oController = script("ModStudioController").new(i)
    me.aControllers.add(oController)
  end repeat
end

on getControllerBySlot me, iSlot
  return me.aControllers[iSlot]
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "ModSessionManager: " & sMessage, bForce
  end if
end
