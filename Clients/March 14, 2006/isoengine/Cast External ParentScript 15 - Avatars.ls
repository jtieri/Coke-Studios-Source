property aItems, bDebug
global oIsoScene

on new me
  me.aItems = []
  me.bDebug = 0
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "Avatars: " & sMessage
  end if
end

on init me, oXml
  if voidp(oXml) then
    return 
  end if
end

on getAvatar me, sID
  iLength = me.aItems.count
  repeat with i = 1 to iLength
    oAvatar = me.aItems[i]
    if oAvatar.getId() = sID then
      return oAvatar
    end if
  end repeat
end

on getRandomAVatar me
  if me.aItems.count = 0 then
    return VOID
  end if
  return me.aItems[random(me.aItems.count)]
end

on addItem me, oItem
  me.aItems.add(oItem)
end

on removeItem me, oItem
  me.debug("removeItem(oItem)" && oItem)
  oItem.destroy()
  me.aItems.deleteOne(oItem)
  if not voidp(oIsoScene.oAvatarIndicator) then
    me.debug("destroying oAvatarIndicator")
    oIsoScene.oAvatarIndicator.destroyItem()
  end if
end

on updateAll me
  if me.aItems.count = 0 then
    return 
  end if
  repeat with oItem in me.aItems
    oItem.updateStatus()
  end repeat
end

on updateAllAtSquares me, aSquares
  _aItems = me.getItemsAtSquares(aSquares)
  repeat with oItem in _aItems
    oItem.updateStatus()
  end repeat
end

on getItemsAtSquare me, oSquare
  aList = []
  repeat with oItem in me.aItems
    if oItem.existsAtSquare(oSquare) then
      aList.add(oItem)
    end if
  end repeat
  return aList
end

on getItemsAtSquares me, aSquares
  aList = []
  repeat with oSquare in aSquares
    _aItems = me.getItemsAtSquare(oSquare)
    repeat with oItem in _aItems
      aList.add(oItem)
    end repeat
  end repeat
  return aList
end

on destroy me
  repeat with i = 1 to me.aItems.count
    oItem = me.aItems[i]
    oItem.destroy()
  end repeat
  me.aItems = []
end

on toggleDisplay me
  repeat with i in me.aItems
    i.toggleDisplay()
  end repeat
end

on generateXml me
end

on getItemsUnderMouse me, aItemsUnderMouse
  if voidp(aItemsUnderMouse) then
    aItemsUnderMouse = []
  end if
  repeat with i in me.aItems
    if i.mouseIsOverITem() then
      aItemsUnderMouse.add(i)
    end if
  end repeat
  return aItemsUnderMouse
end

on getSpritesUnderMouse me, aSpritesUnderMouse
  if voidp(aSpritesUnderMouse) then
    aSpritesUnderMouse = [:]
  end if
  repeat with i in me.aItems
    aItemSprites = i.getSpritesUnderMouse()
    repeat with x = 1 to aItemSprites.count()
      _iZ = aItemSprites.getPropAt(x)
      _iSprite = aItemSprites[x]
      aSpritesUnderMouse.addProp(_iZ, _iSprite)
    end repeat
  end repeat
  return aSpritesUnderMouse
end

on getObjectsUnderMouse me, aObjectsUnderMouse
  repeat with i in me.aItems
    bRollover = i.rolloverObject()
    if bRollover then
      _iZ = i.getHighestDepth()
      aObjectsUnderMouse.addProp(_iZ, i)
    end if
  end repeat
  return aObjectsUnderMouse
end

on hearChat me, oAvatar
  put "Avatars.hearChat()"
  repeat with i in me.aItems
    if i.getScreenName() = oAvatar.getScreenName() then
      next repeat
    end if
    i.hearChat(oAvatar)
  end repeat
end
