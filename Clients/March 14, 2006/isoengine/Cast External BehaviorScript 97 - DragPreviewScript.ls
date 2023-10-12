property oController
global oIsoScene, ElementMgr

on new me, _oController
  me.oController = _oController
  return me
end

on mouseDown me
  put "Preview.mouseDown()"
  bTrading = not voidp(ElementMgr.getTrader())
  if bTrading then
    bDropped = sendAllSprites(#testTradeDrop)
    if bDropped then
      pass()
      return 
    else
      if ElementMgr.mouseIsOverBackpack() then
        oIsoScene.deleteSelectedItem()
      end if
      stopEvent()
      return 
    end if
  end if
  oIsoScene.mouseDownEvent(the doubleClick)
  stopEvent()
end
