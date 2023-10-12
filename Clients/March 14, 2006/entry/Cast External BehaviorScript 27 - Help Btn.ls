property pID
global TextMgr

on beginSprite me
  pID = "HELP_ROLL"
end

on mouseWithin me
  TextMgr(pID)
end
