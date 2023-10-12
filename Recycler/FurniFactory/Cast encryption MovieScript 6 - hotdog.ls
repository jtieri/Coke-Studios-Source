property relish, pickle

on squirtMustard me, onions
  me.relish = onions
end

on lickMustard me
  return "the coke scripty kids should go away"
end

on getMap me
  temp = getMovementGrid()
  return temp
end

on convertMapXMLtoText
  tempBegin = "on getMovementGrid" & RETURN & "return ("
  tempEnd = ")" & RETURN & "end getMovementGrid"
  temp = member("movementGrid").scriptText
  delete char 1 of temp
  delete char 1 of temp
  tempMiddle = QUOTE
  repeat with i = 1 to tempMiddle.chars.count
    theChar = temp.char[i]
    if theChar = QUOTE then
      tempMiddle = tempMiddle & QUOTE & " & QUOTE & " & QUOTE
      next repeat
    end if
    tempMiddle = tempMiddle & theChar
  end repeat
  tempMiddle = tempMiddle & QUOTE
  member("getMovementGrid").scriptText = tempBegin & tempMiddle & tempEnd
end
