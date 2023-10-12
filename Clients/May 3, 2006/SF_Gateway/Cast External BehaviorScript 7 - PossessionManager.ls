property bDebug, bInitialized, bReadyForuse, foPossessionManager, fo_level0, ERROR_TYPE, bPendingPurchase
global oPossessionManager, oDenizenManager, ElementMgr, gbTestMode, gFeatureSet

on beginSprite me
  me.bPendingPurchase = 0
  me.bDebug = 0
  me.bInitialized = 0
  me.bReadyForuse = 0
  me.ERROR_TYPE = "FlashReturnStatusEnum"
  oPossessionManager = me
  script("_TIMER_").new(700, #Init, me)
end

on Init me
  me.debug("init()")
  me.foPossessionManager = sprite(me.spriteNum).getVariable("_level0.oPosessionManager", 0)
  me.setCallbacks()
  me.fo_level0 = sprite(me.spriteNum).getVariable("_level0", 0)
  me.foPossessionManager.bDebug = 0
  me.foPossessionManager.bTestMode = 0
  if the runMode = "Author" then
    me.bReadyForuse = 1
  else
    me.foPossessionManager.createGateway(me.fo_level0.getGatewayConnection())
  end if
  me.bInitialized = 1
end

on beanCreated me
  me.debug("beanCreated()")
  me.bReadyForuse = 1
end

on setCallbacks me
  sprite(me.spriteNum).setCallback(me.foPossessionManager, "beanCreated", #beanCreated, me)
  sprite(me.spriteNum).setCallback(me.foPossessionManager, "getPossessionsInBackpack_Result", #getPossessionsInBackpack_Result, me)
  sprite(me.spriteNum).setCallback(me.foPossessionManager, "getPossessionsInStudio_Result", #getPossessionsInStudio_Result, me)
  sprite(me.spriteNum).setCallback(me.foPossessionManager, "purchaseItem_Result", #purchaseItem_Result, me)
  sprite(me.spriteNum).setCallback(me.foPossessionManager, "prePurchaseItem_Result", #prePurchaseItem_Result, me)
  sprite(me.spriteNum).setCallback(me.foPossessionManager, "dispenseItem_Result", #dispenseItem_Result, me)
  sprite(me.spriteNum).setCallback(me.foPossessionManager, "getBurnedCdsInBackpack_Result", #getBurnedCdsInBackpack_Result, me)
  sprite(me.spriteNum).setCallback(me.foPossessionManager, "getBackPack_Result", #getBackPack_Result, me)
  sprite(me.spriteNum).setCallback(me.foPossessionManager, "getPossessionList_Result", #getPossessionList_Result, me)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "PossessionManager: " & sMessage
  end if
end

on getBackpack me
  me.debug("getBackPack()")
  if not gFeatureSet.isEnabled(#BACKPACK) then
    return 
  end if
  me.foPossessionManager.getBackpack(oDenizenManager.getScreenName(), oDenizenManager.getDenizen().getSecret())
end

on getBackPack_Result me, oCaller, oResult
  me.debug("getPackPack_Result()")
  if voidp(oResult) then
    me.debug("ERROR ON RESULT FOR BACKPACK")
    return 
  end if
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("getBackPack_Result() ERROR " & iError)
    return 
  end if
  oDenizenManager.setBackPack(oResult)
  me.getPossessionsInBackpack(oDenizenManager.getScreenName(), 1, 25)
  me.debug("** BACKPACK: " & oResult.getPossessionIDs().toString())
end

on getPossessionList me, aIDs
  me.debug("getPossessionList() " & aIDs.length & ": " & aIDs.toString())
  me.foPossessionManager.getPossessionList(oDenizenManager.getDenizen().getScreenName(), oDenizenManager.getDenizen().getSecret(), aIDs)
end

on getPossessionList_Result me, oCaller, oResult
  me.debug("getPossessionList_Result()")
  if voidp(oResult) then
    me.debug("ERROR ON RESULT FOR getPossessionList_Result")
    return 
  end if
  oBackPack = oDenizenManager.getBackpack()
  if voidp(oBackPack) then
    return 
  end if
  me.debug("getPossessionList_Result() COUNT: " & oResult.length)
  oDenizenManager.getBackpack().addPossessions(oResult, 0)
  me.getPossessionsInBackpack_Result(VOID, oBackPack)
end

on getPossessionsInBackpack me, sScreenName, iPage, iPageSize
  me.debug("getPossessionsInBackpack() " & sScreenName && iPage && iPageSize)
  if voidp(iPage) then
    iPage = 1
  end if
  if voidp(iPageSize) then
    iPageSize = 25
  end if
  oBackPack = oDenizenManager.getBackpack()
  if voidp(oBackPack) then
    return 
  end if
  oBackPack.setCurrentPage(iPage)
  aIDs = oBackPack.getPossessionIDsByPage(iPage)
  aPos = oBackPack.getPossessionsByPage(iPage)
  if aIDs.length = aPos.length then
    me.getPossessionsInBackpack_Result(VOID, oBackPack)
    return 
  else
    me.getPossessionList(aIDs)
  end if
end

on getPossessionsInStudio me, sStudioID
  me.debug("getPossessionsInStudio() " & sStudioID)
  if gbTestMode then
    iError = 0
    aProdList = me.getTestStudioItems()
    me.debug("getPossessionsInStudio() aProdList: " & aProdList)
    if not voidp(ElementMgr) then
      ElementMgr.getPossessionsInStudio_Result(iError, aProdList)
    end if
    return 
  end if
  me.foPossessionManager.getPossessionsInStudio(sStudioID)
end

on purchaseItem me, sScreenName, iCatId, aAttributes
  global gFeatureSet
  me.debug("purchaseItem() " & sScreenName && iCatId && aAttributes)
  if not gFeatureSet.isEnabled(#PURCHASING) then
    return 
  end if
  if me.bPendingPurchase then
    ElementMgr.alert("ALERT_PENDING_PURCHASE")
    return 
  end if
  if voidp(aAttributes) then
    aAttributes = "[:]"
  else
    aAttributes = string(aAttributes)
  end if
  if gbTestMode then
    iError = random(2) - 1
    me.debug("purchaseItem_Result() " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.purchaseItem_Result(iError)
    end if
  end if
  me.bPendingPurchase = 1
  me.foPossessionManager.purchaseItem(sScreenName, oDenizenManager.getDenizen().getSecret(), iCatId, string(aAttributes))
end

on prePurchaseItem me, sScreenName, iCatId, aAttributes
  global gFeatureSet
  me.debug("prePurchaseItem() " & sScreenName && iCatId && aAttributes)
  if not gFeatureSet.isEnabled(#PURCHASING) then
    return 
  end if
  if me.bPendingPurchase then
    ElementMgr.alert("ALERT_PENDING_PURCHASE")
    return 
  end if
  iCatId = integer(iCatId)
  if voidp(aAttributes) then
    aAttributes = "[:]"
  else
    aAttributes = string(aAttributes)
  end if
  if gbTestMode then
    iError = 0
    iBalance = 2
    iPrice = 500
    iProdId = 4
    me.debug("prePurchaseItem_Result() " & iBalance && iPrice)
    if not voidp(ElementMgr) then
      ElementMgr.prePurchaseItem_Result(iError, iBalance, iPrice, iProdId, aAttributes)
    end if
  end if
  me.foPossessionManager.prePurchaseItem(sScreenName, oDenizenManager.getDenizen().getSecret(), iCatId, aAttributes)
end

on dispenseItem me, sScreenName
  global gFeatureSet
  me.debug("dispenseItem() " & sScreenName)
  if not gFeatureSet.isEnabled(#ITEM_DISPENSER) then
    return 
  end if
  me.foPossessionManager.dispenseItem(sScreenName, oDenizenManager.getDenizen().getSecret())
end

on getBurnedCDsInBackPack me, sScreenName
  me.debug("getBurnedCDsInBackPack() " & sScreenName)
  if gbTestMode then
    iError = 0
    aCds = me.createTestCds()
    me.debug("getBurnedCDsInBackPack() aCDs: " & aCds)
    if not voidp(ElementMgr) then
      ElementMgr.getBurnedCdsInBackpack_Result(iError, aCds)
    end if
    return 
  end if
  me.foPossessionManager.getBurnedCDsInBackPack(sScreenName, oDenizenManager.getDenizen().getSecret())
end

on destroy me, iPosId
  me.debug("destroy() " & iPosId)
  if voidp(iPosId) then
    return 
  end if
  if gbTestMode then
    iError = 0
    me.debug("destroy() " & iError)
  end if
  me.foPossessionMananger.destroy(iPosId)
end

on getPossessionsInBackpack_Result me, oCaller, oBackPack
  me.debug("getPossessionsInBackpack_Result()")
  iError = 0
  iCurrentPage = integer(oBackPack.getCurrentPage())
  iTotalPages = integer(oBackPack.getTotalPages())
  iTotalItems = integer(oBackPack.getTotalItems())
  iCds = integer(oBackPack.getNumberOfBlankCds())
  if iTotalItems <= oBackPack.getPageSize() then
    iCurrentPage = 1
  end if
  if iCurrentPage > iTotalPages then
    iCurrentPage = iTotalPages
  end if
  aPossessions = oBackPack.getPossessionsByPage(iCurrentPage)
  aProdList = []
  if voidp(aPossessions) then
    return 
  end if
  iLength = aPossessions.length
  repeat with i = 0 to iLength - 1
    oItem = aPossessions[i]
    me.debug("oItem: " & oItem.toString())
    aItem = [:]
    aItem[#prodID] = integer(oItem.getCatalogItem())
    me.debug("aItem: prodId: " & aItem)
    aItem[#posId] = integer(oItem.getId())
    me.debug("aItem: posId: " & aItem)
    sProperties = oItem.getProperties().getProperties()
    me.debug("sProperties: " & sProperties)
    if voidp(sProperties) or (sProperties = VOID) then
      aItem[#attributes] = [:]
    else
      aItem[#attributes] = value(sProperties)
    end if
    me.debug("aItem: attributes: " & aItem)
    aProdList.add(aItem)
  end repeat
  me.debug("getPossessionsInBackpack_Result() aProdList: " & aProdList)
  if not voidp(ElementMgr) then
    ElementMgr.getPossessionsInBackpack_Result(iError, aProdList, iCurrentPage, iTotalPages, iTotalItems, iCds)
  end if
end

on getPossessionsInStudio_Result me, oCaller, oResult
  me.debug("getPossessionsInStudio_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("getPossessionsInStudio_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.getPossessionsInStudio_Result(iError)
    end if
    return 
  end if
  iError = 0
  aProdList = []
  iLength = oResult.length
  repeat with i = 0 to iLength - 1
    oItem = oResult[i]
    aItem = [:]
    aItem[#prodID] = integer(oItem.getCatalogItem())
    aItem[#posId] = integer(oItem.getId())
    aItem[#dir] = integer(oItem.getFacingDirection())
    aItem[#attributes] = value(oItem.getProperties().getProperties())
    aItem[#state] = integer(oItem.getState())
    aItem[#gridX] = integer(oItem.getXPos())
    aItem[#gridY] = integer(oItem.getYPos())
    aItem[#gridZ] = integer(oItem.getZPos())
    aItem[#owner] = oItem.getOwnerScreenName()
    aProdList.add(aItem)
  end repeat
  me.debug("getPossessionsInBackpack_Result() aProdList: " & aProdList)
  if not voidp(ElementMgr) then
    ElementMgr.getPossessionsInStudio_Result(iError, aProdList)
  end if
end

on purchaseItem_Result me, oCaller, oResult
  me.debug("purchaseItem_Result()")
  me.bPendingPurchase = 0
  iError = 0
  if voidp(oResult) or (oResult = VOID) then
    iError = 1
  end if
  me.debug("purchaseItem_Result() ERROR " & iError)
  if not voidp(ElementMgr) then
    ElementMgr.purchaseItem_Result(iError, oResult)
  end if
end

on prePurchaseItem_Result me, oCaller, oResult
  me.debug("prePurchaseItem_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("prePurchaseItem_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.prePurchaseItem_Result(iError)
    end if
    return 
  end if
  iError = 0
  iBalance = integer(oResult.getBalance())
  iPrice = integer(oResult.getPrice())
  iProdId = integer(oResult.getCatalogItemId())
  aAttributes = value(oResult.getProperties())
  me.debug("prePurchaseItem_Result() " & iBalance && iPrice)
  if not voidp(ElementMgr) then
    ElementMgr.prePurchaseItem_Result(iError, iBalance, iPrice, iProdId, aAttributes)
  end if
end

on dispenseItem_Result me, oCaller, oResult
  me.debug("dispenseItem_Result() oCaller: " & oCaller & " oResult.toString(): " & oResult.toString())
  if oResult.length > 0 then
    iError = 1
  else
    iError = 0
  end if
  if not voidp(ElementMgr) then
    ElementMgr.dispenseItem_Result(iError, oResult)
  end if
end

on getBurnedCdsInBackpack_Result me, oCaller, oResult
  me.debug("getBurnedCdsInBackpack_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("getBurnedCdsInBackpack_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.getBurnedCdsInBackpack_Result(iError)
    end if
    return 
  end if
  iError = 0
  aCds = me.createCds(oResult)
  me.debug("getBurnedCdsInBackpack_Result() aCDs: " & aCds)
  if not voidp(ElementMgr) then
    ElementMgr.getBurnedCdsInBackpack_Result(iError, aCds)
  end if
end

on destroy_Result me, oCaller, oResult
  me.debug("destroy_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("destroy_Result() ERROR " & iError)
    return 
  end if
end

on onStatus me, oCaller, oXml
  me.debug("onStatus()", 1)
end

on getTestBackpackItems me, iStart, iEnd
  iProdIndex = 3
  aProdList = []
  repeat with i = 305 to 380
    aProdList.add([#prodID: iProdIndex, #posId: i])
    iProdIndex = iProdIndex + 1
  end repeat
  return aProdList
end

on getTestStudioItems me
  aProdList = []
  aProdList.add([#prodID: 3, #posId: 1, #dir: 2, #attributes: [:], #state: 0, #gridX: 10, #gridY: 0, #gridZ: 10, #owner: "aslan"])
  aProdList.add([#prodID: 4, #posId: 2, #dir: 2, #attributes: [:], #state: 0, #gridX: 12, #gridY: 0, #gridZ: 12, #owner: "aslan"])
  return aProdList
end

on createTestCds me
  aCds = []
  repeat with i = 436 to 437
    iPosId = i
    sSong = "jazzyjeff,4,4,54,^4x4,97,308,countryOne_beatz00,{24,7996,{^Drum kit 2,100,403,shared_trapset00_,{8,15996,{^Delayed,100,355,popTwo_kbd00,{12,21989,{^C'mon Again,100,352,popOne_vocal00,{1,27986,{1,31984,{1,35982,{1,39980,{1,43978,{1,47976,{1,51974,{^Cop Show 2,100,402,popOne_kbd00_,{12,7998,{^Slinky 2,100,406,hipHopOne_kbd00_,{15,0,{^"
    sAuthor = "Aslan"
    sSongName = "Test"
    aCds.add([#posId: iPosId, #author: sAuthor, #name: sSongName, #song: sSong])
  end repeat
  return aCds
end

on createCds me, oResult
  me.debug("createCDs() " & oResult)
  aCds = []
  repeat with i = 0 to oResult.length - 1
    me.debug("1")
    me.debug("i:" && i)
    me.debug("oResult[i]:" && oResult[i])
    oPossession = oResult[i]
    iPosId = oPossession.getId()
    me.debug("iPosId:" && iPosId)
    sProperties = oPossession.getProperties().getProperties()
    aProperties = value(sProperties)
    me.debug("aProperties:" && aProperties)
    sOwnerName = aProperties[#ownerName]
    sSong = aProperties[#song]
    sSongName = aProperties[#songName]
    aCd = [:]
    aCd[#posId] = iPosId
    aCd[#author] = sOwnerName
    aCd[#name] = sSongName
    aCd[#song] = sSong
    aCds.add(aCd)
  end repeat
  return aCds
end

on getGatewaySprite me
  return sprite(me.spriteNum)
end
