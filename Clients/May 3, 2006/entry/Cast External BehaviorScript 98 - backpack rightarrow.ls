property pParentWindow
global oStudio

on new me, parentwindow
  pParentWindow = parentwindow
  return me
end

on mouseDown me
  stopEvent()
end

on mouseUp me
  global oDenizenManager, oPossessionManager
  if sprite(pParentWindow.pSpritelist[2]).pIndex < sprite(pParentWindow.pSpritelist[2]).pTotalPages then
    myindex = sprite(pParentWindow.pSpritelist[2]).pIndex + 1
  else
    myindex = 1
  end if
  sprite(pParentWindow.pSpritelist[2]).pIndex = myindex
  myscreenname = oDenizenManager.getScreenName()
  oPossessionManager.getPossessionsInBackpack(myscreenname, myindex, 25)
  stopEvent()
end

on hiderightarrow me
  sprite(me.spriteNum).member = member("arrow_placeholder")
end

on showrightarrow me
  sprite(me.spriteNum).member = member("cc.pack.rightarrow")
end
