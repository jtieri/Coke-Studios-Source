property iRow, iCol, w, d, p

on new me, _iRow, _iCol, _w
  me.iRow = _iRow
  me.iCol = _iCol
  me.w = _w
  me.d = VOID
  me.p = []
  return me
end

on addPointer me, n
  me.p.add([#row: n._iRow, #col: n._iCol])
end

on equals me, n
  return (n.iRow = me.iRow) and (n.iCol = me.iCol) and (n.w = me.w)
end

on toString me
  return "[MapNode] iRow: " & me.iRow & ", iCol: " & me.iCol + ", w: " + me.w
end

on getWeight me
  return me.w
end
