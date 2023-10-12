on new me
  return me
end

on burnCD me
  sprite(me.spriteNum).member = member("mixeranimfilmloop")
  sprite(me.spriteNum).width = member("mixeranimfilmloop").width
  sprite(me.spriteNum).height = member("mixeranimfilmloop").height
end

on openCD me
  sprite(me.spriteNum).member = member("cc.mixer.door.open")
  sprite(me.spriteNum).width = member("cc.mixer.door.open").width
  sprite(me.spriteNum).height = member("cc.mixer.door.open").height
end

on closeCD me
  sprite(me.spriteNum).member = member("shadow.pixel")
  sprite(me.spriteNum).width = member("shadow.pixel").width
  sprite(me.spriteNum).height = member("shadow.pixel").height
end
