property bTestMode
global gbTestMode

on beginSprite me
  if voidp(me.bTestMode) then
    me.bTestMode = 0
  end if
  if the runMode <> "Author" then
    gbTestMode = 0
  else
    gbTestMode = me.bTestMode
  end if
end

on getPropertyDescriptionList me
  vRange = [0, 1]
  vList = [:]
  vList.addProp(#bTestMode, [#comment: "TestMode", #format: #boolean, #range: vRange, #default: vRange[1]])
  return vList
end

on keyDown me
  pass()
end
