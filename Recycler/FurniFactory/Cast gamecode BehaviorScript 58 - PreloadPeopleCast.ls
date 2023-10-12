global peopleNetID, peopleCastPath

on exitFrame me
  sendAllSprites(#showAlert, "Loading Your Character")
  sprite(83).show()
  if the runMode contains "Author" then
    peopleCastPath = "./people.cst"
  else
    peopleCastPath = "./people.cct"
  end if
  peopleNetID = preloadNetThing(peopleCastPath)
end
