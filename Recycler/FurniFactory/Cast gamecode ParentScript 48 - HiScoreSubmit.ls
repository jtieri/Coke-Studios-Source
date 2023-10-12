property netID
global oServerHelper, sInputString, sAvatarString, sScreenName, sTimeString, iLatestScore, sHiScoreURL

on new me
  sRawSubmission = "theGameID=2&" & oServerHelper.getScreenNameStringForServerCall() & "&" & oServerHelper.getScoreStringForServerCall() & "&" & oServerHelper.getDateStringForServerCall()
  sEncryptedSubmission = script("hotdog").pickle.Encrypt(sRawSubmission)
  sB64edSubmission = base64Encode(sEncryptedSubmission)
  pList = [#var: sB64edSubmission]
  me.netID = postNetText(sHiScoreURL, pList)
  sendAllSprites(#showAlert, "Checking your score against the high score list...")
  (the actorList).add(me)
  return me
end

on stepFrame me
  if netDone(me.netID) then
    sTemp = netTextresult(me.netID)
    if sTemp.chars.count < 45 then
      case sTemp of
        "-1":
          sendAllSprites(#showAlert, "Sorry, there has been an error. Please try again later.")
        "0":
          sendAllSprites(#showAlert, "Sorry, you didn't make the high score list. Please try again.")
        otherwise:
          sendAllSprites(#showAlert, "Congratulations, your score is currently ranked at #" & sTemp && "for the day.")
      end case
    else
      sendAllSprites(#showAlert, "Result:" && sTemp.char[1..45])
    end if
    (the actorList).deleteOne(me)
  end if
end
