property bDebug, bInitialized, bReadyForuse, aStudioData
global sLanguageSetting, oStudioManager, oPublicstudioData, sPublicStudioText

on beginSprite me
  me.bDebug = 1
  me.bInitialized = 0
  me.bReadyForuse = 0
  oPublicstudioData = me
  me.aStudioData = []
end

on exitFrame me
  if not me.bInitialized then
    me.loadData()
    me.bInitialized = 1
    me.bReadyForuse = 1
  end if
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "PublicStudioData: " & sMessage
  end if
end

on loadData me
  me.debug("loadData()")
  me.bReadyForuse = 1
  oXml = newObject("Xml")
  oXml.ignoreWhite = 1
  oXml.parseXML(sPublicStudioText)
  me.aStudioData = []
  aStudioNodes = getNodes(oXml.firstChild, "Studio")
  repeat with i = 1 to aStudioNodes.count
    oStudioNode = aStudioNodes[i]
    sStudioID = oStudioNode.attributes.studioId
    sName = oStudioNode.attributes.name
    sDescription = oStudioNode.attributes.description
    iUserCount = integer(oStudioNode.attributes.userCount)
    iCapacity = integer(oStudioNode.attributes.capacity)
    iLocation = integer(oStudioNode.attributes.location)
    iLayout = integer(oStudioNode.attributes.layout)
    sOwner = oStudioNode.attributes.owner
    sServer = EMPTY
    aStudio = [#studioId: sStudioID, #name: sName, #description: sDescription, #userCount: iUserCount, #capacity: iCapacity, #location: iLocation, #layout: iLayout, #owner: sOwner, #server: sServer]
    me.aStudioData.add(aStudio)
  end repeat
  nothing()
end

on getStudioData me
  return me.aStudioData
end

on updateStudio me, sStudioID, iUserCount, iCapacity, iLocation, sServer
  iIndex = me.getStudioIndex(sStudioID)
  if not voidp(iIndex) then
    me.aStudioData[iIndex][#userCount] = iUserCount
    me.aStudioData[iIndex][#capacity] = iCapacity
    me.aStudioData[iIndex][#location] = iLocation
    me.aStudioData[iIndex][#server] = sServer
  end if
end

on getStudio me, sStudioID
  repeat with i = 1 to aStudioData.count
    oStudio = me.aStudioData[i]
    if oStudio[#studioId] = sStudioID then
      return oStudio
    end if
  end repeat
end

on getStudioIndex me, sStudioID
  repeat with i = 1 to aStudioData.count
    oStudio = me.aStudioData[i]
    if oStudio[#studioId] = sStudioID then
      return i
    end if
  end repeat
end

on syncWithServer me, oResult
  aSyncData = []
  iLength = oResult.length
  repeat with i = 0 to iLength - 1
    oStudio = oResult[i]
    sStudioID = oStudio.getStudioID()
    aStudio = me.getStudio(sStudioID)
    if not voidp(aStudio) then
      aSyncData.add(aStudio)
      next repeat
    end if
    put "studio was null: " & sStudioID
  end repeat
  return aSyncData
end

on getPublicStudioDataSprite me
  return sprite(me.spriteNum)
end
