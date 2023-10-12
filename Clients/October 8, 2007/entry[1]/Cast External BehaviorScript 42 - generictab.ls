property pParentWindow, pDest, pClicked, bDebug
global gFeatureSet, ElementMgr, oStudioManager

on new me, whichparent, whichdestination
  bDebug = 1
  pParentWindow = whichparent
  pDest = whichdestination
  return me
end

on debug me, sMessage, bForce
  if me.bDebug or bForce then
    put "generictab: " & sMessage
  end if
end

on mouseUp me
  if pClicked then
    me.debug("pParentWindow.pName:" && pParentWindow.pname)
    me.debug("pDest:" && pDest)
    if pParentWindow.pname contains "nav_public" then
      roomdata = pParentWindow.pScrollingLists.roomlist.pRoomData
      if count(roomdata) then
        scrollindex = pParentWindow.pScrollingLists.roomlist.pScrollIndex
        lastclicked = pParentWindow.pScrollingLists.roomlist.pLastClicked
        member("roomdisplay").comments = roomdata & RETURN & scrollindex & RETURN & lastclicked
      end if
    end if
    if pDest = "nav_private_start.window" then
      if not gFeatureSet.isEnabled(#PRIVATE_STUDIOS) then
        ElementMgr.alert("FEATURE_DISABLED")
        return 
      end if
      if member("userlist").memberNum > 0 then
        member("userlist").comments = EMPTY
      end if
    else
      if pDest = "nav_private_people.window" then
        userData = pParentWindow.pScrollingLists.userList.pUserData
        if count(userData) then
          userData = string(userData)
          repeat while userData contains "<void>"
            mypos = offset("<void>", userData)
            delete char mypos + 5 of userData
            delete char mypos of userData
          end repeat
          scrollindex = pParentWindow.pScrollingLists.userList.pScrollIndex
          member("userlist").comments = userData & RETURN & scrollindex
        end if
      end if
    end if
    the updateLock = 1
    myRect = pParentWindow.prect
    pParentWindow.closeWindow()
    ElementMgr.newwindow(pDest, myRect)
    if pDest = "nav_private_info.window" then
      oStudioManager.getPrivateStudioDetail(member("userroomid").text)
    else
      if pDest = "nav_public_info.window" then
        sRoomId = member("roomID").text
        oStudioManager.getPublicStudioDetail(sRoomId)
      end if
    end if
    updateStage()
    the updateLock = 0
  end if
end

on mouseDown me
  pClicked = 1
  stopEvent()
end
