import unittest, numbertheory

suite "Various functions":
  test "Modular Exponentiation":
    check powmod(4, 13, 497) == 445
    check powmod(3, 5, 7) == 5
  test "Binomial transform":
    var a = @[1,1,1,1,1,1] # gives the powers of two
    var b = @[1,-1,1,-1,1] # gives 0^n
    var c = @[1,2,4,8,16,32] # gives the powers of three
    check binomTransform(a) == @[1,2,4,8,16,32]
    check binomTransform(b) == @[1,0,0,0,0]
    check binomTransform(c) == @[1,3,9,27,81,243]
  test "Jacobi symbol":
    check jacobi(1001, 9907) == -1
    check jacobi(19, 45) == 1
    check jacobi(8, 21) == -1
    check jacobi(5, 21) == 1