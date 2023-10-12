property pSprite, pText, pAction, pBackGroundTransparent, pBold, pHexColorString

on getPropertyDescriptionList me
  mylist = [:]
  mylist[#pBold] = [#comment: "Bold?:", #format: #boolean, #default: 0]
  mylist[#pBackGroundTransparent] = [#comment: "BackGroundTransparent?:", #format: #boolean, #default: 0]
  mylist[#pText] = [#comment: "Display text:", #format: #string, #default: "This is a test."]
  mylist[#pHexColorString] = [#comment: "Text color (hex):", #format: #string, #default: "000000"]
  mylist[#pAction] = [#comment: "Action:", #format: #string, #default: "nothing", #range: ["BEEP", "nothing", "displayText(me,pText)"]]
  return mylist
end

on hexColorConvertor me, sHexString
  repeat with i = sHexString.char.count down to 1
    sChar = sHexString.char[i]
    case sChar of
      "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
        iNum = integer(sChar)
      "A":
        iNum = 10
      "B":
        iNum = 11
      "C":
        iNum = 12
      "D":
        iNum = 13
      "E":
        iNum = 14
      "F":
        iNum = 15
    end case
    if i = sHexString.char.count then
      iColorNum = iColorNum + iNum
      next repeat
    end if
    iColorNum = iColorNum + (iNum * power(16, sHexString.char.count - i))
  end repeat
  return integer(iColorNum)
end

on beginSprite me
  pSprite = sprite(me.spriteNum)
  pSprite.member.font = "Verdana"
  if pBold then
    pSprite.member.fontStyle = "bold"
  else
    if pSprite.member.type = #text then
      pSprite.member.fontStyle = [#plain]
    else
      pSprite.member.fontStyle = "plain"
    end if
  end if
  pSprite.member.fontSize = 10
  if pSprite.member.type = #text then
    pSprite.member.fixedLineSpace = 14
  else
    pSprite.member.lineHeight = 14
  end if
  if pBackGroundTransparent then
    pSprite.ink = 36
  end if
  pSprite.member.color = rgb(pHexColorString)
  pSprite.member.scrollTop = 0
  pSprite.member.text = EMPTY
end

on displayText me, sTextToDisplay
  pSprite.member.text = sTextToDisplay
end
