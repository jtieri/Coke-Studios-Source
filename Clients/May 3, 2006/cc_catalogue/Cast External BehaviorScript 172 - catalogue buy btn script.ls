property pID, pParentWindow

on new me, id, parentwindow
  pID = id
  pParentWindow = parentwindow
  return me
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  global gFeatureSet, ElementMgr, oPossessionManager, oDenizenManager, gCatalog
  if not gFeatureSet.isEnabled(#PURCHASING) then
    ElementMgr.alert("FEATURE_DISABLED")
    return 
  end if
  oItemsList = pParentWindow.pScrollingLists.itemslist
  aItem = oItemsList.pItemsList[pID]
  myProdID = aItem.prodID
  catitem = gCatalog.getItemByProdId(myProdID)
  myAttributes = catitem.attributes
  myscreenname = oDenizenManager.getScreenName()
  oPossessionManager.prePurchaseItem(myscreenname, myProdID, myAttributes)
  dontPassEvent()
end

on showBuyButton me, iID, bVisible
  if me.pID = iID then
    sprite(me.spriteNum).visible = bVisible
    sprite(me.spriteNum + 1).visible = bVisible
  end if
end
