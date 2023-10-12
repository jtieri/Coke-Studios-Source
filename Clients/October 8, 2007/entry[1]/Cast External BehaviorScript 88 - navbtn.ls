on new me
  return me
end

on mouseUp me
  global ElementMgr
  repeat with n = 1 to count(ElementMgr.pOpenWindows)
    if getPropAt(ElementMgr.pOpenWindows, n).char[1..4] = "nav_" then
      ElementMgr.pOpenWindows[n].closeWindow()
      exit repeat
      next repeat
    end if
    if n = count(ElementMgr.pOpenWindows) then
      if member("roomdisplay").memberNum < 1 then
        ElementMgr.newwindow("nav_public_start.window")
        exit repeat
        next repeat
      end if
      if (member("roomdisplay").comments.line[3] = EMPTY) or (member("roomdisplay").comments.line[3] = "0") then
        ElementMgr.newwindow("nav_public_start.window", [434, 66, 721, 427])
        exit repeat
        next repeat
      end if
      ElementMgr.newwindow("nav_public_info.window", [434, 66, 721, 427])
      exit repeat
    end if
  end repeat
end
