property pContent

on new me
  return me
end

on getleftslot1 me
  return me.spriteNum
end

on mouseWithin me
  global TextMgr
  if voidp(pContent) = 0 then
    member("cc.tradinghelptext").text = pContent.name
  end if
end
