property pStudioDataId, pTextId, pCatalogId, pFeatureSetId, bInit
global sLanguageSetting, sPublicStudioText, sTextManagerText, sCatalogText, gCatalog, gFeatureSet

on beginSprite me
  me.bInit = 0
end

on Init me
  me.pStudioDataId = "StudioData"
  me.pTextId = "TextManagerText"
  me.pCatalogId = "Catalog"
  me.pFeatureSetId = "FeatureSet"
  p = script("PreloadTexts").new("Loading Coke Studios")
  p.addItem(me.pStudioDataId, the moviePath & "PublicStudios_" & sLanguageSetting & ".xml")
  p.addItem(me.pTextId, the moviePath & "Text_" & sLanguageSetting & ".txt")
  p.addItem(me.pCatalogId, the moviePath & "Catalogue_" & sLanguageSetting & ".txt")
  p.addItem(me.pFeatureSetId, the moviePath & "FeatureSet.txt")
  p.start(me, #finished)
end

on exitFrame me
  if not me.bInit then
    me.bInit = 1
    me.Init()
  end if
  go(the frame)
end

on finished me, aLoadList
  global ElementMgr, TextMgr
  sPublicStudioText = aLoadList[me.pStudioDataId][#text]
  sTextManagerText = aLoadList[me.pTextId][#text]
  sCatalogText = aLoadList[me.pCatalogId][#text]
  sFeatureSet = aLoadList[me.pFeatureSetId][#text]
  ElementMgr = new(script("ElementManager"))
  TextMgr = new(script("Text manager"))
  gCatalog = new(script("CatalogScript"), sCatalogText)
  gFeatureSet = new(script("FEATURE_SET"), sFeatureSet)
  go(#next)
end
