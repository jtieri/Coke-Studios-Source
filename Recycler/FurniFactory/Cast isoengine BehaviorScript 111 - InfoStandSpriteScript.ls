property oController, oActiveMember, oPressedMember, sID
global oIsoScene

on new me, _sId, _oController, _oActiveMember, _oPressedMember
  me.sID = _sId
  me.oController = _oController
  me.oActiveMember = _oActiveMember
  me.oPressedMember = _oPressedMember
  return me
end

on mouseDown me
  sprite(me.spriteNum).member = me.oPressedMember
  updateStage()
end

on mouseUp me
  sprite(me.spriteNum).member = me.oActiveMember
  updateStage()
  bClickAllowed = oIsoScene.clickAllowed()
  if not bClickAllowed then
    return 
  end if
  me.oController.mouseUpEvent(me.sID)
end

on mouseUpOutSide me
  sprite(me.spriteNum).member = me.oActiveMember
  updateStage()
end
