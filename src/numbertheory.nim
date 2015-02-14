import complex, math, poly, times
import unittest
import bigints
import fractions

type NegativeExponentError = object of ArithmeticError

const
  GAMMA* = 0.57721_56649_01532_86060_65120_90082_40243_10421_59335_93992 ## Euler-Mascheroni constant
  γ* = GAMMA  ## Alias of gamma
  GOLDEN* = 1.61803_39887_49894_84820_45868_34365_63811_77203_09179 ## Golden Ratio
  MEISSEL_MERTENS* = 0.26149_72128_47642_78375_54268_38608_69585_90516 ## Meissel-Mertens constant
  ERDOS_BORWEIN* = 1.60669_51524_15291_76378_33015_23190_92458_04805 ## the Erdős–Borwein constant
  APERY* = 1.20205_69031_59594_28539_97381_61511_44999_07649_86292 ## Apéry's constant ζ(3)


proc zeta*(s: float, terms: int): float  =
  ## Real zeta function ζ(s), up to `terms` terms.
  # doesn't converge when s <= 1.0
  # use the harmonic() fxn instead
  assert(s > 1.0)
  result = 0.0
  for i in 1..terms:
    result += pow(1/i, s)

proc zeta*(s: float, tol = 1.0e-10): float =
  ## Real zeta function ζ(s), up to a certain tolerance.
  assert(s > 0)
  result = 0.0
  var i = 1
  var tmpResult = 0.0
  result = 1.0
  while not(abs(tmpResult - result) < tol): # implement the approximation ourselves
    result = tmpResult
    tmpResult += pow(1/i, s)
    i += 1

proc zeta*(s: Complex, terms: int): Complex =
  ## Complex zeta function ζ(s), up to `terms` terms.
  # doesn't converge when s.re <= 1.0
  assert(s.re > 1.0)
  result = (0.0, 0.0)
  var complexi: Complex
  for i in 1..terms:
    complexi = (float(i), 0.0)
    result += pow(1/complexi, s)

proc zeta*(s: Complex): Complex =
  ## Generic complex zeta function ζ(s).
  # Uses the built-in approximate equality
  assert(s.re > 1.0)
  result = (1.0, 0.0)
  var tmpResult = (0.0, 0.0)
  var i = (1.0, 0.0)
  while not(tmpResult =~ result):
    result = tmpResult
    tmpResult += pow(1/i, s)
    i += (1.0, 0.0)

proc bernoulli*(n: int): Fraction =
  ## Returns the nth Bernoulli number as a rational number.
  ##
  ## NB These are the second Bernoulli numbers.
  var berSeq = newSeq[float](n+1)
  for m in 0..n:
    berSeq[m] = 1/(m+1)
    for j in countdown(m,1):
      berSeq[j-1] = float(j)*(berSeq[j-1]-berSeq[j])
  result = toRational(berSeq[0])

proc harmonic*(n: int): float {.noSideEffect.} =
  ## The nth harmonic number.
  result = 0.0
  for i in 1..n:
    # if n is 1, we stop at 1.0
    # if n is 2, we have 1.0 + 0.5, etc.
    result += 1/i

proc mersenne*(n: int): int {.noSideEffect.} =
  ## Gives the nth mersenne number (not necessarily prime).
  result = (1 shl n) - 1

proc stirling2*(n, k: int): int =
  ## s(n,k) - Stirling numbers of the second kind.
  for j in 0..k:
    result += int(pow(-1.0,float(k-j))) * binom(k,j) * int(pow(float(j),float(n)))
  result = result div fac(k)

var bellTable = @[1,1,2,5,15,52]
proc bell*(n: int): int =
  ## Bell numbers.
  try:
    result = bellTable[n]
  except:
    for i in 0..(n-1):
      result += (binom(n-1, i))*bell(i)

proc pochhammer*(q, n: int): int {.noSideEffect.} =
  ## The Pochhammer symbol (falling factorial).
  if (n==0):
    return 1
  result = 1
  for i in q..(n-1):
    result *= i

proc binomTransform*(a: openarray[int]): seq[int] {.noSideEffect.} =
  ## Binomial transform of a certain sequence of integers.
  newSeq(result, a.len)
  for n in 0..(a.len-1):
    result[n] = 0
    for k in 0..n:
      result[n] += binom(n, k)*a[k]

var fibTable = @[0,1,1,2,3,5,8,13,21,34,55]
proc fib*(n: int): int =
  ## The nth Fibonacci number.
  #try:
  #  result = fibTable[n]
  #except:
  if (n == 0):
    return 0
  elif (n == 1):
    return 1
  else:
    result = fib(n-1) + fib(n-2)
      #fibTable.add(result)

var lucasTable = @[2,1,3,4,7,11,18,29,47]
proc lucas*(n: int): int =
  ## The nth Lucas number.
  try:
    result = lucasTable[n]
  except:
    result = lucas(n-1) + lucas(n-2)
    lucasTable.add(result)

proc woodall*(n: int): int =
  ## The nth Woodall number.
  ## The first is 1.
  result = n*(1 shl n) - 1

proc cullen*(n: int): int {.noSideEffect.} =
  ## The nth Cullen number.
  ## The first is 1.
  # The "n-1" is so this works like Woodall numbers
  result = (n-1)*(1 shl (n-1)) + 1

var orderedBellTable: seq[BigInt] = @[initBigInt(1),initBigInt(1),initBigInt(3)]
proc orderedBell*(n: int): BigInt =
  ## The ordered Bell numbers.
  try:
    result = orderedBellTable[n]
  except:
    result = initBigInt(0)
    for i in 1..n:
      result = result + orderedBell(n-i)*int32(binom(n, i))

proc catalan*(n: int): int {.noSideEffect.} =
  ## The Catalan numbers.
  result = binom(2*n, n) div (n+1)

proc lobb*(m, n: int): int {.noSideEffect.} =
  ## The Lobb numbers.
  result = binom(2*n, m+n)*(2*m+1) div (m+n+1)

proc caterer*(n: int): int =
  ## The lazy caterer's sequence.
  # we won't lose anything in the shift, since
  # n^2 + n == n(n+1), which will always be even
  result = (n*n + n + 2) shr 1

var leonardoTable = @[1,1,3,5,9,15,25,41]
proc leonardo*(n: int): int =
  ## The Leonardo numbers.
  try:
    result = leonardoTable[n]
  except:
    result = leonardo(n-1) + leonardo(n-2) + 1
    leonardoTable.add(result)

var jacobsthalTable = @[0,1,1,3,5,11,21,43,85,171]
proc jacobsthal*(n: int): int =
  ## The Jacobsthal numbers.
  try:
    result = jacobsthalTable[n]
  except:
    result = jacobsthal(n-1) + 2*jacobsthal(n-2)
    jacobsthalTable.add(result)

var jacobsthalLucasTable = @[2,1,5,7,17,31,65,127,257]
proc jacobsthal_lucas*(n: int): int =
  ## The Jacobsthal-Lucas numbers.
  ## These are always +/- 1 from a power of two.
  try:
    result = jacobsthalLucasTable[n]
  except:
    result = jacobsthal_lucas(n-1) + 2*jacobsthal_lucas(n-2)
    jacobsthalLucasTable.add(result)

var pellTable = @[0,1,2,5,12,29,70,169]
proc pell*(n: int): int =
  ## The Pell numbers.
  try:
    result = pellTable[n]
  except:
    result = 2*pell(n-1) + pell(n-2)
    pellTable.add(result)

var pellLucasTable = @[2,2,6,14,34,82]
proc pell_lucas*(n: int): int =
  ## The Pell-Lucas numbers.
  try:
    result = pellLucasTable[n]
  except:
    result = 2*pell_lucas(n-1) + pell_lucas(n-2)
    pellLucasTable.add(result)

var perrinTable = @[3,0,2,3]
proc perrin*(n: int): int =
  ## The Perrin numbers.
  try:
    result = perrinTable[n]
  except:
    result = perrin(n-2) + perrin(n-3)
    let preResult = perrin(n-1)
    if(perrinTable.len > n):
      # update the table if we need to
      perrinTable.add(preResult)
    perrinTable.add(result)

var padovanTable = @[1,0,0,1,0]
proc padovan*(n: int): int =
  ## The Padovan numbers.
  try:
    result = padovanTable[n]
  except:
    result = padovan(n-2) + padovan(n-3)
    let preResult = padovan(n-1)
    if(padovanTable.len > n):
      # update the table if we need to
      padovanTable.add(preResult)
    padovanTable.add(result)

var hermiteTable = @[1,0,-2,0,12,0,-120,0]
proc hermite*(n: int): int =
  ## The Hermite numbers.
  if (n mod 2 == 1):
    return 0 # all odd Hermite numbers are 0
  try:
    result = hermiteTable[n]
  except:
    result = -2*(n-1)*hermite(n-2)
    hermiteTable.add(0) # for the odd integers
    hermiteTable.add(result)

var sylvesterTable = @[initBigInt(2), initBigInt(3)]
proc sylvester*(n: int): BigInt =
  ## Sylvester's sequence.
  try:
    result = sylvesterTable[n]
  except:
    result = initBigInt(0)
    result = sylvester(n-1)*(sylvester(n-1) - 1) + 1
    sylvesterTable.add(result)

proc isMonic*(p: Poly): bool {.noSideEffect.} =
  ## Test whether a given polynomial is monic.
  result = (p[p.degree] == 1)

proc toMonic*(p: Poly): Poly {.noSideEffect.} =
  ## Create a monic polynomial from any given.
  if p.isMonic: return p
  result = p / p[p.degree]

proc powmod*(b, e, m: int): int {.raises: [NegativeExponentError].} =
  ## Raise base to exponent, reducing by modulus.
  ## The naive method is pow(b,e) mod m, but we can do better
  if e < 0:
    raise newException(NegativeExponentError, "Negative exponents not allowed")
  assert((m-1)*(m-1) < high(int))
  var 
    base = b
    exponent = e
  result = 1
  base = base mod m
  while(exponent > 0):
    if(exponent mod 2 == 1):
      result = (result * base) mod m
    exponent = exponent shr 1
    base = (base*base) mod m

proc jacobi*(ain, min: int): int {.noSideEffect.} =
  ## The Jacobi symbol (a | m).
  ## When `min` is an odd prime, this is also the Legendre symbol.
  ##
  ## Algorithm 2.3.5 in Crandall and Pomerance
  assert(min mod 2 == 1) # m should be an odd integer
  var a = ain mod min
  var m = min
  var t = 1
  while (a != 0):
    while(a mod 2 == 0): # while a is even
      a = a shr 1 # a = a / 2
      if (m mod 8 == 3 or m mod 8 == 5):
        t = -t
    swap(a, m)
    if (a mod 4 == 3 and m mod 4 == 3):
      t = -t
    a = a mod m
  if (m == 1):
    return t
  result = 0

when(isMainModule):
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
  