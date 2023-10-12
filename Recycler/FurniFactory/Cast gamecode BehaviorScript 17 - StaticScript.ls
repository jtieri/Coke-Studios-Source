property iRow, iCol, iLayer

on beginSprite me
  sprite(me.spriteNum).locZ = (me.iRow * 100) + me.iCol
end

on initTexts me
  if (sprite(me.spriteNum).member.type = #field) or (sprite(me.spriteNum).member.type = #text) then
    sprite(me.spriteNum).member.text = EMPTY
  end if
end

on getPropertyDescriptionList me
  vRowColRange = []
  repeat with i = 1 to 30
    vRowColRange.add(i)
  end repeat
  vLayerRange = []
  repeat with i = 1 to 10
    vLayerRange.add(i)
  end repeat
  vList = [:]
  vList.addProp(#iRow, [#comment: "Row", #range: vRowColRange, #format: #integer, #default: vRowColRange[1]])
  vList.addProp(#iCol, [#comment: "Column", #range: vRowColRange, #format: #integer, #default: vRowColRange[1]])
  vList.addProp(#iLayer, [#comment: "Layer", #range: vLayerRange, #format: #integer, #default: vLayerRange[1]])
  return vList
end
