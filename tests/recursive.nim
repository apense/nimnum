import unittest, numbertheory, bigints

suite "Recursive algorithms":
  test "Fibonacci numbers":
    check fib(7) == 13
    check fib(12) == 144
  test "Lucas numbers":
    check lucas(10) == 123
  test "Woodall numbers":
    check woodall(7) == 895
  test "Cullen numbers":
    check cullen(12) == 22529
  test "Bell numbers":
    check bell(14) == 190899322
    check bell(20) == 51724_15823_5372
  test "Ordered Bell numbers":
    var a: BigInt = initBigInt("102247563")
    check orderedBell(10) == a
  test "Stirling numbers of the second kind":
    check stirling2(4,2) == 7
    check stirling2(10,5) == 42525
  test "Catalan numbers":
    check catalan(8) == 1430
  test "Lobb numbers":
    check lobb(0,11) == 58786
  test "Lazy Caterer's numbers":
    check caterer(20) == 211
  test "Leonardo numbers":
    check leonardo(11) == 287
  test "Pell numbers":
    check pell(11) == 5741
  test "Pell-Lucas numbers":
    check pell_lucas(7) == 478
  test "Jacobsthal numbers":
    check jacobsthal(12) == 1365
  test "Jacobsthal-Lucas numbers":
    check jacobsthal_lucas(12) == 4097
  test "Perrin numbers":
    check perrin(3) == 3
    check perrin(6) == 5
    check perrin(10) == 17
    check perrin(21) == 367
  test "Padovan numbers":
    check padovan(25) == 200
  test "Hermite numbers":
    check hermite(10) == -30240
  test "Sylvester's sequence":
    let syl = initBigInt("3263443")
    check sylvester(5) == syl
    let syl2 = initBigInt("113423713055421844361000443")
    check sylvester(7) == syl2