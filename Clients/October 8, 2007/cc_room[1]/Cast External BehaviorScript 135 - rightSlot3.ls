property pContent
global oIsoScene

on new me
  return me
end

on getrightslot3 me
  return me.spriteNum
end

on mouseWithin me
  global TextMgr
  if voidp(pContent) then
    member("cc.tradinghelptext").text = TextMgr.GetRefText("BOX_ROLL")
  else
    member("cc.tradinghelptext").text = pContent.name
  end if
end

on mouseOverTradeSlot me
  if rollover(me.spriteNum) then
    return me.spriteNum
  end if
end

on testTradeDrop me
  if me.mouseOverTradeSlot(me) then
    if voidp(me.pContent) then
      oIsoScene.addSelectedItemToTrade()
      return 1
    end if
  end if
end
