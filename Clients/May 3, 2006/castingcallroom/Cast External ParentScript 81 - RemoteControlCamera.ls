property iScreen, iInitSource, iScanlines, rScreenRect, rScreenRectOffset, pScreenLocNow, pScreenLocDest, iZoomNow, iZoomDest, iTrackingDivisor, iCrossFading, iSprite, pAvatarCameraOffset, oAvatar, bPerformance, oPerformer
global oIsoScene, oStudio

on new me, _iSprite
  me.iSprite = _iSprite
  me.iTrackingDivisor = 7
  me.iCrossFading = -1
  me.pAvatarCameraOffset = point(0, -25)
  me.bPerformance = 0
  me.oPerformer = VOID
  return me
end

on Init me, initMember, drawMember
  if voidp(initMember) then
    me.iInitSource = member("RemoteControlCameraInit").image
  else
    me.iInitSource = member(initMember).image
  end if
  if voidp(drawMember) then
    me.iScreen = member("RemoteControlCameraScreen").image
  else
    me.iScreen = member(drawMember).image
  end if
  me.iScanlines = member("RemoteControlCameraScanlines").image
  me.pScreenLocNow = VOID
  me.pScreenLocDest = VOID
  me.iZoomNow = 100
  me.iZoomDest = 100
  me.rScreenRect = rect(0.0, 0.0, float(me.iScreen.width), float(me.iScreen.height))
  put me.rScreenRect
  me.rScreenRectOffset = rect(me.iScreen.width / 2.0, me.iScreen.height / 2.0, me.iScreen.width / 2.0, me.iScreen.height / 2.0)
  me.iScreen.fill(me.rScreenRect, [#color: rgb(0, 0, 0), #bgColor: rgb(0, 0, 0), #lineSize: 0, #shapeType: #rect])
  me.iScreen.copyPixels(iScanlines, me.rScreenRect, me.rScreenRect, [#blend: 35, #ink: 39])
  (the actorList).add(me)
  if not voidp(oIsoScene) then
    me.oAvatar = oIsoScene.oAvatars.getRandomAVatar()
  end if
end

on destroy me
  me.iScreen.fill(me.rScreenRect, [#ink: 39, #color: rgb(0, 0, 0), #bgColor: rgb(0, 0, 0), #lineSize: 0, #shapeType: #rect])
  (the actorList).deleteOne(me)
end

on drawScreen me
  if voidp(me.pScreenLocNow) and voidp(me.pScreenLocDest) then
    me.iScreen.copyPixels(me.iInitSource, me.rScreenRect, me.rScreenRect, [#blend: 25])
  else
    if voidp(me.pScreenLocNow) then
      me.pScreenLocNow = point(692.0, 78.0)
    else
      if me.iCrossFading < 0 then
        me.iZoomNow = me.iZoomNow + ((me.iZoomDest - me.iZoomNow) / me.iTrackingDivisor)
        me.pScreenLocNow = me.pScreenLocNow + ((me.pScreenLocDest - me.pScreenLocNow) / me.iTrackingDivisor)
        rZoomedRect = (me.rScreenRect * 100 / me.iZoomNow) + rect(me.pScreenLocNow, me.pScreenLocNow) - (me.rScreenRectOffset * 100 / me.iZoomNow)
        me.iScreen.copyPixels((the stage).image, me.rScreenRect, rZoomedRect, [#blend: 60, #ink: 39])
      else
        me.iZoomNow = me.iZoomNow + ((me.iZoomDest - me.iZoomNow) / me.iTrackingDivisor)
        me.iCrossFading = me.iCrossFading + 5
        if me.iCrossFading > 100 then
          me.iCrossFading = -1
          me.pScreenLocNow = me.pScreenLocDest
          me.iZoomNow = me.iZoomDest
          rZoomedRectNow = (me.rScreenRect * 100 / me.iZoomNow) + rect(me.pScreenLocNow, me.pScreenLocNow) - (me.rScreenRectOffset * 100 / me.iZoomNow)
          me.iScreen.copyPixels((the stage).image, me.rScreenRect, rZoomedRectNow, [#blend: 100, #ink: 39])
        else
          if voidp(pScreenLocDest) then
            pScreenLocDest = point(0, 0)
          end if
          rZoomedRectNow = (me.rScreenRect * 100 / me.iZoomNow) + rect(me.pScreenLocNow, me.pScreenLocNow) - (me.rScreenRectOffset * 100 / me.iZoomNow)
          rZoomedRectDest = (me.rScreenRect * 100 / me.iZoomDest) + rect(me.pScreenLocDest, me.pScreenLocDest) - (me.rScreenRectOffset * 100 / me.iZoomDest)
          me.iScreen.copyPixels((the stage).image, me.rScreenRect, rZoomedRectNow, [#blend: 100])
          me.iScreen.copyPixels((the stage).image, me.rScreenRect, rZoomedRectDest, [#blend: me.iCrossFading])
        end if
      end if
    end if
    me.iScreen.copyPixels(iScanlines, me.rScreenRect, me.rScreenRect, [#blend: 35, #ink: 39])
    me.iScreen.copyPixels(iScanlines, me.rScreenRect, rect(0, 0, 1, 1), [#blend: random(10)])
  end if
end

on setNewPoint me, newPoint
  if me.iCrossFading < 0 then
    me.pScreenLocDest = newPoint
  end if
end

on setNewZoom me, newZoom
  me.iZoomDest = newZoom
end

on setNewFade me, newFade
  me.pScreenLocDest = newFade
  me.iCrossFading = 0
end

on stepFrame me
  if not voidp(oIsoScene) then
    if not me.bPerformance then
      if not voidp(me.oAvatar) then
        if random(60) = 1 then
          me.oAvatar = oIsoScene.oAvatars.getRandomAVatar()
        end if
        oViewPoint = me.oAvatar.oViewPoint + (me.pAvatarCameraOffset * me.iZoomNow / 100)
      else
        me.oAvatar = oIsoScene.oAvatars.getRandomAVatar()
      end if
    else
      if not voidp(me.oPerformer) then
        me.oAvatar = me.oPerformer
      else
        if voidp(me.oAvatar) then
          me.oAvatar = oIsoScene.oAvatars.getRandomAVatar()
        end if
      end if
      oViewPoint = me.oAvatar.oViewPoint + (me.pAvatarCameraOffset * me.iZoomNow / 100)
    end if
  end if
  if not voidp(oViewPoint) then
    me.setNewPoint(oViewPoint)
  end if
  whichProcess = random(60)
  if whichProcess = 1 then
    me.setNewPoint(oViewPoint)
  else
    if whichProcess = 2 then
      me.setNewFade(oViewPoint)
    else
      if whichProcess = 3 then
        me.setNewZoom(100 + random(100))
      end if
    end if
  end if
  me.drawScreen()
end

on startPerformance me
  put "RemoteControlCamera startPerformance"
  if oIsoScene.oAvatars.aItems.count > 0 then
    me.bPerformance = 1
    me.oPerformer = VOID
    put "RemoteControlCamera - oAvatars.aItems.count>0"
    i = 1
    repeat while (i <= oIsoScene.oAvatars.aItems.count) and (me.oPerformer = VOID)
      theAvatar = oIsoScene.oAvatars.aItems[i]
      if not voidp(oStudio) then
        bIsPlaying = oStudio.getcdplayer().isPlaying() = 1
      end if
      if bIsPlaying then
        sCdPlayerAvatar = oStudio.getcdplayer().getAvatar()
      end if
      if theAvatar.getScreenName() = sCdPlayerAvatar then
        me.oPerformer = theAvatar
        put "theAvatar: " & theAvatar.sScreenName && "isPerforming"
      end if
      i = i + 1
    end repeat
  else
    me.bPerformance = 0
    me.oPerformer = VOID
  end if
end

on stopPerformance me
  put "RemoteControlCamera stopPerformance"
  me.bPerformance = 0
  me.oPerformer = VOID
end
