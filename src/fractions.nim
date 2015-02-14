import math, unittest

type
  Fraction* = tuple[numer, denom: int] ## Fraction as integer numerator and denominator

proc toRational*(r: float, bound: int = 10000): Fraction =
  ## Convert a given float to a rational number with at most `bound` iterations
  if (r == 0.0):
    result.numer = 0
    result.denom = 1
  elif (r < 0.0):
    result = toRational(-r, bound)
    result.numer = -result.numer
  else:
    var
      best = 1
      bestError = Inf
      err: float
    for i in 1..(bound+1):
      err = abs(float(i)*r - float(round(float(i)*r)))
      if (err < bestError):
        best = i
        bestError = err
    result = (int(round(float(best)*r)), best)

proc `$`*(f: Fraction): string =
  ## Represent a fraction as "n / d"
  result = $f.numer & " / " & $f.denom

when isMainModule:
  test "toRational":
    check ($toRational(0.750000000, 1000000) == "3 / 4")
    check ($toRational(0.518518) == "14 / 27")
    check ($toRational(0.9054054) == "67 / 74")
    check ($toRational(Pi) == "355 / 113")