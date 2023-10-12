property pChatSprite, pMargin, pMaxBubbles, pBubblesMargin, pOffscreenImg, pLastUpdate, pNoChatDistance, pFilterChatDistance, pTimeoutobject, UNDEFINED, speak, shout, sing, SWEAR, MUTED
global gFeatureSet

on new me, numSprite, spriteLocz
  me.UNDEFINED = 0
  me.speak = 1
  me.shout = 2
  me.sing = 3
  me.SWEAR = 4
  me.MUTED = 5
  me.pNoChatDistance = 9
  me.pFilterChatDistance = 6
  me.pChatSprite = numSprite
  puppetSprite(me.pChatSprite, 1)
  sprite(me.pChatSprite).member = member("chatimg")
  sprite(me.pChatSprite).ink = 8
  sprite(me.pChatSprite).locZ = spriteLocz
  sprite(me.pChatSprite).rect = member("chatimg").rect
  pMargin = 10
  pMaxBubbles = 5
  pBubblesMargin = 5
  me.showChat()
  return me
end

on showChat me
  me.reset()
  sprite(me.pChatSprite).visible = 1
  updateStage()
  if gFeatureSet.isEnabled(#BETA) then
    oBetaMember = member("_BETA_")
    iBetaSprite = the lastChannel - 2
    puppetSprite(iBetaSprite, 1)
    sprite(iBetaSprite).member = oBetaMember
    sprite(iBetaSprite).locH = 622
    sprite(iBetaSprite).locV = 506
    sprite(iBetaSprite).width = oBetaMember.width
    sprite(iBetaSprite).height = oBetaMember.height
    sprite(iBetaSprite).ink = 36
    sprite(iBetaSprite).locZ = the maxinteger
    sprite(iBetaSprite).visible = 1
    updateStage()
  end if
end

on hideChat me
  sprite(me.pChatSprite).visible = 0
  me.pTimeoutobject.forget()
  if gFeatureSet.isEnabled(#BETA) then
    oBetaMember = member("_BETA_")
    iBetaSprite = the lastChannel - 2
    puppetSprite(iBetaSprite, 0)
    sprite(iBetaSprite).visible = 0
    updateStage()
  end if
end

on displaychat me, sName, sMessage, cColor, pOrigin, iStrength, iDistance
  if stringp(sName) = 0 then
    return -1
  end if
  if stringp(sMessage) = 0 then
    return -2
  end if
  if ilk(cColor) <> #color then
    return -3
  end if
  if ilk(pOrigin) <> #point then
    return -4
  end if
  if iStrength = me.UNDEFINED then
    return -5
  end if
  if integerp(iDistance) = 0 then
    return -6
  end if
  if (iStrength <> me.sing) and (iStrength <> me.shout) then
    if iDistance >= me.pNoChatDistance then
      return -7
    end if
    if iDistance >= me.pFilterChatDistance then
      sMessage = me.filterChat(sMessage)
    end if
  end if
  member("CHATobject.textholder").text = sName & " "
  member("CHATobject.textholder").fontStyle = [#bold]
  member("CHATobject.textholder").fontSize = 10
  member("CHATobject.textholder").font = "Verdana"
  nameTempImage = member("CHATobject.textholder").image
  nameWidth = charPosToLoc(member("CHATobject.textholder"), length(sName) + 1).locH
  nameHeight = member("CHATobject.textholder").height
  nameImage = image(nameWidth, nameHeight, 32)
  nameImage.copyPixels(nameTempImage, nameImage.rect, nameImage.rect)
  member("CHATobject.textholder").text = sMessage & " "
  case iStrength of
    me.speak:
      member("CHATobject.textholder").fontStyle = [#plain]
      member("CHATobject.textholder").fontSize = 10
    me.shout:
      member("CHATobject.textholder").fontStyle = [#bold]
      member("CHATobject.textholder").fontSize = 10
    me.sing:
      member("CHATobject.textholder").fontStyle = [#bold]
      member("CHATobject.textholder").fontSize = 9
    me.WHISPER:
      member("CHATobject.textholder").fontStyle = [#plain]
      member("CHATobject.textholder").fontSize = 9
    otherwise:
      return -5
  end case
  member("CHATobject.textholder").font = "Verdana"
  member("CHATobject.textholder").bgColor = rgb(255, 255, 255)
  msgTempImage = member("CHATobject.textholder").image
  msgWidth = charPosToLoc(member("CHATobject.textholder"), length(sMessage) + 1).locH
  msgHeight = member("CHATobject.textholder").height
  msgImage = image(msgWidth, msgHeight, 32)
  msgImage.copyPixels(msgTempImage, msgImage.rect, msgImage.rect)
  sourceimg = member("cc.bubble.left").image.duplicate()
  bubblename = image(nameImage.width + (pMargin * 2), sourceimg.height, 32)
  bubblename.useAlpha = 1
  bubblename.copyPixels(sourceimg, bubblename.rect, sourceimg.rect, [#bgColor: cColor])
  namedisplacementrect = rect(pMargin, (bubblename.height - nameImage.height) / 2, pMargin, (bubblename.height - nameImage.height) / 2)
  bubblename.copyPixels(nameImage, nameImage.rect + namedisplacementrect, nameImage.rect, [#ink: 36])
  sourceimg = member("cc.bubble.right").image.duplicate()
  bubblemsg = image(msgImage.width + (pMargin * 2), sourceimg.height, 32)
  bubblemsg.useAlpha = 1
  bubblemsg.copyPixels(sourceimg, bubblemsg.rect, sourceimg.rect)
  msgdisplacementrect = rect(pMargin, (bubblemsg.height - msgImage.height) / 2, pMargin, (bubblemsg.height - msgImage.height) / 2)
  bubblemsg.copyPixels(msgImage, msgImage.rect + msgdisplacementrect, msgImage.rect, [#ink: 36])
  bubble = image(bubblename.width + bubblemsg.width, bubblemsg.height, 32)
  bubble.useAlpha = 1
  bubble.copyPixels(bubblename, bubblename.rect, bubblename.rect)
  bubble.copyPixels(bubblemsg, rect(bubblename.width, 0, bubble.width, bubble.height), bubblemsg.rect)
  tempOffscreenImg = image(pOffscreenImg.width, pOffscreenImg.height + pBubblesMargin + bubble.height, 32)
  tempOffscreenImg.useAlpha = 1
  tempOffscreenImg.setAlpha(0)
  if (pOrigin.locH - (bubble.width / 2)) < 0 then
    myRect = rect(0, tempOffscreenImg.height - bubble.height, bubble.width, tempOffscreenImg.height)
  else
    if (pOrigin.locH + (bubble.width / 2)) > (the stage).rect.width then
      myRect = rect(tempOffscreenImg.width - bubble.width, tempOffscreenImg.height - bubble.height, tempOffscreenImg.width, tempOffscreenImg.height)
    else
      myRect = rect(pOrigin.locH - (bubble.width / 2), tempOffscreenImg.height - bubble.height, pOrigin.locH + (bubble.width / 2), tempOffscreenImg.height)
    end if
  end if
  tempOffscreenImg.copyPixels(pOffscreenImg, pOffscreenImg.rect, pOffscreenImg.rect)
  tempOffscreenImg.copyPixels(bubble, myRect, bubble.rect)
  pOffscreenImg = tempOffscreenImg.duplicate()
  pLastUpdate = the milliSeconds
  return 0
end

on filterChat me, sMessage
  aFilter = [1, 0, 1, 0, 1]
  sNewMessage = EMPTY
  iCount = sMessage.chars.count
  repeat with i = 1 to iCount
    sChar = sMessage.char[i]
    bFilter = aFilter[random(aFilter.count)]
    if bFilter then
      sNewMessage = sNewMessage & "."
      next repeat
    end if
    sNewMessage = sNewMessage & sChar
  end repeat
  return sNewMessage
end

on errormessage errornum
  case errornum of
    0:
      return "OK"
    (-1):
      return "Name string invalid"
    (-2):
      return "Message string invalid"
    (-3):
      return "Color value invalid"
    (-4):
      return "Origin point invalid"
    (-5):
      return "Strength string invalid"
    (-6):
      return "Distance integer invalid"
    otherwise:
      return "unknown error"
  end case
end

on update me
  if pOffscreenImg <> member("chatimg").image then
    tempbuffer = image(pOffscreenImg.width, pOffscreenImg.height - 28, 32)
    tempbuffer.useAlpha = 1
    tempbuffer.copyPixels(pOffscreenImg, tempbuffer.rect, tempbuffer.rect + rect(0, 28, 0, 28))
    pOffscreenImg = tempbuffer.duplicate()
    destimg = member("chatimg").image
    destimg.copyPixels(pOffscreenImg, destimg.rect, destimg.rect)
  end if
  if (the milliSeconds - pLastUpdate) >= 60000 then
    tempOffscreenImg = image(pOffscreenImg.width, pOffscreenImg.height + pBubblesMargin + member("cc.bubble.right").height, 32)
    tempOffscreenImg.useAlpha = 1
    tempOffscreenImg.setAlpha(0)
    tempOffscreenImg.copyPixels(pOffscreenImg, pOffscreenImg.rect, pOffscreenImg.rect)
    pOffscreenImg = tempOffscreenImg.duplicate()
    pLastUpdate = the milliSeconds
  end if
end

on reset me
  me.pTimeoutobject = timeout("intervalTimer").new(33, #update, me)
  pLastUpdate = the milliSeconds
  defaultchatimg = image((the stage).rect.width, (pMaxBubbles * member("cc.bubble.right").height) + ((pMaxBubbles - 1) * pBubblesMargin), 32)
  defaultchatimg.useAlpha = 1
  defaultchatimg.setAlpha(0)
  member("chatimg").image = defaultchatimg
  sprite(me.pChatSprite).loc = point((the stage).rect.width / 2, defaultchatimg.height / 2)
  pOffscreenImg = defaultchatimg.duplicate()
end
