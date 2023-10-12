global peopleNetID, peopleCastPath

on exitFrame me
  if not netDone(peopleNetID) then
    alertString = "Loading Your Character"
    sendAllSprites(#showAlert, alertString)
    go(the frame)
  else
    castLib("people").fileName = peopleCastPath
  end if
end
