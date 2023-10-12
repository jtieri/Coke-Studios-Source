property sCastLib, sAssetCastLib, sDataAsset, oXml, aSounds, aCategories

on new me, _sCastLib, _sAssetCastLib
  me.sCastLib = _sCastLib
  me.sAssetCastLib = _sAssetCastLib
  me.sDataAsset = "SoundLibraryData"
  me.aSounds = []
  me.aCategories = []
  me.parseData(member(me.sDataAsset, me.sAssetCastLib).text)
  return me
end

on parseData me, sData
  me.aSounds = [:]
  me.aCategories = []
  me.oXml = newObject("XML")
  me.oXml.ignoreWhite = 1
  me.oXml.parseXML(sData)
  oRoot = me.oXml.firstChild
  aSoundNodes = me.getNodes(oRoot, "Sound")
  iLength = aSoundNodes.count
  repeat with i = 1 to iLength
    oSoundNode = aSoundNodes[i]
    sName = oSoundNode.attributes.name
    iBeats = integer(oSoundNode.attributes.beats)
    sAsset = oSoundNode.attributes.asset
    if voidp(sAsset) then
      next repeat
    end if
    sIcon = "none"
    sCategoryName = "none"
    oMember = member(sAsset, me.sAssetCastLib)
    me.aSounds.addProp(sAsset, script("Sound").new(sName, iBeats, sAsset, sIcon, sCategoryName, oMember))
  end repeat
  aCategoryNodes = me.getNodes(oRoot, "Category")
  iLength = aCategoryNodes.count
  repeat with i = 1 to iLength
    oCategory = aCategoryNodes[i]
    sCategoryName = oCategory.attributes.name
    me.aCategories.add(sCategoryName)
    aSoundNodes = me.getNodes(oCategory, "Sound")
    iSoundsNodeLength = aSoundNodes.count
    repeat with ii = 1 to iSoundsNodeLength
      oSoundNode = aSoundNodes[ii]
      sName = oSoundNode.attributes.name
      iBeats = integer(oSoundNode.attributes.beats)
      sAsset = oSoundNode.attributes.asset
      if voidp(sAsset) then
        next repeat
      end if
      sIcon = oSoundNode.attributes.icon
      oMember = member(sAsset, me.sAssetCastLib)
      me.aSounds.addProp(sAsset, script("Sound").new(sName, iBeats, sAsset, sIcon, sCategoryName, oMember))
    end repeat
  end repeat
end

on getXml me
  return me.oXml
end

on getCategories me
  return me.aCategories
end

on getSoundsByCategory me, sCategory
  aSoundsByCategory = []
  iLength = me.aSounds.count
  repeat with i = 1 to iLength
    oSound = me.aSounds[i]
    if oSound.sCategory = sCategory then
      aSoundsByCategory.add(oSound)
    end if
  end repeat
  return aSoundsByCategory
end

on getSilence me, iBeats
  sAsset = "Silence" & iBeats & "Beats"
  oSound = me.getSoundByAsset(sAsset)
  return oSound
end

on getSoundByAsset me, sAsset
  oSound = me.aSounds[sAsset]
  return oSound
end

on getNode me, _oXml, sNodeName
  aChildren = _oXml.childNodes
  repeat with i = 0 to aChildren.length - 1
    oNode = aChildren[i]
    if oNode.nodeName = sNodeName then
      return oNode
    end if
  end repeat
end

on getNodes me, _oXml, sNodeName
  aNodes = []
  aChildren = _oXml.childNodes
  repeat with i = 0 to aChildren.length - 1
    oNode = aChildren[i]
    if oNode.nodeName = sNodeName then
      aNodes.add(oNode)
    end if
  end repeat
  return aNodes
end
