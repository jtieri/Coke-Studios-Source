global gWalls

on new me
  return me
end

on mouseDown me
  dontPassEvent()
end

on mouseUp me
  sendAllSprites(#scrollwallPattern, -1)
  dontPassEvent()
end
