{-|

Programming Languages
Fall 2018

Implementation in Haskell of the concepts covered in Chapter 1 of
Nielson & Nielson, Semantics with Applications

Author: Salvador Carrillo Fuentes

-}

module Exercises01 where

import           Test.HUnit hiding (State)
import           While
import           Data.List

-- |----------------------------------------------------------------------
-- | Exercise 1
-- |----------------------------------------------------------------------
-- | Given the algebraic data type 'Bin' for the binary numerals:

data Bit = O
         | I
         deriving (Show, Eq)

data Bin = MSB Bit
         | B Bin Bit
         deriving (Show, Eq)

-- | and the following values of type 'Bin':

zero :: Bin
zero = MSB O

one :: Bin
one = MSB I

-- 3 = 011
three :: Bin
three = B (B (MSB O) I) I

-- 6 = 110
six :: Bin
six = B (B (MSB I) I) O

-- | define a semantic function 'binVal' that associates
-- | a number (in the decimal system) to each binary numeral.

binVal :: Bin -> Z
binVal (MSB O)= 0
binVal (MSB I)= 1
binVal (B bin O)= 2 * binVal bin
binVal (B bin I)= 2 * binVal bin +1

-- | Test your function with HUnit.

testBinVal :: Test
testBinVal = test ["value of zero"  ~: 0 ~=? binVal zero,
                   "value of one"   ~: 1 ~=? binVal one,
                   "value of three" ~: 3 ~=? binVal three,
                   "value of six"   ~: 6 ~=? binVal six]

{-
*Exercises01> runTestTT testBinVal
Cases: 4  Tried: 4  Errors: 0  Failures: 0
Counts {cases = 4, tried = 4, errors = 0, failures = 0}
-}

-- | Define a function 'foldBin' to fold a value of type 'Bin'

{-
Primero busco los constructores: MSB y B

MSB :: Bit -> Bin
B :: Bin -> Bit -> Bin

La idea es traducir el tipo Bin por el tipo a (Bin (recursivo) -> a)

MSB :: Bit -> Bin ___________ msb :: Bit -> a
B :: Bin -> Bit -> Bin ______ b :: a -> Bit -> a

donde vea MSB pongo msb
donde vea B pongo b
-}

--foldBin :: a
{-
*Exercises01> :t foldBin
foldBin :: (t -> Bit -> t) -> (Bit -> t) -> Bin -> t
-}
--                b               msb
foldBin :: (a -> Bit -> a) -> (Bit -> a) -> Bin -> a
foldBin b msb (MSB bit) = msb bit
foldBin b msb (B bin bit) = b (foldBin b msb bin) bit

-- | and use 'foldBin' to define a function 'binVal''  equivalent to 'binVal'.

binVal' :: Bin -> Integer
binVal' = foldBin b msb
  where
    msb O = 0
    msb I = 1
    b sol bit = 2 * sol + (msb bit)

{-
Ejemplo de ejecución:

binVal' B (B (MSB I) I) O =>
foldBin b msb B (B (MSB I) I) O =>
b (foldBin b msb (B (MSB I) I)) O =>
b (b (foldBin b msb (MSB I)) I) O =>
b (b (msb I) I) O =>
b (b (1) I) O =>
b (2 * 1 + msb I) O =>
b (2 * 1 + 1) O =>
b 3 O =>
2 * 3 + msb O =>
2 * 3 + 0 =>
6
-}

-- | Test your function with HUnit.

testBinVal' :: Test
testBinVal' = test ["value of zero"  ~: 0 ~=? binVal zero,
                   "value of one"   ~: 1 ~=? binVal one,
                   "value of three" ~: 3 ~=? binVal three,
                   "value of six"   ~: 6 ~=? binVal six]

{-
*Exercises01> runTestTT testBinVal'
Cases: 4  Tried: 4  Errors: 0  Failures: 0
Counts {cases = 4, tried = 4, errors = 0, failures = 0}

-}

-- | Define a function 'hammingWeight' that returns the number of ones occurring
-- | in a binary numeral.

hammingWeight :: Bin -> Integer
hammingWeight (MSB bit) = if (bit == O) then 0 else 1
hammingWeight (B bin bit) = if (bit == O) then hammingWeight bin else 1 + hammingWeight bin

-- | and use 'foldBin' to define a function 'hammingWeight''  equivalent to 'hammingWeight'.

hammingWeight' :: Bin -> Integer
hammingWeight' = foldBin b msb
  where
    msb bit = if (bit == O) then 0 else 1
    b sol bit = sol + msb bit

-- | Test your functions with HUnit.

testHammingWeight' :: Test
testHammingWeight' = test ["Hamming weight of zero"  ~: 0 ~=? hammingWeight' zero,
                   "Hamming weight of one"   ~: 1 ~=? hammingWeight' one,
                   "Hamming weight of three" ~: 2 ~=? hammingWeight' three,
                   "Hamming weight of six"   ~: 2 ~=? hammingWeight' six]
{-
*Exercises01> runTestTT testHammingWeight'
Cases: 4  Tried: 4  Errors: 0  Failures: 0
Counts {cases = 4, tried = 4, errors = 0, failures = 0}

-}

-- | Define a function 'complement' that returns the complement of a binary numeral

complement :: Bin -> Bin
complement (MSB bit) = if (bit == O) then MSB I else MSB O
complement (B bin bit) = if (bit == O) then B (complement bin) I else B (complement bin) O

-- | and use 'foldBin' to define a function 'complement''  equivalent to 'complement'.

complement' :: Bin -> Bin
complement' = foldBin b msb
  where
    msb bit = if (bit == O) then (MSB I) else (MSB O)
    b sol bit = if (bit == O) then (B sol I) else (B sol O)

-- | Test your functions with HUnit.

testComplement' :: Test
testComplement' = test ["Complement of zero"  ~: MSB I ~=? complement' zero,
                   "Complement of one"   ~: MSB O ~=? complement' one,
                   "Complement of three" ~: B (B (MSB I) O) O ~=? complement' three,
                   "Complement of six"   ~: B (B (MSB O) O) I ~=? complement' six]

{-
*Exercises01> runTestTT testComplement'
Cases: 4  Tried: 4  Errors: 0  Failures: 0
Counts {cases = 4, tried = 4, errors = 0, failures = 0}
-}

-- | Define a function 'normalize' that given a binary numeral trims leading zeroes.

-- repasar los ejemplos de Repaso.hs
normalize :: Bin -> Bin
normalize (MSB bit) = (MSB bit)
normalize (B bin bit) = if (normalize bin == MSB O) then (MSB bit) else B (normalize bin) bit

{-
normalize :: Bin -> Bin
normalize (MSB bit) = (MSB bit)
normalize (B bin bit) = f (normalize bin) bit
  where
    f sol b = if (sol == MSB O) then (MSB b) else B sol b

Ejemplo de ejecución:

normalize B (B (MSB O) I) I =>
f (normalize B (MSB O) I) I =>
if (normalize B (MSB O) I == MSB O) then (MSB I) else B (normalize B (MSB O) I) I =>
if (f (normalize MSB O) I == MSB O) then (MSB I) else B (f (normalize MSB O) I) I =>
if (if (normalize MSB O) == MSB O) then (MSB I) else B (normalize MSB O) I) == MSB O) then (MSB I) else B (if (normalize MSB O == MSB O) then (MSB I) else B (normalize MSB O) I) I =>
if (if (true) then MSB I else B (MSB O) I) == MSB O) then (MSB I) else B (if (true) then (MSB I) else B (normalize MSB O) I) I =>
if (MSB I == MSB O) then MSB I else B (if (true) then MSB I else B (MSB O) I) I
if (false) then MSB I else B (MSB I) I
B (MSB I) I
-}

-- | and use 'foldBin' to define a function 'normalize''  equivalent to 'normalize'.

normalize' :: Bin -> Bin
normalize' = foldBin b MSB
  where
    b sol bit = if (sol == MSB O) then (MSB bit) else (B sol bit)

{-
Ejemplo de ejecución:

normalize' B (B (MSB O) I) I =>
foldBin b msb B (B (MSB O) I) I =>
b (foldBin b msb (B (MSB O) I)) I =>
b (b (foldBin b msb (MSB O)) I) I =>
b (b (msb O) I) I =>
b (b (MSB O) I) I =>
b (MSB I) I =>
B (MSB I) I
-}

-- | Test your functions with HUnit.

testNormalize' :: Test
testNormalize' = test [ "trim zero"  ~: MSB O ~=? normalize' zero,
                        "trim one"   ~: MSB I ~=? normalize' one,
                        "trim three" ~: B (MSB I) I ~=? normalize' three,
                        "trim six"   ~: B (B (MSB I) I) O ~=? normalize' six]

{-
*Exercises01> runTestTT testNormalize'
Cases: 4  Tried: 4  Errors: 0  Failures: 0
Counts {cases = 4, tried = 4, errors = 0, failures = 0}

-}

-- |----------------------------------------------------------------------
-- | Exercise 2
-- |----------------------------------------------------------------------
-- | Define the function 'fvAexp' that computes the set of free variables
-- | occurring in an arithmetic expression. Ensure that each free variable
-- | occurs once in the resulting list.

ea1 :: Aexp
ea1 = N 0

ea2 :: Aexp
ea2 = V "x"

ea3 :: Aexp
ea3 = Mult (N 2) (V "x")

ea4 :: Aexp
ea4 = Add (Mult (N 2) (V "x")) (Sub (V "x") (Mult (N 2) (V "y")))

ea5 :: Aexp
ea5 = Mult (Add (Add (V "x") (V "y")) (V "z")) (V "z")

fvAexp :: Aexp -> [Var]
fvAexp (N e)        = []
fvAexp (V v)        = [v]
fvAexp (Add e1 e2)  = nub $ (fvAexp e1) ++ (fvAexp e2)
fvAexp (Mult e1 e2) = nub $ (fvAexp e1) ++ (fvAexp e2)
fvAexp (Sub e1 e2)  = nub $ (fvAexp e1) ++ (fvAexp e2)

-- | Test your function with HUnit.

testfvAexp :: Test
testfvAexp = test [    "Free variables ea1" ~: [] ~=? fvAexp ea1,
                        "Free variables ea2" ~: ["x"] ~=? fvAexp ea2,
                        "Free variables ea3" ~: ["x"] ~=? fvAexp ea3,
                        "Free variables ea4" ~: ["x","y"] ~=? fvAexp ea4,
                        "Free variables ea5" ~: ["x","y","z"] ~=? fvAexp ea5]

{-
*Exercises01> runTestTT testfvAexp

Cases: 5  Tried: 0  Errors: 0  Failures: 0
Cases: 5  Tried: 1  Errors: 0  Failures: 0
Cases: 5  Tried: 2  Errors: 0  Failures: 0
Cases: 5  Tried: 3  Errors: 0  Failures: 0
Cases: 5  Tried: 4  Errors: 0  Failures: 0

Cases: 5  Tried: 5  Errors: 0  Failures: 0
Counts {cases = 5, tried = 5, errors = 0, failures = 0}
-}

-- | Define the function 'fvBexp' that computes the set of free variables
-- | occurring in a Boolean expression.

eb1 :: Bexp
eb1 = TRUE

eb2 :: Bexp
eb2 = And TRUE FALSE

eb3 :: Bexp
eb3 = Eq ea5 ea5

eb4 :: Bexp
eb4 = Eq ea1 ea2

eb5 :: Bexp
eb5 = Neg $ And (Le ea3 ea4) (TRUE)

fvBexp :: Bexp -> [Var]
fvBexp TRUE         = []
fvBexp FALSE        = []
fvBexp (Eq e1 e2)   = nub $ (fvAexp e1) ++ (fvAexp e2)
fvBexp (Le e1 e2)   = nub $ (fvAexp e1) ++ (fvAexp e2)
fvBexp (Neg e)      = fvBexp e
fvBexp (And e1 e2)  = nub $ (fvBexp e1) ++ (fvBexp e2)

-- | Test your function with HUnit.

testfvBexp :: Test
testfvBexp = test [     "Free variables eb1" ~: [] ~=? fvBexp eb1,
                        "Free variables eb2" ~: [] ~=? fvBexp eb2,
                        "Free variables eb3" ~: ["x","y","z"] ~=? fvBexp eb3,
                        "Free variables eb4" ~: ["x"] ~=? fvBexp eb4,
                        "Free variables eb5" ~: ["x","y"] ~=? fvBexp eb5]

{-
*Exercises01> runTestTT testfvBexp

Cases: 5  Tried: 0  Errors: 0  Failures: 0
Cases: 5  Tried: 1  Errors: 0  Failures: 0
Cases: 5  Tried: 2  Errors: 0  Failures: 0
Cases: 5  Tried: 3  Errors: 0  Failures: 0
Cases: 5  Tried: 4  Errors: 0  Failures: 0

Cases: 5  Tried: 5  Errors: 0  Failures: 0
Counts {cases = 5, tried = 5, errors = 0, failures = 0}
-}

-- |----------------------------------------------------------------------
-- | Exercise 3
-- |----------------------------------------------------------------------
-- | Given the algebraic data type 'Subst' for representing substitutions:

data Subst = Var :->: Aexp

-- | define a function 'substAexp' that takes an arithmetic expression
-- | 'a' and a substitution 'y:->:a0' and returns the substitution a [y:->:a0];
-- | i.e., replaces every occurrence of 'y' in 'a' by 'a0'.

s1 :: Subst
s1 = ("x" :->: N 5)

s2 :: Subst
s2 = ("x" :->: Mult (N 2) (V "y"))

s3 :: Subst
s3 = ("x" :->: V "y")

s4:: Subst
s4 = ("y" :->: Add (N 2) (V "z"))

substAexp :: Aexp -> Subst -> Aexp
substAexp a@(N i) _ = a
substAexp a@(V v) (y :->: a0)= if (v == y) then a0 else a
substAexp (Add e1 e2) s = Add (substAexp e1 s) (substAexp e2 s)
substAexp (Mult e1 e2) s = Mult (substAexp e1 s) (substAexp e2 s)
substAexp (Sub e1 e2) s = Sub (substAexp e1 s) (substAexp e2 s)

-- | Test your function with HUnit.

testSubstAexp :: Test
testSubstAexp = test [  "Substitution ea1 s1" ~: N 0 ~=? substAexp ea1 s1,
                        "Substitution ea2 s2" ~: Mult (N 2) (V "y") ~=? substAexp ea2 s2,
                        "Substitution ea3 s3" ~: Mult (N 2) (V "y") ~=? substAexp ea3 s3,
                        "Substitution ea4 s4" ~: Add (Mult (N 2) (V "x")) (Sub (V "x") (Mult (N 2) (Add (N 2) (V "z")))) ~=? substAexp ea4 s4]

{-
*Exercises01> runTestTT testSubstAexp

Cases: 4  Tried: 0  Errors: 0  Failures: 0
Cases: 4  Tried: 1  Errors: 0  Failures: 0
Cases: 4  Tried: 2  Errors: 0  Failures: 0
Cases: 4  Tried: 3  Errors: 0  Failures: 0

Cases: 4  Tried: 4  Errors: 0  Failures: 0
Counts {cases = 4, tried = 4, errors = 0, failures = 0}
-}

-- | Define a function 'substBexp' that implements substitution for
-- | Boolean expressions.

substBexp :: Bexp -> Subst -> Bexp
substBexp TRUE (y :->: a0) = TRUE
substBexp FALSE (y :->: a0) = FALSE
substBexp (Eq e1 e2) s = Eq (substAexp e1 s) (substAexp e2 s)
substBexp (Le e1 e2) s = Le (substAexp e1 s) (substAexp e2 s)
substBexp (Neg e) s = Neg (substBexp e s)
substBexp (And e1 e2) s = And (substBexp e1 s) (substBexp e2 s)

-- | Test your function with HUnit.

testSubstBexp :: Test
testSubstBexp = test [  "Substitution eb1 s1" ~: TRUE ~=? substBexp eb1 s1,
                        "Substitution eb2 s2" ~: And TRUE FALSE ~=? substBexp eb2 s2,
                        "Substitution eb3 s3" ~: Eq (Mult (Add (Add (V "y") (V "y")) (V "z")) (V "z")) (Mult (Add (Add (V "y") (V "y")) (V "z")) (V "z")) ~=? substBexp eb3 s3,
                        "Substitution eb4 s4" ~: Eq (N 0) (V "x") ~=? substBexp eb4 s4,
                        "Substitution eb5 s2" ~: Neg (And (Le (Mult (N 2) (Mult (N 2) (V "y"))) (Add (Mult (N 2) (Mult (N 2) (V "y"))) (Sub (Mult (N 2) (V "y")) (Mult (N 2) (V "y"))))) TRUE) ~=? substBexp eb5 s2]

{-
*Exercises01> runTestTT testSubstBexp

Cases: 5  Tried: 0  Errors: 0  Failures: 0
Cases: 5  Tried: 1  Errors: 0  Failures: 0
Cases: 5  Tried: 2  Errors: 0  Failures: 0
Cases: 5  Tried: 3  Errors: 0  Failures: 0
Cases: 5  Tried: 4  Errors: 0  Failures: 0

Cases: 5  Tried: 5  Errors: 0  Failures: 0
Counts {cases = 5, tried = 5, errors = 0, failures = 0}
-}

-- |----------------------------------------------------------------------
-- | Exercise 4
-- |----------------------------------------------------------------------
-- | Given the algebraic data type 'Update' for state updates:

data Update = Var :=>: Z

-- | define a function 'update' that takes a state 's' and an update 'x :=>: v'
-- | and returns the updated state 's [x :=>: v]'

st1 :: State
st1 "x" = 6
-- st1 "y" = 3 esto se añade cuando hago un update con "y" :=>: 3
st1 "z" = 8
st1 _ = 0

-- *Exercises01> st1 "x"
-- *Exercises01> (update st1 up1) "x"

up1 :: Update
up1 = "x" :=>: 3

up2 :: Update
up2 = "z" :=>: 1

update :: State -> Update -> State
update s (x :=>: v) = s'
    where
        s' y  | (y == x) = v -- actualiza
              | otherwise = s y -- mete otro caso nuevo en el estado

-- | Test your function with HUnit.

testUpdate :: Test
testUpdate = test [     "Update st1 up1" ~: 3 ~=? (update st1 up1) "x",
                        "Update st1 up1" ~: 8 ~=? (update st1 up1) "z",
                        "Update st1 up2" ~: 6 ~=? (update st1 up2) "x",
                        "Update st1 up2" ~: 1 ~=? (update st1 up2) "z",
                        "Update st1 up2" ~: 0 ~=? (update st1 up2) "w"]

{-
*Exercises01> runTestTT testUpdate

Cases: 5  Tried: 0  Errors: 0  Failures: 0
Cases: 5  Tried: 1  Errors: 0  Failures: 0
Cases: 5  Tried: 2  Errors: 0  Failures: 0
Cases: 5  Tried: 3  Errors: 0  Failures: 0
Cases: 5  Tried: 4  Errors: 0  Failures: 0

Cases: 5  Tried: 5  Errors: 0  Failures: 0
Counts {cases = 5, tried = 5, errors = 0, failures = 0}
-}

-- | Define a function 'updates' that takes a state 's' and a list of updates
-- | 'us' and returns the updated states resulting from applying the updates
-- | in 'us' from head to tail. For example:
-- |
-- |    updates s ["x" :=>: 1, "y" :=>: 2, "x" :=>: 3]
-- |
-- | returns a state that binds "x" to 3 (the most recent update for "x").

ups :: [Update]
ups = ["x" :=>: 1, "y" :=>: 2, "x" :=>: 3, "z" :=>: 4]

updates :: State ->  [Update] -> State
updates s [] = s
updates s (u:us) = updates (update s u) us

-- |----------------------------------------------------------------------
-- | Exercise 5
-- |----------------------------------------------------------------------
-- | Define a function 'foldAexp' to fold an arithmetic expression

{-
Primero busco los constructores: N, V, Add, Mult, Sub

N :: Integer -> Aexp
V :: Var -> Aexp
Add :: Aexp -> Aexp -> Aexp
Mult :: Aexp -> Aexp -> Aexp
Sub :: Aexp -> Aexp -> Aexp

La idea es traducir el tipo Aexp por el tipo a (Aexp (recursivo) -> a(Z))

N :: Integer -> Aexp ___________ n :: Integer -> a
V :: Var -> Aexp _______________ v :: Var -> a
Add :: Aexp -> Aexp -> Aexp ____ add :: a -> a -> a
Mult :: Aexp -> Aexp -> Aexp ___ mult :: a -> a -> a
Sub :: Aexp -> Aexp -> Aexp ____ sub :: a -> a -> a

donde vea N pongo n
donde vea V pongo v
donde vea Add pongo add
donde vea Mult pongo mult
donde vea Sub pongo sub
-}

foldAexp :: (Integer -> a) -> (Var -> a) -> (a -> a -> a) -> (a -> a -> a) -> (a -> a -> a) -> Aexp -> a
foldAexp n v add mult sub (N int) = n int
foldAexp n v add mult sub (V var) = v var
foldAexp n v add mult sub (Add e1 e2) = add (foldAexp n v add mult sub e1) (foldAexp n v add mult sub e2)
foldAexp n v add mult sub (Mult e1 e2) = mult (foldAexp n v add mult sub e1) (foldAexp n v add mult sub e2)
foldAexp n v add mult sub (Sub e1 e2) = sub (foldAexp n v add mult sub e1) (foldAexp n v add mult sub e2)

-- | Use 'foldAexp' to define the functions 'aVal'', 'fvAexp'', and 'substAexp''
-- | and test your definitions with HUnit.

aVal' :: Aexp -> State -> Z
aVal' e s = foldAexp id (s) (+) (*) (-) e

testaVal' :: Test
testaVal' = test [      "Value ea1 st1" ~: 0 ~=? aVal' ea1 st1,
                        "Value ea2 st1" ~: 6 ~=? aVal' ea2 st1,
                        "Value ea3 st1" ~: 12 ~=? aVal' ea3 st1,
                        "Value ea4 st1" ~: 18 ~=? aVal' ea4 st1,
                        "Value ea5 st1" ~: 112 ~=? aVal' ea5 st1]

{-
*Exercises01> runTestTT testaVal'

Cases: 5  Tried: 0  Errors: 0  Failures: 0
Cases: 5  Tried: 1  Errors: 0  Failures: 0
Cases: 5  Tried: 2  Errors: 0  Failures: 0
Cases: 5  Tried: 3  Errors: 0  Failures: 0
Cases: 5  Tried: 4  Errors: 0  Failures: 0

Cases: 5  Tried: 5  Errors: 0  Failures: 0
Counts {cases = 5, tried = 5, errors = 0, failures = 0}
-}

fvAexp' :: Aexp -> [Var]
fvAexp' = foldAexp (const []) (\v -> [v]) ams ams ams
  where
    ams e1 e2 = nub $ e1 ++ e2

{-
Ejemplo ejecución

fvAexp' Mult (N 2) (V "x")
foldAexp (n v add mult sub Mult (N 2) (V "x")  {como es Mult, aplico ams (mult)}
mult (foldAexp n v add mult sub (N 2)) (foldAexp n v add mult sub (V "x"))
mult (n 2) (v "x")  { con n = const [] y v var = [var] }
mult ([]) (["x"]) { con mult e1 e2 = nub $ e1 ++ e2 }
nub $ [] ++ ["x"]
[v]
-}

testFvAexp' :: Test
testFvAexp' = test ["Free variables ea1" ~: [] ~=? fvAexp' ea1,
                    "Free variables ea2" ~: ["x"] ~=? fvAexp' ea2,
                    "Free variables ea3" ~: ["x"] ~=? fvAexp' ea3,
                    "Free variables ea4" ~: ["x","y"] ~=? fvAexp' ea4,
                    "Free variables ea5" ~: ["x","y","z"] ~=? fvAexp' ea5]

{-
*Exercises01> runTestTT testFvAexp'

Cases: 5  Tried: 0  Errors: 0  Failures: 0
Cases: 5  Tried: 1  Errors: 0  Failures: 0
Cases: 5  Tried: 2  Errors: 0  Failures: 0
Cases: 5  Tried: 3  Errors: 0  Failures: 0
Cases: 5  Tried: 4  Errors: 0  Failures: 0

Cases: 5  Tried: 5  Errors: 0  Failures: 0
Counts {cases = 5, tried = 5, errors = 0, failures = 0}
-}

substAexp' :: Aexp -> Subst -> Aexp
substAexp' e (y :->: a0) = foldAexp N v Add Mult Sub e
  where
    v var = if (var == y) then a0 else V var

testSubstAexp' :: Test
testSubstAexp' = test [ "Substitution ea1 s1" ~: N 0 ~=? substAexp' ea1 s1,
                        "Substitution ea2 s2" ~: Mult (N 2) (V "y") ~=? substAexp' ea2 s2,
                        "Substitution ea3 s3" ~: Mult (N 2) (V "y") ~=? substAexp' ea3 s3,
                        "Substitution ea4 s4" ~: Add (Mult (N 2) (V "x")) (Sub (V "x") (Mult (N 2) (Add (N 2) (V "z")))) ~=? substAexp' ea4 s4]

{-
*Exercises01> runTestTT testSubstAexp'

Cases: 4  Tried: 0  Errors: 0  Failures: 0
Cases: 4  Tried: 1  Errors: 0  Failures: 0
Cases: 4  Tried: 2  Errors: 0  Failures: 0
Cases: 4  Tried: 3  Errors: 0  Failures: 0

Cases: 4  Tried: 4  Errors: 0  Failures: 0
Counts {cases = 4, tried = 4, errors = 0, failures = 0}
-}

-- | Define a function 'foldBexp' to fold a Boolean expression and use it
-- | to define the functions 'bVal'', 'fvBexp'', and 'substAexp''. Test
-- | your definitions with HUnit.

{-
Primero busco los constructores: TRUE, FALSE, Eq, Le, Neg, And

TRUE :: Bexp
FALSE :: Bexp
Eq :: Aexp -> Aexp -> Bexp
Le :: Aexp -> Aexp -> Bexp
Neg :: Bexp -> Bexp
And :: Bexp -> Bexp -> Bexp

La idea es traducir el tipo Bexp por el tipo a (Bexp (recursivo) -> a(Z))

TRUE :: Bexp ___________________ t :: a
FALSE :: Bexp __________________ f :: a
Eq :: Aexp -> Aexp -> Bexp _____ eq :: Aexp -> Aexp -> a
Le :: Aexp -> Aexp -> Bexp _____ le :: Aexp -> Aexp -> a
Neg :: Bexp -> Bexp ____________ neg :: a -> a
And :: Bexp -> Bexp -> Bexp ____ an :: a -> a -> a

donde vea TRUE pongo t
donde vea FALSE pongo f
donde vea Eq pongo eq
donde vea Le pongo le
donde vea Neg pongo neg
donde vea And pongo an
-}

--foldBexp :: a
foldBexp t f eq le neg an TRUE = t TRUE
foldBexp t f eq le neg an FALSE = f FALSE
foldBexp t f eq le neg an (Eq ea1 ea2) = eq ea1 ea2
foldBexp t f eq le neg an (Le ea1 ea2) = le ea1 ea2
foldBexp t f eq le neg an (Neg eb) = neg (foldBexp t f eq le neg an eb)
foldBexp t f eq le neg an (And eb1 eb2) = an (foldBexp t f eq le neg an eb1) (foldBexp t f eq le neg an eb2)

bVal' :: Bexp -> State -> Bool
bVal' e s = foldBexp (const True) (const False) eq le (not) (&&) e
  where
    eq ea1 ea2 = (aVal' ea1 s) == (aVal' ea2 s)
    le ea1 ea2 = (aVal' ea1 s) <= (aVal' ea2 s)

testbVal' :: Test
testbVal' = test [      "Value eb1 st1" ~: True ~=? bVal' eb1 st1,
                        "Value eb2 st1" ~: False ~=? bVal' eb2 st1,
                        "Value eb3 st1" ~: True ~=? bVal' eb3 st1,
                        "Value eb4 st1" ~: False ~=? bVal' eb4 st1,
                        "Value eb5 st1" ~: False ~=? bVal' eb5 st1]

{-
*Exercises01> runTestTT testbVal'

Cases: 5  Tried: 0  Errors: 0  Failures: 0
Cases: 5  Tried: 1  Errors: 0  Failures: 0
Cases: 5  Tried: 2  Errors: 0  Failures: 0
Cases: 5  Tried: 3  Errors: 0  Failures: 0
Cases: 5  Tried: 4  Errors: 0  Failures: 0

Cases: 5  Tried: 5  Errors: 0  Failures: 0
Counts {cases = 5, tried = 5, errors = 0, failures = 0}
-}

fvBexp' :: Bexp -> [Var]
fvBexp' = foldBexp (const []) (const []) el el nub an
  where
    el ea1 ea2 = nub $ fvAexp ea1 ++ fvAexp ea2
    an eb1 eb2 = nub $ eb1 ++ eb2

{-
Ejemplo de ejecución

fvBexp' And (Eq (V "x") (V "y")) (Neg TRUE)
foldBexp (const []) (const []) el el nub an And (Eq (V "x") (V "y")) (Neg TRUE)
an (foldBexp t f eq le neg an  (Eq (V "x") (V "y"))) (foldBexp t f eq le neg an (Neg TRUE))
an (eq (Eq (V "x") (V "y"))) (neg (foldBexp t f eq le neg an TRUE))
an (eq (Eq (V "x") (V "y"))) (neg (t TRUE))
an (nub $ fvAexp (V "x") ++ fvAexp (V "y")) (neg ([]))
an (nub $ fvAexp (V "x") ++ fvAexp (V "y")) ([])
an (["x","y"]) ([])
nub $ ["x","y"] ++ []
["x","y"]
-}

testFvBexp' :: Test
testFvBexp' = test ["Free variables eb1" ~: [] ~=? fvBexp' eb1,
                    "Free variables eb2" ~: [] ~=? fvBexp' eb2,
                    "Free variables eb3" ~: ["x","y","z"] ~=? fvBexp' eb3,
                    "Free variables eb4" ~: ["x"] ~=? fvBexp' eb4,
                    "Free variables eb5" ~: ["x","y"] ~=? fvBexp' eb5]

{-
*Exercises01> runTestTT testFvBexp'

Cases: 5  Tried: 0  Errors: 0  Failures: 0
Cases: 5  Tried: 1  Errors: 0  Failures: 0
Cases: 5  Tried: 2  Errors: 0  Failures: 0
Cases: 5  Tried: 3  Errors: 0  Failures: 0
Cases: 5  Tried: 4  Errors: 0  Failures: 0

Cases: 5  Tried: 5  Errors: 0  Failures: 0
Counts {cases = 5, tried = 5, errors = 0, failures = 0}
-}

substBexp' :: Bexp -> Subst -> Bexp
substBexp' e s = foldBexp id id eq le neg an e
  where
    eq ea1 ea2 = Eq (substAexp ea1 s) (substAexp ea2 s)
    le ea1 ea2 = Le (substAexp ea1 s) (substAexp ea2 s)
    neg eb = Neg eb
    an eb1 eb2 = And eb1 eb2

{-
Ejemplo de ejecución

substBexp' And (Eq (V "x") (V "x")) (Neg (TRUE)) ("x" :->: N 5)
foldBexp id id eq le neg an And (Eq (V "x") (V "x")) (Neg (TRUE))
an (foldBexp t f eq le neg an (Eq (V "x") (V "x"))) (foldBexp t f eq le neg an (Neg (TRUE)))
an (eq (V "x") (V "x")) (neg (TRUE))
an (Eq (substAexp (V "x") s) (substAexp (V "x") s)) (Neg TRUE))
an (Eq (N 5) (N 5)) (Neg TRUE))
And (Eq (N 5) (N 5)) (Neg TRUE))

-}

testSubstBexp' :: Test
testSubstBexp' = test [ "Substitution eb1 s1" ~: TRUE ~=? substBexp' eb1 s1,
                        "Substitution eb2 s2" ~: And TRUE FALSE ~=? substBexp' eb2 s2,
                        "Substitution eb3 s3" ~: Eq (Mult (Add (Add (V "y") (V "y")) (V "z")) (V "z")) (Mult (Add (Add (V "y") (V "y")) (V "z")) (V "z")) ~=? substBexp' eb3 s3,
                        "Substitution eb4 s2" ~: Eq (N 0) (Mult (N 2) (V "y")) ~=? substBexp' eb4 s2]

{-
*Exercises01> runTestTT testSubstBexp'

Cases: 4  Tried: 0  Errors: 0  Failures: 0
Cases: 4  Tried: 1  Errors: 0  Failures: 0
Cases: 4  Tried: 2  Errors: 0  Failures: 0
Cases: 4  Tried: 3  Errors: 0  Failures: 0

Cases: 4  Tried: 4  Errors: 0  Failures: 0
Counts {cases = 4, tried = 4, errors = 0, failures = 0}
-}
