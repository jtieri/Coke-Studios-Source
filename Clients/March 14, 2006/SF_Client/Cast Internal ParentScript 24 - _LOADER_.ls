property oBackgroundMember, oBGRect, iBackgroundSprite, oTextMember, oTextMemberRect, oTextSpriteRect, iTextSprite, oStatusMember, oStatusRect, iStatusSprite
global ElementMgr

on new me
  me.oBackgroundMember = member("loading")
  me.oBGRect = rect(222, 197, 538, 323)
  me.oTextMember = member("LoadingStatus")
  me.oTextMemberRect = rect(0, 0, 317, 15)
  me.oTextSpriteRect = rect(222, 177, 539, 202)
  me.oStatusMember = member("StatusBar")
  me.oStatusRect = rect(222, 330, 539, 335)
  me.setSprites()
  return me
end

on setSprites me
  me.iBackgroundSprite = the lastChannel - 10
  me.iTextSprite = the lastChannel - 9
  me.iStatusSprite = the lastChannel - 8
end

on openWindow me
  puppetSprite(me.iBackgroundSprite, 1)
  sprite(me.iBackgroundSprite).member = me.oBackgroundMember
  sprite(me.iBackgroundSprite).rect = me.oBGRect
  sprite(me.iBackgroundSprite).ink = 8
  sprite(me.iBackgroundSprite).visible = 1
  sprite(me.iBackgroundSprite).locZ = 1000000
  puppetSprite(me.iTextSprite, 1)
  sprite(me.iTextSprite).member = me.oTextMember
  me.oTextMember.rect = me.oTextMemberRect
  me.oTextMember.font = "Arial"
  me.oTextMember.color = rgb(255, 255, 255)
  sprite(me.iTextSprite).rect = me.oTextSpriteRect
  sprite(me.iTextSprite).ink = 36
  sprite(me.iTextSprite).visible = 1
  sprite(me.iTextSprite).locZ = 1000001
  puppetSprite(me.iStatusSprite, 1)
  sprite(me.iStatusSprite).member = me.oStatusMember
  sprite(me.iStatusSprite).rect = me.oStatusRect
  sprite(me.iStatusSprite).ink = 0
  sprite(me.iStatusSprite).visible = 0
  sprite(me.iStatusSprite).locZ = 1000002
  sprite(me.iStatusSprite).color = rgb(255, 255, 255)
  updateStage()
end

on closeWindow me
  puppetSprite(me.iBackgroundSprite, 0)
  sprite(me.iBackgroundSprite).visible = 0
  puppetSprite(me.iTextSprite, 0)
  sprite(me.iTextSprite).visible = 0
  puppetSprite(me.iStatusSprite, 0)
  sprite(me.iStatusSprite).visible = 0
  updateStage()
end

on displayStatus me, sDisplayText, iPercentage
  if iPercentage > 100 then
    iPercentage = 100
  end if
  me.oTextMember.text = sDisplayText
  iWidth = me.map(float(iPercentage), 1.0, 100.0, 1.0, float(me.oStatusRect.width))
  sprite(me.iStatusSprite).width = iWidth
end

on map me, inVal, inLow, inHi, outLow, outHi
  outVal = ((inVal - inLow) / (inHi - inLow) * (outHi - outLow)) + outLow
  return outVal
end
