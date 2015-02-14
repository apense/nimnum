import unittest, numbertheory, complex, math

suite "Loop-based algorithms":
  test "Harmonic numbers":
      check harmonic(5) == (1.0 + 1/2 + 1/3 + 1/4 + 1/5)
      check harmonic(25)>harmonic(24)
      check harmonic(100)>harmonic(99)
  test "Real zeta function":
    # should give about pi^2/6
    check (abs(pow(PI,2)/6 - zeta(2, 10000)) < 0.001)
    # should give about pi^4/90
    check (abs(pow(PI,4)/90 - zeta(4, 10000)) < 0.001)
    # ζ(3) is Apéry's constant
    check (abs(APERY - zeta(3.0)) < 1.0e-6)
  test "Complex zeta function":
    var exponent: Complex
    exponent = (3.0, 1.0)
    var myRes: Complex
    myRes = zeta(exponent, 10000)
    check (myRes =~ (1.107214408, -0.14829086))
    exponent = (10.5, 2.3)
    myRes = zeta(exponent, 10000)
    check (myRes =~ (0.99997530, -0.00069592))
    check (zeta(exponent) =~ (0.99997530, -0.00069592))
  test "Bernoulli numbers":
    var oneSixth = (numer: 1, denom: 6)
    check (bernoulli(2) == oneSixth)
    check (bernoulli(10) == (numer: 5, denom: 66))
    check (bernoulli(4) == (numer: -1, denom: 30))