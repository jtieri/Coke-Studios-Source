property pRollText

on new me, id
  global TextMgr
  myID = id
  IDs = ["cb.jukebox.btn", "cb.nav.btn", "cb.mms.btn", "cb.dbs.btn", "cb.bag.btn", "cb.cat.btn", "cb.snd.btn", "cb.hlp.btn"]
  Refs = ["JUKEBOX", "NAVIGATOR", "MESSENGER", "BALANCE", "YOUR_ITEMS", "CATALOGUE", "SOUND", "CALL_FOR_ASSISTANCE"]
  myref = Refs[getPos(IDs, myID)]
  pRollText = TextMgr.GetRefText(myref)
  return me
end

on mouseWithin me
  member("cb.rolldisplay").text = pRollText
end

on mouseLeave me
  member("cb.rolldisplay").text = EMPTY
end
