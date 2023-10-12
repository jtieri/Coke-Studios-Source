property sIntro, sBeginning, sEncryptionKey, aToolList, sBotCollision, sVertScrubberCollision, sWhaleCartCollision, sSteamerCollision, sHoriScrubberCollision

on new me
  aToolList = ["Threads", "Spikes", "Wall Sauce", "Poof", "Planks", "Stickum", "Slivers", "Twisters", "Braces", "Sproingys"]
  me.sIntro = "Help run the recycler! Use the arrow keys to carry the materials to the machine in the correct order to help build furni for Coke Studios."
  me.sBeginning = "Starting Game Now." & RETURN & RETURN & "Get Ready!"
  me.sBotCollision = "Hey, stay out of everyone's way!"
  me.sVertScrubberCollision = "Don't get smelted! Watch out for that molten metal!"
  me.sWhaleCartCollision = "Ouch! You got run down by the grappler!"
  me.sSteamerCollision = "Yowie! You just got zapped!"
  me.sHoriScrubberCollision = "Oof! Looks like you're recycled now!"
  return me
end

on getCollisionMessage me, sObstacleMsg, iLivesLeft
  if iLivesLeft <> 1 then
    sCollisionMessage = sObstacleMsg & RETURN & RETURN & "You have" && iLivesLeft && "turns left."
  else
    sCollisionMessage = sObstacleMsg & RETURN & RETURN & "You have" && iLivesLeft && "turn left."
  end if
  return sCollisionMessage
end

on getGameBeginMessage me, sToolName
  alertString = "Please bring me the " & sToolName
  return alertString
end

on getGameWonMessage me, iLivesLeft, iAddLifeScoreBonus, iAddFinishScoreBonus, iScore
  alertString = "CONGRATULATIONS!" & RETURN & "You helped run the recycler!" & RETURN & "You get a bonus of " & iAddLifeScoreBonus & " points for having" && iLivesLeft && "turns left, and" && iAddFinishScoreBonus && "points for finishing the game, bringing your total to " & iScore & " points."
  return alertString
end

on getGameOverMessage me, iScore
  alertString = "GAME OVER!" & RETURN & "You scored a total of " & iScore & " points."
  return alertString
end

on getGameTimerZeroedMessage me, iLivesLeft
  sMessage = "You have run out of time!"
  if iLivesLeft > 1 then
    sMessage = sMessage & RETURN & RETURN & "You have" && iLivesLeft && "turns left."
  else
    sMessage = sMessage & RETURN & RETURN & "You have" && iLivesLeft && "turn left."
  end if
  return sMessage
end

on getCallForToolMessage me, sToolName
  alertString = "Please bring me the " & sToolName & "."
  return alertString
end

on getCallForToolAgainMessage me, sToolName
  alertString = "Please go back and bring me the " & sToolName & " this time."
  return alertString
end

on getCallForToolAfterCollisionMessage me, sToolName
  alertString = "Try again! Please bring me the " & sToolName & "."
  return alertString
end

on getMatchToolMessageTrue me, sToolName, iToolAddScore, iTimeBonus, iTotal
  theMessage = "Good work! You brought me the " & sToolName & "!" & RETURN & RETURN
  theMessage = theMessage & "Points earned: " & iToolAddScore && "points +" && iTimeBonus && "time bonus =" && iTotal
  return theMessage
end

on getMatchToolMessageFalse me, sToolCarriedName
  theMessage = "Oops! You brought me the " & sToolCarriedName & ". You have to take that back."
  return theMessage
end

on getMatchToolMessageEmpty me
  theMessage = "Hey! You brought me nothing! You were supposed to bring me raw materials."
  return theMessage
end
