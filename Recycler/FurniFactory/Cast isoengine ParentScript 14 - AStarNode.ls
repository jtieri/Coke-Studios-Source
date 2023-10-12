property pt, g, w, s, h, f, parent, open, closed, bDebug
global oIsoScene

on new me
  me.bDebug = 1
  me.open = 1
  me.closed = 2
  return me
end

on equals me, n
  return me.pt = n.pt
end

on toString me
  var(s = ("[AStarNode] pt: " & me.pt))
  s = s & ", g: " & me.g
  s = s & ", w: " & me.w
  s = s & ", s: " & me.s
  s = s & ", h: " & me.h
  s = s & ", f: " & me.f
  s = s & ", parent: " & me.parent.pt
  return s
end
