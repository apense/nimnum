import unittest, numbertheory, poly

suite "Basic polynomials":
  test "Monic polynomial works":
      var xp = initPoly(1.0,2.0,3.0)
      check xp.isMonic
      var yp = initPoly(2.0,1.0,1.0)
      check isMonic(yp) == false
      var zp = initPoly(1.0) 
      check isMonic(zp) == true # "1" is a polynomial, and its highest term is 1