property aSprites
global oIsoScene

on new me
  me.aSprites = []
  return me
end

on init me, oXml
  if voidp(oXml) then
    return 
  end if
  aStaticItems = getNodes(oXml, "Item")
  repeat with i = 1 to aStaticItems.count
    oItem = aStaticItems[i]
    aProps = oIsoScene.oSpriteManager.buildSpriteProps(oItem)
    iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
    sAction = aProps[#Action]
    if not voidp(sAction) then
      sprite(iSprite).scriptInstanceList.add(script(sAction).new(iSprite, me))
    end if
    me.aSprites.add(iSprite)
  end repeat
end

on mouseDownEvent me, iSprite, oSprite, iRow, iCol, iLayer
end

on destroy me
  repeat with i in me.aSprites
    sendSprite(i, #destroy)
  end repeat
  oIsoScene.oSpriteManager.returnPooledSprites(me.aSprites)
  me.aSprites = []
end

on toggleDisplay me
  repeat with i in me.aSprites
    sprite(i).visible = not sprite(i).visible
  end repeat
end

on generateXml me
end
