property pProdID, pAttributes, pParentWindow
global ElementMgr

on new me, parentwindow
  pParentWindow = parentwindow
  return me
end

on getpurchasebtn me
  return me.spriteNum
end

on setProdId me, prodID
  me.pProdID = prodID
end

on setAttributes me, attributes
  me.pAttributes = attributes
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  global oPossessionManager, oDenizenManager
  myscreenname = oDenizenManager.getScreenName()
  _prodid = ElementMgr.pSelectedCatId
  _attributes = ElementMgr.pSelectedAttributes
  oPossessionManager.purchaseItem(myscreenname, _prodid, _attributes)
  pParentWindow.closeWindow()
  dontPassEvent()
end
