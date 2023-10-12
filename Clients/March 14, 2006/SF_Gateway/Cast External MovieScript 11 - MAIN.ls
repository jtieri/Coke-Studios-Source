on startMovie
  if the runMode = "Author" then
    oMember = member("SF_Gateway")
    result = importFileInto(oMember, the moviePath & "SF_Gateway.swf")
    oMember.name = "SF_Gateway"
  end if
end
