property pLoc, pTextOffset, pTextOffsetBegin, mTextMember, iTextSprite, hexColor, htmlHeader, htmlFooter
global oSpriteManager

on beginSprite me
  me.hexColor = "#7D5543"
  me.htmlHeader = "<html><body bg=#000000 text=" & me.hexColor & " link=" & me.hexColor & " alink=" & me.hexColor & " vlink=" & me.hexColor & "><center><font face=" & QUOTE & "FFF Reaction *" & QUOTE & ">"
  me.htmlFooter = "</font></center></body></html>"
  me.pLoc = sprite(me.spriteNum).loc
  me.mTextMember = member("alertbox_text")
  me.iTextSprite = me.spriteNum + 1
  me.pTextOffsetBegin = point(380, 282)
  me.pTextOffset = point(380, 250)
  me.hideAlert()
end

on hideAlert me
  sprite(me.spriteNum).loc = point(-1500, -1500)
  sprite(me.iTextSprite).loc = point(-1500, -1500)
end

on showAlert me, sMessage
  me.mTextMember.html = me.htmlHeader & sMessage & me.htmlFooter
  puppetSprite(me.iTextSprite, 1)
  sprite(me.iTextSprite).member = me.mTextMember
  sprite(me.iTextSprite).ink = 8
  sprite(me.spriteNum).locZ = 16000
  sprite(me.spriteNum).loc = me.pLoc
  sprite(me.iTextSprite).locZ = 16001
  if the frameLabel contains "begin" then
    sprite(me.iTextSprite).loc = me.pTextOffsetBegin
  else
    sprite(me.iTextSprite).loc = me.pTextOffset
  end if
end

on endSprite me
end
