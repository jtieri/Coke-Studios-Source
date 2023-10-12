global ElementMgr

on new me
  return me
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  ElementMgr.getMixer().closeWindow()
  dontPassEvent()
end
