property pSafetyTips, pIndex, pLastUpdate

on new me
  global TextMgr
  pSafetyTips = TextMgr.getsafetytips()
  pIndex = 1
  pLastUpdate = 0
  return me
end

on exitFrame me
  if (the milliSeconds - pLastUpdate) > 5000 then
    sprite(me.spriteNum).member.text = EMPTY
  end if
  if (the milliSeconds - pLastUpdate) > 5100 then
    shownewtip(me)
  end if
end

on shownewtip me
  pLastUpdate = the milliSeconds
  mytip = pSafetyTips[pIndex]
  sprite(me.spriteNum).member.text = mytip
  if pIndex < count(pSafetyTips) then
    pIndex = pIndex + 1
  else
    pIndex = 1
  end if
end
