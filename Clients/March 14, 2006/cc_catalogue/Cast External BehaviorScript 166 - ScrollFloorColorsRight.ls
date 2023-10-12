global gFloors

on new me
  return me
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  sendAllSprites(#scrollFloorColor, 1)
  dontPassEvent()
end
