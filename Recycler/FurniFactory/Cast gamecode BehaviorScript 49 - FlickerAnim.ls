property iIndex, iState, iTimer, iTimeLength, iTimeLengthMax, iSprite, bDebug

on beginSprite me
  me.iSprite = me.spriteNum
  me.init()
end

on init me
  if voidp(me.iSprite) then
    return 
  end if
  me.iIndex = 1
  me.iState = 1
  me.iTimer = the milliSeconds
  me.iTimeLengthMax = 200
  me.iTimeLength = random(me.iTimeLengthMax)
end

on exitFrame me
  if me.iState = 1 then
    iElapsedTime = the milliSeconds - me.iTimer
    if iElapsedTime >= me.iTimeLength then
      me.nextFrame()
      me.iTimer = the milliSeconds
      me.iTimeLength = random(me.iTimeLengthMax)
    end if
  end if
end

on startAnim me
  me.iTimer = the milliSeconds
  me.iState = 1
end

on stopAnim me
  me.iState = 0
end

on nextFrame me
  sprite(me.iSprite).blend = random(15) + 85
end
