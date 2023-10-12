global oStudioManager, oDenizenManager

on exitFrame me
  if voidp(oStudioManager) or voidp(oDenizenManager) then
    go(the frame)
  else
    if oStudioManager.bReadyForuse and oDenizenManager.bReadyForuse then
      go(#next)
    else
      go(the frame)
    end if
  end if
end
