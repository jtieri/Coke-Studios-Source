property oController, oActiveMember, oPressedMember, sID, myURL
global oIsoScene, ElementMgr

on new me, _myURL, _oController, _oActiveMember, _oPressedMember
  me.myURL = _myURL
  me.oController = _oController
  me.oActiveMember = _oActiveMember
  me.oPressedMember = _oPressedMember
  return me
end

on mouseDown me
  if the doubleClick then
    stopEvent()
    return 
  end if
  sprite(me.spriteNum).member = me.oPressedMember
  updateStage()
end

on mouseUp me
  sprite(me.spriteNum).member = me.oActiveMember
  updateStage()
  bClickAllowed = oIsoScene.clickAllowed()
  if not bClickAllowed then
    stopEvent()
    return 
  end if
  ElementMgr.URLdialog("ALERT_EXTERNAL_URL", myURL)
end

on mouseUpOutSide me
  sprite(me.spriteNum).member = me.oActiveMember
  updateStage()
end
