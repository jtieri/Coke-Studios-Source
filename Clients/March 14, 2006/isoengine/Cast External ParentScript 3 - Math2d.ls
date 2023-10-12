property bDebug

on new me
  me.bDebug = 0
  return me
end

on direction me, oP1, oP2
  return point(oP1.locH - oP2.locH, oP1.locV - oP2.locV)
end

on length me, Op
  return sqrt((Op.locH * Op.locH) + (Op.locV * Op.locV))
end

on unit me, Op
  iLength = me.length(Op)
  if iLength = 0 then
    return Op
  end if
  return point(Op.locH / iLength, Op.locV / iLength)
end

on dotProduct me, oP1, oP2
  oP1 = me.unit(oP1)
  oP2 = me.unit(oP2)
  return me.arccos((oP1.locH * oP2.locH) + (oP1.locV * oP2.locV))
end

on arcsin me, x
  y = atan(x / sqrt(1 - (x * x)))
  return y
end

on arccos me, x
  y = atan(sqrt(1 - (x * x)) / x)
  return y
end

on distance me, oP1, oP2
  idx = oP1.locH - oP2.locH
  iDy = oP1.locV - oP2.locV
  return sqrt((idx * idx) + (iDy * iDy))
end

on rad me, iDeg
  return iDeg * PI / 180
end

on deg me, iRad
  return 180 * iRad / PI
end

on translatePoints me, aPoints, iXChange, iYChange
  aTranslatedPoints = []
  repeat with i = 1 to aPoints.count
    aPoint = aPoints[i]
    aNewPoint = aPoint + point(iXChange, iYChange)
    aTranslatedPoints.append(aNewPoint)
  end repeat
  return aTranslatedPoints
end

on rotatePoints me, aPoints, iTheta
  aRotatedPoints = []
  repeat with i = 1 to aPoints.count
    aPoint = aPoints[i]
    iX = (aPoint.locH * cos(iTheta)) - (aPoint.locV * sin(iTheta))
    iY = (aPoint.locH * sin(iTheta)) + (aPoint.locV * cos(iTheta))
    aRotatedPoints.append(point(iX, iY))
  end repeat
  return aRotatedPoints
end

on scalePoint
end

on rotatePoint me, aPoint, iDeg
  iTheta = me.rad(iDeg)
  iX = (aPoint.locH * cos(iTheta)) - (aPoint.locV * sin(iTheta))
  iY = (aPoint.locH * sin(iTheta)) + (aPoint.locV * cos(iTheta))
  return point(iX, iY)
end

on slope me, aPoint1, aPoint2
  return (aPoint2.locH - aPoint1.locV) / (aPoint2.locH - aPoint1.locH)
end

on map me, inVal, inLow, inHi, outLow, outHi
  outVal = ((inVal - inLow) / (inHi - inLow) * (outHi - outLow)) + outLow
  return outVal
end
