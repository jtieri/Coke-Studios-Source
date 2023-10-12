on new me
  return me
end

on mouseWithin me
  global TextMgr
  member("cc.entry.cfh").text = TextMgr.GetRefText("MESSENGER")
end

on mouseLeave me
  global TextMgr
  member("cc.entry.cfh").text = TextMgr.GetRefText("CALL_FOR_ASSISTANCE")
end
