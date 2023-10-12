property aSprites, iExitSprite, iLowestZ, oSquare, oHitTestColor
global oIsoScene, oStudio, oStudioMap

on new me
  me.aSprites = []
  return me
end

on Init me, oXml
  if voidp(oXml) then
    return 
  end if
  me.drawDoor(oXml)
  me.iLowestZ = me.calculateLowestZ()
  me.oHitTestColor = paletteIndex(0)
end

on drawDoor me, oXml
  if voidp(oXml) then
    return 
  end if
  iRow = integer(oXml.attributes.row)
  iCol = integer(oXml.attributes.col)
  me.oSquare = oIsoScene.oGrid.getSquareByRowCol(iRow, iCol)
  oLoc = me.oSquare.oViewPoints.bl
  oFloorTile = getNode(oXml, "FloorTile")
  if not voidp(oFloorTile) then
    aFloorTileProps = oIsoScene.oSpriteManager.buildSpriteProps(oFloorTile)
    oIsoScene.oFloor.drawFloortile(iRow, iCol, aFloorTileProps)
  end if
  oExit = getNode(oXml, "Exit")
  if not voidp(oExit) then
    aProps = oIsoScene.oSpriteManager.buildSpriteProps(oExit)
    aProps[#x] = oLoc.locH
    aProps[#y] = oLoc.locV
    iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
    oExitScript = script("ExitStudio").new(me)
    sprite(iSprite).scriptInstanceList.add(oExitScript)
    me.iExitSprite = iSprite
  end if
  oDoorMask = getNode(oXml, "DoorMask")
  if not voidp(oDoorMask) then
    sDoorMask = oDoorMask.toString()
    iXOff = 0
    iYOff = 0
    if sDoorMask contains "xoff=" then
      iXOff = integer(oDoorMask.attributes.xoff)
    end if
    if sDoorMask contains "yoff=" then
      iYOff = integer(oDoorMask.attributes.yoff)
    end if
    case oStudioMap.iLayout of
      6, 10:
        aProps = [#member: "starsuite_doormask_1_c_0_2_0", #x: oLoc.locH - 1, #y: oLoc.locV + 1, #ink: 8]
      7, 8:
        aProps = [#member: "model_e_f_doormask_1_c_0_2_0", #x: oLoc.locH + 5, #y: oLoc.locV - 3, #ink: 8]
      9:
        aProps = [#member: "model_g_doormask_1_c_0_2_0", #x: oLoc.locH + 1, #y: oLoc.locV - 3, #ink: 8]
      otherwise:
        aProps = [#member: "wall_doormask_1_c_0_2_0", #x: oLoc.locH - 1, #y: oLoc.locV + 1, #ink: 8]
    end case
    iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
    sprite(iSprite).locH = sprite(iSprite).locH + iXOff
    sprite(iSprite).locV = sprite(iSprite).locV + iYOff
    sprite(iSprite).locV = sprite(iSprite).locV - 1
    me.aSprites.add(iSprite)
    case oStudioMap.iLayout of
      6, 10:
        aProps = [#member: "starsuite_doormask_1_d_0_2_0", #x: oLoc.locH - 1, #y: oLoc.locV + 1, #ink: 8]
      7, 8:
        aProps = [#member: "model_e_f_doormask_1_d_0_2_0", #x: oLoc.locH + 5, #y: oLoc.locV - 3, #ink: 8]
      9:
        aProps = [#member: "model_g_doormask_1_d_0_2_0", #x: oLoc.locH + 2, #y: oLoc.locV - 3, #ink: 8]
      otherwise:
        aProps = [#member: "wall_doormask_1_d_0_2_0", #x: oLoc.locH - 1, #y: oLoc.locV + 1, #ink: 8]
    end case
    iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(aProps)
    sprite(iSprite).locH = sprite(iSprite).locH + iXOff
    sprite(iSprite).locV = sprite(iSprite).locV + iYOff
    sprite(iSprite).locV = sprite(iSprite).locV - 1
    me.aSprites.add(iSprite)
    oIsoScene.oWall.drawWallTile(iRow, iCol, "wall_doormask_1_b_0_2_0", "right", "wall_doormask", "color", VOID, 0, 1)
    oIsoScene.oWall.drawWallTile(iRow, iCol, "wall_doormask_1_a_0_2_0", "right", "wall_doormask", "texture", VOID, 0, 1)
  end if
end

on mouseDownEvent me, iSprite, oSprite
  oIsoScene.mouseDownEvent()
end

on exitSelected me
  if voidp(oStudio) then
    return 
  end if
  oStudio.sendExitStudioViaDoor()
end

on mouseOverDoor me
  if voidp(me.iExitSprite) then
    return 0
  else
    return me.mouseIsOverITem()
  end if
end

on destroy me
  oIsoScene.oSpriteManager.returnPooledSprites(me.aSprites)
  oIsoScene.oSpriteManager.returnPooledSprite(me.iExitSprite)
  me.aSprites = []
  me.iExitSprite = VOID
end

on toggleDisplay me
  repeat with i in me.aSprites
    sprite(i).visible = not sprite(i).visible
  end repeat
  if not voidp(me.iExitSprite) then
    sprite(me.iExitSprite).visible = not sprite(me.iExitSprite).visible
  end if
end

on calculateLowestZ me
  _iLowestZ = VOID
  repeat with i in me.aSprites
    _iZ = sprite(i).locZ
    if voidp(_iLowestZ) then
      _iLowestZ = _iZ
      next repeat
    end if
    if _iZ < _iLowestZ then
      _iLowestZ = _iZ
    end if
  end repeat
  return _iLowestZ
end

on getLowestZ me
  return me.iLowestZ
end

on getExitSprite me
  return me.iExitSprite
end

on hitTest me, iSpriteNum
  _oSprite = sprite(iSpriteNum)
  if voidp(_oSprite) then
    return 0
  end if
  _oMember = _oSprite.member
  if voidp(_oMember) then
    return 0
  end if
  if _oMember.memberNum <= 0 then
    return 0
  end if
  _oMemberLoc = _oSprite.mapStageToMember(the mouseLoc)
  if voidp(_oMemberLoc) then
    return 0
  end if
  _oImage = _oMember.image
  _oPixelColor = _oImage.getPixel(_oMemberLoc)
  bHitTest = 0
  if _oPixelColor <> me.oHitTestColor then
    return 1
  end if
  return 0
end

on mouseIsOverITem me
  if me.hitTest(me.iExitSprite) then
    return 1
  end if
end
