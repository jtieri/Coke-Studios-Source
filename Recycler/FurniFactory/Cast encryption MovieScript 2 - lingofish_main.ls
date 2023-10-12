property blowfish_ok, blowfish_rounds, blowfish_P, blowfish_S1, blowfish_S2, blowfish_S3, blowfish_S4

on new me, aKey
  blowfish_rounds = 16
  blowfish_ok = 0
  if stringp(aKey) then
    me.SetKey(aKey)
  end if
  return me
end

on getVersion me
  return "1.11"
end

on SetKey me, aKey
  blowfish_ok = 0
  if not stringp(aKey) then
    return #error_notstring
  end if
  if (aKey.length mod 4) <> 0 then
    return #error_not32bit
  end if
  if aKey.length <= 0 then
    return #error_empty
  end if
  if aKey.length > 56 then
    return #error_toolong
  end if
  LingoFish_GetInitialConstants(me)
  j = 0
  repeat with i = 1 to blowfish_rounds + 2
    data = charToNum(aKey.char[j + 4]) + (charToNum(aKey.char[j + 3]) * 256) + (charToNum(aKey.char[j + 2]) * 65536) + (charToNum(aKey.char[j + 1]) * 16777216)
    j = (j + 4) mod aKey.length
    blowfish_P[i] = bitXor(blowfish_P[i], data)
  end repeat
  dataLeft = 0
  dataRight = 0
  i = 1
  repeat while i < (blowfish_rounds + 2)
    data = me.blowfish_Encipher(dataLeft, dataRight)
    dataLeft = data[#left]
    dataRight = data[#right]
    blowfish_P[i] = dataLeft
    blowfish_P[i + 1] = dataRight
    i = i + 2
  end repeat
  i = 1
  repeat while i < 256
    data = me.blowfish_Encipher(dataLeft, dataRight)
    dataLeft = data[#left]
    dataRight = data[#right]
    blowfish_S1[i] = dataLeft
    blowfish_S1[i + 1] = dataRight
    i = i + 2
  end repeat
  i = 1
  repeat while i < 256
    data = me.blowfish_Encipher(dataLeft, dataRight)
    dataLeft = data[#left]
    dataRight = data[#right]
    blowfish_S2[i] = dataLeft
    blowfish_S2[i + 1] = dataRight
    i = i + 2
  end repeat
  i = 1
  repeat while i < 256
    data = me.blowfish_Encipher(dataLeft, dataRight)
    dataLeft = data[#left]
    dataRight = data[#right]
    blowfish_S3[i] = dataLeft
    blowfish_S3[i + 1] = dataRight
    i = i + 2
  end repeat
  i = 1
  repeat while i < 256
    data = me.blowfish_Encipher(dataLeft, dataRight)
    dataLeft = data[#left]
    dataRight = data[#right]
    blowfish_S4[i] = dataLeft
    blowfish_S4[i + 1] = dataRight
    i = i + 2
  end repeat
  blowfish_ok = 1
  return 0
end

on Encrypt me, plainText
  if (blowfish_ok <> 1) or not stringp(plainText) then
    return VOID
  end if
  cipherText = EMPTY
  i = 1
  plainTextLength = plainText.length
  repeat while i <= plainTextLength
    dataLeft = charToNum(plainText.char[i + 3]) + (charToNum(plainText.char[i + 2]) * 256) + (charToNum(plainText.char[i + 1]) * 65536) + (charToNum(plainText.char[i]) * 16777216)
    dataRight = charToNum(plainText.char[i + 7]) + (charToNum(plainText.char[i + 6]) * 256) + (charToNum(plainText.char[i + 5]) * 65536) + (charToNum(plainText.char[i + 4]) * 16777216)
    data = me.blowfish_Encipher(dataLeft, dataRight)
    dataLeft = data[#left]
    dataRight = data[#right]
    put numToChar(bitAnd(bitAnd(dataLeft, -16777216) / 16777216, 255)) after cipherText
    put numToChar(bitAnd(dataLeft, 16711680) / 65536) after cipherText
    put numToChar(bitAnd(dataLeft, 65280) / 256) after cipherText
    put numToChar(bitAnd(dataLeft, 255)) after cipherText
    put numToChar(bitAnd(bitAnd(dataRight, -16777216) / 16777216, 255)) after cipherText
    put numToChar(bitAnd(dataRight, 16711680) / 65536) after cipherText
    put numToChar(bitAnd(dataRight, 65280) / 256) after cipherText
    put numToChar(bitAnd(dataRight, 255)) after cipherText
    i = i + 8
  end repeat
  return cipherText
end

on Decrypt me, cipherText
  if (blowfish_ok <> 1) or not stringp(cipherText) then
    return VOID
  end if
  plainText = EMPTY
  i = 1
  cipherTextLength = cipherText.length
  repeat while i <= cipherTextLength
    dataLeft = charToNum(cipherText.char[i + 3]) + (charToNum(cipherText.char[i + 2]) * 256) + (charToNum(cipherText.char[i + 1]) * 65536) + bitAnd(charToNum(cipherText.char[i]) * 16777216, -1)
    dataRight = charToNum(cipherText.char[i + 7]) + (charToNum(cipherText.char[i + 6]) * 256) + (charToNum(cipherText.char[i + 5]) * 65536) + bitAnd(charToNum(cipherText.char[i + 4]) * 16777216, -1)
    data = me.blowfish_Decipher(dataLeft, dataRight)
    dataLeft = data[#left]
    dataRight = data[#right]
    put numToChar(bitAnd(bitAnd(dataLeft, -16777216) / 16777216, 255)) after plainText
    put numToChar(bitAnd(dataLeft, 16711680) / 65536) after plainText
    put numToChar(bitAnd(dataLeft, 65280) / 256) after plainText
    put numToChar(bitAnd(dataLeft, 255)) after plainText
    put numToChar(bitAnd(bitAnd(dataRight, -16777216) / 16777216, 255)) after plainText
    put numToChar(bitAnd(dataRight, 16711680) / 65536) after plainText
    put numToChar(bitAnd(dataRight, 65280) / 256) after plainText
    put numToChar(bitAnd(dataRight, 255)) after plainText
    i = i + 8
  end repeat
  return plainText
end

on blowfish_F me, x
  a = bitAnd(bitAnd(x, -16777216) / 16777216, 255) + 1
  b = (bitAnd(x, 16711680) / 65536) + 1
  c = (bitAnd(x, 65280) / 256) + 1
  d = bitAnd(x, 255) + 1
  f = blowfish_S1[a] + blowfish_S2[b]
  f = bitXor(f, blowfish_S3[c])
  f = bitAnd(f + blowfish_S4[d], -1)
  return f
end

on blowfish_Encipher me, dataLeft, dataRight
  repeat with i = 1 to blowfish_rounds
    dataLeft = bitXor(dataLeft, blowfish_P[i])
    dataRight = bitXor(me.blowfish_F(dataLeft), dataRight)
    temp = dataLeft
    dataLeft = dataRight
    dataRight = temp
  end repeat
  temp = dataLeft
  dataLeft = dataRight
  dataRight = temp
  dataRight = bitXor(dataRight, blowfish_P[blowfish_rounds + 1])
  dataLeft = bitXor(dataLeft, blowfish_P[blowfish_rounds + 2])
  return [#left: dataLeft, #right: dataRight]
end

on blowfish_Decipher me, dataLeft, dataRight
  repeat with i = blowfish_rounds + 2 down to 3
    dataLeft = bitXor(dataLeft, blowfish_P[i])
    dataRight = bitXor(me.blowfish_F(dataLeft), dataRight)
    temp = dataLeft
    dataLeft = dataRight
    dataRight = temp
  end repeat
  temp = dataLeft
  dataLeft = dataRight
  dataRight = temp
  dataRight = bitXor(dataRight, blowfish_P[2])
  dataLeft = bitXor(dataLeft, blowfish_P[1])
  return [#left: dataLeft, #right: dataRight]
end
