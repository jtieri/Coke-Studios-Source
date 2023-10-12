on getNode oXml, sNodeName
  aChildren = oXml.childNodes
  repeat with i = 0 to aChildren.length - 1
    oNode = aChildren[i]
    if oNode.nodeName = sNodeName then
      return oNode
    end if
  end repeat
end

on getNodes oXml, sNodeName
  aNodes = []
  aChildren = oXml.childNodes
  repeat with i = 0 to aChildren.length - 1
    oNode = aChildren[i]
    if oNode.nodeName = sNodeName then
      aNodes.add(oNode)
    end if
  end repeat
  return aNodes
end
