property pSprite, aCallAlertList, aCallList, aAlertList, pCallAlertList, iCallAlertNum, iCallAlertTotalNum, pDisplayIndexSprite, pPublicStudioData, pTime, pInterval, pStudioID, bDebug, bSoundOn, iCallID, aDeletedIDList
global oCallAlertDisplayManager, oUserDisplayManager, oStudioManager, oDenizenManager

on beginSprite me
  me.bDebug = 1
  pSprite = sprite(me.spriteNum)
  pSprite.member.text = EMPTY
  oCallAlertDisplayManager = me
  aCallAlertList = []
  aCallList = []
  aAlertList = []
  pCallAlertList = aCallAlertList
  pTime = the timer
  pInterval = pInterval * 60
  me.iCallAlertNum = 0
  me.bSoundOn = 1
end

on addDeletedID me, iThisCallID
  put "addDeletedID() " & iThisCallID
  if voidp(me.aDeletedIDList) then
    me.aDeletedIDList = []
  end if
  if me.aDeletedIDList.getOne(iThisCallID) = 0 then
    me.aDeletedIDList.add(iThisCallID)
  end if
end

on isDeletedID me, iThisCallID
  put "isDeletedID() " & iThisCallID
  if voidp(me.aDeletedIDList) then
    me.aDeletedIDList = []
  end if
  if me.aDeletedIDList.getPos(iThisCallID) > 0 then
    return 1
  end if
  return 0
end

on filterDeletedIDs me, aList
  aNewList = []
  repeat with aCallAlert in aList
    iThisCallID = aCallAlert[#callID]
    if me.isDeletedID(iThisCallID) then
      next repeat
      next repeat
    end if
    aNewList.add(aCallAlert)
  end repeat
  return aNewList
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "oCallAlertDisplayManager: " & sMessage
  end if
end

on displayCallAlert me, aList
  me.debug("displayCallAlert:aList" && aList)
  me.iCallAlertTotalNum = aList.count
  if me.iCallAlertTotalNum = 0 then
    me.iCallAlertNum = 0
    sString = EMPTY
  else
    if me.iCallAlertNum = 0 then
      me.iCallAlertNum = 1
    else
      if me.iCallAlertNum > me.iCallAlertTotalNum then
        me.iCallAlertNum = me.iCallAlertTotalNum
      end if
    end if
    if aList[me.iCallAlertNum].isAlert then
      sAlertString = "Automatically generated warning"
    else
      if aList[me.iCallAlertNum].isPickedUp then
        sAlertString = "Call for assistance" && "(picked by:" && modLookUp(aList[me.iCallAlertNum].pickedUpBy) & ")"
      else
        sAlertString = "Call for assistance"
      end if
    end if
    sUserName = "User:" && aList[me.iCallAlertNum].screenName
    sStudioNameOwner = "Studio:" && aList[me.iCallAlertNum].studioName && "[" & aList[me.iCallAlertNum].studioOwner & "]"
    sMessage = aList[me.iCallAlertNum].message
  end if
  sString = sAlertString & RETURN & sUserName & RETURN & sStudioNameOwner & RETURN & sMessage
  pSprite.member.text = sString
  oCallAlertDisplayManager.pDisplayIndexSprite.displayIndex(me.iCallAlertNum, me.iCallAlertTotalNum)
  if me.iCallAlertTotalNum > 0 then
    sScreenName = aList[me.iCallAlertNum].screenName
    sStudioName = aList[me.iCallAlertNum].studioName
    sStudioOwner = aList[me.iCallAlertNum].studioOwner
    oUserDisplayManager.displayExtendedUserInfo(sScreenName, sStudioName, sStudioOwner, 1)
  end if
end

on replaceCallAlertData me, aCallAlertData
  repeat with i = 1 to me.aCallAlertList.count
    if me.aCallAlertList[i].callID = aCallAlertData.callID then
      me.aCallAlertList[i] = aCallAlertData
      exit repeat
    end if
  end repeat
  repeat with i = 1 to me.aCallList.count
    if me.aCallList[i].callID = aCallAlertData.callID then
      me.aCallList[i] = aCallAlertData
      exit repeat
    end if
  end repeat
  repeat with i = 1 to me.aAlertList.count
    if me.aAlertList[i].callID = aCallAlertData.callID then
      me.aAlertList[i] = aCallAlertData
      exit repeat
    end if
  end repeat
  displayCallAlert(me, pCallAlertList)
end

on receiveStudioCallAlert me, aCallAlertData
  me.debug("receiveStudioCallAlert:aCallAlertData" && aCallAlertData, 1)
  if me.isDeletedID(aCallAlertData.callID) then
    put "received deleted id: returning"
    return 
  end if
  if aCallAlertData.studioOwner.char[1] = "$" then
    aCallAlertData.studioOwner = "public"
  end if
  aCallAlertData[#studioId] = EMPTY
  repeat with i = 1 to me.aCallAlertList.count
    if me.aCallAlertList[i].callID = aCallAlertData.callID then
      put "replacing old call alet"
      me.replaceCallAlertData(aCallAlertData)
      exit
    end if
  end repeat
  me.iCallID = aCallAlertData.callID
  oDenizenManager.getDenizenByScreenName(aCallAlertData.screenName)
  me.aCallAlertList.add(aCallAlertData)
  if aCallAlertData.isAlert then
    me.aAlertList.add(aCallAlertData)
  else
    me.aCallList.add(aCallAlertData)
  end if
  if me.bSoundOn = 1 then
    beep()
  end if
  displayCallAlert(me, pCallAlertList)
end

on receiveStudioID me, sStudioID
  me.debug("receiveStudioID:sStudioID" && sStudioID)
  repeat with i = 1 to me.aCallAlertList.count
    put "receiveStudioID: me.iCallID" && me.iCallID
    if me.aCallAlertList[i].getOne(me.iCallID) <> 0 then
      me.aCallAlertList[i].studioId = sStudioID
      if me.aCallAlertList[i].isAlert then
        repeat with ii = 1 to me.aAlertList.count
          if me.aAlertList[ii].getOne(me.iCallID) <> 0 then
            me.aAlertList[ii].studioId = sStudioID
            exit
          end if
        end repeat
        next repeat
      end if
      repeat with ii = 1 to me.aCallList.count
        if me.aCallList[ii].getOne(me.iCallID) <> 0 then
          me.aCallList[ii].studioId = sStudioID
          exit
        end if
      end repeat
    end if
  end repeat
end

on sendCallAlert me
  aTestCallAlertData = [:]
  iNum = random(5)
  case iNum of
    1:
      aTestCallAlertData[#callID] = random(power(10, 10) - 1)
      aTestCallAlertData[#isAlert] = 0
      aTestCallAlertData[#screenName] = "freeble"
      aTestCallAlertData[#studioId] = "freeble1"
      aTestCallAlertData[#studioName] = "freeblesHut"
      aTestCallAlertData[#studioOwner] = "freeble"
      aTestCallAlertData[#message] = "Help! I got scammed by britneySpears22!"
      aTestCallAlertData[#isPickedUp] = 0
      aTestCallAlertData[#pickedUpBy] = EMPTY
    2:
      aTestCallAlertData[#callID] = random(power(10, 10) - 1)
      aTestCallAlertData[#isAlert] = 0
      aTestCallAlertData[#screenName] = "jesus"
      aTestCallAlertData[#studioId] = "aslan1"
      aTestCallAlertData[#studioName] = "theLion"
      aTestCallAlertData[#studioOwner] = "aslan"
      aTestCallAlertData[#message] = "Kick oldFart69...he's harassing me."
      aTestCallAlertData[#isPickedUp] = 0
      aTestCallAlertData[#pickedUpBy] = EMPTY
    3:
      aTestCallAlertData[#callID] = 443888215
      aTestCallAlertData[#isAlert] = 1
      aTestCallAlertData[#screenName] = "rupaul"
      aTestCallAlertData[#studioId] = "aslan2"
      aTestCallAlertData[#studioName] = "theWitch"
      aTestCallAlertData[#studioOwner] = "aslan"
      aTestCallAlertData[#message] = EMPTY
      aTestCallAlertData[#isPickedUp] = 0
      aTestCallAlertData[#pickedUpBy] = EMPTY
    4:
      aTestCallAlertData[#callID] = random(power(10, 10) - 1)
      aTestCallAlertData[#isAlert] = 1
      aTestCallAlertData[#screenName] = "SammyJenkins"
      aTestCallAlertData[#studioId] = "freeble1"
      aTestCallAlertData[#studioName] = "freeblesHut"
      aTestCallAlertData[#studioOwner] = "freeble"
      aTestCallAlertData[#message] = EMPTY
      aTestCallAlertData[#isPickedUp] = 0
      aTestCallAlertData[#pickedUpBy] = EMPTY
    5:
      aTestCallAlertData[#callID] = random(power(10, 10) - 1)
      aTestCallAlertData[#isAlert] = 0
      aTestCallAlertData[#screenName] = "fuzzy_lollipop"
      aTestCallAlertData[#studioId] = "freeble1"
      aTestCallAlertData[#studioName] = "freeblesHut"
      aTestCallAlertData[#studioOwner] = "freeble"
      aTestCallAlertData[#message] = "Crazy8s is spamming ad infinitum."
      aTestCallAlertData[#isPickedUp] = 0
      aTestCallAlertData[#pickedUpBy] = EMPTY
  end case
  me.receiveStudioCallAlert(aTestCallAlertData)
end
