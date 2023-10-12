on genString validstring
  if validstring = VOID then
    put base64Encode(script("hotdog").pickle.Encrypt("theScreenName=binibon&theScore=315&st=2004:09:06:01:13"))
    put "try variant of:" && "theScreenName=binibon&theScore=315&st=2004:09:06:01:13"
  else
    put base64Encode(script("hotdog").pickle.Encrypt(validstring))
  end if
end
