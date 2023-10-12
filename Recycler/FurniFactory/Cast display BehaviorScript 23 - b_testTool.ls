global oComputer, oDisplay

on mouseUp me
  if oComputer.matchTool() then
    oDisplay.sendDisplay("Alert", "You got it!")
  else
    oDisplay.sendDisplay("Alert", "Wrong tool!")
  end if
end
