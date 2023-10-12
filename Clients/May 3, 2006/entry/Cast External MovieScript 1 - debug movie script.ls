on outputSpriteList
  repeat with i = 1 to 1000
    if sprite(i).member <> member(0, 0) then
      put "sprite:" && i && "member:" && sprite(i).member.name && "scripts:" && sprite(i).scriptInstanceList
    end if
  end repeat
end

on clearOldAvatarCastMembers
  put "*** CLEARING OLD AVATAR CAST MEMBERS ***"
  bShouldClear = 0
  repeat with i = 1 to castLib("AvatarEngine").member.count
    if bShouldClear then
      testname = castLib("AvatarEngine").member[i].name
      testtype = castLib("AvatarEngine").member[i].type
      put "Number=" & i && "Membername=" & testname && "Type=" & testtype
      castLib("AvatarEngine").member[i].erase()
    end if
    if not bShouldClear then
      bShouldClear = castLib("AvatarEngine").member[i].name = "_PREVIEW_"
    end if
  end repeat
  put "***  ***"
end
