property aSprites, aSounds, iEffectSound, iWhaleCartSound, iComputerSound

on new me, firstSprite, lastSprite
  aSprites = []
  repeat with i = firstSprite to lastSprite
    me.checkInSprite(i)
  end repeat
  aSounds = []
  repeat with i = 1 to 5
    me.checkInSound(i)
  end repeat
  me.iComputerSound = 6
  me.iWhaleCartSound = 7
  me.iEffectSound = 8
  return me
end

on checkOutSprite me
  iSpriteNum = aSprites[1]
  aSprites.deleteAt(1)
  return iSpriteNum
end

on checkInSprite me, iSpriteNum
  aSprites.add(iSpriteNum)
end

on checkOutSound me
  iSoundNum = aSounds[1]
  aSounds.deleteAt(1)
  return iSoundNum
end

on checkInSound me, iSoundNum
  aSounds.add(iSoundNum)
end
