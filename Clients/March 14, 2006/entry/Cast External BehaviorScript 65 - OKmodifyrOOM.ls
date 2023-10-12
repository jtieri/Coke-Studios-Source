property pParentWindow, pStatus
global ElementMgr

on new me, whichparent
  pParentWindow = whichparent
  pStatus = #idle
  return me
end

on mouseUp me
  global ElementMgr, oDenizenManager, oStudioManager, TextMgr
  pStatus = #idle
  if member("nav_modify_studio_name").text = EMPTY then
    ElementMgr.alert("ALERT_ST_NAME")
  else
    sScreenName = oDenizenManager.getScreenName()
    sStudioID = member("userroomID").text
    sStudioName = member("nav_modify_studio_name").text
    sDescription = member("nav_modify_studio_desc").text
    repeat with n in pParentWindow.pSpritelist
      if sprite(n).member = member("cc.radiobutton.active.on") then
        myID = sprite(n).pID
        the itemDelimiter = "_"
        if myID contains "nav_studiolocation_radio_" then
          iLocationID = integer(myID.item[myID.items.count])
        else
          if myID contains "nav_createstudio_radio_" then
            iLayoutID = integer(myID.item[myID.items.count])
          end if
        end if
      end if
      if (voidp(iLayoutID) = 0) and (voidp(iLocationID) = 0) then
        exit repeat
      end if
    end repeat
    myRect = pParentWindow.prect
    pParentWindow.closeWindow()
    ElementMgr.newwindow("nav_loadnewroom.window", myRect)
    oStudioManager.modifyStudio(sStudioID, sStudioName, sDescription)
  end if
end

on mouseDown me
  pStatus = #clicked
  stopEvent()
end

on mouseUpOutSide me
  pStatus = #idle
end

on mouseWithin me
  myName = sprite(me.spriteNum).member.name
  if (pStatus = #clicked) and the mouseDown then
    the itemDelimiter = "."
    myName = myName.item[1..myName.items.count - 1] & ".pressed"
    the itemDelimiter = ","
    sprite(me.spriteNum).member = member(myName)
    updateStage()
  else
    the itemDelimiter = "."
    myName = myName.item[1..myName.items.count - 1] & ".active"
    the itemDelimiter = ","
    sprite(me.spriteNum).member = member(myName)
    updateStage()
  end if
end

on mouseLeave me
  myName = sprite(me.spriteNum).member.name
  the itemDelimiter = "."
  myName = myName.item[1..myName.items.count - 1] & ".active"
  the itemDelimiter = ","
  sprite(me.spriteNum).member = member(myName)
end
