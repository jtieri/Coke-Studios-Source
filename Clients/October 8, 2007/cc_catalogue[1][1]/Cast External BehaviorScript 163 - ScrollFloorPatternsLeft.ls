global gFloors

on new me
  return me
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  sendAllSprites(#scrollFloorPattern, -1)
  dontPassEvent()
end
