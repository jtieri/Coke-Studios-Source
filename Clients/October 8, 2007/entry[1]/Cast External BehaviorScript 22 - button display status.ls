property pBasename, pClicked, pStatus, pCounter

on new me, MyNum
  the itemDelimiter = "."
  pBasename = sprite(MyNum).member.name.item[1..sprite(MyNum).member.name.items.count - 1]
  the itemDelimiter = ","
  pClicked = 0
  pStatus = #idel
  return me
end

on mouseWithin me
  if sprite(me.spriteNum).blend = 100 then
    if not (the mouseDown) then
      if member(pBasename & ".rollover").memberNum > 0 then
        sprite(me.spriteNum).member = member(pBasename & ".rollover")
      else
        if member(pBasename & ".active").memberNum > 0 then
          sprite(me.spriteNum).member = member(pBasename & ".active")
        end if
      end if
    else
      if pClicked then
        if member(pBasename & ".pressed").memberNum > 0 then
          sprite(me.spriteNum).member = member(pBasename & ".pressed")
        end if
      end if
    end if
  end if
end

on mouseLeave me
  if member(pBasename & ".active").memberNum > 0 then
    sprite(me.spriteNum).member = member(pBasename & ".active")
  end if
end

on mouseDown me
  if sprite(me.spriteNum).blend = 100 then
    pClicked = 1
    if member(pBasename & ".pressed").memberNum > 0 then
      sprite(me.spriteNum).member = member(pBasename & ".pressed")
    end if
  end if
  stopEvent()
end

on mouseUp me
  pClicked = 0
end

on mouseUpOutSide me
  pClicked = 0
end

on exitFrame me
  if pStatus = #blink then
    if (pCounter mod 5) = 0 then
      if sprite(me.spriteNum).member = member(pBasename & ".flash") then
        sprite(me.spriteNum).member = member(pBasename & ".active")
      else
        if sprite(me.spriteNum).member = member(pBasename & ".active") then
          sprite(me.spriteNum).member = member(pBasename & ".flash")
        end if
      end if
    end if
    pCounter = pCounter + 1
  end if
end

on setStatus me, _pStatus
  me.pStatus = _pStatus
  if me.pStatus = #idel then
    sprite(me.spriteNum).member = member(pBasename & ".active")
  end if
end
