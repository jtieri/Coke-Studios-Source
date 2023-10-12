property ancestor
global oDenizenManager, ElementMgr

on new me, _oItem, aAttributes
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  return me
end

on mouseDownEvent me
  if the doubleClick then
    if (the clickLoc).locH > sprite(me.oItem.iSprite).locH then
      oDenizenManager.getCokeBulletinURL()
    else
      if voidp(getaProp(me.oItem.aAttributes, #urlLink)) = 0 then
        ElementMgr.URLdialog("ALERT_EXTERNAL_URL", me.oItem.aAttributes[#urlLink])
      end if
    end if
  end if
end
