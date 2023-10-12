property spriteNum, mySprite, myname, myContent, myAction, myCheckmark, myStandard, myListMember, myField, myItemsList, myRestoreString, myDisplayString, myItemHeight, myOpenRect, myClosedRect, myClosedLoc, myOpenHeight, myStageHeight, myStageWidth, mySelectedItem, myListIsOpen, myClickTicks, myLastHilite, myoriginaleditablestate, myoriginallocz

on getBehaviorDescription me
  return "DROPDOWN LIST" & RETURN & RETURN & "Drop this behavior on a field member to create a pop-up list. " & "Animations continue while the the list is kept open." & RETURN & RETURN & "When the user clicks on the sprite, the dropdown list opens to reveal all its items. " & "If the user immediately releases the mouse, the menu remains open until the next click. " & "When the user selects a menu item, the menu closes up to displays the selected item. " & "If the user clicks elsewhere, the menu closes to display the previously selected item." & RETURN & RETURN & "You can use one of two modes for the dropdown list:" & RETURN & "1) To allow the user to make a selection." & RETURN & "2) To execute a simple command." & RETURN & RETURN & "SELECTION" & RETURN & RETURN & "In the first case, you will need to determine what the user selected. " & "To interrogate the dropdown list, use syntax similar to the following:" & RETURN & RETURN & "   put sendAllSprites (#DropList_Selection, 'listName')" & RETURN & RETURN & "This returns a property list with all the necessary information:" & RETURN & RETURN & "-- [#item: 1, #text: 'First choice', #type: #content, #sprite: 1]" & RETURN & RETURN & "See the Notes for developers in the script itself for more details." & RETURN & RETURN & "You can choose any character to act as a checkmark to indicate the previous selection when the dropdown list is open. " & "Depending on the font you use, you may wish to use a checkmark followed by a space. " & "Reopen the Behavior Parameters dialog to make such a change." & RETURN & RETURN & "EXECUTION" & RETURN & RETURN & "You can choose to execute three types of command:" & RETURN & "a) go marker (<selected item>)" & RETURN & "b) go movie '<selected item>'" & RETURN & "c) do '<selected item>'" & RETURN & RETURN & "The type of command depends on the contents of the list. " & "The behavior can automatically create a list of markers in the current movie, or movies in the current folder... " & "or it can leave the contents of the field as they are. " & "In this last case, choosing Execute makes the behavior treat the selected item as a Lingo command. " & "You should include handlers in a movie script to deal with such commands." & RETURN & RETURN & "TIP: Place the dropdown list sprite in a high channel where it will not be covered by any other sprites." & RETURN & RETURN & "PERMITTED MEMBER TYPES:" & RETURN & "field" & RETURN & RETURN & "PARAMETERS:" & RETURN & "* Name of the list (used in sendAllSprite calls)" & RETURN & "* Purpose - Choose between:" & RETURN & "  - Marker: creates a list of markers in current movie" & RETURN & "  - Movie: creates a list of movies with the same pathName" & RETURN & "  - Field contents: uses the current contents of the field" & RETURN & "* Action on selection - Choose between:" & RETURN & "  - Execute: go movie | go marker | do selectedLine" & RETURN & "  - Select:  return the selected item if called to do so" & RETURN & "* Checkmark to indicate currently selected item" & RETURN & "* Standard style: deselect this option if you want to give the field member a particular border, margin or shadow." & RETURN & RETURN & "PUBLIC METHODS:" & RETURN & "* Get info on currently selected item" & RETURN & "* Set the contents of the dropdown list" & RETURN & "* Toggle between Execute and Select modes" & RETURN & "* Get behavior reference"
end

on getBehaviorTooltip me
  return "Use with field members only." & RETURN & RETURN & "Turn a field into a pop-up list to execute commands or store selected data. " & "See the Behavior Description for tips on executing items with the 'do' command or accessing the currently selected item using Lingo." & RETURN & RETURN & "Options: Create a list of movies with the same path name, or a list of markers in the current movie."
end

on beginSprite me
  Initialize(me)
end

on endSprite me
  myListMember.editable = myoriginaleditablestate
  mySprite.locZ = myoriginallocz
end

on mouseDown me
  if not myListIsOpen then
    OpenList(me)
  end if
end

on prepareFrame me
  CheckListState(me)
end

on mouseUp me
  CheckClick(me)
end

on mouseUpOutSide me
  CloseList(me)
end

on CheckListState me
  if myListIsOpen then
    if the clickOn <> spriteNum then
      CloseList(me)
    else
      HiliteSelection(me)
    end if
  else
    if (myContent = #marker) and myAction then
      markerNumber = GetCurrentMarker(me)
      if mySelectedItem = markerNumber then
        exit
      end if
      mySelectedItem = markerNumber
      ScrollTo(me, mySelectedItem)
    end if
  end if
end

on OpenList me
  mySprite.locZ = the maxinteger
  myClickTicks = the ticks
  myListIsOpen = 1
  myDisplayString = myRestoreString
  if not myAction then
    put myCheckmark into myDisplayString.line[mySelectedItem].char[1..2]
  end if
  myListMember.text = myDisplayString
  currentScroll = myListMember.scrollTop
  if myOpenHeight <= myStageHeight then
    overShoot = currentScroll - myClosedLoc[2]
    if overShoot < 0 then
      overShoot = myOpenHeight - overShoot - myStageHeight
      if overShoot < 0 then
        mySprite.locV = myClosedLoc[2] - currentScroll
      else
        lineAdjust = ((overShoot - 1) / myItemHeight) + 1
        pixelAdjust = (lineAdjust * myItemHeight) - overShoot
        openTop = myStageHeight - myOpenHeight - pixelAdjust
        mySprite.locV = openTop
      end if
    else
      lineAdjust = ((overShoot - 1) / myItemHeight) + 1
      pixelAdjust = lineAdjust * myItemHeight
      openTop = pixelAdjust - overShoot
      mySprite.locV = openTop
    end if
    myListMember.scrollTop = 0
    myListMember.rect = myOpenRect
  else
    mySprite.locV = -2
    clippedRect = myOpenRect.duplicate()
    clippedRect[4] = myStageHeight
    myListMember.rect = clippedRect
    myListMember.boxType = #scroll
    if mySprite.right > myStageWidth then
      spriteWIdth = mySprite.right - mySprite.left
      mySprite.locH = myStageWidth - spriteWIdth
    end if
    scrollAdjust = myClosedLoc[2] - mySprite.locV
    myListMember.scrollTop = currentScroll - scrollAdjust
  end if
  updateStage()
end

on HiliteSelection me
  if the mouseMember <> myListMember then
    if myLastHilite then
      myLastHilite = 0
      hilite char the maxinteger of field myField
    end if
    exit
  else
    if myListMember.boxType = #scroll then
      AutoScroll(me)
    end if
    listLocV = mouseV() - mySprite.locV + myListMember.scrollTop
    mouseItem = (listLocV / myItemHeight) + 1
  end if
  if mouseItem = myLastHilite then
    exit
  end if
  if mouseItem > myItemsList.count then
    myLastHilite = 0
    hilite char the maxinteger of field myField
    exit
  end if
  myLastHilite = mouseItem
  if mouseItem = 1 then
    firstCharToHilite = 1
  else
    textBeforeMouseItem = line 1 to mouseItem - 1 of myDisplayString
    firstCharToHilite = the number of chars in textBeforeMouseItem + 2
  end if
  mouseItemLength = the number of chars in line mouseItem of myDisplayString
  lastCharToHilite = firstCharToHilite + mouseItemLength
  hilite char firstCharToHilite to lastCharToHilite of field myField
end

on AutoScroll me
  scrollDownHeight = myItemHeight / 2
  scrollUpHeight = myStageHeight - (myItemHeight / 2)
  currentScroll = myListMember.scrollTop
  if mouseV() < scrollDownHeight then
    if currentScroll <> 0 then
      newScroll = currentScroll - scrollDownHeight
      myListMember.scrollTop = max(0, newScroll)
    end if
  else
    if mouseV() > scrollUpHeight then
      maxScroll = myOpenHeight - myStageHeight
      if currentScroll <> maxScroll then
        newScroll = currentScroll + scrollDownHeight
        myListMember.scrollTop = min(maxScroll, newScroll)
      end if
    end if
  end if
end

on CheckClick me
  if (the ticks - myClickTicks) < 30 then
    myClickTicks = 0
  else
    if myLastHilite then
      mySelectedItem = myLastHilite
      sendSprite(sprite(me.spriteNum), #doAction)
    end if
    CloseList(me)
    if myAction and myLastHilite then
      Execute(me)
    end if
  end if
  myLastHilite = 0
end

on ScrollTo me, theLine
  myListMember.scrollTop = -10
  myListMember.scrollTop = myItemHeight * (theLine - 1)
end

on ScrollToText me, sName, sText
  if sName <> myname then
    exit
  end if
  repeat with i = 1 to myItemsList.count
    iLine = myItemsList.getPropAt(i)
    sLineText = myItemsList[i]
    if sLineText = sText then
      me.ScrollTo(iLine)
      mySelectedItem = iLine
    end if
  end repeat
end

on CloseList me
  hilite char the maxinteger of field myField
  if not myAction then
    myListMember.text = myRestoreString
  end if
  mySprite.loc = myClosedLoc
  mySprite.locZ = myoriginallocz
  myListMember.boxType = #fixed
  myListMember.rect = myClosedRect
  ScrollTo(me, mySelectedItem)
  myListIsOpen = 0
  if myContent <> #marker then
    updateStage()
  end if
end

on Execute me
  theItem = myItemsList[mySelectedItem]
  case myContent of
    #movie:
      if not (the movieName starts theItem & ".") then
        go(1, theItem)
      end if
    #marker:
      go(myItemsList.getPropAt(mySelectedItem))
    #content:
      do(theItem)
  end case
end

on Initialize me
  mySprite = sprite(me.spriteNum)
  myListMember = mySprite.member
  myoriginallocz = mySprite.locZ
  myoriginaleditablestate = myListMember.editable
  myListMember.editable = 0
  myField = myListMember.number
  case myContent of
    "Current contents of the field":
      myContent = #content
    "Markers in this movie":
      myContent = #marker
    "Movies with the same path name":
      myContent = #movie
  end case
  case myAction of
    "Select:  return the selected item when called":
      myAction = 0
    "Execute: go movie | go marker | do selectedLine":
      myAction = 1
  end case
  myListMember.wordWrap = 0
  myListMember.alignment = "left"
  myListMember.boxType = #fixed
  if myStandard then
    myListMember.border = 1
    myListMember.margin = 2
    myListMember.boxDropShadow = 2
  end if
  CreateItems(me)
  mySelectedItem = DefaultItem(me)
  SetDimensions(me)
  myListMember.rect = myClosedRect
  ScrollTo(me, mySelectedItem)
end

on CreateItems me
  case myContent of
    #content:
      CreateContentsLists(me)
    #marker:
      myRestoreString = AddSpaces(me, the labelList)
      myItemsList = GetMarkedFrames(me)
    #movie:
      myRestoreString = EMPTY
      myItemsList = [:]
      saveDelimiter = the itemDelimiter
      the itemDelimiter = "."
      CreateMovieLists(me, the moviePath)
      the itemDelimiter = saveDelimiter
  end case
end

on AddSpaces me, theText
  repeat while the last char in theText = RETURN
    delete char -30000 of theText
  end repeat
  newString = EMPTY
  lineCount = theText.line.count
  repeat while lineCount
    theItem = theText.line[lineCount]
    put "   " & theItem & RETURN before newString
    lineCount = lineCount - 1
  end repeat
  return newString
end

on CreateContentsLists me
  theText = myListMember.text
  repeat while the last char in theText = RETURN
    delete char -30000 of theText
  end repeat
  myRestoreString = EMPTY
  myItemsList = [:]
  lineCount = theText.line.count
  repeat with i = 1 to lineCount
    theItem = theText.line[i]
    if SPACE & myCheckmark contains theItem.char[1] then
      delete theItem.char[1]
      repeat while theItem.char[1] = " "
        delete theItem.char[1]
      end repeat
    end if
    myRestoreString = myRestoreString & "   " & theItem & RETURN
    myItemsList.addProp(i, theItem)
  end repeat
end

on GetMarkedFrames me
  markerlist = [:]
  sort(markerlist)
  lastCheckedMarker = 0
  if marker(1) <> marker(-(the maxinteger) / 2) then
    repeat with i = 0 down to -(the maxinteger)
      checkMarker = marker(i)
      if checkMarker = lastCheckedMarker then
        exit repeat
      end if
      lastCheckedMarker = checkMarker
      markerlist.addProp(checkMarker, 0)
    end repeat
  end if
  if marker(0) <> marker(the maxinteger / 2) then
    repeat with i = 1 to the maxinteger
      checkMarker = marker(i)
      if checkMarker = lastCheckedMarker then
        exit repeat
      end if
      lastCheckedMarker = checkMarker
      markerlist.addProp(checkMarker, 0)
    end repeat
  end if
  i = markerlist.count()
  theLabels = the labelList
  repeat while i
    markerlist[i] = theLabels.line[i]
    i = i - 1
  end repeat
  return markerlist
end

on CreateMovieLists me, folderName
  if the machineType = 256 then
    fileDelimiter = "\"
  else
    fileDelimiter = ":"
  end if
  fileCount = 0
  repeat while 1
    fileCount = fileCount + 1
    theFileName = getNthFileNameInFolder(folderName, fileCount)
    if theFileName = EMPTY then
      return 
      next repeat
    end if
    case item 2 of theFileName of
      "dir", "dxr", "dcr":
        theMovie = item 1 of theFileName
        myRestoreString = myRestoreString & "   " & theMovie & RETURN
        movieCount = myItemsList.count() + 1
        myItemsList.addProp(movieCount, theMovie)
      otherwise:
        CreateMovieLists(me, folderName & theFileName & fileDelimiter)
    end case
  end repeat
end

on DefaultItem me
  case myContent of
    #content:
      return 1
    #marker:
      return GetCurrentMarker(me)
    #movie:
      saveDelimiter = the itemDelimiter
      the itemDelimiter = "."
      shortName = item 1 of the movieName
      the itemDelimiter = saveDelimiter
      return myItemsList.getPos(shortName)
  end case
end

on SetDimensions me
  saveLastChar = the last char in myRestoreString
  delete char -30000 of myRestoreString
  myListMember.text = myRestoreString
  myItemHeight = myListMember.lineHeight
  myOpenRect = myListMember.rect
  myClosedRect = myOpenRect.duplicate()
  myClosedRect[4] = myItemHeight + (myListMember.margin / 2)
  myClosedLoc = mySprite.loc
  addedHeight = (myListMember.margin * 2) + myListMember.boxDropShadow
  myOpenHeight = myOpenRect.bottom + addedHeight
  windowRect = (the activeWindow).rect
  myStageHeight = windowRect.bottom - windowRect.top
  myStageWidth = windowRect.right - windowRect.left
  myRestoreString = myRestoreString & saveLastChar
  myListMember.text = myRestoreString
end

on GetCurrentMarker me
  markerPosition = myItemsList.findPos(the frame)
  if not markerPosition then
    markerPosition = myItemsList.findPosNear(the frame) - 1
  end if
  return max(1, markerPosition)
end

on DropList_Selection me, propListOrString
  if stringp(propListOrString) then
    if propListOrString <> myname then
      exit
    end if
  end if
  data = [#item: mySelectedItem, #text: myItemsList[mySelectedItem], #type: myContent, #sprite: spriteNum]
  if ilk(propListOrString) <> #propList then
    return data
  else
    propListOrString.addProp(myname, data)
    return propListOrString
  end if
end

on DropList_SetContents me, theContents, theListName
  if not voidp(theListName) then
    if theListName <> myname then
      exit
    end if
  end if
  case ilk(theContents) of
    #string:
      myListMember.text = theContents
      myContent = #content
      Initialize(me)
    #list:
      listItems = EMPTY
      lineCount = theContents.count
      repeat with i = 1 to lineCount
        theLine = string(theContents[i])
        put theLine & RETURN after listItems
      end repeat
      myListMember.text = listItems
      myContent = #content
      Initialize(me)
    #symbol:
      case theContents of
        #marker:
          myContent = #marker
          Initialize(me)
        #movie:
          myContent = #movie
          Initialize(me)
        otherwise:
          return #invalidListContents
      end case
    otherwise:
      return #invalidListContents
  end case
end

on DropList_ToggleExecution me, executeMode, listName
  if not voidp(listName) then
    if listName <> myname then
      exit
    end if
  else
    if stringp(executeMode) then
      if executeMode = myname then
        myAction = not myAction
      else
        exit
      end if
    end if
  end if
  if voidp(executeMode) then
    myAction = not myAction
  else
    case executeMode of
      #Execute, 1:
        myAction = 1
      #select, 0:
        myAction = 0
      otherwise:
        return #invalidExecuteMode
    end case
  end if
end

on DropList_GetReference me, propListOrString
  case ilk(propListOrString) of
    #propList:
      propListOrString.addProp(myname, me)
      return propListOrString
    #string:
      if propListOrString = myname then
        return me
      end if
    otherwise:
      return me
  end case
end

on isOKToAttach me, aSpriteType, aSpriteNum
  case aSpriteType of
    #graphic:
      return getPos([#field], sprite(aSpriteNum).member.type) <> 0
    #script:
      return 0
  end case
end

on getPropertyDescriptionList me
  if not (the currentSpriteNum) then
    exit
  end if
  return [#myname: [#comment: "Name of this list", #format: #string, #default: "List " & the currentSpriteNum], #myContent: [#comment: "Contents of list", #format: #string, #range: ["Current contents of the field", "Markers in this movie", "Movies with the same path name"], #default: "Current contents of the field"], #myAction: [#comment: "Purpose of list", #format: #string, #range: ["Select:  return the selected item when called", "Execute: go movie | go marker | do selectedLine"], #default: "Select:  return the selected item when called"], #myCheckmark: [#comment: "Checkmark to indicate currently selected item", #format: #string, #default: ">"], #myStandard: [#comment: "Use standard style?", #format: #boolean, #default: 1]]
end
