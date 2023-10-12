property sPartCast, sAvatarCast, iWidth, iHeight, iColorDepth, iAlphaDepth, iDefaultInk, sDefaultString, aAttributes, aConfigSettings, aRuntimeConfig, aDirectionMap, aDrawOrder, aDefDrawOrder, iDirection, aCurrDrawSettings, oPoint, iScale, iShadowSprite, iImageSprite, iAnimStep, iAnimStepMax, sBodyAction, sFaceAction, sItemAction, iFPS, iFPSTimer, iFPSTimerLength, bBlink, iBlinkTimer, iBlinkTimerLength, bChatting, iChatTimer, iChatTimerLength, bEmote, iEmoteTimer, iEmoteTimerLength, bDance, aDanceOverride, bCarry, bDrink, iDrinkTimer, iDrinkTimerLength, iDrinkWaitTimerLength, iDrinkActionTimerLength, bSleep, iSleepTimer, iSleepTimerLength, oImageMember, oBuffer, aSourceImages, bUseSprites, oBufferBGColor, oSpriteBgColor, iSpriteInk, oPreviewImage, iHeightOffset, iDither, bDoFloodFill, iDrawTime, iDrawCount, iDisplayTime, iDisplayCount, iFrameTime, iFrameCount, bDisplayStatus, bMove, bMoving, iStepsToNextSquare, iStepsTravelled, pCurrentSquareLoc, pNextSquareLoc, oCurrentSquare, oNextSquare, aStepSizes, bOnSled, oSled, aSleds, aDirectionPointVectors, iCollisionWidth, iCollisionHeight, oStartSquare, iToolCarried, iToolSprite, bPaused, bFlash, iFlashSpeed, iFlashTimer, iFlashTimerLength, oFlashImage, oFlashImageGood, oFlashImageBad
global oStudioMap, oSpriteManager, iSledTrackValue, iBotSquareValue, bDebugCollision, oTextConstants, oIsoScene, oMapObject, oComputer, oAvatar

on new me, _sAttributes, _iScale, _bPreviewOnly
  me.iCollisionWidth = 10
  me.iCollisionHeight = 50
  me.bOnSled = 0
  me.oSled = VOID
  me.aSleds = []
  me.iStepsToNextSquare = 4.0
  me.iStepsTravelled = 0
  me.aStepSizes = [point(0, 0), point(0, 0), point(0, 0), point(0, 0), point(0, 0), point(0, 0), point(0, 0), point(0, 0)]
  distFrac = 1 / me.iStepsToNextSquare
  me.aStepSizes[1] = distFrac * (oIsoScene.oGrid.aSquares[1][2].oViewCenter - oIsoScene.oGrid.aSquares[2][2].oViewCenter)
  me.aStepSizes[5] = distFrac * (oIsoScene.oGrid.aSquares[2][2].oViewCenter - oIsoScene.oGrid.aSquares[1][2].oViewCenter)
  me.aStepSizes[7] = distFrac * (oIsoScene.oGrid.aSquares[2][1].oViewCenter - oIsoScene.oGrid.aSquares[2][2].oViewCenter)
  me.aStepSizes[3] = distFrac * (oIsoScene.oGrid.aSquares[2][2].oViewCenter - oIsoScene.oGrid.aSquares[2][1].oViewCenter)
  me.aDirectionPointVectors = [0: point(-1, 0), 2: point(0, 1), 4: point(1, 0), 6: point(0, -1)]
  me.bDisplayStatus = 0
  me.bFlash = 0
  me.iFlashSpeed = 125
  me.iFlashTimer = the milliSeconds
  me.iFlashTimerLength = 2000
  me.oFlashImage = image(1, 1, 16)
  me.oFlashImage.fill(me.oFlashImage.rect, rgb(0, 0, 0))
  me.oFlashImageGood = image(1, 1, 16)
  me.oFlashImageGood.fill(me.oFlashImage.rect, rgb(0, 255, 0))
  me.oFlashImageBad = image(1, 1, 16)
  me.oFlashImageBad.fill(me.oFlashImage.rect, rgb(255, 0, 0))
  me.sPartCast = "people"
  me.sAvatarCast = "gamecode"
  me.iWidth = 77.0
  me.iHeight = 110.0
  me.iScale = 58
  me.iDirection = 4
  me.bPaused = 1
  me.oPoint = point(90, 275)
  if the platform contains "windows" then
    me.iColorDepth = 32
  else
    me.iColorDepth = 32
  end if
  me.iAlphaDepth = 0
  me.iDefaultInk = 41
  me.aSourceImages = [:]
  me.oSpriteBgColor = rgb(100, 100, 100)
  me.oBufferBGColor = rgb(100, 100, 100)
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
  me.iToolSprite = oSpriteManager.checkOutSprite()
  me.bDrink = 0
  me.iDrinkTimer = the milliSeconds
  me.iDrinkWaitTimerLength = 5000
  me.iDrinkActionTimerLength = 400
  me.iDrinkTimerLength = me.iDrinkWaitTimerLength
  me.bSleep = 0
  me.iSleepTimer = the milliSeconds
  me.iSleepTimerLength = 300000
  me.setDefaultString()
  me.setAttributes(_sAttributes)
  me.setConfigSettings()
  me.setRuntimeConfig()
  me.setDirectionMap()
  me.aDefDrawOrder = [#lh, #ls, #bd, #sh, #lg, #ch, #ri, #rh, #rs, #hd, #fc, #ey, #hr, #ht]
  me.setDrawOrder()
  me.setDanceOverride()
  me.iDither = 0
  me.setFloodFill(_bPreviewOnly)
  me.createBuffer()
  me.setScale(me.iScale)
  me.iHeightOffset = 0
  me.draw()
  me.oPreviewImage = me.oBuffer.duplicate()
  return me
end

on getDirectionPoint me, dirVal
  return me.aDirectionPointVectors.getProp(symbol(string(dirVal)))
end

on startFlash me, iFlashTime, isGood
  me.bFlash = 1
  me.iFlashTimer = the milliSeconds
  me.iFlashTimerLength = iFlashTime
  if isGood then
    me.oFlashImage = me.oFlashImageGood
  else
    me.oFlashImage = me.oFlashImageBad
  end if
end

on stopFlash me
  me.bFlash = 0
end

on getFlashing me
  return me.bFlash
end

on enterSled me, theSled
  me.bOnSled = 1
  me.oSled = theSled
  me.oNextSquare = me.oSled
end

on exitSled me
  me.bOnSled = 0
  me.oSled = VOID
end

on getCollisionRect me
  return rect(me.getLoc() - point(me.iCollisionWidth / 2, me.iCollisionHeight), me.getLoc() + point(me.iCollisionWidth / 2, 0))
end

on setFloodFill me, _bPreviewOnly
  me.bDoFloodFill = 0
  if _bPreviewOnly then
    me.bDoFloodFill = 0
    me.oBufferBGColor = me.oSpriteBgColor
    return 
  end if
  if not voidp(oStudioMap) then
    if oStudioMap.isPrivate() then
      me.bDoFloodFill = 0
      me.oBufferBGColor = me.oSpriteBgColor
    else
      me.bDoFloodFill = 1
    end if
  else
    me.bDoFloodFill = 0
    me.oBufferBGColor = me.oSpriteBgColor
  end if
end

on getFPS me
  return me.iFPS
end

on initSprites me, _iImageSprite, _iShadowSprite
  me.iImageSprite = _iImageSprite
  me.iShadowSprite = _iShadowSprite
  me.createMember()
  me.createSprites()
end

on getPreviewImage me
  return me.oPreviewImage
end

on end me
end

on createBuffer me
  me.oBuffer = image(me.iWidth, me.iHeight + 20, me.iColorDepth, me.iAlphaDepth)
  me.oBuffer.fill(me.oBuffer.rect, me.oBufferBGColor)
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

on createSprites me
  puppetSprite(me.iImageSprite, 1)
  sprite(me.iImageSprite).member = me.oImageMember
  if me.bDoFloodFill then
    sprite(me.iImageSprite).bgColor = me.oSpriteBgColor
  else
    sprite(me.iImageSprite).bgColor = me.oBufferBGColor
  end if
  sprite(me.iImageSprite).ink = me.iSpriteInk
  puppetSprite(me.iShadowSprite, 1)
  sShadowMember = "human_shadow_sh"
  if not voidp(oStudioMap) then
    if oStudioMap.isPrivate() then
      sShadowMember = "human_shadow_h"
    end if
  end if
  sprite(me.iShadowSprite).member = member(sShadowMember)
end

on getBuffer me
  return me.oBuffer
end

on setDefaultString me
  me.sDefaultString = "hr=008/115,61,17&hd=001/153,126,99&ey=006/238,238,238&fc=002/153,126,99&bd=001/153,126,99&lh=001/153,126,99&rh=001/153,126,99&ch=004/238,153,0&ls=001/238,60,47&rs=001/238,60,47&lg=001/97,120,85&sh=001/51,25,25"
  me.sDefaultString = me.fishifyAvatarString(me.sDefaultString)
end

on fishifyAvatarString me, sOriginalString
  flo = newObject("Object")
  flo.s = newObject("String", sOriginalString)
  flo.a = flo.s.split("&")
  colorString = EMPTY
  isBoy = 0
  repeat with i = 0 to flo.a.length - 1
    if flo.a[i].char[1..2] = "lg" then
      partString = newObject("String", flo.a[i])
      colorString = partString.split("/")[1]
      next repeat
    end if
    if flo.a[i].char[1..6] = "bd=001" then
      isBoy = 1
    end if
  end repeat
  repeat with i = 0 to flo.a.length - 1
    bodyPart = flo.a[i].char[1..2]
    case bodyPart of
      "hr", "ey":
      "sh":
        flo.a[i] = flo.a[i].char[1..3] & "000" & flo.a[i].char[7..flo.a[i].length]
      "hd", "fc", "bd", "lh", "rh":
      "lg":
        if isBoy then
          flo.a[i] = flo.a[i].char[1..3] & "101/" & colorString
        else
          flo.a[i] = flo.a[i].char[1..3] & "100/" & colorString
        end if
    end case
  end repeat
  sOutString = flo.a.join("&")
  return sOutString
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
  me.aAttributes["ri"] = [#prtCd: "003", #clr: color(#rgb, 255, 255, 255)]
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
end

on setDirectionMap me
  me.aDirectionMap = [0: 6, 1: 5, 2: 4, 3: 7, 4: 2, 5: 1, 6: 0, 7: 3]
end

on setDrawOrder me
  case me.iDirection of
    2:
      me.aDrawOrder = [#bd, #sh, #lg, #lh, #ls, #ch, #hd, #fc, #ey, #ri, #rh, #rs, #hr]
    3:
      me.aDrawOrder = [#bd, #sh, #lg, #ch, #lh, #ls, #hd, #fc, #ey, #ri, #rh, #rs, #hr]
    4:
      me.aDrawOrder = [#bd, #sh, #lg, #lh, #ls, #ch, #hd, #fc, #ey, #ri, #rh, #rs, #hr]
    6, 7, 0:
      me.aDrawOrder = [#lh, #ls, #bd, #sh, #lg, #ch, #ri, #rh, #rs, #hd, #hr, #ht]
    otherwise:
      me.aDrawOrder = me.aDefDrawOrder
  end case
end

on stepFrame me
  if me.iFPS > 0 then
    iElapsedTime = the milliSeconds - me.iFPSTimer
    if iElapsedTime >= me.iFPSTimerLength then
      me.doFrameEvent()
      return 1
    end if
  end if
  return 0
end

on pauseMachine me, bPauseValue
  me.bPaused = bPauseValue
end

on displayDrawStatus me
  sStatus = EMPTY
  sStatus = sStatus & "DRAW TIME: " & me.iDrawTime & RETURN
  sStatus = sStatus & "DRAW COUNT: " & me.iDrawCount & RETURN
  sStatus = sStatus & "DISPLAY TIME: " & me.iDisplayTime & RETURN
  sStatus = sStatus & "DISPLAY COUNT: " & me.iDisplayCount & RETURN
  sStatus = sStatus & "FRAME TIME: " & me.iFrameTime & RETURN
  sStatus = sStatus & "FRAME COUNT: " & me.iFrameCount & RETURN
  member("DrawStatus").text = sStatus
end

on setUserCommand me, whichKey
  if not me.bPaused then
    ks = [126, -1, 124, -1, 125, -1, 123]
    newdir = ks.getPos(the keyCode) - 1
    newdir = ks.getPos(whichKey) - 1
    if newdir <> -1 then
      if not (((newdir = 2) or (newdir = 6)) and me.bOnSled) then
        me.iDirection = newdir
        me.bMove = 1
        me.iStepsTravelled = 1
        me.pCurrentSquareLoc = point(me.getCurrentSquare().iRow, me.getCurrentSquare().iCol)
        me.pNextSquareLoc = me.pCurrentSquareLoc + me.getDirectionPoint(me.iDirection)
        thisGridVal = oMapObject.oGridVals[me.pNextSquareLoc[1]][me.pNextSquareLoc[2]]
        if (thisGridVal = iSledTrackValue) or (thisGridVal = -1) then
          me.oNextSquare = me.oCurrentSquare
        else
          me.setNextSquare(me.pNextSquareLoc[1], me.pNextSquareLoc[2])
        end if
      end if
      if me.bOnSled and ((newdir = 0) or (newdir = 4)) then
        me.exitSled()
      end if
      repeat with i = 1 to me.aSleds.count
        if ((me.pNextSquareLoc.locH = me.aSleds[i].iRow) or (me.pNextSquareLoc.locH = (me.aSleds[i].iRow + me.aSleds[i].iDirection))) and (oMapObject.oGridVals[me.pNextSquareLoc[1]][me.pNextSquareLoc[2]] = (iSledTrackValue + 1)) then
          me.enterSled(me.aSleds[i])
        end if
      end repeat
    end if
  end if
end

on evaluateUserCommand me
  if (me.iStepsTravelled = 0) or (me.iStepsTravelled = integer(me.iStepsToNextSquare)) then
    me.iStepsTravelled = 0
    sprite(iImageSprite).locZ = (me.getCurrentSquare().iRow * 100) + me.getCurrentSquare().iCol + 1
    me.bMove = 0
    if keyPressed(123) then
      me.setUserCommand(123)
    else
      if keyPressed(124) then
        me.setUserCommand(124)
      else
        if keyPressed(125) then
          me.setUserCommand(125)
        else
          if keyPressed(126) then
            me.setUserCommand(126)
          else
            me.oNextSquare = me.oCurrentSquare
            me.stand()
          end if
        end if
      end if
    end if
    if me.bMove then
      thisGridVal = oMapObject.oGridVals[me.pNextSquareLoc[1]][me.pNextSquareLoc[2]]
      if (thisGridVal = iSledTrackValue) or (thisGridVal = -1) then
        me.pCurrentSquareLoc = point(me.getCurrentSquare().iRow, me.getCurrentSquare().iCol)
        me.pNextSquareLoc = me.pCurrentSquareLoc
      end if
    end if
    if me.oNextSquare = me.oCurrentSquare then
      me.setLoc(me.oCurrentSquare.calcViewCenter())
      updateStage()
    end if
  else
    me.iStepsTravelled = me.iStepsTravelled + 1
  end if
  me.doUserMove()
  if oMapObject.oGridVals[me.oCurrentSquare.iRow][me.oCurrentSquare.iCol] = 175 then
    iToolNum = me.oCurrentSquare.iCol - 9
    if oComputer.getToolOnTable(iToolNum) then
      if keyPressed(49) or (keyPressed(125) and not oComputer.getInteractingWithUser()) then
        me.pickUpTool(iToolNum)
      else
        iToolNum = me.oCurrentSquare.iCol - 9
        oComputer.hiliteTool(iToolNum)
      end if
      return 
    else
      oComputer.hiliteTool(0)
      return 
    end if
  else
    oComputer.hiliteTool(0)
  end if
  if oMapObject.oGridVals[me.oCurrentSquare.iRow][me.oCurrentSquare.iCol] = 180 then
    if keyPressed(49) or (keyPressed(126) and not oComputer.getInteractingWithUser()) then
      oComputer.matchTool()
      put "TODO: MATCH TOOL COMPUTER CALL"
      me.setDirection(0)
    end if
    return 
  else
    return 
  end if
end

on getToolCarried me
  return me.iToolCarried
end

on setToolCarried me, iTool
  me.iToolCarried = iTool
end

on carryTool me
  puppetSprite(me.iToolSprite, 1)
  if (me.iDirection = 6) or (me.iDirection = 0) then
    sprite(me.iToolSprite).member = member("Tool_" & "1" & "_" & me.iDirection)
    sprite(me.iToolSprite).locZ = sprite(me.iImageSprite).locZ - 1
  else
    sprite(me.iToolSprite).member = member("Tool_" & me.iToolCarried & "_" & me.iDirection)
    sprite(me.iToolSprite).locZ = sprite(me.iImageSprite).locZ + 1
  end if
  sprite(me.iToolSprite).ink = 36
  sprite(me.iToolSprite).loc = me.getLoc()
end

on pickUpTool me, iToolNum
  me.setDirection(4)
  if me.bCarry then
    oComputer.dropOffTool(me.iToolCarried)
  end if
  oComputer.pickUpTool(iToolNum)
  me.bCarry = 1
  me.setToolCarried(iToolNum)
  me.carryTool()
end

on dropTool me
  me.bCarry = 0
  me.setToolCarried(0)
  sprite(me.iToolSprite).loc = point(-500, -500)
end

on doUserMove me
  if not (me.oNextSquare = me.oCurrentSquare) then
    me.setDirection(me.iDirection, 1)
    currentLoc = me.getCurrentSquare().calcViewCenter()
    nextLoc = me.getNextSquare().calcViewCenter()
    changeLoc = me.aStepSizes[me.iDirection + 1]
    pNextStepTaken = me.getLoc() + changeLoc
    pNextStepTaken = currentLoc + ((nextLoc - currentLoc) * (1.0 * me.iStepsTravelled) / me.iStepsToNextSquare)
    me.setLoc(pNextStepTaken)
    bDraw = 1
    me.walk()
    if me.iStepsTravelled = integer(me.iStepsToNextSquare) then
      if me.bOnSled then
        me.oCurrentSquare = me.oNextSquare
      else
        me.setCurrentSquare(me.pNextSquareLoc[1], me.pNextSquareLoc[2])
      end if
    end if
  end if
end

on doFrameEvent me
  if bDebugCollision then
    cSprite = me.iImageSprite + 100
    puppetSprite(cSprite, 1)
    sprite(cSprite).member = member("testbox")
    sprite(cSprite).blend = 50
    sprite(cSprite).rect = me.getCollisionRect()
    sprite(cSprite).locZ = 10000
  end if
  bDraw = 1
  me.bMove = 0
  me.evaluateUserCommand()
  me.bMove = 1
  me.bMoving = 1
  iStartTime = the milliSeconds
  bAnim = me.calcAnim()
  if bDraw or bAnim or me.bMove or me.bOnSled then
    me.display()
    me.iFrameTime = the milliSeconds - iStartTime
    me.iFrameCount = iFrameCount + 1
  end if
  me.advanceAnimFrame()
  me.iFPSTimer = the milliSeconds
  updateStage()
end

on advanceAnimFrame me
  if me.iAnimStep = me.iAnimStepMax then
    me.iAnimStep = 0
  else
    me.iAnimStep = me.iAnimStep + 1
  end if
end

on calcAnim me
  bDrawAnim = 0
  if me.isWalking() or me.bDance then
    repeat with i = 1 to me.aRuntimeConfig.count
      sPart = me.aRuntimeConfig.getPropAt(i)
      aPartConfig = me.aRuntimeConfig[sPart]
      sAction = aPartConfig[#act]
      bAnim = aPartConfig[#anim]
      if bAnim then
        bDrawAnim = 1
        aAnimFrames = me.aConfigSettings[sPart][sAction][#fr]
        if aAnimFrames.getPos(me.iAnimStep mod 4) > 0 then
          me.aRuntimeConfig[sPart][#animIndex] = me.iAnimStep mod 4
        end if
      end if
    end repeat
  end if
  return bDrawAnim
end

on draw me, bForce
  iStartTime = the milliSeconds
  aDrawSettings = me.getDrawSettings()
  me.oBuffer.fill(me.oBuffer.rect, me.oBufferBGColor)
  me.aCurrDrawSettings = aDrawSettings
  repeat with i in aDrawSettings
    me.drawPart(i)
  end repeat
  me.iDrawTime = the milliSeconds - iStartTime
  me.iDrawCount = me.iDrawCount + 1
end

on display me, bForce
  iStartTime = the milliSeconds
  me.draw()
  if voidp(me.oImageMember) then
    return 
  end if
  if me.getFlashing() then
    iElapsedTime = the milliSeconds - me.iFlashTimer
    if iElapsedTime >= me.iFlashTimerLength then
      me.stopFlash()
    else
      if (integer(float(iElapsedTime) / me.iFlashSpeed) mod 2) = 0 then
        me.oBuffer.copyPixels(me.oFlashImage, me.oBuffer.rect, rect(0, 0, 1, 1), [#blend: 50])
        put me.oSpriteBgColor
        me.oBuffer.floodFill(point(1, 1), me.oSpriteBgColor)
        me.oBuffer.floodFill(point(1, 1), rgb(100, 100, 100))
      end if
    end if
  end if
  me.oImageMember.image.copyPixels(me.oBuffer, me.oBuffer.rect * (me.iScale * 0.01), me.oBuffer.rect, [#dither: me.iDither])
  if me.bDoFloodFill then
    me.oImageMember.image.floodFill(point(1, 1), me.oSpriteBgColor)
  end if
  me.iDisplayTime = the milliSeconds - iStartTime
  me.iDisplayCount = me.iDisplayCount + 1
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
  aParams[#dither] = me.iDither
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
  sPart = prt
  aConfig = me.aRuntimeConfig[sPart]
  if aConfig = VOID then
    return VOID
  end if
  sPartCode = me.aAttributes[prt][#prtCd]
  if sPartCode = "000" then
    return VOID
  end if
  bActive = aConfig[#Active]
  if not bActive then
    return VOID
  end if
  aDanceSetting = me.aDanceOverride[sPart]
  sID = "h"
  sAction = aConfig[#act]
  if me.bDance and (me.sBodyAction = "std") then
    if not voidp(aDanceSetting) then
      aDanceParts = aDanceSetting[#prts]
      if not voidp(aDanceParts) then
        sAction = aDanceParts[me.iAnimStep + 1][#act]
      end if
    end if
  end if
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
    sAction = "crr"
  end if
  if me.bCarry then
    if (sPart = #rh) or (sPart = #rs) or (sPart = #lh) or (sPart = #ls) then
      sAction = "crr"
      iFrame = 0
    end if
    me.carryTool()
  else
    sprite(me.iToolSprite).loc = point(-500, -500)
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

on doCollision me, sCollisionMessage, sSoundType
  if not me.getFlashing() then
    oComputer.oTimer.stopTiming()
    me.pauseMachine(1)
    sendAllSprites(#pauseMachine, 1)
    oComputer.decrementLives(1)
    case sSoundType of
      "hit":
        oMember = member("metlcrs1")
        sound(oSpriteManager.iEffectSound).volume = 235
      "cook":
        oMember = member("shock")
        sound(oSpriteManager.iEffectSound).volume = 200
      "bot":
        oMember = member("Boing002")
        sound(oSpriteManager.iEffectSound).volume = 200
      otherwise:
        oMember = member("metlcrs1")
        sound(oSpriteManager.iEffectSound).volume = 235
    end case
    sound(oSpriteManager.iEffectSound).pan = 0
    sound(oSpriteManager.iEffectSound).play(oMember)
    if oComputer.getLives() > 0 then
      sTheCollisionMessage = oTextConstants.getCollisionMessage(sCollisionMessage, oComputer.getLives())
      sendAllSprites(#showAlert, sTheCollisionMessage)
      script("_TIMER_").new(3000, #callForToolAfterCollision, oComputer)
    else
      sTheCollisionMessage = oTextConstants.getCollisionMessage(sCollisionMessage, oComputer.getLives())
      sendAllSprites(#showAlert, sTheCollisionMessage)
      script("_TIMER_").new(3000, #gameOver, oComputer)
    end if
  end if
end

on resetPositionToStart me
  me.setLoc(point(-500, -500))
  updateStage()
  me.setDirection(4)
  me.oCurrentSquare = me.oStartSquare
  me.oNextSquare = me.oStartSquare
  me.pCurrentSquareLoc = point(me.oStartSquare.iRow, me.oStartSquare.iCol)
  me.pNextSquareLoc = point(me.oStartSquare.iRow, me.oStartSquare.iCol)
  sprite(iImageSprite).locZ = (me.getCurrentSquare().iRow * 100) + me.getCurrentSquare().iCol + 1
  me.stand()
  if me.bCarry then
    oComputer.dropOffTool(me.iToolCarried)
    me.dropTool()
  end if
end

on setStartSquare me, theRow, theCol
  me.oStartSquare = oIsoScene.oGrid.aSquares[theRow][theCol]
  me.oCurrentSquare = me.oStartSquare
  me.oNextSquare = me.oStartSquare
  me.pCurrentSquareLoc = point(theRow, theCol)
  me.pNextSquareLoc = point(theRow, theCol)
  me.oCurrentSquare = oIsoScene.oGrid.aSquares[30][30]
  me.pCurrentSquareLoc = point(30, 30)
  me.pNextSquareLoc = point(30, 30)
end

on getStartSquare me
  return me.oStartSquare
end

on setCurrentSquare me, theRow, theCol
  me.oCurrentSquare = oIsoScene.oGrid.aSquares[theRow][theCol]
  me.pCurrentSquareLoc = point(theRow, theCol)
end

on setNextSquare me, theRow, theCol
  me.oNextSquare = oIsoScene.oGrid.aSquares[theRow][theCol]
  me.pNextSquareLoc = point(theRow, theCol)
end

on getCurrentSquare me
  return me.oCurrentSquare
end

on getCurrentSquareForCollision me
  if me.iStepsTravelled <= integer(me.iStepsToNextSquare / 2) then
    return me.oCurrentSquare
  else
    return me.oNextSquare
  end if
end

on getNextSquare me
  return me.oNextSquare
end

on setLoc me, oLoc
  me.oPoint = oLoc
  if voidp(me.iImageSprite) then
    return 
  end if
  sprite(me.iImageSprite).locH = me.oPoint.locH
  sprite(me.iImageSprite).locV = me.oPoint.locV - me.iHeightOffset
  if voidp(me.iShadowSprite) then
    return 
  end if
  sprite(me.iShadowSprite).loc = me.oPoint
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
end

on getPartActive me, sPart
  return me.aRuntimeConfig[sPart][#Active]
end

on setPartCode me, sPart, sPartCode, bDisplay
  me.aAttributes[sPart][#prtCd] = sPartCode
end

on getPartCode me, sPart
  return me.aAttributes[sPart][#prtCd]
end

on setPartAction me, sPart, sAct, bDisplay
  me.aRuntimeConfig[sPart][#act] = sAct
end

on getPartAction me, sPart
  return me.aRuntimeConfig[sPart][#act]
end

on setDirection me, iDir, bDisplay
  if voidp(iDir) then
    iDir = 2
  end if
  if me.iDirection = iDir then
    return 
  end if
  me.iDirection = iDir
  me.setDrawOrder()
  me.display()
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
end

on setAnimFrame me, iFrame, bDisplay
  if (iFrame >= 0) and (iFrame <= me.iAnimStepMax) then
    me.iAnimStep = iFrame
  end if
end

on setScale me, _iScale, bDisplay
  me.iScale = _iScale
  me.createMember()
end

on getPartColor me, sPart
  return me.aAttributes[sPart][#clr]
end

on setPartColor me, sPart, oColor, bDisplay
  me.aAttributes[sPart][#clr] = oColor
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
  me.display()
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
  me.display()
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
  me.display()
end

on sit me
  me.setPartAction(#bd, "sit")
  me.setPartAction(#ch, "std")
  me.setPartAction(#lh, "std")
  me.setPartAction(#rh, "std")
  me.setPartAction(#ls, "std")
  me.setPartAction(#rs, "std")
  me.setPartAction(#lg, "sit")
  me.setPartAction(#sh, "sit")
  me.sBodyAction = "sit"
  me.display()
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
  me.display()
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
  me.display()
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

on setDepth me, iDepth, iShadowDepth
  if voidp(me.iImageSprite) then
    return 
  end if
  sprite(me.iImageSprite).locZ = iDepth + 1
  if voidp(me.iShadowSprite) then
    return 
  end if
  sprite(me.iShadowSprite).locZ = iShadowDepth
end

on setHeightOffset me, _iHeightOffset
  me.iHeightOffset = _iHeightOffset
end

on getHeightOffset me
  return me.iHeightOffset
end

on destroy me
  (the actorList).deleteOne(me)
  sprite(me.iImageSprite).member = VOID
  sprite(me.iShadowSprite).member = VOID
  oAvatar = VOID
  me = VOID
end
