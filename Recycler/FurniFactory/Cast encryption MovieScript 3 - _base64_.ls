on base64Encode aBinaryString, aNoWrap, aUrlSafe
  if aUrlSafe = 0 then
    vBase64Lookup = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    vTrail = "="
  else
    vBase64Lookup = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
    vTrail = "."
  end if
  vOutput = EMPTY
  vIndex = 1
  vTrailingBytes = aBinaryString.length mod 3
  vLengthWhole = aBinaryString.length - vTrailingBytes
  repeat while vIndex < vLengthWhole
    vByte1 = charToNum(aBinaryString.char[vIndex])
    vByte2 = charToNum(aBinaryString.char[vIndex + 1])
    vByte3 = charToNum(aBinaryString.char[vIndex + 2])
    vChar1 = vBase64Lookup.char[(bitAnd(vByte1, 252) / 4) + 1]
    vChar2 = vBase64Lookup.char[(bitAnd((vByte1 * 256) + vByte2, 1008) / 16) + 1]
    vChar3 = vBase64Lookup.char[(bitAnd((vByte2 * 256) + vByte3, 4032) / 64) + 1]
    vChar4 = vBase64Lookup.char[bitAnd(vByte3, 63) + 1]
    put vChar1 & vChar2 & vChar3 & vChar4 after vOutput
    vIndex = vIndex + 3
    if aNoWrap = 0 then
      if ((vIndex - 1) mod 57) = 0 then
        put RETURN after vOutput
      end if
    end if
  end repeat
  if vTrailingBytes = 1 then
    vByte1 = charToNum(aBinaryString.char[vIndex])
    vChar1 = vBase64Lookup.char[(bitAnd(vByte1, 252) / 4) + 1]
    vChar2 = vBase64Lookup.char[(bitAnd(vByte1 * 256, 1008) / 16) + 1]
    vChar3 = vTrail
    vChar4 = vTrail
    put vChar1 & vChar2 & vChar3 & vChar4 after vOutput
  else
    if vTrailingBytes = 2 then
      vByte1 = charToNum(aBinaryString.char[vIndex])
      vByte2 = charToNum(aBinaryString.char[vIndex + 1])
      vChar1 = vBase64Lookup.char[(bitAnd(vByte1, 252) / 4) + 1]
      vChar2 = vBase64Lookup.char[(bitAnd((vByte1 * 256) + vByte2, 1008) / 16) + 1]
      vChar3 = vBase64Lookup.char[(bitAnd(vByte2 * 256, 4032) / 64) + 1]
      vChar4 = vTrail
      put vChar1 & vChar2 & vChar3 & vChar4 after vOutput
    end if
  end if
  return vOutput
end

on base64Decode aEncodedString, aUrlSafe
  vBase64Lookup = ["A": 0, "B": 1, "C": 2, "D": 3, "E": 4, "F": 5, "G": 6, "H": 7, "I": 8, "J": 9, "K": 10, "L": 11, "M": 12, "N": 13, "O": 14, "P": 15, "Q": 16, "R": 17, "S": 18, "T": 19, "U": 20, "V": 21, "W": 22, "X": 23, "Y": 24, "Z": 25, "a": 26, "b": 27, "c": 28, "d": 29, "e": 30, "f": 31, "g": 32, "h": 33, "i": 34, "j": 35, "k": 36, "l": 37, "m": 38, "n": 39, "o": 40, "p": 41, "q": 42, "r": 43, "s": 44, "t": 45, "u": 46, "v": 47, "w": 48, "x": 49, "y": 50, "z": 51, "0": 52, "1": 53, "2": 54, "3": 55, "4": 56, "5": 57, "6": 58, "7": 59, "8": 60, "9": 61]
  if aUrlSafe = 0 then
    vBase64Lookup["+"] = 62
    vBase64Lookup["/"] = 63
  else
    vBase64Lookup["-"] = 62
    vBase64Lookup["_"] = 63
  end if
  vOutput = EMPTY
  vQuanta = []
  repeat with vIndex = 1 to aEncodedString.length
    ch = vBase64Lookup.getaProp(aEncodedString.char[vIndex])
    if not voidp(ch) then
      vQuanta.add(ch)
    end if
    if vQuanta.count = 4 then
      vByte1 = numToChar(bitAnd((vQuanta[1] * 64) + vQuanta[2], 4080) / 16)
      vByte2 = numToChar(bitAnd((vQuanta[2] * 64) + vQuanta[3], 1020) / 4)
      vByte3 = numToChar(bitAnd((vQuanta[3] * 64) + vQuanta[4], 255))
      put vByte1 & vByte2 & vByte3 after vOutput
      vQuanta = []
    end if
  end repeat
  if vQuanta.count = 3 then
    vByte1 = numToChar(bitAnd((vQuanta[1] * 64) + vQuanta[2], 4080) / 16)
    vByte2 = numToChar(bitAnd((vQuanta[2] * 64) + vQuanta[3], 1020) / 4)
    put vByte1 & vByte2 after vOutput
  else
    if vQuanta.count = 2 then
      vByte1 = numToChar(bitAnd((vQuanta[1] * 64) + vQuanta[2], 4080) / 16)
      put vByte1 after vOutput
    end if
  end if
  return vOutput
end
