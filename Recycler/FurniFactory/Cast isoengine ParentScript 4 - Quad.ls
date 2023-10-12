property tl, tr, br, bl

on new me, tl, tr, br, bl
  me.tl = tl
  me.tr = tr
  me.br = br
  me.bl = bl
  return me
end

on toString me
  return me.tl && me.tr && me.br && me.bl
end
