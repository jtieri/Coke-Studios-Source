property sPartCast, sAvatarCast, iWidth, iHeight, iColorDepth, iAlphaDepth, iDefaultInk, sDefaultString, aAttributes, aConfigSettings, aRuntimeConfig, aDirectionMap, aDrawOrder, aDefDrawOrder, iDirection, aCurrDrawSettings, oPoint, iScale, iShadowSprite, iImageSprite, iAnimStep, iAnimStepMax, sBodyAction, sFaceAction, sItemAction, iFPS, iFPSTimer, iFPSTimerLength, bBlink, iBlinkTimer, iBlinkTimerLength, bChatting, iChatTimer, iChatTimerLength, bEmote, iEmoteTimer, iEmoteTimerLength, bDance, aDanceOverride, bCarry, iCarryTimer, iCarryTimerLength, bDrink, iDrinkTimer, iDrinkTimerLength, iDrinkWaitTimerLength, iDrinkActionTimerLength, bSleep, iSleepTimer, iSleepTimerLength, oImageMember, oBuffer, aSourceImages, bUseSprites, oSpriteBgColor, iSpriteInk, oPreviewImage, iHeightOffset

on new me, _sAttributes, _iScale
  me.sPartCast = "people"
  me.sAvatarCast = "AvatarEngine"
  me.iWidth = 77.0
  me.iHeight = 110.0
  if not voidp(_iScale) then
    me.iScale = _iScale
  else
    me.iScale = 100
  end if
  me.iDirection = 2
  me.oPoint = point(90, 275)
  me.iColorDepth = 16
  me.iAlphaDepth = 0
  me.iDefaultInk = 41
  me.aSourceImages = [:]
  me.oSpriteBgColor = rgb(255, 255, 255)
  me.iSpriteInk = 36
  me.iAnimStep = 0
  me.iAnimStepMax = 7
  me.sBodyAction = "std"
  me.sFaceAction = "std"
  me.sItemAction = EMPTY
  me.iFPS = 15
  me.iFPSTimer = the milliSeconds
  me.iFPSTimerLength = 1000 / me.iFPS
  me.bBlink = 1
  me.iBlinkTimer = the milliSeconds
  me.iBlinkTimerLength = 3000
  me.iChatTimer = the milliSeconds
  me.iChatTimerLength = 1000
  me.bChatting = 0
  me.bEmote = 0
  me.iEmoteTimer = the milliSeconds
  me.iEmoteTimerLength = 5000
  me.bDance = 0
  me.bCarry = 0
  me.iCarryTimer = the milliSeconds
  me.iCarryTimerLength = 15000
  me.bDrink = 0
  me.iDrinkTimer = the milliSeconds
  me.iDrinkWaitTimerLength = 5000
  me.iDrinkActionTimerLength = 400
  me.iDrinkTimerLength = me.iDrinkWaitTimerLength
  me.bSleep = 0
  me.iSleepTimer = the milliSeconds
  me.iSleepTimerLength = 30000
  me.setDefaultString()
  me.setAttributes(_sAttributes)
  me.setConfigSettings()
  me.setRuntimeConfig()
  me.setDirectionMap()
  me.aDefDrawOrder = [#lh, #ls, #bd, #sh, #lg, #ch, #ri, #rh, #rs, #hd, #fc, #ey, #hr, #ht]
  me.setDrawOrder()
  me.setDanceOverride()
  me.createBuffer()
  me.setScale(me.iScale)
  me.iHeightOffset = 0
  me.draw()
  me.oPreviewImage = me.oBuffer.duplicate()
  return me
end

on initSprite me, iSprite
  me.iImageSprite = iSprite
  me.createMember()
  me.createSprite()
end

on getPreviewImage me
  return me.oPreviewImage
end

on end me
end

on createBuffer me
  me.oBuffer = image(me.iWidth, me.iHeight + 20, me.iColorDepth, me.iAlphaDepth)
  me.oBuffer.fill(me.oBuffer.rect, me.oSpriteBgColor)
end

on createMember me
  sName = string(me.iImageSprite)
  oExistingMember = member(sName, me.sAvatarCast)
  if oExistingMember.memberNum <= 0 then
    me.oImageMember = new(#bitmap, castLib(me.sAvatarCast))
  else
    me.oImageMember = oExistingMember
  end if
  me.oImageMember.name = sName
  oMemberImage = image(me.oBuffer.width * (me.iScale * 0.01), me.oBuffer.height * (me.iScale * 0.01), me.iColorDepth, me.iAlphaDepth)
  oMemberImage.copyPixels(me.oBuffer, me.oBuffer.rect * (me.iScale * 0.01), me.oBuffer.rect)
  me.oImageMember.image = oMemberImage
  me.oImageMember.regPoint = point(me.iWidth * (me.iScale * 0.01) / 2, me.iHeight * (me.iScale * 0.01))
end

on createSprite me
  puppetSprite(me.iImageSprite, 1)
  sprite(me.iImageSprite).member = me.oImageMember
  sprite(me.iImageSprite).bgColor = me.oSpriteBgColor
  sprite(me.iImageSprite).ink = me.iSpriteInk
end

on getBuffer me
  return me.oBuffer
end

on setDefaultString me
  me.sDefaultString = "hr=003/238,238,238&hd=001/245,226,203&ey=004/245,226,203&fc=001/245,226,203&bd=001/245,226,203&lh=001/245,226,203&rh=001/245,226,203&ch=001/238,238,238&ls=002/238,238,238&rs=002/238,238,238&lg=001/127,102,64&sh=001/194,123,56"
end

on setAttributes me, sString
  if sString = VOID then
    sString = me.sDefaultString
  end if
  me.aAttributes = [:]
  the itemDelimiter = "&"
  iNumParts = sString.items.count
  repeat with i = 1 to iNumParts
    the itemDelimiter = "&"
    sTotalPart = sString.item[i]
    the itemDelimiter = "="
    sPart = sTotalPart.item[1]
    sPartCodeAndColor = sTotalPart.item[2]
    the itemDelimiter = "/"
    sPartCode = sPartCodeAndColor.item[1]
    sColorParts = sPartCodeAndColor.item[2]
    the itemDelimiter = ","
    iColorLength = sColorParts.items.count
    iR = integer(sColorParts.item[1])
    iG = integer(sColorParts.item[2])
    iB = integer(sColorParts.item[3])
    if iColorLength = 1 then
      oColor = color(#paletteIndex, iR)
    else
      oColor = rgb(iR, iG, iB)
    end if
    if sPart = "ey" then
      oColor = color(#rgb, 255, 255, 255)
    end if
    aPart = [#prtCd: sPartCode, #clr: oColor]
    me.aAttributes[sPart] = aPart
  end repeat
  me.aAttributes["ri"] = [#prtCd: "001", #clr: color(#rgb, 255, 255, 255)]
  me.aAttributes["ht"] = [#prtCd: "001", #clr: color(#rgb, 255, 255, 255)]
end

on generateAttributeString me
  s = EMPTY
  repeat with i = 1 to me.aAttributes.count
    sPart = me.aAttributes.getPropAt(i)
    sPartCode = me.aAttributes[sPart][#prtCd]
    oColor = me.aAttributes[sPart][#clr]
    if sPart = "ri" then
      next repeat
    end if
    sP = sPart & "=" & sPartCode & "/" & oColor.red & "," & oColor.green & "," & oColor.blue
    if s <> EMPTY then
      s = s & "&"
    end if
    s = s & sP
  end repeat
  return s
end

on setConfigSettings me
  me.aConfigSettings = value(member("AvatarConfigSettings", me.sAvatarCast).text)
end

on setRuntimeConfig me
  me.aRuntimeConfig = [:]
  me.aRuntimeConfig[#bd] = [#act: #std, #anim: 1, #animIndex: 0, #Active: 1, #dirOff: 0]
  me.aRuntimeConfig[#hd] = [#act: #std, #anim: 1, #animIndex: 0, #Active: 1, #dirOff: 0]
  me.aRuntimeConfig[#fc] = [#act: #std, #anim: 1, #animIndex: 0, #Active: 1, #dirOff: 0]
  me.aRuntimeConfig[#ey] = [#act: #std, #anim: 1, #animIndex: 0, #Active: 1, #dirOff: 0, #ink: 36]
  me.aRuntimeConfig[#hr] = [#act: #std, #anim: 1, #animIndex: 0, #Active: 1, #dirOff: 0]
  me.aRuntimeConfig[#sh] = [#act: #std, #anim: 1, #animIndex: 0, #Active: 1, #dirOff: 0]
  me.aRuntimeConfig[#lg] = [#act: #std, #anim: 1, #animIndex: 0, #Active: 1, #dirOff: 0]
  me.aRuntimeConfig[#lh] = [#act: #std, #anim: 1, #animIndex: 0, #Active: 1, #dirOff: 0]
  me.aRuntimeConfig[#rh] = [#act: #std, #anim: 1, #animIndex: 0, #Active: 1, #dirOff: 0]
  me.aRuntimeConfig[#ch] = [#act: #std, #anim: 1, #animIndex: 0, #Active: 1, #dirOff: 0]
  me.aRuntimeConfig[#rs] = [#act: #std, #anim: 1, #animIndex: 0, #Active: 1, #dirOff: 0]
  me.aRuntimeConfig[#ls] = [#act: #std, #anim: 1, #animIndex: 0, #Active: 1, #dirOff: 0]
  me.aRuntimeConfig[#ri] = [#act: #crr, #anim: 1, #animIndex: 0, #Active: 0, #dirOff: 0]
  me.aRuntimeConfig[#ht] = [#act: #std, #anim: 1, #animIndex: 0, #Active: 0, #dirOff: 0]
end

on setDanceOverride me
  aLocOff = [point(0, 0), point(0, 0), point(0, -1), point(0, -1), point(0, 0), point(0, 0), point(0, -1), point(0, -1)]
  aDirOff = [1, 1, 1, 1, -1, -1, -1, -1]
  me.aDanceOverride = [:]
  me.aDanceOverride[#bd] = [:]
  me.aDanceOverride[#bd][#prts] = [[#act: "std", #fr: 0], [#act: "std", #fr: 0], [#act: "wlk", #fr: 0], [#act: "wlk", #fr: 0], [#act: "std", #fr: 0], [#act: "std", #fr: 0], [#act: "wlk", #fr: 2], [#act: "wlk", #fr: 2]]
  me.aDanceOverride[#lg] = [:]
  me.aDanceOverride[#lg][#prts] = [[#act: "std", #fr: 0], [#act: "std", #fr: 0], [#act: "wlk", #fr: 0], [#act: "wlk", #fr: 0], [#act: "std", #fr: 0], [#act: "std", #fr: 0], [#act: "wlk", #fr: 2], [#act: "wlk", #fr: 2]]
  me.aDanceOverride[#sh] = [:]
  me.aDanceOverride[#sh][#prts] = [[#act: "std", #fr: 0], [#act: "std", #fr: 0], [#act: "wlk", #fr: 0], [#act: "wlk", #fr: 0], [#act: "std", #fr: 0], [#act: "std", #fr: 0], [#act: "wlk", #fr: 2], [#act: "wlk", #fr: 2]]
  me.aDanceOverride[#lh] = [:]
  me.aDanceOverride[#lh][#prts] = [[#act: "crr", #fr: 0], [#act: "wlk", #fr: 1], [#act: "std", #fr: 0], [#act: "std", #fr: 0], [#act: "std", #fr: 0], [#act: "wlk", #fr: 1], [#act: "crr", #fr: 0], [#act: "crr", #fr: 0]]
  me.aDanceOverride[#lh][#locOff] = aLocOff
  me.aDanceOverride[#ls] = [:]
  me.aDanceOverride[#ls][#prts] = [[#act: "crr", #fr: 0], [#act: "wlk", #fr: 1], [#act: "std", #fr: 0], [#act: "std", #fr: 0], [#act: "std", #fr: 0], [#act: "wlk", #fr: 1], [#act: "crr", #fr: 0], [#act: "crr", #fr: 0]]
  me.aDanceOverride[#ls][#locOff] = aLocOff
  me.aDanceOverride[#rh] = [:]
  me.aDanceOverride[#rh][#prts] = [[#act: "std", #fr: 0], [#act: "wlk", #fr: 3], [#act: "crr", #fr: 0], [#act: "crr", #fr: 0], [#act: "crr", #fr: 0], [#act: "wlk", #fr: 3], [#act: "std", #fr: 0], [#act: "std", #fr: 0]]
  me.aDanceOverride[#rh][#locOff] = aLocOff
  me.aDanceOverride[#rs] = [:]
  me.aDanceOverride[#rs][#prts] = [[#act: "std", #fr: 0], [#act: "wlk", #fr: 3], [#act: "crr", #fr: 0], [#act: "crr", #fr: 0], [#act: "crr", #fr: 0], [#act: "wlk", #fr: 3], [#act: "std", #fr: 0], [#act: "std", #fr: 0]]
  me.aDanceOverride[#rs][#locOff] = aLocOff
  me.aDanceOverride[#ch] = [:]
  me.aDanceOverride[#ch][#locOff] = aLocOff
  me.aDanceOverride[#hd] = [:]
  me.aDanceOverride[#hd][#locOff] = aLocOff
  me.aDanceOverride[#hd][#dirOff] = aDirOff
  me.aDanceOverride[#fc] = [:]
  me.aDanceOverride[#fc][#locOff] = aLocOff
  me.aDanceOverride[#fc][#dirOff] = aDirOff
  me.aDanceOverride[#ey] = [:]
  me.aDanceOverride[#ey][#locOff] = aLocOff
  me.aDanceOverride[#ey][#dirOff] = aDirOff
  me.aDanceOverride[#hr] = [:]
  me.aDanceOverride[#hr][#locOff] = aLocOff
  me.aDanceOverride[#hr][#dirOff] = aDirOff
  me.aDanceOverride[#ri] = [:]
  me.aDanceOverride[#ri][#locOff] = aLocOff
  me.aDanceOverride[#ht] = [:]
  me.aDanceOverride[#ht][#locOff] = aLocOff
  me.aDanceOverride[#ht][#dirOff] = aDirOff
end

on setDirectionMap me
  me.aDirectionMap = [0: 6, 1: 5, 2: 4, 3: 7, 4: 2, 5: 1, 6: 0, 7: 3]
end

on setDrawOrder me
  case me.iDirection of
    2:
      me.aDrawOrder = [#bd, #sh, #lg, #lh, #ls, #ch, #hd, #fc, #ey, #ri, #rh, #rs, #hr, #ht]
    3:
      me.aDrawOrder = [#bd, #sh, #lg, #ch, #lh, #ls, #hd, #fc, #ey, #ri, #rh, #rs, #hr, #ht]
    4:
      me.aDrawOrder = [#bd, #sh, #lg, #lh, #ls, #ch, #hd, #fc, #ey, #ri, #rh, #rs, #hr, #ht]
    otherwise:
      me.aDrawOrder = me.aDefDrawOrder
  end case
end

on stepFrame me
  if me.iFPS > 0 then
    iElapsedTime = the milliSeconds - me.iFPSTimer
    if iElapsedTime >= me.iFPSTimerLength then
      if me.bChatting then
        iElapsedChatTime = the milliSeconds - me.iChatTimer
        if iElapsedChatTime >= me.iChatTimerLength then
          me.bChatting = 0
          me.setFaceAction(me.sFaceAction, 0)
        end if
      end if
      if not me.bSleep and me.bBlink then
        sEyeAction = me.getPartAction("ey")
        if sEyeAction = "eyb" then
          me.setFaceAction(me.sFaceAction, 0)
        end if
        iElapsedBlinkTime = the milliSeconds - me.iBlinkTimer
        if iElapsedBlinkTime >= me.iBlinkTimerLength then
          me.setPartAction("ey", "eyb")
          me.iBlinkTimer = the milliSeconds
          me.iBlinkTimerLength = (random(3) + 1) * 1000
        end if
      end if
      if me.bEmote then
        iElapsedEmoteTime = the milliSeconds - me.iEmoteTimer
        if iElapsedEmoteTime >= me.iEmoteTimerLength then
          me.setFaceAction("std")
          me.bEmote = 0
        end if
      end if
      if me.bCarry then
        iElapsedCarryTime = the milliSeconds - me.iCarryTimer
        if iElapsedCarryTime >= me.iCarryTimerLength then
          if (me.getPartCode(#ri) = "001") or (me.getPartCode(#ri) = "001") then
            me.setItemAction(EMPTY)
          end if
        end if
      end if
      if me.bCarry then
        iElapsedDrinkTime = the milliSeconds - me.iDrinkTimer
        if iElapsedDrinkTime >= me.iDrinkTimerLength then
          if me.bDrink then
            me.bDrink = 0
            me.iDrinkTimerLength = me.iDrinkWaitTimerLength
          else
            me.bDrink = 1
            me.iDrinkTimerLength = me.iDrinkActionTimerLength
          end if
          me.iDrinkTimer = the milliSeconds
        end if
      end if
      if me.bSleep then
        sEyeAction = me.getPartAction("ey")
        if sEyeAction <> "eyb" then
          me.setPartAction("ey", "eyb")
        end if
      else
        iElapsedSleepTime = the milliSeconds - me.iSleepTimer
        if iElapsedSleepTime >= me.iSleepTimerLength then
          me.bSleep = 1
        end if
      end if
      me.calcAnim()
      me.display()
      me.advanceAnimFrame()
      me.iFPSTimer = the milliSeconds
    end if
  end if
end

on advanceAnimFrame me
  if me.iAnimStep = me.iAnimStepMax then
    me.iAnimStep = 0
  else
    me.iAnimStep = me.iAnimStep + 1
  end if
end

on calcAnim me
  repeat with i = 1 to me.aRuntimeConfig.count
    sPart = me.aRuntimeConfig.getPropAt(i)
    aPartConfig = me.aRuntimeConfig[sPart]
    sAction = aPartConfig[#act]
    bAnim = aPartConfig[#anim]
    if bAnim then
      aAnimFrames = me.aConfigSettings[sPart][sAction][#fr]
      if aAnimFrames.getPos(me.iAnimStep mod 4) > 0 then
        me.aRuntimeConfig[sPart][#animIndex] = me.iAnimStep mod 4
      end if
    end if
  end repeat
end

on draw me, bForce
  aDrawSettings = me.getDrawSettings()
  if (aDrawSettings = me.aCurrDrawSettings) and (voidp(bForce) or not bForce) then
    return 
  end if
  me.oBuffer.fill(me.oBuffer.rect, me.oSpriteBgColor)
  me.aCurrDrawSettings = aDrawSettings
  repeat with i in aDrawSettings
    me.drawPart(i)
  end repeat
end

on display me, bForce
  me.draw()
  if voidp(me.oImageMember) then
    return 
  end if
  me.oImageMember.image.copyPixels(me.oBuffer, me.oBuffer.rect * (me.iScale * 0.01), me.oBuffer.rect)
  if voidp(me.iImageSprite) then
    return 
  end if
  sprite(me.iImageSprite).locH = me.oPoint.locH
  sprite(me.iImageSprite).locV = me.oPoint.locV - me.iHeightOffset
  sprite(me.iImageSprite).width = me.iScale * (58 * 0.01)
  sprite(me.iImageSprite).height = me.iScale * (58 * 0.01)
end

on drawPart me, aPartSettings
  sPart = aPartSettings[#prt]
  if not me.aRuntimeConfig[sPart][#Active] then
    return 
  end if
  oPartMember = aPartSettings[#member]
  if oPartMember.memberNum = -1 then
    return 
  end if
  oColor = aPartSettings[#clr]
  iInk = aPartSettings[#ink]
  the itemDelimiter = "_"
  custominks = value(member("custominks").text)
  myink = getaProp(custominks, oPartMember.name.item[3..4])
  if integerp(myink) then
    iInk = myink
  end if
  bFlip = aPartSettings[#flip]
  oLocOff = aPartSettings[#locOff]
  oLocOffQuad = [oLocOff, oLocOff, oLocOff, oLocOff]
  aSourceImageData = me.aSourceImages[oPartMember.name]
  if voidp(aSourceImageData) then
    oSourceImage = oPartMember.image
    oMatte = oSourceImage.createMatte()
    aParams = [#bgColor: oColor, #ink: iInk, #maskImage: oMatte]
    me.aSourceImages[oPartMember.name] = [#image: oSourceImage, #params: aParams]
  else
    oSourceImage = aSourceImageData[#image]
    aParams = aSourceImageData[#params]
  end if
  oSourceRect = me.getMemberRect(oPartMember)
  oDestRect = rect(0, 0, oSourceRect.width, oSourceRect.height)
  oDestQuad = me.createQuadFromRect(oDestRect, bFlip)
  oDestQuad = oDestQuad + oLocOffQuad
  me.oBuffer.copyPixels(oSourceImage, oDestQuad, oSourceRect, aParams)
end

on createQuadFromRect me, rRect, bFlip
  oP1 = point(rRect.left, rRect.top)
  oP2 = point(rRect.right, rRect.top)
  oP3 = point(rRect.right, rRect.bottom)
  oP4 = point(rRect.left, rRect.bottom)
  if bFlip then
    return [oP2, oP1, oP4, oP3]
  else
    return [oP1, oP2, oP3, oP4]
  end if
end

on getMemberRect me, oMember
  oRegPoint = oMember.regPoint
  vAdd = 0
  if oRegPoint.locV < oMember.rect.bottom then
    vAdd = oMember.rect.bottom - oRegPoint.locV
  end if
  return rect(oRegPoint.locH, oRegPoint.locV - 110, oRegPoint.locH + 77, oRegPoint.locV + vAdd)
end

on getDrawSettings me
  aDrawSettings = [:]
  repeat with i = 1 to me.aDrawOrder.count
    sPart = me.aDrawOrder[i]
    aPartSettings = me.getPartSettings(sPart)
    if not voidp(aPartSettings) then
      aDrawSettings[sPart] = aPartSettings
    end if
  end repeat
  return aDrawSettings
end

on getPartSettings me, prt
  aConfig = me.aRuntimeConfig[prt]
  if aConfig = VOID then
    return VOID
  end if
  bActive = aConfig[#Active]
  if not bActive then
    return VOID
  end if
  aDanceSetting = me.aDanceOverride[prt]
  sID = "h"
  sPart = prt
  sAction = aConfig[#act]
  if me.bDance and (me.sBodyAction = "std") then
    if not voidp(aDanceSetting) then
      aDanceParts = aDanceSetting[#prts]
      if not voidp(aDanceParts) then
        sAction = aDanceParts[me.iAnimStep + 1][#act]
      end if
    end if
  end if
  sPartCode = me.aAttributes[prt][#prtCd]
  aDirs = me.aConfigSettings[sPart][aConfig[#act]][#dir]
  iDirOff = me.getDirectionOffset(me.iDirection, aConfig[#dirOff])
  iDir = me.getRealDirection(iDirOff, aDirs)
  if voidp(iDir) and not me.bDance then
    return VOID
  end if
  iFrame = aConfig[#animIndex]
  if not voidp(aDanceParts) then
    iFrame = aDanceParts[me.iAnimStep + 1][#fr]
  end if
  if me.bDance and (me.sBodyAction = "std") then
    if not voidp(aDanceSetting) then
      aDanceDirOff = aDanceSetting[#dirOff]
      if not voidp(aDanceDirOff) then
        iDirOff = me.getDirectionOffset(me.iDirection, aDanceDirOff[me.iAnimStep + 1])
        iDir = me.getRealDirection(iDirOff, aDirs)
        if voidp(iDir) then
          return VOID
        end if
      end if
    end if
  end if
  bFlip = not (aDirs.getPos(me.iDirection) > 0)
  if me.bCarry and (sPart = #ri) then
    if (me.iDirection = 5) or (me.iDirection = 4) then
      bFlip = 1
    end if
    if me.bDrink then
      sAction = "drk"
    else
      sAction = "crr"
    end if
  end if
  if me.bCarry then
    if (me.iDirection > 3) and (me.iDirection < 7) then
      if (sPart = #lh) or (sPart = #ls) then
        if me.bDrink then
          sAction = "drk"
        else
          sAction = "crr"
        end if
        iFrame = 0
      end if
      if not me.bDance and ((sPart = #rh) or (sPart = #rs)) then
        sAction = "std"
        iFrame = 0
      end if
    else
      if not me.bDance and ((sPart = #lh) or (sPart = #ls)) then
        sAction = "std"
        iFrame = 0
      end if
      if (sPart = #rh) or (sPart = #rs) then
        if me.bDrink then
          sAction = "drk"
        else
          sAction = "crr"
        end if
        iFrame = 0
      end if
    end if
  end if
  oColor = me.aAttributes[prt][#clr]
  sMemberName = sID & "_" & sAction & "_" & sPart & "_" & sPartCode & "_" & iDir & "_" & iFrame
  oMember = member(sMemberName, me.sPartCast)
  if oMember.memberNum = -1 then
    sMemberName = sID & "_" & sAction & "_" & sPart & "_" & sPartCode & "_" & iDir & "_" & "0"
    oMember = member(sMemberName, me.sPartCast)
    if oMember.memberNum = -1 then
      return VOID
    end if
  end if
  iInk = aConfig[#ink]
  if voidp(iInk) then
    iInk = me.iDefaultInk
  end if
  the itemDelimiter = "_"
  custominks = value(member("custominks").text)
  myink = getaProp(custominks, oMember.name.item[3..4])
  if integerp(myink) then
    iInk = myink
  end if
  oLocOff = point(0, 0)
  if me.bDance and (me.sBodyAction = "std") then
    if not voidp(aDanceSetting) then
      aDanceLocOff = aDanceSetting[#locOff]
      if not voidp(aDanceLocOff) then
        oLocOff = aDanceLocOff[me.iAnimStep + 1]
      end if
    end if
  end if
  aPartSettings = [#id: sID, #act: sAction, #prt: prt, #prtCd: sPartCode, #dir: iDir, #fr: iFrame, #flip: bFlip, #clr: oColor, #memberName: sMemberName, #member: oMember, #ink: iInk, #locOff: oLocOff]
  return aPartSettings
end

on setLoc me, oLoc
  me.oPoint = oLoc
  if voidp(me.iImageSprite) then
    return 
  end if
  sprite(me.iImageSprite).locH = me.oPoint.locH
  sprite(me.iImageSprite).locV = me.oPoint.locV - me.iHeightOffset
end

on getLoc me, oLoc
  return me.oPoint
end

on getRealDirection me, iDir, aDirs
  bRealExists = aDirs.getPos(iDir) > 0
  if bRealExists then
    return iDir
  end if
  if iDir = 7 then
    return VOID
  end if
  iFakeDir = me.aDirectionMap.getProp(iDir)
  bFakeExists = aDirs.getPos(iFakeDir) > 0
  if bFakeExists then
    return iFakeDir
  else
    return VOID
  end if
end

on getDirectionOffset me, iDir, iDirOff
  iNewDir = iDir + iDirOff
  if iNewDir < 0 then
    iNewDir = 8 + iNewDir
  end if
  if iNewDir > 7 then
    iNewDir = iNewDir mod 8
  end if
  return iNewDir
end

on setPartActive me, sPart, bActive, bDisplay
  me.aRuntimeConfig[sPart][#Active] = bActive
  if bDisplay then
    me.calcAnim()
    me.display(1)
  end if
end

on getPartActive me, sPart
  return me.aRuntimeConfig[sPart][#Active]
end

on setPartCode me, sPart, sPartCode, bDisplay
  me.aAttributes[sPart][#prtCd] = sPartCode
  if bDisplay then
    me.calcAnim()
    me.display(1)
  end if
end

on getPartCode me, sPart
  return me.aAttributes[sPart][#prtCd]
end

on setPartAction me, sPart, sAct, bDisplay
  me.aRuntimeConfig[sPart][#act] = sAct
  if bDisplay then
    me.calcAnim()
    me.display(1)
  end if
end

on getPartAction me, sPart
  return me.aRuntimeConfig[sPart][#act]
end

on setDirection me, iDir, bDisplay
  if voidp(iDir) then
    iDir = 2
  end if
  me.iDirection = iDir
  me.setDrawOrder()
  if bDisplay then
    me.calcAnim()
    me.display()
  end if
  me.wakeup()
end

on rotate me
  iNewDir = me.iDirection + 1
  if iNewDir > 7 then
    iNewDir = 0
  end if
  me.setDirection(iNewDir, 1)
end

on setFPS me, _iFPS, bDisplay
  me.iFPS = _iFPS
  if me.iFPS = 0 then
    me.iFPSTimerLength = the maxinteger
  else
    me.iFPSTimerLength = 1000 / me.iFPS
  end if
  if bDisplay then
    me.calcAnim()
    me.display(1)
  end if
end

on setAnimFrame me, iFrame, bDisplay
  if (iFrame >= 0) and (iFrame <= me.iAnimStepMax) then
    me.iAnimStep = iFrame
    if bDisplay then
      me.calcAnim()
      me.display(1)
    end if
  end if
end

on setScale me, _iScale, bDisplay
  me.iScale = _iScale
  me.createMember()
  if bDisplay then
    me.calcAnim()
    me.display(1)
  end if
end

on getPartColor me, sPart
  return me.aAttributes[sPart][#clr]
end

on setPartColor me, sPart, oColor, bDisplay
  me.aAttributes[sPart][#clr] = oColor
  if bDisplay then
    me.calcAnim()
    me.display(1)
  end if
end

on flipHSpriteRect me, oSprite
  oOrigSpriteRect = oSprite.rect
  iLeft = oOrigSpriteRect.left
  iLocH = oSprite.locH
  iHDif = ((iLocH - iLeft) * 2) - oOrigSpriteRect.width
  rDifRect = rect(iHDif, 0, iHDif, 0)
  oNewRect = oOrigSpriteRect + rDifRect
  return oNewRect
end

on calcViewRect me
  iLeft = me.oPoint.locH - (me.oScaledRect.width / 2)
  iRight = iLeft + me.oScaledRect.width
  iTop = me.oPoint.locV - me.oScaledRect.height
  iBottom = me.oPoint.locV
  return rect(iLeft, iTop, iRight, iBottom)
end

on changeDirection me, iDir
  me.setDirection(iDir)
end

on setDefaultActions me
  me.setBodyAction("std")
  me.setFaceAction("std")
  me.setItemAction("std")
  me.setAnimFrame(0)
  me.calcAnim()
  me.display()
end

on setBodyAction me, sAction
  me.sBodyAction = sAction
  case sAction of
    "std":
      me.stand()
    "wlk":
      me.walk()
    "sit":
      me.sit()
    otherwise:
      me.resetBody()
  end case
  me.setFaceAction(me.sFaceAction)
  me.setItemAction(me.sItemAction)
  me.setAnimFrame(0)
  me.wakeup()
end

on stand me
  me.setPartAction(#bd, "std")
  me.setPartAction(#ch, "std")
  me.setPartAction(#lh, "std")
  me.setPartAction(#rh, "std")
  me.setPartAction(#ls, "std")
  me.setPartAction(#rs, "std")
  me.setPartAction(#lg, "std")
  me.setPartAction(#sh, "std")
  me.setAnimFrame(0)
  me.sBodyAction = "std"
end

on walk me
  me.setPartAction(#bd, "wlk")
  me.setPartAction(#ch, "std")
  me.setPartAction(#lh, "wlk")
  me.setPartAction(#rh, "wlk")
  me.setPartAction(#ls, "wlk")
  me.setPartAction(#rs, "wlk")
  me.setPartAction(#lg, "wlk")
  me.setPartAction(#sh, "wlk")
  me.sBodyAction = "wlk"
end

on sit me
  me.setPartAction(#bd, "sit")
  me.setPartAction(#ch, "std")
  me.setPartAction(#lh, "std")
  me.setPartAction(#rh, "std")
  me.setPartAction(#ls, "sit")
  me.setPartAction(#rs, "std")
  me.setPartAction(#lg, "sit")
  me.setPartAction(#sh, "sit")
  me.sBodyAction = "sit"
end

on isWalking me
  if not me.bDance and (me.sBodyAction = "wlk") then
    return 1
  else
    return 0
  end if
end

on isSitting me
  if me.sBodyAction = "sit" then
    return 1
  else
    return 0
  end if
end

on dance me, bState
  me.bDance = bState
end

on lookStraight me
  me.setLookDirection(0)
end

on lookLeft me
  me.setLookDirection(-1)
end

on lookRight me
  me.setLookDirection(1)
end

on setLookDirection me, iDir
  me.aRuntimeConfig[#hd][#dirOff] = iDir
  me.aRuntimeConfig[#fc][#dirOff] = iDir
  me.aRuntimeConfig[#ey][#dirOff] = iDir
  me.aRuntimeConfig[#hr][#dirOff] = iDir
  me.aRuntimeConfig[#ht][#dirOff] = iDir
end

on setItemAction me, sAction
  if (me.sItemAction <> EMPTY) and (me.sItemAction = sAction) then
    sAction = EMPTY
  end if
  me.sItemAction = sAction
  case sAction of
    "crr":
      me.bCarry = 1
      me.carry()
    "drk":
      me.bDrink = 1
      me.drink()
    otherwise:
      me.resetItem()
  end case
  me.wakeup()
end

on resetItem me
  me.setPartActive("ri", 0)
  me.bCarry = 0
  me.bDrink = 0
end

on carry me
  me.setPartActive("ri", 1)
  me.iCarryTimer = the milliSeconds
end

on drink me
end

on isCarrying me
  return me.bCarry
end

on wakeup me
  me.bSleep = 0
  me.iSleepTimer = the milliSeconds
  me.resetFace()
end

on setFaceAction me, sAction, bStartEmoteTimer
  if me.bSleep then
    me.wakeup()
  end if
  me.sFaceAction = sAction
  case sAction of
    "std":
      me.resetFace()
      me.bEmote = 0
    "spk":
      me.speak()
    "sml":
      me.smile()
      me.bEmote = 1
    "agr":
      me.angry()
      me.bEmote = 1
    "sad":
      me.sad()
      me.bEmote = 1
    "srp":
      me.surprised()
      me.bEmote = 1
    otherwise:
      me.resetFace()
      me.bEmote = 0
  end case
  if me.bEmote then
    if voidp(bStartEmoteTimer) or bStartEmoteTimer then
      me.iEmoteTimer = the milliSeconds
    end if
  end if
end

on resetFace me
  if not me.bChatting then
    me.setPartAction(#hd, "std")
  end if
  if not me.bChatting then
    me.setPartAction(#fc, "std")
  end if
  me.setPartAction(#ey, "std")
  if not me.bChatting then
    me.setPartAction(#hr, "std")
  end if
end

on speak me
  me.setPartAction(#ey, "std")
  me.setPartAction(#hd, "spk")
  me.setPartAction(#fc, "spk")
  me.setPartAction(#hr, "spk")
end

on smile me
  if not me.bChatting then
    me.setPartAction(#hd, "std")
  end if
  if not me.bChatting then
    me.setPartAction(#fc, "sml")
  end if
  me.setPartAction(#ey, "sml")
  if not me.bChatting then
    me.setPartAction(#hr, "std")
  end if
end

on angry me
  if not me.bChatting then
    me.setPartAction(#hd, "std")
  end if
  if not me.bChatting then
    me.setPartAction(#fc, "agr")
  end if
  me.setPartAction(#ey, "agr")
  if not me.bChatting then
    me.setPartAction(#hr, "std")
  end if
end

on sad me
  if not me.bChatting then
    me.setPartAction(#hd, "std")
  end if
  if not me.bChatting then
    me.setPartAction(#fc, "sad")
  end if
  me.setPartAction(#ey, "sad")
  if not me.bChatting then
    me.setPartAction(#hr, "std")
  end if
end

on surprised me
  if not me.bChatting then
    me.setPartAction(#hd, "std")
  end if
  if not me.bChatting then
    me.setPartAction(#fc, "srp")
  end if
  me.setPartAction(#ey, "srp")
  if not me.bChatting then
    me.setPartAction(#hr, "std")
  end if
end

on chat me, sString
  if voidp(sString) or (sString = EMPTY) then
    return 
  end if
  me.iChatTimerLength = sString.length * 100
  me.iChatTimer = the milliSeconds
  me.bChatting = 1
  me.speak()
end

on setDepth me, iDepth
  if voidp(me.iImageSprite) then
    return 
  end if
  sprite(me.iImageSprite).locZ = iDepth + 1
end

on setHeightOffset me, _iHeightOffset
  me.iHeightOffset = _iHeightOffset
end

on getHeightOffset me
  return me.iHeightOffset
end
