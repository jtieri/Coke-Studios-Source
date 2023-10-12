property pMixerData
global ElementMgr, TextMgr, oDenizenManager, oStudioManager, oStudio

on new me
  pMixerData = []
  me.openWindow("cc_mixer.window")
  return me
end

on updatecontent me
  myblankcdcount = pMixerData.blankCDCount
  mymixes = pMixerData.mixes
  repeat with n = 1 to 5
    mytext = TextMgr.GetRefText("MIXER_EMPTY")
    mychar = offset("{mixNumber}", mytext)
    delete char mychar to mychar + 10 of mytext
    put string(n) & " " into char mychar of mytext
    member("cc.mixer.slot.text" & n).text = mytext
  end repeat
  repeat with n = 1 to count(mymixes)
    member("cc.mixer.slot.text" & n).text = mymixes[n].name
  end repeat
end

on openWindow me, sID, oArg
  myRect = me.closeWindow()
  mywindow = ElementMgr.newwindow(sID, myRect)
  me.displayWindow(mywindow, oArg)
end

on closeWindow me
  ElementMgr.getSequencer().stop()
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n) contains "mixer" then
      mywindow = ElementMgr.pOpenWindows[n]
      exit repeat
    end if
  end repeat
  if voidp(mywindow) then
    return 
  end if
  iLastRect = mywindow.closeWindow()
  ElementMgr.oMixer = VOID
  me = VOID
  return iLastRect
end

on getOpenWindow me
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n) contains "mixer" then
      mywindow = ElementMgr.pOpenWindows[n]
      return mywindow
      exit repeat
    end if
  end repeat
end

on displayWindow me, mywindow, oArg
end

on displayCurrentWindow me
  me.displayWindow(me.getOpenWindow())
end

on playMix me, iIndex
  if me.pMixerData.mixes.count = 0 then
    return 0
  end if
  if me.pMixerData.mixes.count < iIndex then
    return 0
  end if
  sSongData = me.pMixerData.mixes[iIndex].song
  ElementMgr.getSequencer().loadOddCastSequence(sSongData)
  ElementMgr.getSequencer().play()
  return 1
end

on stopMix me
  ElementMgr.getSequencer().stop()
end

on getMixNumber me, iIndex
  if me.pMixerData.mixes.count < iIndex then
    return 
  end if
  return me.pMixerData.mixes[iIndex].mixNumber
end

on replaceChar mString, mSearchCharacter, mReplaceCharacter
  str = EMPTY
  repeat with i = 1 to mString.length
    if char i of mString = mSearchCharacter then
      put mReplaceCharacter after str
      next repeat
    end if
    put char i of mString after str
  end repeat
  return str
end

on editMix me, iIndex
  bBlankMix = 0
  if me.pMixerData.mixes.count = 0 then
    bBlankMix = 1
  end if
  if me.pMixerData.mixes.count < iIndex then
    bBlankMix = 1
  end if
  ElementMgr.getSequencer().stop()
  ElementMgr.newwindow("paused.window")
  sSessionId = me.pMixerData[#sessionId]
  if not bBlankMix then
    aMix = me.pMixerData.mixes[iIndex]
    iMixId = aMix[#mixid]
    iMixNumber = aMix[#mixNumber]
  end if
  if not voidp(oStudio) then
    sUrl = oStudio.getMixerServer()
    if not bBlankMix then
      mNum = iMixNumber
    else
      mNum = iIndex
    end if
    if not bBlankMix then
      MID = iMixId
      sParams = urlEncode([#door: 4, #client: 4, #sID: sSessionId, #mNum: mNum, #MID: MID])
    else
      sParams = urlEncode([#door: 4, #client: 4, #sID: sSessionId, #mNum: mNum])
    end if
    idx = offset("sID", sParams)
    cnt = the number of chars in sParams
    part1 = char 1 to idx - 1 of sParams
    part2 = "SID"
    part3 = char idx + 3 to cnt of sParams
    sParams = part1 & part2 & part3
    sUrl = sUrl & "?" & sParams
    sLaunchScript = "javascript:openMixer('" & sUrl & "');"
    gotoNetPage(sLaunchScript)
  end if
  return 1
end

on burnMix me, iIndex
  if me.pMixerData.mixes.count = 0 then
    return 0
  end if
  if me.pMixerData.mixes.count < iIndex then
    return 0
  end if
  ElementMgr.getSequencer().stop()
  oBackPack = oDenizenManager.getBackpack()
  if voidp(oBackPack) then
    ElementMgr.alert("ALERT_NO_BLANK_CDS")
    return 
  end if
  iBlankCds = integer(oBackPack.getNumberOfBlankCds())
  if iBlankCds < 1 then
    ElementMgr.alert("ALERT_NO_BLANK_CDS")
    return 
  end if
  ElementMgr.newwindow("burn_decision.window")
  mytext = TextMgr.GetRefText("BURN_DESC")
  mychar = offset("{blankCds}", mytext)
  delete char mychar to mychar + 9 of mytext
  put iBlankCds & " " into char mychar of mytext
  member("burn_prompttext").text = mytext
  return 1
end
