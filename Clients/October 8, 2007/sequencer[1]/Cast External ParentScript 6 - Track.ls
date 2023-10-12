property iVolume, iChannel, oSound, bMute, aSoundEvents, oSequencer
global gSoundLevel

on new me, _oSequencer, _iChannel
  me.oSequencer = _oSequencer
  me.iChannel = _iChannel
  me.reset()
  return me
end

on reset me
  me.iVolume = 255
  me.oSound = me.oSequencer.oSoundLibrary.getSilence(4)
  me.bMute = 0
  me.aSoundEvents = []
end

on getVolume me
  return me.iVolume
end

on setVolume me, _iVolume
  me.iVolume = _iVolume
  me.resetVolume()
end

on resetVolume me
  sound(me.iChannel).volume = me.oSequencer.mapPoints(me.iVolume, 0.0, 255.0, 0.0, gSoundLevel)
end

on getSound me
  return me.oSound
end

on setSound me, _oSound
  me.oSound = _oSound
end

on setSoundByAsset me, sAsset
  me.oSound = me.oSequencer.oSoundLibrary.getSoundByAsset(sAsset)
end

on getMute me
  return me.bMute
end

on setMute me, _bMute
  me.bMute = _bMute
  if me.bMute then
    sound(me.iChannel).volume = 0
  else
    sound(me.iChannel).volume = me.iVolume
  end if
end

on getSoundEvents me
  return me.aSoundEvents
end

on addSoundEvent me, iBeat, iLoopCount
  me.aSoundEvents.add(script("SoundEvent").new(iBeat, iLoopCount))
end

on clearSoundEvents me
  me.aSoundEvents = []
end
