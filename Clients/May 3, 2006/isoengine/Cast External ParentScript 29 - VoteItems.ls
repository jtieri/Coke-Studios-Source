property aItems
global oIsoScene

on new me
  me.aItems = []
  return me
end

on Init me
end

on addItem me, oItem
  me.aItems.add(oItem)
end

on removeItem me, oItem
  oItem.destroy()
  me.aItems.deleteOne(oItem)
end

on destroy me
  repeat with i = 1 to me.aItems.count
    oItem = me.aItems[i]
    oItem.destroy()
  end repeat
  me.aItems = []
end
