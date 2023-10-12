property bDebug, oPathfinder, iRows, iCols, aNodes
global oIsoScene

on new me, _iRows, _iCols, oXml
  me.bDebug = 0
  me.oPathfinder = new(script("AStar"), me)
  me.reset(_iRows, _iCols)
  if not voidp(oXml) then
    me.createMapFromXML(oXml)
  end if
  me.debug("new Map()")
  return me
end

on reset me, _iRows, _iCols
  me.iRows = _iRows
  me.iCols = _iCols
  me.createNodes()
end

on createNodes me
  me.aNodes = []
  repeat with iRow = 1 to me.iRows
    aRow = []
    repeat with iCol = 1 to me.iCols
      aRow.append(new(script("MapNode"), iRow, iCol, me.oPathfinder.W_BLOCKED))
    end repeat
    me.aNodes.append(aRow)
  end repeat
  nothing()
end

on getNodeByWeight me, iW
  repeat with iRow = 1 to me.iRows
    repeat with iCol = 1 to me.iCols
      oNode = me.getNode(iRow, iCol)
      if oNode.w = iW then
        return oNode
      end if
    end repeat
  end repeat
end

on getNode me, iRow, iCol
  if iRow = 0 then
    return VOID
  end if
  if iCol = 0 then
    return VOID
  end if
  if iRow > me.iRows then
    return VOID
  end if
  if iCol > me.iCols then
    return VOID
  end if
  return me.aNodes[iRow][iCol]
end

on setWeight me, iW, iRow, iCol
  me.getNode(iRow, iCol).w = iW
end

on createMapFromXML me, oXml
  me.debug("createMapFromXML()")
  if oXml = VOID then
    me.aNodes = []
    repeat with iRow = 1 to me.iRows
      aRow = []
      repeat with iCol = 1 to me.iCols
        aRow.append(new(script("MapNode"), iRow, iCol, me.oPathfinder.W_OPEN))
      end repeat
      me.aNodes.append(aRow)
    end repeat
    return 
  end if
  oRoot = oXml.firstChild
  iRows = integer(oRoot.attributes.rows)
  iCols = integer(oRoot.attributes.cols)
  me.reset(iRows, iCols)
  aTiles = oRoot.childNodes
  repeat with i = 0 to aTiles.length - 1
    oTile = aTiles[i]
    iRow = integer(oTile.attributes.r)
    iCol = integer(oTile.attributes.c)
    iW = integer(oTile.attributes.w)
    aP = []
    aPointers = me.getXMLNodes(oTile, "PointerNode")
    if not voidp(aPointers) then
      repeat with ii = 1 to aPointers.count
        oPNode = aPointers[ii]
        iPRow = integer(oPNode.attributes.r)
        iPCol = integer(oPNode.attributes.c)
        aP.add([#row: iPRow, #col: iPCol])
      end repeat
    end if
    oNode = me.getNode(iRow, iCol)
    oNode.w = iW
    oNode.p = aP
  end repeat
end

on getXMLNode me, oXml, sNodeName
  aChildren = oXml.childNodes
  repeat with i = 0 to aChildren.length - 1
    oNode = aChildren[i]
    if oNode.nodeName = sNodeName then
      return oNode
    end if
  end repeat
end

on getXMLNodes me, xml, sNodeName
  aXmlNodes = []
  childNodes = xml.childNodes
  repeat with i = 0 to childNodes.length - 1
    node = childNodes[i]
    if node.nodeName = sNodeName then
      aXmlNodes.add(node)
    end if
  end repeat
  return aXmlNodes
end

on toString me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "Map:" & sMessage
  end if
end
