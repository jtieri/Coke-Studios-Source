property iSprite, sCastLib, iDiameter, iIndexY, iStartY, iStartX, iSpeed, iStartSpeed, iAcceleration, iState, iTimer, iTimeLength, iWaitTimer, iWaitTimeLength, iWaitRandomTimeMax, iWaitRandomTimeLength, bDebug

on new me, _iSprite
  me.bDebug = 0
  me.debug("new() leakingbubble animator")
  me.iSprite = _iSprite
  me.init()
  return me
end

on beginSprite me
  me.debug("beginSprite() leakingbubble animator")
  me.iSprite = me.spriteNum
  me.init(#authoring)
end

on endSprite me
  put "endsprite called"
  sprite(me.iSprite).locH = me.iStartX
  sprite(me.iSprite).locV = me.iStartY
end

on init me, theMode
  if voidp(me.iSprite) then
    return 
  end if
  me.iWaitTimeLength = 6000 + random(10000)
  me.iWaitRandomTimeMax = 3000 + random(10000)
  me.iDiameter = 5 + random(4)
  me.iStartX = sprite(me.iSprite).locH
  me.iStartY = sprite(me.iSprite).locV
  me.iIndexY = sprite(me.iSprite).locV
  sprite(me.iSprite).width = me.iDiameter
  sprite(me.iSprite).height = me.iDiameter
  me.iStartSpeed = 1
  me.iSpeed = me.iStartSpeed
  me.iAcceleration = 0.5
  me.iState = 0
  me.iTimer = the milliSeconds
  me.iTimeLength = 75
  me.iWaitRandomTimeLength = random(me.iWaitRandomTimeMax)
  me.iWaitTimer = the milliSeconds
  if theMode <> #authoring then
    sprite(me.iSprite).locH = -100
  end if
  me.debug("finished init leakingbubble animator")
end

on exitFrame me
  iElapsedWait = the milliSeconds - me.iWaitTimer
  if iElapsedWait >= (me.iWaitTimeLength + me.iWaitRandomTimeLength) then
    me.iState = 1
  end if
  if me.iState = 1 then
    iElapsedTime = the milliSeconds - me.iTimer
    if iElapsedTime >= me.iTimeLength then
      me.nextFrame(-1)
      me.iTimer = the milliSeconds
      if sprite(me.iSprite).locV < -10 then
        me.iState = 0
        me.iWaitTimer = the milliSeconds
        me.iWaitRandomTimeLength = random(me.iWaitRandomTimeMax)
        sprite(me.iSprite).locH = -100
        sprite(me.iSprite).locV = me.iStartY
        me.iSpeed = me.iStartSpeed
      end if
    end if
  end if
end

on destroy me
  put "*********** DESTROY SPRITE leakingbubble ANIMATRIX **********"
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "leakingbubbleAnim: " & sMessage
  end if
end

on startPerformance me
  me.iTimer = the milliSeconds
  me.iState = 1
  sprite(me.iSprite).locH = me.iStartX
  sprite(me.iSprite).locV = me.iStartY
end

on stopPerformance me
  me.iState = 0
  sprite(me.iSprite).locH = -100
  sprite(me.iSprite).locV = me.iStartY
end

on nextFrame me
  me.iSpeed = me.iSpeed + me.iAcceleration
  sprite(me.iSprite).locV = sprite(me.iSprite).locV - me.iSpeed
  sprite(me.iSprite).locH = me.iStartX + (5 * sin(float(me.iStartY - sprite(me.iSprite).locV) / me.iStartY * 270 / 180 * PI))
end
