property bDebug, aSprites, aSpritePool, iSpriteCounter
global oIsoScene

on new me
  me.bDebug = 0
  me.iSpriteCounter = oIsoScene.oIsoConstants.DEFAULT_SPRITE_COUNTER
  me.aSpritePool = []
  me.aSprites = []
  return me
end

on addSprite me, oSprite
  me.debug("addSprite()")
  me.aSprites.add(oSprite)
end

on getSprite me, sID
  me.debug("getSprite()")
  repeat with i = 1 to me.aSprites.count
    oSprite = me.aSprites[i]
    if oSprite.getId() = sID then
      return oSprite
    end if
  end repeat
end

on getSpritesAtSquare me, oSquare
  aSpritesAtSquare = []
  repeat with i = 1 to me.aSprites.count
    oSprite = me.aSprites[i]
    if oSprite.existsAtSquare(oSquare) then
      aSpritesAtSquare.add(oSprite)
    end if
  end repeat
  return aSpritesAtSquare
end

on removeSprite me, _oSprite
  me.debug("removeSprite()")
  repeat with i = 1 to me.aSprites.count
    oSprite = me.aSprites[i]
    if oSprite.getId() = _oSprite.getId() then
      oSprite.destroy()
      me.aSprites.deleteAt(i)
      return 
    end if
  end repeat
end

on toggleBackground me
end

on getPooledSprite me
  iSprite = VOID
  repeat with i = oIsoScene.oIsoConstants.DEFAULT_SPRITE_COUNTER to oIsoScene.oIsoConstants.DEFAULT_SPRITE_COUNTER_MAX
    if me.aSpritePool.getOne(i) = 0 then
      iSprite = i
      me.aSpritePool.add(i)
      puppetSprite(iSprite, 1)
      sprite(iSprite).scriptInstanceList = []
      exit repeat
    end if
  end repeat
  if voidp(iSprite) then
    put "**** OUT OF SPRITES *****"
    alert("I'm all out of sprites. :(")
  end if
  return iSprite
end

on getPooledSprites me, iNum
  _aSprites = []
  repeat with i = 1 to iNum
    _aSprites.add(me.getPooledSprite())
  end repeat
  return _aSprites
end

on returnPooledSprites me, _aSprites
  if voidp(_aSprites) then
    return 
  end if
  repeat with i = 1 to _aSprites.count
    me.returnPooledSprite(_aSprites[i])
  end repeat
end

on returnPooledSprite me, iSprite
  if voidp(iSprite) then
    return 
  end if
  me.aSpritePool.deleteOne(iSprite)
  sprite(iSprite).scriptInstanceList = []
  puppetSprite(iSprite, 0)
  sprite(iSprite).visible = 0
end

on clearSpritePool me
  me.returnPooledSprites(me.aSpritePool)
end

on drawStaticSceneSprite me, aProps
  iSprite = me.getPooledSprite()
  if voidp(aProps[#member]) then
    me.returnPooledSprite(iSprite)
    return 
  else
    oMember = member(aProps.member)
    if oMember.memberNum = -1 then
      me.returnPooledSprite(iSprite)
      return 
    else
      sprite(iSprite).member = aProps.member
    end if
  end if
  if voidp(aProps[#x]) then
    sprite(iSprite).locH = 0
  else
    sprite(iSprite).locH = aProps.x
  end if
  if voidp(aProps[#y]) then
    sprite(iSprite).locV = 0
  else
    sprite(iSprite).locV = aProps.y
  end if
  if voidp(aProps[#ink]) then
    sprite(iSprite).ink = 0
  else
    sprite(iSprite).ink = aProps.ink
  end if
  if voidp(aProps[#blend]) then
    sprite(iSprite).blend = 100
  else
    sprite(iSprite).blend = aProps.blend
  end if
  if voidp(aProps[#width]) then
    sprite(iSprite).width = oMember.width
  else
    sprite(iSprite).width = aProps.width
  end if
  if voidp(aProps[#height]) then
    sprite(iSprite).height = oMember.height
  else
    sprite(iSprite).height = aProps.height
  end if
  if voidp(aProps[#palette]) then
  else
    oPaletteMember = member(aProps.palette)
    if oPaletteMember.memberNum <> -1 then
      oMember.palette = oPaletteMember
    end if
  end if
  if voidp(aProps[#skew]) then
    sprite(iSprite).skew = 0
  else
    sprite(iSprite).skew = aProps.skew
  end if
  if voidp(aProps[#flipH]) then
    sprite(iSprite).flipH = 0
  else
    sprite(iSprite).flipH = aProps.flipH
  end if
  if voidp(aProps[#flipV]) then
    sprite(iSprite).flipV = 0
  else
    sprite(iSprite).flipV = aProps.flipV
  end if
  if voidp(aProps[#rotation]) then
    sprite(iSprite).rotation = 0
  else
    sprite(iSprite).rotation = aProps.rotation
  end if
  iRow = VOID
  if not voidp(aProps[#row]) then
    iRow = integer(aProps.row)
  end if
  iCol = VOID
  if not voidp(aProps[#col]) then
    iCol = integer(aProps.col)
  end if
  iLayer = VOID
  if not voidp(aProps[#layer]) then
    iLayer = aProps.layer
  end if
  iDepth = VOID
  oSquare = VOID
  if not voidp(iRow) and not voidp(iCol) and not voidp(iLayer) then
    oSquare = oIsoScene.oGrid.getSquareByRowCol(iRow, iCol)
    if not voidp(oSquare) then
      iHeightLayer = oSquare.getHeightLayer(iLayer, 0)
      iDepth = oSquare.getDepthByLayer(iHeightLayer)
      sprite(iSprite).locZ = iDepth
    end if
  end if
  sprite(iSprite).visible = 1
  return iSprite
end

on buildSpriteProps me, oXml
  iOldDelimiter = the itemDelimiter
  the itemDelimiter = ">"
  sXmlString = oXml.toString()
  sXmlString = sXmlString.item[1]
  the itemDelimiter = iOldDelimiter
  aProps = [:]
  if sXmlString contains "member=" then
    aProps.addProp(#member, oXml.attributes.member)
  end if
  if sXmlString contains "media=" then
    aProps.addProp(#member, symbol(oXml.attributes.media))
  end if
  if sXmlString contains "x=" then
    aProps.addProp(#x, integer(oXml.attributes.x))
  end if
  if sXmlString contains "y=" then
    aProps.addProp(#y, integer(oXml.attributes.y))
  end if
  if sXmlString contains "ink=" then
    aProps.addProp(#ink, integer(oXml.attributes.ink))
  end if
  if sXmlString contains "blend=" then
    aProps.addProp(#blend, integer(oXml.attributes.blend))
  end if
  if sXmlString contains "width=" then
    aProps.addProp(#width, integer(oXml.attributes.width))
  end if
  if sXmlString contains "height=" then
    aProps.addProp(#height, integer(oXml.attributes.height))
  end if
  if sXmlString contains "palette=" then
    aProps.addProp(#palette, oXml.attributes.palette)
  end if
  if sXmlString contains "skew=" then
    aProps.addProp(#skew, integer(oXml.attributes.skew))
  end if
  if sXmlString contains "flipH=" then
    aProps.addProp(#flipH, integer(oXml.attributes.flipH))
  end if
  if sXmlString contains "flipV=" then
    aProps.addProp(#flipV, integer(oXml.attributes.flipV))
  end if
  if sXmlString contains "rotation=" then
    aProps.addProp(#rotation, integer(oXml.attributes.rotation))
  end if
  if sXmlString contains "row=" then
    aProps.addProp(#row, integer(oXml.attributes.row))
  end if
  if sXmlString contains "col=" then
    aProps.addProp(#col, integer(oXml.attributes.col))
  end if
  if sXmlString contains "layer=" then
    aProps.addProp(#layer, integer(oXml.attributes.layer))
  end if
  if sXmlString contains "Action=" then
    aProps.addProp(#Action, oXml.attributes.Action)
  end if
  if sXmlString contains "backcolor=" then
    aProps.addProp(#backColor, integer(oXml.attributes.backColor))
  end if
  return aProps
end

on destroy me
  me.clearSpritePool()
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "IsoSpriteManager." & sMessage
  end if
end

on printSpritePool me
  put "********** BEGIN SPRITE POOL ******************" & RETURN
  repeat with i in me.aSpritePool
    oMember = sprite(i).member
    sName = EMPTY
    if oMember.memberNum > 0 then
      sName = oMember.name
    end if
    put "SPRITE: " & i & ": MEMBER: " & sName
  end repeat
  put "******** END SPRITE POOL ******************"
end
