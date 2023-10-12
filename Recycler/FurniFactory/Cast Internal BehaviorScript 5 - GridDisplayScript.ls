on addToXml me, oXml
  iX = sprite(me.spriteNum).locH
  iY = sprite(me.spriteNum).locV
  oXml.attributes.xoff = iX
  oXml.attributes.yoff = iY
  oXml.attributes.layoutType = 1
end
