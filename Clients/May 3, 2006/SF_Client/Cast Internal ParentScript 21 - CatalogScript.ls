property aItems
global gCatalog

on new me, sText
  me.Init(sText)
  gCatalog = me
  return me
end

on getItemByProdId me, iProdId
  repeat with i in me.aItems
    if i[#prodID] = iProdId then
      return i
    end if
  end repeat
end

on Init me, sText
  me.aItems = []
  repeat with i = 1 to sText.lines.count
    sLine = sText.line[i]
    if sLine = EMPTY then
      next repeat
    end if
    aItem = me.getItem(sLine)
    if ilk(aItem) = #propList then
      me.aItems.add(aItem)
    end if
  end repeat
end

on getItem me, sLine
  aItem = VOID
  sOldDelimiter = the itemDelimiter
  the itemDelimiter = "="
  sLabel = sLine.item[1]
  if sLabel = "ITEM" then
    sData = sLine.item[2]
    the itemDelimiter = sOldDelimiter
    if not voidp(sData) and not (sData = EMPTY) then
      aItem = value(sData)
    else
    end if
  end if
  return aItem
end
