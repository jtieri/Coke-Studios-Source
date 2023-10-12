property aProps, aSprites
global oIsoScene, oStudio

on new me
  me.aProps = [#member: "StudioInfoText", #x: 15, #y: 430, #ink: 36]
  me.aSprites = []
  return me
end

on Init me
  me.display()
end

on display me
  if voidp(oStudio) then
    return 
  end if
  sText = "Studio: " & oStudio.getStudioName() & RETURN
  sText = sText & "Owner: " & oStudio.getOwner()
  oMember = member(me.aProps[#member])
  oMember.text = sText
  oMember.font = "verdana"
  oMember.boxType = #fixed
  oMember.fontSize = 10
  oMember.fontStyle = [#bold]
  iSprite = oIsoScene.oSpriteManager.drawStaticSceneSprite(me.aProps)
  me.aSprites.add(iSprite)
end

on destroy me
  oIsoScene.oSpriteManager.returnPooledSprites(me.aSprites)
  me.aSprites = []
end
