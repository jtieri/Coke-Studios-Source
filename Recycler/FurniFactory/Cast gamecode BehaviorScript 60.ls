global sInputString, sAvatarString, sScreenName, sTimeString, sHiScoreURL, oServerHelper

on exitFrame me
  if externalParamName("sw1") = "sw1" then
    sInputData = externalParamValue("sw1")
  else
    sInputData = "c249d2hvcmZpbnxocj0wMDgvMTE1LDYxLDE3JmhkPTAwMS8xNTMsMTI2LDk5JmV5PTAwNi8yMzgsMjM4LDIzOCZmYz0wMDIvMTUzLDEyNiw5OSZiZD0wMDEvMTUzLDEyNiw5OSZsaD0wMDEvMTUzLDEyNiw5OSZyaD0wMDEvMTUzLDEyNiw5OSZjaD0wMDQvMjM4LDIzOCwyMzgmbHM9MDAxLzIzOCw2MCw0NyZycz0wMDEvMjM4LDYwLDQ3JmxnPTAwMS85NywxMjAsODUmc2g9MDAxLzUxLDUxLDUxfHN0PTIwMDQ6MDk6MDE6MTY6MDM=="
  end if
  sInputString = base64Decode(sInputData)
  if the runMode contains "Author" then
    sHiScoreURL = "http://mycoke.studiocom.com/recycler.do"
  else
    if externalParamName("sw2") = "sw2" then
      sHiScoreURL = externalParamValue("sw2")
      sHiScoreURL = sHiScoreURL & "/recycler.do"
    else
      sHiScoreURL = EMPTY
    end if
  end if
  the itemDelimiter = "|"
  sScreenName = sInputString.item[1]
  sAvatarString = sInputString.item[2]
  sTimeString = sInputString.item[3]
  the itemDelimiter = ","
  oServerHelper = script("ServerHelper").new(sTimeString)
end
