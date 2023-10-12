property oTextMember, oTextRect, aTextProps, oBackgroundMember, oBackgroundRect, aBackgroundProps, aSprites, iTimerLength, iStartTime, bRunning
global oIsoScene

on new me
  me.bRunning = 0
  me.iTimerLength = 3000
  me.aSprites = []
  me.initTextProps()
  me.initBackgroundProps()
  return me
end

on initBackgroundProps me
  me.oBackgroundMember = member("TriviaBackground")
  me.oBackgroundRect = rect(190, 363, 612, 467)
  me.aBackgroundProps = [#member: me.oBackgroundMember, #x: me.oBackgroundRect.left, #y: me.oBackgroundRect.top, #ink: 8]
end

on initTextProps me
  me.oTextMember = member("TriviaDisplay")
  me.oTextMember.backColor = 255
  me.oTextMember.fontSize = 10
  me.oTextMember.fontStyle = "plain"
  me.oTextRect = rect(200, 368, 605, 468)
  me.aTextProps = [#member: me.oTextMember, #x: me.oTextRect.left, #y: me.oTextRect.top, #ink: 36]
end

on displayTrivia me, sQuestion, sAnswer, iDisplayTime
  if not voidp(iDisplayTime) then
    me.iTimerLength = iDisplayTime - 5000
  end if
  me.destroy()
  (the actorList).add(me)
  me.drawBackground()
  me.DrawText(sQuestion, sAnswer)
  me.iStartTime = the milliSeconds
  me.bRunning = 1
end

on DrawText me, sQuestion, sAnswer
  sText = "Trivia Question:" & RETURN
  sText = sText & sQuestion & RETURN & RETURN
  if voidp(sAnswer) then
    sText = sText & "Answer coming up in a couple minutes.."
  else
    sText = sText & "And the answer is:" & RETURN & sAnswer
  end if
  me.oTextMember.text = sText
  set the foreColor of line 1 of member "TriviaDisplay" to 4
  set the foreColor of line 2 of member "TriviaDisplay" to 0
  set the foreColor of line 4 of member "TriviaDisplay" to 4
  set the foreColor of line 5 of member "TriviaDisplay" to 0
  iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(me.aTextProps)
  sprite(iSprite).rect = me.oTextRect
  sprite(iSprite).member.rect = me.oTextRect
  sprite(iSprite).locZ = oIsoScene.oGrid.getHighestDepth()
  sprite(iSprite).visible = 1
  me.aSprites.add(iSprite)
end

on drawBackground me
  iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(me.aBackgroundProps)
  sprite(iSprite).rect = me.oBackgroundRect
  sprite(iSprite).locZ = oIsoScene.oGrid.getHighestDepth()
  sprite(iSprite).blend = 55
  sprite(iSprite).color = rgb("#0099CC")
  sprite(iSprite).visible = 1
  me.aSprites.add(iSprite)
end

on Init me
end

on stepFrame me
  if not me.bRunning then
    return 
  end if
  if (the milliSeconds - me.iStartTime) >= me.iTimerLength then
    me.destroy()
    me.bRunning = 0
  end if
end

on clearTrivia me
  me.destroy()
end

on destroy me
  me.bRunning = 0
  (the actorList).deleteOne(me)
  oIsoScene.oSpriteManager.returnPooledSprites(me.aSprites)
  me.aSprites = []
end
