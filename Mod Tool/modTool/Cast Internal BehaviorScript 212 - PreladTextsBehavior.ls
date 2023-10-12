property pStudioDataId, pTextId, pCatalogId, bInit
global sLanguageSetting, TextMgr, sPublicStudioText, sTextManagerText, sCatalogText

on beginSprite me
  me.bInit = 0
end

on init me
  me.pStudioDataId = "StudioData"
  me.pTextId = "TextManagerText"
  me.pCatalogId = "Catalog"
  p = script("PreloadTexts").new()
  p.addItem(me.pStudioDataId, the moviePath & "PublicStudios_" & sLanguageSetting & ".xml")
  p.addItem(me.pTextId, the moviePath & "Text_" & sLanguageSetting & ".txt")
  p.addItem(me.pCatalogId, the moviePath & "Catalogue_" & sLanguageSetting & ".txt")
  p.start(me, #finished)
end

on exitFrame me
  if not me.bInit then
    me.bInit = 1
    me.init()
  end if
  go(the frame)
end

on finished me, aLoadList
  sPublicStudioText = aLoadList[me.pStudioDataId][#text]
  sTextManagerText = aLoadList[me.pTextId][#text]
  sCatalogText = aLoadList[me.pCatalogId][#text]
  TextMgr = new(script("Text manager"))
  put "PreladTextsBehavior finished"
  go(#next)
end
