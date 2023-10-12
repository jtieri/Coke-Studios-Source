property bDebug, bInitialized, bReadyForuse, foCatalogManager, fo_level0, ERROR_TYPE, aCachedProdList, iLastProductListUpdate, iCacheTimeLength
global oCatalogManager, ElementMgr, gbTestMode, gFeatureSet

on beginSprite me
  me.bDebug = 0
  me.bInitialized = 0
  me.bReadyForuse = 0
  me.ERROR_TYPE = "FlashReturnStatusEnum"
  me.iCacheTimeLength = 5 * (60 * 1000)
  oCatalogManager = me
  script("_TIMER_").new(600, #Init, me)
end

on Init me
  me.debug("init()")
  me.foCatalogManager = sprite(me.spriteNum).getVariable("_level0.oCatalogManager", 0)
  me.setCallbacks()
  me.fo_level0 = sprite(me.spriteNum).getVariable("_level0", 0)
  me.foCatalogManager.bDebug = 0
  me.foCatalogManager.bTestMode = 0
  if the runMode = "Author" then
    me.bReadyForuse = 1
  else
    me.foCatalogManager.createGateway(me.fo_level0.getGatewayConnection())
  end if
  me.bInitialized = 1
end

on beanCreated me
  me.debug("beanCreated()")
  me.bReadyForuse = 1
end

on setCallbacks me
  sprite(me.spriteNum).setCallback(me.foCatalogManager, "beanCreated", #beanCreated, me)
  sprite(me.spriteNum).setCallback(me.foCatalogManager, "getProductList_Result", #getProductList_Result, me)
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "CatalogManager: " & sMessage
  end if
end

on getProductList me
  me.debug("getProductList() ")
  if not gFeatureSet.isEnabled(#CATALOG) then
    return 
  end if
  if gbTestMode then
    aProdList = me.getTestITems()
    iError = 0
    me.debug("getProductList_Result() aProdList: " & aProdList)
    if not voidp(ElementMgr) then
      ElementMgr.getProductList_Result(iError, aProdList)
    end if
    return 
  end if
  bUseCache = 1
  if not voidp(me.iLastProductListUpdate) then
    iElapsedTime = the milliSeconds - me.iLastProductListUpdate
    if iElapsedTime >= me.iCacheTimeLength then
      bUseCache = 0
    end if
  else
    bUseCache = 0
  end if
  me.debug("getProductList() bUseCache: " & bUseCache)
  if not bUseCache or voidp(me.aCachedProdList) then
    me.foCatalogManager.getProductList()
  else
    me.debug("*** CACHED ****: getProductList_Result()", 1)
    if not voidp(ElementMgr) then
      ElementMgr.getProductList_Result(0, me.aCachedProdList)
    end if
  end if
end

on getProductList_Result me, oCaller, oResult
  me.debug("getProductList_Result()")
  if oResult.getTypeOf() = me.ERROR_TYPE then
    iError = oResult.getOrdinal()
    me.debug("getProductList_Result() ERROR " & iError)
    if not voidp(ElementMgr) then
      ElementMgr.getProductList_Result(iError)
    end if
    return 
  end if
  me.iLastProductListUpdate = the milliSeconds
  iError = 0
  aProdList = []
  iLength = oResult.length
  repeat with i = 0 to iLength - 1
    oItem = oResult[i]
    aItem = [:]
    aItem[#prodID] = integer(oItem.getId())
    aItem[#price] = integer(oItem.getPrice())
    aProdList.add(aItem)
  end repeat
  me.aCachedProdList = aProdList
  me.debug("getProductList_Result() aProdList: " & aProdList)
  if not voidp(ElementMgr) then
    ElementMgr.getProductList_Result(iError, aProdList)
  end if
end

on onStatus me, oCaller, oXml
  me.debug("onStatus()", 1)
end

on getGatewaySprite me
  return sprite(me.spriteNum)
end

on getTestITems me
  aProdList = []
  repeat with i = 1 to 81
    aProdList.add([#prodID: i, #price: i])
  end repeat
  return aProdList
end
