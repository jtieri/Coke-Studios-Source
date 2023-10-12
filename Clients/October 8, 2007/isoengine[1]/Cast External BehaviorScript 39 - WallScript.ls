property oController, sId1, sId2, sId3, sId4, sId5
global oIsoScene

on new me, _oController, _sId1, _sId2, _sId3, _sId4, _sId5
  me.oController = _oController
  me.sId1 = _sId1
  me.sId2 = _sId2
  me.sId3 = _sId3
  me.sId4 = _sId4
  me.sId5 = _sId5
  return me
end

on getController me
  return me.oController
end

on mouseDown me
  pass()
end

on getId1 me
  return me.sId1
end

on getId2 me
  return me.sId2
end

on getId3 me
  return me.sId3
end

on getId4 me
  return me.sId4
end

on getId5 me
  return me.sId5
end
