property bInit, bDebug
global bPreloadCasts, oStudioManager, oStudioMap, oStudio, oRoom

on beginSprite me
  bDebug = 1
  me.debug("** LOAD CASTS 3 **")
  me.bInit = 0
end

on init me
  me.debug("init()")
  sStudioAsset = oStudioMap.getAsset()
  me.debug("sStudioAsset: " & sStudioAsset)
  if bPreloadCasts then
    me.debug("oStudioMap.getStudioName(): " & oStudioMap.getStudioName())
    p = script("PreloadCasts").new("Loading" && oStudioMap.getStudioName())
    p.addItem("Studio", sStudioAsset)
    p.addItem("ChatEngine", the moviePath & "chatengine")
    p.addItem("Room", the moviePath & "cc_room")
    p.addItem("Furniture", the moviePath & "cc_furniture[1]")
    p.addItem("FurnitureSmall", the moviePath & "cc_furniture_small")
    p.addItem("Catalogue", the moviePath & "cc_catalogue[1]")
    p.addItem("Items", the moviePath & "cc_items[1]")
    p.addItem("IsoEngine", the moviePath & "isoengine")
    p.addItem("Sequencer", the moviePath & "sequencer")
    p.addItem("Mixer", the moviePath & "mixer")
    p.addItem("SoundLibrary", the moviePath & "soundlibrary")
    p.start(me, #finished)
  else
    put "load casts 3 done"
    me.finished()
  end if
end

on exitFrame me
  if not me.bInit then
    me.bInit = 1
    me.init()
  end if
  go(the frame)
end

on finished me
  go(#next)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "LoadCast3: " & sMessage
  end if
end
