property oController
global oIsoScene

on new me, _oController
  me.oController = _oController
  return me
end

on getController me
  return me.oController
end
