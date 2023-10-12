on new me
  return me
end

on alertHook me, sErr, sMsg, errorType
  put "*** ALERT: " && errorType & ":" && sErr, ":" && sMsg
  return 1
end
