{-|

Programming Languages
Fall 2018

Implementation in Haskell of the Natural Semantics described in Chapter 2 of
Nielson & Nielson, Semantics with Applications

Author:

-}

module Exercises02 where

import           Exercises01      (Update (..), fvAexp, fvBexp, update)
import           NaturalSemantics
import           Test.HUnit       hiding (State)
import           While
import           Data.List

-- |----------------------------------------------------------------------
-- | Exercise 1
-- |----------------------------------------------------------------------
-- | The function 'sNs' returns the final state of the execution of a
-- | WHILE statement 'st' from a given initial state 's'. For example:
-- |
-- |  sNs factorial sInit
-- |
-- | returns the final state:
-- |
-- |    s x = 1
-- |    s y = 6
-- |    s _ = 0
-- |
-- | Since a state is a function it cannot be printed thus you cannot
-- | add 'deriving Show' to the algebraic data type 'Config'.
-- | The goal of this exercise is to define a number of functions to
-- | "show" a state thus you can inspect the final state computed by the
-- | natural semantics of WHILE.

-- | Exercise 1.1
-- | Define a function 'showState' that given a state 's' and a list
-- | of variables 'vs' returns a list of strings showing the bindings
-- | of the variables mentioned in 'vs'. For example, for the state
-- | 's' above we get:
-- |
-- |    showState s ["x"] = ["x -> 1"]
-- |    showState s ["y"] = ["y -> 6"]
-- |    showState s ["x", "y"] = ["x -> 1", "y -> 6"]
-- |    showState s ["y", "z", "x"] = ["y -> 6", "z -> 0", "x -> 1"]

-- State definition to test "showState"
s :: State
s "x" = 1
s "y" = 6
s _ = 0

showState :: State -> [Var] -> [String]
showState s [] = []
showState s (v:vs) = (v ++ " -> " ++ show (s v)) : (showState s vs)

-- | Test your function with HUnit.

testShowState :: Test
testShowState = test ["For state s = [x -> 1, y -> 6, _ -> 0], the bindings of vs = [] are: " ~: [] ~=? showState s [],
                      "For state s = [x -> 1, y -> 6, _ -> 0], the bindings of vs = [x] are" ~: ["x -> 1"] ~=? showState s ["x"],
                      "For state s = [x -> 1, y -> 6, _ -> 0], the bindings of vs = [y] are" ~: ["y -> 6"] ~=? showState s ["y"],
                      "For state s = [x -> 1, y -> 6, _ -> 0], the bindings of vs = [x, y] are" ~: ["x -> 1", "y -> 6"] ~=? showState s ["x", "y"],
                      "For state s = [x -> 1, y -> 6, _ -> 0], the bindings of vs = [y, z, x] are" ~: ["y -> 6", "z -> 0", "x -> 1"] ~=? showState s ["y", "z", "x"]]

{-
*Exercises02> runTestTT testShowState

Cases: 5  Tried: 0  Errors: 0  Failures: 0
Cases: 5  Tried: 1  Errors: 0  Failures: 0
Cases: 5  Tried: 2  Errors: 0  Failures: 0
Cases: 5  Tried: 3  Errors: 0  Failures: 0
Cases: 5  Tried: 4  Errors: 0  Failures: 0

Cases: 5  Tried: 5  Errors: 0  Failures: 0
Counts {cases = 5, tried = 5, errors = 0, failures = 0}
-}

-- | Exercise 1.2
-- | Define a function 'fvStm' that returns the free variables of a WHILE
-- | statement. For example:
-- |
-- | fvStm factorial = ["y","x"]
-- |
-- | Note: the order of appearance is not relevant, but there should not be
-- | duplicates.

-- Some states definitions to test "fvStm"
st1 :: Stm
st1 = Ass "x" (N 7)

st2 :: Stm
st2 = Skip

st3 :: Stm
st3 = Comp (Ass "y" (Mult (N 3) (V "x"))) (Skip)

st4 :: Stm
st4 = If (Eq (V "x") (N 10)) (Ass ("x") (Add (V "x") (N 1))) (Skip)

st5 :: Stm
st5 = While (Le (V "x") (N 100)) (Ass "x" (Add (V "x") (N 1)))

fvStm :: Stm -> [Var]
fvStm (Ass var aexp) = nub $ [var] ++ fvAexp aexp
fvStm Skip = []
fvStm (Comp st1 st2) = nub $ (fvStm st1) ++ (fvStm st2)
fvStm (If bexp st1 st2) = nub $ (fvBexp bexp) ++ (fvStm st1) ++ (fvStm st2)
fvStm (While bexp st) = nub $ (fvBexp bexp) ++ (fvStm st)
fvStm (Repeat st bexp) = nub $ (fvStm st) ++ (fvBexp bexp)
fvStm (For var a1 a2 st) = nub $ [var] ++ fvAexp a1 ++ fvAexp a2 ++ fvStm st

-- | Test your function with HUnit. Beware the order or appearance.

testFvStm :: Test
testFvStm = test ["Free variables of statament <x := 7>" ~: ["x"] ~=? fvStm st1,
                  "Free variables of statament <Skip>" ~: [] ~=? fvStm st2,
                  "Free variables of statament <y := 3*x; Skip>" ~: ["y", "x"] ~=? fvStm st3,
                  "Free variables of statament <if (x == 10) then x := x+1 else Skip>" ~: ["x"] ~=? fvStm st4,
                  "Free variables of statament <while (x <= 100) y := y*z; x := x+1>" ~: ["x", "y", "z"] ~=? fvStm st5,
                  "Free variables of statament <y := 1; while (x != 1) do (y := y*x; x := x-1;)>" ~: ["y", "x"] ~=? fvStm factorial]

{-
*Exercises02> runTestTT testFvStm

Cases: 6  Tried: 0  Errors: 0  Failures: 0
Cases: 6  Tried: 1  Errors: 0  Failures: 0
Cases: 6  Tried: 2  Errors: 0  Failures: 0
Cases: 6  Tried: 3  Errors: 0  Failures: 0
Cases: 6  Tried: 4  Errors: 0  Failures: 0
Cases: 6  Tried: 5  Errors: 0  Failures: 0

Cases: 6  Tried: 6  Errors: 0  Failures: 0
Counts {cases = 6, tried = 6, errors = 0, failures = 0}

-}

-- | Exercise 1.3
-- | Define a function 'showFinalState' that given a WHILE statement and a
-- | initial state returns a list of strings with the bindings of
-- | the free variables of the statement in the final state. For
-- | example:
-- |
-- |  showFinalState factorial sInit = ["y->6","x->1"]

-- I need to modify NaturalSemantics.hs
showFinalState :: Stm -> State -> [String]
showFinalState st s = showState (sNs st s) (fvStm st)

-- | Test your function with HUnit. Beware the order or appearance.

testShowFinalState :: Test
testShowFinalState = test ["Final state of configuration <x := 7, [x -> 3]> " ~: ["x -> 7"] ~=? showFinalState st1 sInit,

                  "Final state of configuration <Skip, [x -> 3]>" ~: [] ~=? showFinalState st2 sInit,

                  "Final state of configuration <y := 3*x; Skip, [x -> 3]>" ~: ["y -> 9", "x -> 3"] ~=? showFinalState st3 sInit,

                  "Final state of configuration <if (x == 10) then x := x+1 else Skip, [x -> 3]>" ~: ["x -> 3"] ~=? showFinalState st4 sInit,

                  "Final state of configuration <while (x <= 100) x := x+1, [x -> 3]>" ~: ["x -> 101"] ~=? showFinalState st5 sInit,

                  "Final state of configuration <y := 1; while (x != 1) do (y := y*x; x := x-1;), [x -> 3]>" ~: ["y -> 6", "x -> 1"] ~=? showFinalState factorial sInit]

{-
*Exercises02> runTestTT testShowFinalState

Cases: 6  Tried: 0  Errors: 0  Failures: 0
Cases: 6  Tried: 1  Errors: 0  Failures: 0
Cases: 6  Tried: 2  Errors: 0  Failures: 0
Cases: 6  Tried: 3  Errors: 0  Failures: 0
Cases: 6  Tried: 4  Errors: 0  Failures: 0
Cases: 6  Tried: 5  Errors: 0  Failures: 0

Cases: 6  Tried: 6  Errors: 0  Failures: 0
Counts {cases = 6, tried = 6, errors = 0, failures = 0}
-}

-- |----------------------------------------------------------------------
-- | Exercise 2
-- |----------------------------------------------------------------------
-- | Write a program in WHILE to compute z = x^y and check it by obtaining a
-- | number of final states.

-- WHILE statement to compute z = x^y
power :: Stm
power = Comp (Ass "z" (N 1))
                 (While (Neg (Eq (V "y") (N 0)))
                    (Comp (Ass "z" (Mult (V "z") (V "x")))
                          (Ass "y" (Sub (V "y") (N 1)))))

-- | Test your function with HUnit. Inspect the final states of at least
-- | four different executions.

s1 :: State
s1 "x" =  2
s1 "y" =  0
s1 _   =  0

s2 :: State
s2 "x" =  3
s2 "y" =  1
s2 _   =  0

s3 :: State
s3 "x" =  5
s3 "y" =  5
s3 _   =  0

s4 :: State
s4 "x" =  10
s4 "y" =  10
s4 _   =  0

s5 :: State
s5 "x" = 32
s5 "y" = 5
s5 _   = 0

testPower :: Test
testPower = test ["Final state of 2^0" ~: ["z -> 1", "y -> 0", "x -> 2"] ~=? showFinalState power s1,

                  "Final state of 3^1" ~: ["z -> 3", "y -> 0", "x -> 3"] ~=? showFinalState power s2,

                  "Final state of 5^5" ~: ["z -> 3125", "y -> 0", "x -> 5"] ~=? showFinalState power s3,

                  "Final state of 10^10" ~: ["z -> 10000000000", "y -> 0", "x -> 10"] ~=? showFinalState power s4]

{-
*Exercises02> runTestTT testPower

Cases: 4  Tried: 0  Errors: 0  Failures: 0
Cases: 4  Tried: 1  Errors: 0  Failures: 0
Cases: 4  Tried: 2  Errors: 0  Failures: 0
Cases: 4  Tried: 3  Errors: 0  Failures: 0

Cases: 4  Tried: 4  Errors: 0  Failures: 0
Counts {cases = 4, tried = 4, errors = 0, failures = 0}
-}

-- |----------------------------------------------------------------------
-- | Exercise 3
-- |----------------------------------------------------------------------
-- | The WHILE language can be extended with a 'repeat S until b' construct.

-- | Exercise 3.1
-- | Define the natural semantics of this new construct. You are not allowed
-- | to rely on the 'while b do S' statement.

{- Formal definition of 'repeat S until b' (it's executed at least one time)

                        <S, s> -> s', <repeat S until b, s'> -> s''
        [repeat-ff]  -----------------------------------------------   if (B[b]s') = ff
                              <repeat S until b, s> -> s''


                              <S, s> -> s'
        [repeat-tt]  ------------------------------   if (B[b]s') = tt
                      <repeat S until b, s> -> s'

-}

-- | Extend  the definitions of  data type 'Stm' (in  module While.hs)
-- |  and  'nsStm'  (in  module NaturalSemantics.hs)  to  include  the
-- | 'repeat  S until b' construct.  Write a couple of  WHILE programs
-- | that use the 'repeat' statement and test your functions with HUnit.

stm1 :: Stm
stm1 =  (Repeat (Ass "x" (Add (V "x") (N 1))) (Eq (V "y") (N 0)))

stm2 :: Stm
stm2 =  (Repeat (Ass "x" (Add (V "x") (N 1))) (Eq (V "x") (N 6)))

modRepeat :: Stm -- WHILE statement to compute z = x % y, where x >= y
modRepeat = Comp
                (If (Le (V "x") (V "y"))
                (Comp (Comp
                (Ass "z" (V "x"))
                (Ass "x" (V "y")))
                (Ass "y" (V "z")))
                Skip)
                (Comp
                    (Repeat
                        (Ass "x" (Sub (V "x") (V "y")))
                        (Neg (Le (V "y") (V "x"))))
                    (Ass "z" (V "x")))

-- <repeat x := x+1; until x==2, [x->2]> este programa no acabaría

testRepeatUntil :: Test
testRepeatUntil = test ["Final state of <repeat x := x+1; until y==0, [x->2, y->0]>" ~: ["x -> 3", "y -> 0"] ~=? showFinalState stm1 s1,

                  "Final state of <repeat x := x+1; until x==6, [x->2]>" ~: ["x -> 6"] ~=? showFinalState stm2 s1,

                  "Final state of <x % y, [x->32, y->5]>" ~: ["x -> 2", "y -> 5", "z -> 2"] ~=? showFinalState modRepeat s5]

{-
*Exercises02> runTestTT testRepeatUntil

Cases: 3  Tried: 0  Errors: 0  Failures: 0
Cases: 3  Tried: 1  Errors: 0  Failures: 0
Cases: 3  Tried: 2  Errors: 0  Failures: 0

Cases: 3  Tried: 3  Errors: 0  Failures: 0
Counts {cases = 3, tried = 3, errors = 0, failures = 0}
-}

-- |----------------------------------------------------------------------
-- | Exercise 4
-- |----------------------------------------------------------------------
-- | The WHILE language can be extended with a 'for x:= a1 to a2 do S'
-- | construct.

-- | Exercise 4.1
-- | Define the natural semantics of this new construct. You are not allowed
-- | to rely on the 'while b do S' or the 'repeat S until b' statements.

-- Remarks:
  -- It is not allowed to change (i.e. assign a value to) the value of a loop variable inside the loop.
  -- The condition of the loop is: if (a1 <= a2) then execute loop's body else leave the loop

{- Formal definition of 'for x:= a1 to a2 do S'

Leave the loop:

                        <x:= a1, s> -> s'
[for-ff]  -----------------------------------------------   if (B[x <= a2]s') = ff
                  <for x:= a1 to a2 do S, s> -> s'


Keep looping:

              <x:= a1, s> -> s', <S, s'> -> s'', <for x:= A[x]s'' +1 to a2 do S, s''> -> s'''
[for-tt]  ---------------------------------------------------------------------------------   if (B[x <= a2]s') = tt
                              <for x:= a1 to a2 do S, s> -> s'''


-}

-- | Extend  the definitions of  data type 'Stm' (in  module While.hs)
-- | and  'nsStm'  (in  module NaturalSemantics.hs)  to  include  the
-- | 'for x:= a1 to a2 do S' construct.  Write a couple of  WHILE programs
-- | that use the 'for' statement and test your functions with HUnit.

st1for :: Stm
st1for = For "x" (N 1) (N 5) Skip

st2for :: Stm
st2for = For "x" (N 6) (N 5) Skip

-- Computes the sum of the first "x" natural numbers. Ej: x = 5 ... solution z = 15
sumUp :: Stm
sumUp =  For "y" (N 1) (V "x") (Ass "z" (Add (V "z") (V "y")))

-- Computes x^y and stores result in z
powerFor :: Stm
powerFor = Comp
              (Ass "z" (N 1))
              (For "w" (N 1) (V "y") (Ass "z" (Mult (V "z") (V "x"))))

sumNestedFor :: Stm
sumNestedFor = Comp
                    (Ass "z" (N 0))
                    (For "x" (N 1) (V "y")
                      (For "w" (N 1) (V "y")
                        (Ass "z" (Add (V "z") (N 1)))
                      )
                    )

testFor :: Test
testFor = test ["Final state of <for x := 1 to 5 do Skip, [x->2]>" ~: ["x -> 6"] ~=? showFinalState st1for s1,

                "Final state of <for x := 6 to 5 do Skip, [x->2]>" ~: ["x -> 6"] ~=? showFinalState st2for s1,

                "Final state of <sum of x first numbers, [x->5, y->5, z->0]>" ~: ["y -> 6", "x -> 5", "z -> 15"] ~=? showFinalState sumUp s3,

                "Final state of <x^y, [x->5, y->5, z->0, w->0]>" ~: ["z -> 3125", "w -> 6", "y -> 5", "x -> 5"] ~=? showFinalState powerFor s3,

                "Final state of <z := 0; for x:= 1 to y do (for w := 1 to y do (z := z + 1)), [x->5, y->5, z->0, w->0]>" ~: ["z -> 25", "x -> 6", "y -> 5", "w -> 6"] ~=? showFinalState sumNestedFor s3]

{-
*Exercises02> runTestTT testFor

Cases: 5  Tried: 0  Errors: 0  Failures: 0
Cases: 5  Tried: 1  Errors: 0  Failures: 0
Cases: 5  Tried: 2  Errors: 0  Failures: 0
Cases: 5  Tried: 3  Errors: 0  Failures: 0
Cases: 5  Tried: 4  Errors: 0  Failures: 0

Cases: 5  Tried: 5  Errors: 0  Failures: 0
Counts {cases = 5, tried = 5, errors = 0, failures = 0}
-}

-- |----------------------------------------------------------------------
-- | Exercise 5
-- |----------------------------------------------------------------------

-- | Define the semantics of arithmetic expressions (Aexp) by means of
-- | natural semantics. To that end, define an algebraic datatype 'ConfigAexp'
-- | to represent the configurations, and a function 'nsAexp' to represent
-- | the transition relation.

-- representation of configurations for Aexp, (replace TODO by appropriate
-- data definition)

data ConfigAExp = InterAexp Aexp State
                  | FinalAexp Z

-- representation of the transition relation <A, s> -> Z

nsAexp :: ConfigAExp -> ConfigAExp
nsAexp (InterAexp (N n) s) = FinalAexp n
nsAexp (InterAexp (V v) s) = FinalAexp (s v)
nsAexp (InterAexp (Add a1 a2) s) = FinalAexp z
    where
        z = z1 + z2
        FinalAexp z1 = nsAexp (InterAexp a1 s)
        FinalAexp z2 = nsAexp (InterAexp a2 s)
nsAexp (InterAexp (Sub a1 a2) s) = FinalAexp z
    where
        z = z1 - z2
        FinalAexp z1 = nsAexp (InterAexp a1 s)
        FinalAexp z2 = nsAexp (InterAexp a2 s)
nsAexp (InterAexp (Mult a1 a2) s) = FinalAexp z
    where
        z = z1 * z2
        FinalAexp z1 = nsAexp (InterAexp a1 s)
        FinalAexp z2 = nsAexp (InterAexp a2 s)

-- Showing value of a ConfigAExp
showAexpVal :: ConfigAExp -> Z
showAexpVal (InterAexp aexp state) = error "showAexpVal: not a final configuration"
showAexpVal (FinalAexp z) = z

-- A few ConfigAexp
cea1 :: ConfigAExp
cea1 = InterAexp (N 0) s1
cea2 :: ConfigAExp
cea2 = InterAexp (V "x") s2
cea3 :: ConfigAExp
cea3 = InterAexp (Mult (N 2) (V "x")) s3
cea4 :: ConfigAExp
cea4 = InterAexp (Add (Mult (N 2) (V "x")) (Sub (V "x") (Mult (N 2) (V "y")))) s4
cea5 :: ConfigAExp
cea5 = InterAexp (Mult (Add (Add (V "x") (V "y")) (V "z")) (V "z")) s5

-- | Test your function with HUnit. Inspect the final states of at least
-- | four different evaluations.

testNsAexp :: Test
testNsAexp = test [     "Value of (N 0) in state []" ~: 0 ~=? (showAexpVal $ nsAexp cea1),
                        "Value ea2 st1" ~: 3 ~=? (showAexpVal $ nsAexp cea2),
                        "Value ea3 st1" ~: 10 ~=? (showAexpVal $ nsAexp cea3),
                        "Value ea4 st1" ~: 10 ~=? (showAexpVal $ nsAexp cea4),
                        "Value ea5 st1" ~: 0 ~=? (showAexpVal $ nsAexp cea5)]

{-
*Exercises02> runTestTT testNsAexp

Cases: 5  Tried: 0  Errors: 0  Failures: 0
Cases: 5  Tried: 1  Errors: 0  Failures: 0
Cases: 5  Tried: 2  Errors: 0  Failures: 0
Cases: 5  Tried: 3  Errors: 0  Failures: 0
Cases: 5  Tried: 4  Errors: 0  Failures: 0

Cases: 5  Tried: 5  Errors: 0  Failures: 0
Counts {cases = 5, tried = 5, errors = 0, failures = 0}
-}

-- |----------------------------------------------------------------------
-- | Exercise 6
-- |----------------------------------------------------------------------

-- | Given the algebraic data type 'DerivTree' to represent derivation trees
-- | of the natural semantics:

data Transition = Config :-->: State

data DerivTree = AssNS     Transition
               | SkipNS    Transition
               | CompNS    Transition DerivTree DerivTree
               | IfTTNS    Transition DerivTree
               | IfFFNS    Transition DerivTree
               | WhileTTNS Transition DerivTree DerivTree
               | WhileFFNS Transition

-- | and the function 'getFinalState' to access the final state of the root
-- | of a derivation tree:

getFinalState :: DerivTree -> State
getFinalState (AssNS  (_ :-->: s))         = s
getFinalState (SkipNS (_ :-->: s))         = s
getFinalState (CompNS (_ :-->: s) _ _ )    = s
getFinalState (IfTTNS (_ :-->: s) _ )      = s
getFinalState (IfFFNS (_ :-->: s) _ )      = s
getFinalState (WhileTTNS (_ :-->: s) _ _ ) = s
getFinalState (WhileFFNS (_ :-->: s))      = s

-- | Define a function 'nsDeriv' that given a WHILE statement 'st' and an
-- | initial state 's' returns corresponding derivation tree.

nsDeriv :: Stm -> State -> DerivTree
-- Axioms
nsDeriv stm@(Ass v a) s0 = AssNS (Inter stm s0 :-->: sNs stm s0)
nsDeriv stm@Skip s0 = SkipNS (Inter stm s0 :-->: sNs stm s0)
-- Rules
nsDeriv stm@(Comp st1 st2) s0 = CompNS (Inter stm s0 :-->: sNs stm s0) (nsDeriv st1 s0) (nsDeriv st2 s1)
  where
    s1 = sNs st1 s0

nsDeriv ss@(If bexp ss1 ss2) s
    | bVal bexp s   = (IfTTNS (config :-->: s') (nsDeriv ss1 s))
    | otherwise     = (IfFFNS (config :-->: s') (nsDeriv ss2 s))
    where
        s' = sNs ss s
        config = Inter ss s

nsDeriv ss@(While bexp ss1) s
        | bVal bexp s   = (WhileTTNS (config :-->: s') (nsDeriv ss1 s) (nsDeriv ss s''))
        | otherwise     = (WhileFFNS (config :-->: s))
        where
            s' = sNs ss s
            s'' = sNs ss1 s
            config = Inter ss s

-- Some programs for testing ---------------------------------------------------
-- swap values of x and y using auxiliar var z
swap :: Stm
swap =  Comp (Comp (Ass "z" (V "x")) (Ass "x" (V "y"))) (Ass "y" (V "z"))

comp :: Stm
comp = Comp (Ass "z" (V "x")) (Ass "y" (V "z"))

ifelse :: Stm
ifelse = If (Le (V "x") (N 5)) (Ass "y" (N 10)) (Ass "y" (N 20))

sSwap :: State
sSwap "x" = 5
sSwap "y" = 7
sSwap _   = 0
--------------------------------------------------------------------------------

-- Shows derivation three with end lines (to follow the derivation easyly)
ioDerivation :: DerivTree -> IO ()
ioDerivation dt = io $ showDerivation dt

io :: String -> IO ()
io st = putStr ("\n\n"++st++"\n\n")
--------------------------------------------------------------------------------

showDerivation :: DerivTree -> String
showDerivation (AssNS (Inter stm s :-->: s')) = str
  where
    str = concat ["( {", show stm, ", [ ", concatMap (++" ") $ showState s (fvStm stm),
          "]} ---> [ ", concatMap (++" ") $ showFinalState stm s, "] )"]

showDerivation (SkipNS (Inter stm s :-->: s')) =  str
  where
    str = concat ["( {", show stm, ", [ ", concatMap (++" ") $ showState s (fvStm stm),
          "]} ---> [ ", concatMap (++" ") $ showFinalState stm s, "] )"]

showDerivation (CompNS (Inter stm s :-->: s') (d1) (d2)) = str
  where
    str = concat ["( {", show stm, ", [ ", concatMap (++" ") $ showState s (fvStm stm),
           "]} ---> [ ", concatMap (++" ") $ showFinalState stm s, "]","\n",
           (showDerivation d1) ++ "\n", (showDerivation d2), " )"]

showDerivation (IfFFNS (Inter stm s :-->: s') (d1)) = str
  where
    str = concat ["( {", show stm, ", [ ", concatMap (++" ") $ showState s (fvStm stm),
                  "]} ---> [ ", concatMap (++" ") $ showFinalState stm s, "]","\n",
                  (showDerivation d1) ++ " )"]

showDerivation (IfTTNS (Inter stm s :-->: s') (d1)) = str
  where
    str = concat ["( {", show stm, ", [ ", concatMap (++" ") $ showState s (fvStm stm),
                  "]} ---> [ ", concatMap (++" ") $ showFinalState stm s, "]","\n",
                  (showDerivation d1) ++ " )"]

showDerivation (WhileTTNS (Inter stm s :-->: s') (d1) (d2)) = str
  where
    str = concat ["( {", show stm, ", [ ", concatMap (++" ") $ showState s (fvStm stm),
                  "]} ---> [ ", concatMap (++" ") $ showFinalState stm s, "]","\n",
                  (showDerivation d1) ++ "\n", (showDerivation d2), " )"]

showDerivation (WhileFFNS (Inter stm s :-->: s')) =  str
  where
    str = concat ["( {", show stm, ", [ ", concatMap (++" ") $ showState s (fvStm stm),
                  "]} ---> [ ", concatMap (++" ") $ showFinalState stm s, "] )"]



-- end
