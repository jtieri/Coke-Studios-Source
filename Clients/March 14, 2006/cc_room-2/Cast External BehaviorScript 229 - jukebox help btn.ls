global TextMgr

on mouseUp me
  myName = "help_topic_1_LINK"
  mydef = TextMgr.GetRefText(myName)
  the itemDelimiter = ":"
  myType = mydef.item[1]
  myLink = mydef.item[2]
  the itemDelimiter = ","
  gotoNetPage("javascript:" & myLink)
end
