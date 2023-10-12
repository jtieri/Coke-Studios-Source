property ancestor, foPoster, bInit, iSprite, bDebug

on new me, _oItem, aAttributes
  bDebug = 0
  bInit = 0
  me.debug("new ACTION_DYNAMIC_POSTER")
  me.ancestor = script("ACTION_DEFAULT").new(_oItem, aAttributes)
  return me
end

on mouseDownEvent me, _iSprite
  me.debug("ACTION_DYNAMIC_POSTER mouseDown() doubleClick: " & the doubleClick && "sprite:" && _iSprite)
  me.iSprite = _iSprite
  if the doubleClick then
    me.launchPage()
  end if
end

on launchPage me
  me.debug("launchPage()")
  if not bInit then
    me.initPoster()
  end if
  sUrl = me.oItem.aAttributes[#link]
  sTargetName = me.oItem.aAttributes[#targetName]
  me.debug("sUrl:" && sUrl && "sTargetName:" && sTargetName)
  if sUrl = "UNDEFINED" then
    return 
  else
    if sTargetName = "UNDEFINED" then
      sTargetName = "_new"
    end if
  end if
  me.debug("sUrl:" && sUrl && "sTargetName:" && sTargetName)
  gotoNetPage(sUrl, sTargetName)
end

on initPoster me
  me.debug("initPoster()")
  me.foPoster = sprite(me.iSprite).getVariable("oPoster", 0)
  me.debug("me.foPoster" && me.foPoster)
  me.oItem.aAttributes[#link] = me.foPoster.getLink()
  me.oItem.aAttributes[#targetName] = me.foPoster.getTargetName()
  bInit = 1
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "Poster: " & sMessage
  end if
end
