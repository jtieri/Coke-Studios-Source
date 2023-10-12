global oTextConstants

on beginSprite me
  oTextConstants = script("TextConstants").new()
  sendAllSprites(#showAlert, oTextConstants.sIntro)
  sendAllSprites(#initTexts)
  script("hotdog").pickle = script("lingofish_main").new(script("hotdog").lickMustard())
  put ["encryption module error", "encryption ok"][script("hotdog").pickle.blowfish_ok + 1]
end

on exitFrame me
  sendAllSprites(#show)
end
