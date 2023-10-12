property iLimit

on new me
  me.iLimit = 175
  return me
end

on mouseDown
  nothing()
end

on keyDown me
  if (the controlDown and (the keyCode = 9)) or (the commandDown and (the keyCode = 9)) then
    stopEvent()
  else
    iCurrentCount = sprite(me.spriteNum).member.chars.count
    if iCurrentCount >= me.iLimit then
      if (the keyCode = 51) or (the keyCode = 117) then
        pass()
      else
        stopEvent()
      end if
    else
      pass()
    end if
  end if
end
