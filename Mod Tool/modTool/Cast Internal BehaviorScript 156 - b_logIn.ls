property pSprite, pLogInType
global oLogInManager

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pLogInType] = [#comment: "LogInType:", #format: #string, #default: "userName", #range: ["userName", "passWord"]]
  return mylist
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
  if pLogInType = "userName" then
    oLogInManager = new(script("LogInManager"), pSprite)
  end if
end

on exitFrame me
  if (pLogInType = "passWord") and objectp(oLogInManager) then
    oLogInManager.pLogInPassWordEntrySprite = pSprite
  end if
end
