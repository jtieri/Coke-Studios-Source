property bDebug
global oDisplay, oComputer

on new me
  init(me)
  me.debug("new()")
  oDisplay = me
  return me
end

on init me
  me.bDebug = 0
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "oDisplay:" && sMessage
  end if
end

on sendDisplay me, sDisplayType, sDisplay
  sDisplay = string(sDisplay)
  sMemberName = "display" & sDisplayType
  case sDisplayType of
    "Computer":
      sDisplay = "Time" & RETURN & sDisplay
    "Lives":
      sDisplay = "Turns Left" & RETURN & sDisplay
    "Score":
      sDisplay = "Score" & RETURN & sDisplay
    "Tool":
      sDisplay = "Tool in Hand" & RETURN & sDisplay
    "TotalTools":
      sDisplay = "Tools Left" & RETURN & sDisplay
    "Alert":
      alert(sDisplay)
      exit
    "Tool_Target":
      sDisplay = "Tool Needed" & RETURN & sDisplay
  end case
  member(sMemberName).text = sDisplay
end
