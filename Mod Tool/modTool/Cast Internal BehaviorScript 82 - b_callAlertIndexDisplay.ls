property pSprite
global oCallAlertDisplayManager

on beginSprite me
  pSprite = sprite(me.spriteNum)
  pSprite.member.text = EMPTY
  oCallAlertDisplayManager.pDisplayIndexSprite = pSprite
end

on displayIndex me, iNum, iMaxNum
  if iMaxNum = 0 then
    sString = EMPTY
  else
    sString = string(iNum & "/" & iMaxNum)
  end if
  pSprite.member.text = sString
end
