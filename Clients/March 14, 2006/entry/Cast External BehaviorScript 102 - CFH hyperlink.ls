property pWindowObject

on new me, windowobject
  pWindowObject = windowobject
  return me
end

on mouseDown me
  nothing()
end

on mouseUp me
  global ElementMgr, TextMgr, gFeatureSet
  myName = sprite(me.spriteNum).member.name
  the itemDelimiter = "_"
  myName = myName.item[1..myName.items.count - 1] & "_LINK"
  mydef = TextMgr.GetRefText(myName)
  the itemDelimiter = ":"
  myType = mydef.item[1]
  myLink = mydef.item[2]
  the itemDelimiter = ","
  if myType = "external" then
    gotoNetPage("javascript:" & myLink)
  else
    if not gFeatureSet.isEnabled(#CALL_FOR_HELP) then
      ElementMgr.alert("FEATURE_DISABLED")
      return 
    end if
    pWindowObject.closeWindow()
    ElementMgr.newwindow(myLink & ".window")
  end if
end
