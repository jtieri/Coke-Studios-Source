property ancestor, aSineAnimFrames, iSineAnimIndex, iFlickerAnimFrame, aFlickerStates, myID
global oIsoScene

on new me, _sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop
  me.ancestor = script("FurnitureItem").new(_sProdId, _sPosId, _sImageBase, _sType, _sAction, _iState, _aAttributes, _sCastLib, _iRow, _iCol, _iGridY, _iDirection, _iHeight, _iHeightOffset, bItemsAllowedOnTop)
  (the actorList).add(me)
  oIsoScene.oFurniture.addItem(me)
  me.oAction = script("ACTION_" & me.sAction).new(me, me.iState, me.aAttributes)
  myID = _sPosId
  me.setAttributes(_aAttributes)
  return me
end

on setAttributes me, oAttributes
  mycount = getaProp(oAttributes, #counter)
  if not voidp(mycount) then
    myImage = rendercounter(mycount, me.iDirection)
    myMember = member("turnstile_f_0_1_1_" & me.iDirection & "_" & myID)
    if myMember.memberNum < 1 then
      myMember = new(#bitmap, castLib("furniture"))
      myMember.name = "turnstile_f_0_1_1_" & me.iDirection & "_" & myID
      me.loadAssets()
    end if
    myMember.image = myImage
    myMember.regPoint = member("turnstile_f_0_1_1_" & me.iDirection & "_0").regPoint
    if me.iNumFrames < integer(myID) then
      me.iNumFrames = integer(myID)
    end if
    me.setFrame(integer(myID))
  end if
end

on rendercounter whatnum, whatpos
  myLength = length(string(whatnum))
  mytext = EMPTY
  if myLength < 6 then
    repeat with n = 1 to 6 - myLength
      mytext = mytext & "0"
    end repeat
  end if
  mytext = mytext & string(whatnum)
  case whatpos of
    0, 4:
      suffix = "0-4"
      myImage = image(29, 20, 8)
      repeat with n = 1 to length(mytext)
        myMember = member("turnstile_num_" & suffix & "_" & mytext.char[n])
        destcenter = point(2, 3) + point((n - 1) * 5, (n - 1) * 2.5)
        mytop = destcenter.locV - (myMember.rect.height / 2)
        myleft = destcenter.locH - (myMember.rect.width / 2)
        myright = myleft + myMember.rect.width
        mybottom = mytop + myMember.rect.height
        destRect = rect(myleft, mytop, myright, mybottom)
        myImage.copyPixels(myMember.image.duplicate(), destRect, myMember.rect)
      end repeat
    2, 6:
      suffix = "2-6"
      myImage = image(29, 20, 8)
      repeat with n = 1 to length(mytext)
        myMember = member("turnstile_num_" & suffix & "_" & mytext.char[n])
        destcenter = point(2, 16) + point((n - 1) * 5, (n - 1) * -2.5)
        mytop = destcenter.locV - (myMember.rect.height / 2)
        myleft = destcenter.locH - (myMember.rect.width / 2)
        myright = myleft + myMember.rect.width
        mybottom = mytop + myMember.rect.height
        destRect = rect(myleft, mytop, myright, mybottom)
        myImage.copyPixels(myMember.image.duplicate(), destRect, myMember.rect)
      end repeat
  end case
  return myImage
end
