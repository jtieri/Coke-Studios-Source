on julianCalendarEncode inDate
  y = inDate.getFullYear()
  m = inDate.getMonth()
  d = inDate.getDate()
  h = inDate.getHours()
  mn = inDate.getMinutes()
  s = inDate.getSeconds()
  Math = newObject("Math")
  if m > 2 then
    jy = y
    jm = m + 1
  else
    jy = y - 1
    jm = m + 13
  end if
  intgr = Math.floor(Math.floor(365.25 * jy) + Math.floor(30.60010000000000119 * jm) + d + 1720995)
  gregcal = 15 + (31 * (10 + (12 * 1582)))
  ja = Math.floor(0.01 * jy)
  intgr = intgr + 2 - ja + Math.floor(0.25 * ja)
  dayfrac = (h / 24.0) - 0.5
  if dayfrac < 0.0 then
    dayfrac = dayfrac + 1.0
  end if
  frac = dayfrac + ((mn + (s / 60.0)) / 60.0 / 24.0)
  jd0 = (intgr + frac) * 100000
  jd = Math.floor(jd0)
  if (jd0 - jd) > 0.5 then
    jd = jd + 1
  end if
  return jd / 100000
end

on julianCalendarDecode jd
  Math = newObject("Math")
  intgr = Math.floor(jd)
  frac = jd - intgr
  gregjd = 2299160.5
  tmp = Math.floor((intgr - 1867216.0 - 0.25) / 36524.25)
  j1 = intgr + 1 + tmp - Math.floor(0.25 * tmp)
  df = frac + 0.5
  if df >= 1.0 then
    df = df - 1.0
    j1 = j1 + 1
  end if
  j2 = j1 + 1524.0
  j3 = Math.floor(6680.0 + ((j2 - 2439870.0 - 122.09999999999999432) / 365.25))
  j4 = Math.floor(j3 * 365.25)
  j5 = Math.floor((j2 - j4) / 30.60010000000000119)
  d = Math.floor(j2 - j4 - Math.floor(j5 * 30.60010000000000119))
  m = Math.floor(j5 - 1.0)
  if m > 12 then
    m = m - 12
  end if
  y = Math.floor(j3 - 4715.0)
  if m > 2 then
  end if
  if y <= 0 then
  end if
  hr = Math.floor(df * 24.0)
  mn = Math.floor(((df * 24.0) - hr) * 60.0)
  f = ((((df * 24.0) - hr) * 60.0) - mn) * 60.0
  sc = Math.floor(f)
  f = f - sc
  if f > 0.5 then
    sc = sc + 1
  end if
  if sc = 60 then
    sc = 0
    mn = mn + 1
  end if
  if mn = 60 then
    mn = 0
    hr = hr + 1
  end if
  if hr = 24 then
    hr = 0
    d = d + 1
  end if
  oDateOut = newObject("Date")
  oDateOut.setYear(y)
  oDateOut.setMonth(m - 1)
  oDateOut.setDate(d)
  oDateOut.setHours(hr)
  oDateOut.setMinutes(mn)
  oDateOut.setSeconds(0)
  return oDateOut
end
