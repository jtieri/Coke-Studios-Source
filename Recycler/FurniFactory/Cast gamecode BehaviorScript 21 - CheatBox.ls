global oComputer, oAvatar, bDebugCollision

on mouseUp me
  if keyPressed("i") and keyPressed("n") and keyPressed("t") and keyPressed("f") then
    oComputer.cheatToolList()
    oAvatar.setCurrentSquare(5, 10)
    oComputer.pickUpTool(oComputer.getComputerTool())
    oAvatar.pickUpTool(oComputer.getComputerTool())
    oComputer.bICheated = 0
  else
    if keyPressed("r") and keyPressed("y") and keyPressed("4") and keyPressed("n") then
      oComputer.cheatToolList()
      oAvatar.setCurrentSquare(5, 10)
      oComputer.pickUpTool(oComputer.getComputerTool())
      oAvatar.pickUpTool(oComputer.getComputerTool())
      oComputer.bICheated = 1
    else
      if keyPressed("c") and keyPressed("o") and keyPressed("l") then
        bDebugCollision = not bDebugCollision
      end if
    end if
  end if
end
