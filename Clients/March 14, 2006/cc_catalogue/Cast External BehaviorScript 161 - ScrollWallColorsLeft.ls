global gWalls

on new me
  return me
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  sendAllSprites(#scrollwallColor, -1)
  dontPassEvent()
end
