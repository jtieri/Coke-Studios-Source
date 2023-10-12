property myURL

on new me, _myURL
  me.myURL = _myURL
  return me
end

on mouseUp me
  gotoNetPage(myURL, "_new")
end
