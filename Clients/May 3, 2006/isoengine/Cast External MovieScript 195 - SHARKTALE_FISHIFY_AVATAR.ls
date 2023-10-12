global oStudioMap

on fishifyAvatarString sOriginalString
  if voidp(oStudioMap) then
    return fishifyPrivateAvatarString(sOriginalString)
  end if
  if oStudioMap.isPrivate() then
    return fishifyPrivateAvatarString(sOriginalString)
  else
    return fishifyPublicAvatarString(sOriginalString)
  end if
end

on fishifyPrivateAvatarString sOriginalString
  flo = newObject("Object")
  flo.s = newObject("String", sOriginalString)
  flo.a = flo.s.split("&")
  colorString = EMPTY
  isBoy = 0
  repeat with i = 0 to flo.a.length - 1
    if flo.a[i].char[1..2] = "lg" then
      partString = newObject("String", flo.a[i])
      colorString = partString.split("/")[1]
      next repeat
    end if
    if flo.a[i].char[1..6] = "bd=001" then
      isBoy = 1
    end if
  end repeat
  repeat with i = 0 to flo.a.length - 1
    bodyPart = flo.a[i].char[1..2]
    case bodyPart of
      "hr":
        if isBoy then
          flo.a[i] = flo.a[i].char[1..3] & "015" & flo.a[i].char[7..flo.a[i].length]
        else
          flo.a[i] = flo.a[i].char[1..3] & "016" & flo.a[i].char[7..flo.a[i].length]
        end if
      "ch":
        if isBoy then
          flo.a[i] = flo.a[i].char[1..3] & "016" & flo.a[i].char[7..flo.a[i].length]
        else
          flo.a[i] = flo.a[i].char[1..3] & "017" & flo.a[i].char[7..flo.a[i].length]
        end if
      "sh":
        flo.a[i] = flo.a[i].char[1..3] & "007" & flo.a[i].char[7..flo.a[i].length]
    end case
  end repeat
  sOutString = flo.a.join("&")
  return sOutString
end

on fishifyPublicAvatarString sOriginalString
  flo = newObject("Object")
  flo.s = newObject("String", sOriginalString)
  flo.a = flo.s.split("&")
  colorString = EMPTY
  isBoy = 0
  repeat with i = 0 to flo.a.length - 1
    if flo.a[i].char[1..2] = "lg" then
      partString = newObject("String", flo.a[i])
      colorString = partString.split("/")[1]
      next repeat
    end if
    if flo.a[i].char[1..6] = "bd=001" then
      isBoy = 1
    end if
  end repeat
  repeat with i = 0 to flo.a.length - 1
    bodyPart = flo.a[i].char[1..2]
    case bodyPart of
      "sh":
        flo.a[i] = flo.a[i].char[1..3] & "000" & flo.a[i].char[7..flo.a[i].length]
      "lg":
        if isBoy then
          flo.a[i] = flo.a[i].char[1..3] & "101" & flo.a[i].char[7..flo.a[i].length]
        else
          flo.a[i] = flo.a[i].char[1..3] & "100" & flo.a[i].char[7..flo.a[i].length]
        end if
    end case
  end repeat
  sOutString = flo.a.join("&")
  return sOutString
end
