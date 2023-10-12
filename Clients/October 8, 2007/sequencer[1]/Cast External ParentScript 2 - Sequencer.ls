property iTimeLength, iBeatsPerMinute, iBeatInterval, iNumTracks, aTracks, iVolumeAdjust, sCastLib, sAssetCastLib, oSoundLibrary, sDefaultSequence, iSampleChannel, sName, sAuthor, sState, bDebug
global gSoundLevel

on new me
  me.bDebug = 0
  me.debug("new()")
  me.iTimeLength = 60000
  me.iBeatsPerMinute = 120
  me.iBeatInterval = me.iTimeLength / me.iBeatsPerMinute
  me.iNumTracks = 6
  me.iSampleChannel = 8
  me.aTracks = []
  me.iVolumeAdjust = 100
  me.sCastLib = "Sequencer"
  me.sAssetCastLib = "SoundLibrary"
  me.oSoundLibrary = script("SoundLibrary").new(me.sCastLib, me.sAssetCastLib)
  me.sName = EMPTY
  me.sAuthor = EMPTY
  me.sDefaultSequence = "DefaultSequence"
  me.initTracks()
  me.sState = "Stop"
  return me
end

on debug me, sMessage
  if me.bDebug then
    put "Sequencer." & sMessage
  end if
end

on sampleSound me, oSound
  sound(me.iSampleChannel).stop()
  sound(me.iSampleChannel).setPlayList([])
  sound(me.iSampleChannel).volume = 255 * (me.iVolumeAdjust * 0.01)
  sound(me.iSampleChannel).play([#member: oSound.getMember(), #loopCount: 1])
end

on initTracks me
  me.aTracks = []
  repeat with i = 1 to me.iNumTracks
    oTrack = script("Track").new(me, i)
    me.aTracks.add(oTrack)
  end repeat
end

on getTotalBeats me
  return me.iTimeLength / me.iBeatInterval
end

on getStartTime me, iBeat
  return iBeat * me.iBeatInterval
end

on getEventLength me, oEvent, oSound
  return oSound.getBeats() * me.iBeatInterval * oEvent.getLoopCount()
end

on getBeatFromTime me, iTime
  return iTime / me.iBeatInterval
end

on queueSequence me, iStartBeat
  iTrackCount = me.aTracks.count
  repeat with i = 1 to iTrackCount
    oTrack = me.aTracks[i]
    me.queueTrack(oTrack, i, iStartBeat)
  end repeat
end

on queueTrack me, oTrack, iChannel, iStartBeat
  oSound = oTrack.getSound()
  oSoundMember = oSound.getMember()
  oSilence = me.oSoundLibrary.getSilence(oSound.getBeats())
  iSilenceDuration = oSilence.oMember.duration
  iStartTime = me.getStartTime(iStartBeat)
  iCursor = iStartTime
  aSoundEvents = oTrack.getSoundEvents()
  aSoundEvents = me.removeEventsBeforeBeat(aSoundEvents, iStartBeat, oSound)
  iEventCount = aSoundEvents.count
  repeat with ii = 1 to iEventCount
    oEvent = aSoundEvents[ii]
    iEventLength = me.getEventLength(oEvent, oSound)
    iEventStartTime = me.getStartTime(oEvent.getBeat())
    iEventStopTime = iEventStartTime + iEventLength
    iSilenceLength = iEventStartTime - iCursor
    if iSilenceLength > 0 then
      iSilenceLoopCount = iSilenceLength / iSilenceDuration
      iBeat = me.getBeatFromTime(iCursor)
      sound(iChannel).queue([#member: oSilence.oMember, #loopCount: iSilenceLoopCount, #preloadTime: 1000, #beat: iBeat])
    end if
    sound(iChannel).queue([#member: oSound.oMember, #loopCount: oEvent.getLoopCount(), #preloadTime: 3000, #beat: oEvent.getBeat()])
    iCursor = iEventStopTime
  end repeat
  iSilenceLength = me.iTimeLength - iCursor
  if iSilenceLength > 0 then
    iSilenceLoopCount = iSilenceLength / iSilenceDuration
    iBeat = me.getBeatFromTime(iCursor)
    sound(iChannel).queue([#member: oSilence.oMember, #loopCount: iSilenceLoopCount, #preloadTime: 1000, #beat: iBeat])
  end if
end

on updatePlayList me, oTrack, iChannel, iBeat
  sound(iChannel).breakLoop()
  sound(iChannel).setPlayList([])
  me.queueTrack(oTrack, iChannel, iBeat)
end

on removeEventsBeforeBeat me, aSoundEvents, iBeat, oSound
  aNewSoundEvents = []
  repeat with i = 1 to aSoundEvents.count
    oEvent = aSoundEvents[i]
    if me.eventCrossesBeat(oEvent, iBeat, oSound) then
      oClipEvent = me.clipEvent(oEvent, iBeat, oSound)
      aNewSoundEvents.add(oClipEvent)
      next repeat
    end if
    if oEvent.iBeat >= iBeat then
      aNewSoundEvents.add(oEvent)
    end if
  end repeat
  return aNewSoundEvents
end

on clipEvent me, oEvent, iBeat, oSound
  iEventLength = me.getEventLength(oEvent, oSound)
  iEventStartTime = me.getStartTime(oEvent.getBeat())
  iEventStopTime = iEventStartTime + iEventLength
  iEventStartBeat = oEvent.iBeat
  iEventEndBeat = me.getBeatFromTime(iEventStopTime)
  iNewBeatDuration = iEventEndBeat - iBeat
  iSoundBeatDuration = oSound.getBeats()
  iLoopCount = iNewBeatDuration / iSoundBeatDuration
  oClipEvent = script("SoundEvent").new(iBeat, iLoopCount)
  return oClipEvent
end

on eventCrossesBeat me, oEvent, iBeat, oSound
  iEventLength = me.getEventLength(oEvent, oSound)
  iEventStartTime = me.getStartTime(oEvent.getBeat())
  iEventStopTime = iEventStartTime + iEventLength
  iEventStartBeat = oEvent.iBeat
  iEventEndBeat = me.getBeatFromTime(iEventStopTime)
  if (iEventStartBeat < iBeat) and (iEventEndBeat > iBeat) then
    return 1
  else
    return 0
  end if
end

on clearPlaylist me
  repeat with i = 1 to me.aTracks.count
    sound(i).stop()
    sound(i).setPlayList([])
  end repeat
end

on play me, iBeat
  me.debug("play() " & iBeat)
  if voidp(iBeat) then
    iBeat = 0
  end if
  if me.sState = "Pause" then
    me.unpause()
    return 
  end if
  me.clearPlaylist()
  oSilence = me.oSoundLibrary.getSilence(2).getMember()
  repeat with i = 1 to me.aTracks.count
    sound(i).queue([#member: oSilence])
    sound(i).play()
  end repeat
  me.queueSequence(iBeat)
  repeat with i = 1 to me.aTracks.count
    sound(i).playNext()
  end repeat
  me.sState = "Play"
end

on stop me
  repeat with i = 1 to me.aTracks.count
    repeat with j = 1 to 100
      sound(i).playNext()
    end repeat
    sound(i).stop()
  end repeat
  me.clearPlaylist()
  me.sState = "Stop"
end

on pause me
  if not (me.sState = "Play") then
    return 
  end if
  repeat with i = 1 to me.aTracks.count
    sound(i).pause()
  end repeat
  me.sState = "Pause"
end

on unpause me
  if not (me.sState = "Pause") then
    return 
  end if
  repeat with i = 1 to me.aTracks.count
    sound(i).play()
  end repeat
  me.sState = "Play"
end

on loadDefaultSequence me
  sData = member(me.sDefaultSequence, me.sCastLib).text
  me.loadSequence(sData)
end

on printPlayList me
  repeat with i = 1 to me.aTracks.count
    aPlaylist = sound(i).getPlaylist()
    put "[ ** SOUND " & i & " ** ]"
    repeat with ii = 1 to aPlaylist.count
      aevent = aPlaylist[ii]
      put "EVENT: " & "#beat: " & aevent.beat && ", #member: " & aevent.member.name && ", #loopCount: " & aevent.loopCount
    end repeat
  end repeat
end

on loadSequence me, sData
  me.stop()
  oXml = newObject("XML")
  oXml.ignoreWhite = 1
  oXml.parseXML(sData)
  oRootNode = oXml.firstChild
  me.sName = oRootNode.attributes.name
  me.sAuthor = oRootNode.attributes.author
  aTrackNodes = me.getNodes(oRootNode, "Track")
  iNumTracks = aTrackNodes.count
  repeat with i = 1 to iNumTracks
    oTrackNode = aTrackNodes[i]
    iVolume = integer(oTrackNode.attributes.volume)
    sAsset = oTrackNode.attributes.asset
    oTrack = me.aTracks[i]
    oTrack.setVolume(iVolume)
    oTrack.setSoundByAsset(sAsset)
    oEventNodes = me.getNodes(oTrackNode, "Event")
    iNumEvents = oEventNodes.count
    repeat with ii = 1 to iNumEvents
      oEventNode = oEventNodes[ii]
      iBeat = integer(oEventNode.attributes.beat)
      iLoopCount = integer(oEventNode.attributes.loopCount)
      oTrack.addSoundEvent(iBeat, iLoopCount)
    end repeat
  end repeat
end

on storeSequence me
  oXml = newObject("XML")
  oRoot = oXml.createElement("Sequence")
  oRoot.attributes.name = me.sName
  oRoot.attributes.author = me.sAuthor
  repeat with i = 1 to me.aTracks.count
    oTrack = me.aTracks[i]
    oTrackNode = oXml.createElement("Track")
    oTrackNode.attributes.volume = oTrack.getVolume()
    oTrackNode.attributes.asset = oTrack.getSound().getAsset()
    aSoundEvents = oTrack.getSoundEvents()
    repeat with ii = 1 to aSoundEvents.count
      aSoundEvent = aSoundEvents[ii]
      oEventNode = oXml.createElement("Event")
      oEventNode.attributes.beat = aSoundEvent.getBeat()
      oEventNode.attributes.loopCount = aSoundEvent.getLoopCount()
      oTrackNode.appendChild(oEventNode)
    end repeat
    oRoot.appendChild(oTrackNode)
  end repeat
  oXml.appendChild(oRoot)
end

on getNode me, oXml, sNodeName
  aChildren = oXml.childNodes
  repeat with i = 0 to aChildren.length - 1
    oNode = aChildren[i]
    if oNode.nodeName = sNodeName then
      return oNode
    end if
  end repeat
end

on getNodes me, oXml, sNodeName
  aNodes = []
  aChildren = oXml.childNodes
  repeat with i = 0 to aChildren.length - 1
    oNode = aChildren[i]
    if oNode.nodeName = sNodeName then
      aNodes.add(oNode)
    end if
  end repeat
  return aNodes
end

on resetVolume me
  repeat with i = 1 to me.aTracks.count
    oTrack = me.aTracks[i]
    oTrack.resetVolume()
  end repeat
end

on loadOddCastSequence me, sData
  me.debug("loadOddCastSequence() " & sData)
  me.initTracks()
  scList = me.parseEDL(sData)
  repeat with iTrack = 1 to scList.count
    scTrack = scList[iTrack]
    sAsset = scTrack[#sName]
    iVolume = me.mapPoints(float(scTrack[#svol]), 0.0, 100.0, 0.0, 255.0)
    aLoopList = scTrack[#loopNum]
    aStartTimes = scTrack[#sttime]
    aStopTimes = scTrack[#sptime]
    if iTrack = 6 then
      nothing()
    end if
    oTrack = me.aTracks[iTrack]
    oTrack.reset()
    oTrack.setVolume(iVolume)
    oTrack.setSoundByAsset(sAsset)
    iSoundBeatCount = oTrack.getSound().getBeats()
    iNumEvents = aLoopList.count
    repeat with iEvent = 1 to iNumEvents
      iEventLoopCount = aLoopList[iEvent]
      iEventStartTime = aStartTimes[iEvent]
      iStopTime = aStopTimes[iEvent]
      iBeat = me.getBeatFromTime(iEventStartTime)
      if (iBeat mod iSoundBeatCount) <> 0 then
        iBeat = iBeat + 1
      end if
      oTrack.addSoundEvent(iBeat, iEventLoopCount)
    end repeat
  end repeat
end

on parseEDL me, sData
  tmpv = sData
  scList = []
  me.setClassProps(chars(tmpv, 1, offset("^", tmpv) - 1))
  tmpv = chars(tmpv, offset("^", tmpv) + 1, tmpv.length)
  repeat while tmpv.length > 0
    tr1 = chars(tmpv, 1, offset("^", tmpv) - 1)
    tmpv = chars(tmpv, offset("^", tmpv) + 1, tmpv.length)
    virgin = 1
    tmplist1 = [#stCheckNum: 1, #spCheckNum: 1]
    sttmplist = []
    lptmplist = []
    sptmplist = []
    repeat while tr1.length > 0
      tr2 = chars(tr1, 1, offset("{", tr1) - 1)
      tr1 = chars(tr1, offset("{", tr1) + 1, tr1.length)
      if virgin = 1 then
        virgin = 0
        repeat with i = 1 to 4
          tr3 = chars(tr2, 1, offset(",", tr2) - 1)
          tr2 = chars(tr2, offset(",", tr2) + 1, tr2.length)
          case i of
            2:
              tmplist1.addProp(#svol, integer(tr3))
            4:
              tmplist1.addProp(#sName, tr3)
          end case
        end repeat
        next repeat
      end if
      repeat with i = 1 to 2
        tr3 = chars(tr2, 1, offset(",", tr2) - 1)
        tr2 = chars(tr2, offset(",", tr2) + 1, tr2.length)
        case i of
          1:
            lptmplist.add(integer(tr3))
          2:
            sttmplist.add(integer(tr3))
        end case
      end repeat
      sptmplist.add((member(tmplist1.sName).duration * lptmplist.getLast()) + sttmplist.getLast())
    end repeat
    tmplist1.addProp(#loopNum, lptmplist)
    tmplist1.addProp(#sttime, sttmplist)
    tmplist1.addProp(#sptime, sptmplist)
    scList.add(tmplist1)
  end repeat
  return scList
end

on setClassProps me, textIn
  repeat with i = 1 to 2
    tmpt = chars(textIn, 1, offset(",", textIn) - 1)
    textIn = chars(textIn, offset(",", textIn) + 1, textIn.length)
    case i of
      1:
      2:
    end case
  end repeat
end

on printEdl me, scList
  put "[ EDL ]"
  repeat with i = 1 to scList.count()
    put scList[i]
  end repeat
end

on mapPoints me, inVal, inLow, inHi, outLow, outHi
  outVal = ((inVal - inLow) / (inHi - inLow) * (outHi - outLow)) + outLow
  return outVal
end
