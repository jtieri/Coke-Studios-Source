on startMovie
  the actorList = []
end

on stopMovie
  the actorList = []
  pass()
end

on getAvatarPreviewImage sAttributes
  oNewAvatar = new(script("AvatarEngine"), sAttributes)
  oPreviewImage = oNewAvatar.getPreviewImage()
  return oPreviewImage
end

on getMemberNames
  aNames = []
  repeat with i = 1 to the number of castMembers of castLib "people"
    aNames.append(member(i, "people").name)
  end repeat
  return aNames
end

on getMemberTable
  aMemberTable = []
  the itemDelimiter = "_"
  aNames = getMemberNames()
  repeat with i = 1 to aNames.count
    sMemberName = aNames[i]
    if not (sMemberName starts "h_") then
      next repeat
    end if
    oMember = member(sMemberName)
    aTable = [:]
    aTable[#memberName] = sMemberName
    aTable[#id] = sMemberName.item[1]
    aTable[#act] = sMemberName.item[2]
    aTable[#prt] = sMemberName.item[3]
    aTable[#prtCd] = sMemberName.item[4]
    aTable[#dir] = integer(sMemberName.item[5])
    aTable[#fr] = integer(sMemberName.item[6])
    aTable[#paletteRef] = oMember.paletteRef
    aMemberTable.append(aTable)
  end repeat
  return aMemberTable
end

on getDirections id, act, prt, prtCd, fr
  aDirections = []
  aMemberTable = getMemberTable()
  repeat with i = 1 to aMemberTable.count
    aTable = aMemberTable[i]
    if id <> VOID then
      if not (aTable[#id] = id) then
        next repeat
      end if
    end if
    if act <> VOID then
      if not (aTable[#act] = act) then
        next repeat
      end if
    end if
    if prt <> VOID then
      if not (aTable[#prt] = prt) then
        next repeat
      end if
    end if
    if prtCd <> VOID then
      if not (aTable[#prtCd] = prtCd) then
        next repeat
      end if
    end if
    if fr <> VOID then
      if not (aTable[#fr] = fr) then
        next repeat
      end if
    end if
    iDir = aTable[#dir]
    if aDirections.getPos(iDir) = 0 then
      aDirections.append(iDir)
    end if
  end repeat
  aDirections.sort()
  return aDirections
end

on getFrames id, act, prt, prtCd, dir
  aFrames = []
  aMemberTable = getMemberTable()
  repeat with i = 1 to aMemberTable.count
    aTable = aMemberTable[i]
    if id <> VOID then
      if not (aTable[#id] = id) then
        next repeat
      end if
    end if
    if act <> VOID then
      if not (aTable[#act] = act) then
        next repeat
      end if
    end if
    if prt <> VOID then
      if not (aTable[#prt] = prt) then
        next repeat
      end if
    end if
    if prtCd <> VOID then
      if not (aTable[#prtCd] = prtCd) then
        next repeat
      end if
    end if
    if dir <> VOID then
      if not (aTable[#dir] = dir) then
        next repeat
      end if
    end if
    fr = aTable[#fr]
    if aFrames.getPos(fr) = 0 then
      aFrames.append(fr)
    end if
  end repeat
  aFrames.sort()
  return aFrames
end

on getPartCodesForPart prt
  aCodes = []
  aMemberTable = getMemberTable()
  repeat with i = 1 to aMemberTable.count
    aTable = aMemberTable[i]
    sPart = aTable[#prt]
    if not (sPart = prt) then
      next repeat
    end if
    sPartCode = aTable[#prtCd]
    if aCodes.getPos(sPartCode) = 0 then
      aCodes.append(sPartCode)
    end if
  end repeat
  return aCodes
end

on getUniquePartCodes
  aParts = []
  aMemberTable = getMemberTable()
  repeat with i = 1 to aMemberTable.count
    aTable = aMemberTable[i]
    sPart = aTable[#prtCd]
    if aParts.getPos(sPart) = 0 then
      aParts.append(sPart)
    end if
  end repeat
  return aParts
end

on getUniqueActions
  aActions = []
  aMemberTable = getMemberTable()
  repeat with i = 1 to aMemberTable.count
    aTable = aMemberTable[i]
    sAction = aTable[#act]
    if aActions.getPos(sAction) = 0 then
      aActions.append(sAction)
    end if
  end repeat
  return aActions
end

on getActionsForPart prt
  aAllActions = getUniqueActions()
  aActions = []
  aMemberTable = getMemberTable()
  repeat with i = 1 to aMemberTable.count
    aTable = aMemberTable[i]
    sPart = aTable[#prt]
    if not (sPart = prt) then
      next repeat
    end if
    sAction = aTable[#act]
    if aActions.getPos(sAction) = 0 then
      aActions.append(sAction)
    end if
  end repeat
  return aActions
end

on getUniqueParts
  aParts = []
  aMemberTable = getMemberTable()
  repeat with i = 1 to aMemberTable.count
    aTable = aMemberTable[i]
    sPart = aTable[#prt]
    if aParts.getPos(sPart) = 0 then
      aParts.append(sPart)
    end if
  end repeat
  return aParts
end

on getPartActionTable
  aPartActions = [:]
  aParts = getUniqueParts()
  repeat with i = 1 to aParts.count
    sPart = aParts[i]
    aActions = getActionsForPart(sPart)
    aPartActions[sPart] = aActions
  end repeat
  return aPartActions
end

on getPartDirections
  aPartDirs = [:]
  aParts = getUniqueParts()
  repeat with i = 1 to aParts.count
    sPart = aParts[i]
    aDirections = getDirections(VOID, VOID, sPart, VOID, VOID, VOID)
    aPartDirs[sPart] = aDirections
  end repeat
  return aPartDirs
end

on getDirectionMap
  aDirMap = [:]
  aFakeMap = [0: 6, 1: 5, 2: 4, 3: 7, 4: 2, 5: 1, 6: 0, 7: 3]
  aParts = getUniqueParts()
  repeat with i = 1 to aParts.count
    aPartActions = [:]
    sPart = aParts[i]
    aActions = getActionsForPart(sPart)
    repeat with ii = 1 to aActions.count
      sAction = aActions[ii]
      aRealDirs = getDirections(VOID, sAction, sPart, VOID, VOID, VOID)
      aFakeDirs = [:]
      repeat with iii = 0 to 7
        bRealDirExists = aRealDirs.getPos(iii) > 0
        if bRealDirExists then
          aFakeDirs.setaProp(iii, iii)
          next repeat
        end if
        aFakeDirs.setaProp(iii, aFakeMap.getProp(iii))
      end repeat
      aPartActions[sAction] = aFakeDirs
    end repeat
    aDirMap[sPart] = aPartActions
  end repeat
  return aDirMap
end

on getConfigList
  aConfigList = [:]
  aParts = getUniqueParts()
  repeat with i = 1 to aParts.count
    sPart = aParts[i]
    aActionConfig = [:]
    aActions = getActionsForPart(sPart)
    repeat with ii = 1 to aActions.count
      sAction = aActions[ii]
      aDirections = getDirections(VOID, sAction, sPart, VOID, VOID)
      aFrames = getFrames(VOID, sAction, sPart, VOID, VOID)
      aActionConfig[sAction] = [#dir: aDirections, #fr: aFrames]
    end repeat
    aConfigList[sPart] = aActionConfig
  end repeat
  return aConfigList
end

on getUniquePartsForAction act
end

on fillPartCodes
  aParts = [:]
  aParts[#bd] = "Body Codes"
  aParts[#hd] = "Head Codes"
  aParts[#fc] = "Face Codes"
  aParts[#ey] = "Eye Codes"
  aParts[#hr] = "Hair Codes"
  aParts[#ch] = "Shirt Codes"
  aParts[#lh] = "Left Arm Codes"
  aParts[#rh] = "Right Arm Codes"
  aParts[#ls] = "Left Sleeve Codes"
  aParts[#rs] = "Right Sleeve Codes"
  aParts[#lg] = "Pants Codes"
  aParts[#sh] = "Shoes Codes"
  aParts[#ri] = "Item Codes"
  repeat with i = 1 to aParts.count
    sPart = aParts.getPropAt(i)
    sMember = aParts[sPart]
    oMember = member(sMember)
    oMember.text = EMPTY
    aCodes = getPartCodesForPart(string(sPart))
    repeat with ii = 1 to aCodes.count
      sCode = aCodes[ii]
      oMember.text = oMember.text & sCode
      if ii < aCodes.count then
        oMember.text = oMember.text & RETURN
      end if
    end repeat
  end repeat
end

on fillPartActions
  aParts = [:]
  aParts[#bd] = "Body Actions"
  aParts[#hd] = "Head Actions"
  aParts[#fc] = "Face Actions"
  aParts[#ey] = "Eye Actions"
  aParts[#hr] = "Hair Actions"
  aParts[#ch] = "Shirt Actions"
  aParts[#lh] = "Left Arm Actions"
  aParts[#rh] = "Right Arm Actions"
  aParts[#ls] = "Left Sleeve Actions"
  aParts[#rs] = "Right Sleeve Actions"
  aParts[#lg] = "Pants Actions"
  aParts[#sh] = "Shoes Actions"
  aParts[#ri] = "Item Actions"
  repeat with i = 1 to aParts.count
    sPart = aParts.getPropAt(i)
    sMember = aParts[sPart]
    oMember = member(sMember)
    oMember.text = EMPTY
    aActions = getActionsForPart(string(sPart))
    repeat with ii = 1 to aActions.count
      sAction = aActions[ii]
      oMember.text = oMember.text & sAction
      if ii < aActions.count then
        oMember.text = oMember.text & RETURN
      end if
    end repeat
  end repeat
end

on fillParts
  sParts = EMPTY
  aParts = getUniqueParts()
  repeat with i = 1 to aParts.count
    sParts = sParts & aParts[i]
    if i < aParts.count then
      sParts = sParts & RETURN
    end if
  end repeat
  member("Parts").text = sParts
end

on getMemberRect oMember
  oRegPoint = oMember.regPoint
  return rect(oRegPoint.locH, oRegPoint.locV - 110, oRegPoint.locH + 77, oRegPoint.locV)
end

on flipHSpriteRect oSprite
  oOrigRect = oSprite.rect
  iLeft = oOrigRect.left
  iLocH = oSprite.locH
  iHDif = ((iLocH - iLeft) * 2) - oOrigRect.width
  rDifRect = rect(iHDif, 0, iHDif, 0)
  oNewRect = oOrigRect + rDifRect
  return oNewRect
end

on fillColors
  sR = EMPTY
  sG = EMPTY
  sB = EMPTY
  repeat with i = 0 to 255
    sR = sR & i
    if i < 255 then
      sR = sR & RETURN
    end if
    sG = sG & i
    if i < 255 then
      sG = sG & RETURN
    end if
    sB = sB & i
    if i < 255 then
      sB = sB & RETURN
    end if
  end repeat
  member("ColorR").text = sR
  member("ColorR").text = sG
  member("ColorR").text = sB
end
