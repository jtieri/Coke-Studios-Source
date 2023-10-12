property iBGSprite
global oIsoScene

on new me
  return me
end

on init me, oXml
  if voidp(oXml) then
    return 
  end if
  aProps = oIsoScene.oSpriteManager.buildSpriteProps(oXml)
  me.drawBackground(aProps)
end

on drawBackground me, aProps
  iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
  me.iBGSprite = iSprite
end

on destroy me
  oIsoScene.oSpriteManager.returnPooledSprite(me.iBGSprite)
  me.iBGSprite = VOID
end

on toggleDisplay me
  sprite(me.iBGSprite).visible = not sprite(me.iBGSprite).visible
end
