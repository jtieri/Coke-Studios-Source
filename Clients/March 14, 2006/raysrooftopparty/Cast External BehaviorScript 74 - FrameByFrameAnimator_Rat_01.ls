property iSprite, sCastLib, iDiameter, iIndexY, iStartY, iStartX, iSpeed, iStartSpeed, iAcceleration, iState, iTimer, iTimeLength, iWaitTimer, iWaitTimeLength, iWaitRandomTimeMax, iWaitRandomTimeLength, bDebug, sBaseName, iFrameCount, iCurrentFrame, iStepFrame, iStepFrameCount

on new me, _iSprite
  sBaseName = "rat01_frame0"
  iFrameCount = 3
  iCurrentFrame = 1
  iStepFrame = 0
  iStepFrameCount = 10
  me.bDebug = 0
  me.debug("new() leakingbubble animator")
  me.iSprite = _iSprite
  me.Init()
  return me
end

on beginSprite me
  me.debug("beginSprite() leakingbubble animator")
  me.iSprite = me.spriteNum
  me.Init(#authoring)
end

on endSprite me
  put "endsprite called"
end

on Init me, theMode
  if voidp(me.iSprite) then
    return 
  end if
  me.iState = 0
end

on exitFrame me
  iStepFrame = iStepFrame + 1
  if iStepFrame > iStepFrameCount then
    iStepFrame = 0
    nextFrame(me)
  end if
end

on destroy me
  put "*********** DESTROY SPRITE leakingbubble ANIMATRIX **********"
end

on debug me, sMessage, bForce
end

on startPerformance me
  me.iTimer = the milliSeconds
  sprite(me.iSprite).member = member(sBaseName & iCurrentFrame)
  sprite(me.iSprite).width = member(sBaseName & iCurrentFrame).width
  sprite(me.iSprite).height = member(sBaseName & iCurrentFrame).height
end

on stopPerformance me
  me.iCurrentFrame = 1
  sprite(me.iSprite).member = member(sBaseName & iCurrentFrame)
  sprite(me.iSprite).width = member(sBaseName & iCurrentFrame).width
  sprite(me.iSprite).height = member(sBaseName & iCurrentFrame).height
end

on nextFrame me
  sprite(me.iSprite).member = member(sBaseName & iCurrentFrame)
  sprite(me.iSprite).width = member(sBaseName & iCurrentFrame).width
  sprite(me.iSprite).height = member(sBaseName & iCurrentFrame).height
  iCurrentFrame = iCurrentFrame + 1
  if iCurrentFrame > iFrameCount then
    iCurrentFrame = 1
  end if
end
