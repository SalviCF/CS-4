{-|

Programming Languages
Fall 2018

Implementation in Haskell of the Structural Operational Semantics
described in Chapter 2 of Nielson & Nielson, Semantics with Applications

Author:

-}

module Exercises03 where

import           ExWhile
import           StructuralSemantics

-- |----------------------------------------------------------------------
-- | Exercise 1
-- |----------------------------------------------------------------------

-- | Given the type synonym 'DerivSeq' to represent derivation sequences
-- | of the structural operational semantics:

type DerivSeq = [Config]

-- | Define a function 'derivSeq' that given a WHILE statement 'st' and an
-- | initial state 's' returns the corresponding derivation sequence:

derivSeq :: Stm -> State -> DerivSeq
derivSeq st ini | isFinal next = (Inter st ini) : next : []
                | otherwise    = (Inter st ini) : derivSeq st' s
  where
    next = sosStm (Inter st ini)
    Inter st' s = sosStm (Inter st ini)


-- | To test your definition of 'derivSeq' you can use the code below.
-- | The function 'facSeq' returns the derivation sequence of the 'factorial'
-- | statement executed from the initial state 'sInit':

facSeq :: DerivSeq
facSeq = derivSeq factorial sInit

-- | The function 'showDerivSeq' returns a String representation  of
-- | a derivation sequence 'dseq'. The 'vars' argument is a list of variables
-- | that holds the variables to be shown in the state:

showDerivSeq :: [Var] -> DerivSeq -> String
showDerivSeq vars dseq = unlines (map showConfig dseq)
  where
    showConfig (Final s)    = "Final state:\n" ++ unlines (showVars s vars)
    showConfig (Inter ss s) = show ss ++ "\n" ++ unlines (showVars s vars)
    showVars s vs = map (showVal s) vs
    showVal s x = " s(" ++ x ++ ")= " ++ show (s x)

-- | Therefore, you can print the derivation sequence of 'factorial' with:

showFacSeq :: IO()
showFacSeq = putStrLn $ showDerivSeq ["x", "y"] facSeq

-- | You should get an output identical to 'derivSeqForFactorial.txt'

-- | The function 'sSoS' below is the semantic function of the
-- | structural operational semantics of WHILE. Given a WHILE statement 'st'
-- | and an initial state 's' returns the final configuration of the
-- | corresponding derivation sequence:

sSos :: Stm -> State -> State
sSos ss s = s'
  where Final s' = last (derivSeq ss s)

sFac' :: State
sFac' = sSos factorial sInit

{-
*Exercises03> sFac' "x"
1
*Exercises03> sFac' "y"
6
-}

-- |----------------------------------------------------------------------
-- | Exercise 2
-- |----------------------------------------------------------------------
-- | The WHILE language can be extended with a 'repeat S until b' construct.

-- | Exercise 2.1
-- | Define the structural operational semantics of this new construct. You
-- | are not allowed to rely on the 'while b do S' statement.

{- Formal definition of 'repeat S until b'


        [repeat-sos]  <repeat S until b, s> => <S; if b then skip else (repeat S until b), s>

-}

-- | Exercise 2.2
-- | Modify the definition of 'sosStm' in 'StructuralSemantics.hs' to deal
-- | with the 'repeat until' construct




-- | Exercise 2.3
-- | Write a WHILE program to test your definition of the repeat statement.

repProgram :: Stm
repProgram = Comp   (Ass "x" (N 1))
                    (Repeat
                         (Ass "x" (Add (V "x") (N 1)))
                    (Eq (V "x") (N 5)))

repProgramSeq :: DerivSeq
repProgramSeq = derivSeq repProgram sInit

showRepProgramSeq :: IO()
showRepProgramSeq = putStrLn $ showDerivSeq ["x"] repProgramSeq

-- |----------------------------------------------------------------------
-- | Exercise 3
-- |----------------------------------------------------------------------

-- |  Extend WHILE with the 'Abort' statement.  The informal semantics of
-- |'Abort' is to abruptly stop the execution of the program, similar to
-- | a call to 'exit(0)' in other mainstream languages.

-- | Exercise 3.1
-- | Modify the definition of 'sosStm' in 'StructuralSemantics.hs' to deal
-- | with the 'abort' statement


-- | Exercise 3.2
-- | Define a function 'derivSeqAbort' similar to 'derivSeq' except
-- | that it deals with stuck configurations.

derivSeqAbort :: Stm -> State -> DerivSeq
derivSeqAbort st ini  | isFinal next           = (Inter st ini) : next : []
                      | isAbort (Inter st ini) = [Inter st ini]
                      | otherwise              = (Inter st ini) : derivSeqAbort st' s
  where
    next = sosStm (Inter st ini)
    Inter st' s = sosStm (Inter st ini)

-- | You can test your code with the examples below and the function
-- | 'showAbortSeq':

showAbortSeq :: IO()
showAbortSeq = putStrLn $ showDerivSeq ["x", "y"] (derivSeqAbort abortExample3 sInit)

abortExample0 :: Stm
abortExample0 = Abort

abortExample1 :: Stm
abortExample1 =  Comp (Ass "x" (N 1))
                (Comp (Ass "y" (N 2))
                      Abort)

abortExample2 :: Stm
abortExample2 =  Comp (Ass "x" (N 1))
                (Comp (Ass "y" (N 2))
                (Comp  Abort
                      (Ass "z" (N 3))))

abortExample3 :: Stm
abortExample3 = Comp (Ass "x" (N 1))
                     (While (Le (V "x") (N 5))
                         (If (Eq (V "x") (N 3))
                             Abort
                             (Ass "x" (Add (V "x") (N 1))))
                     )

-- |----------------------------------------------------------------------
-- | Exercise 4
-- |----------------------------------------------------------------------

-- | Implement in Haskell the Structural Operational Semantics for the
-- | evaluation of arithmetic expressions Aexp.

{-
   Structural Operational Semantics for the left-to-right evaluation of
   arithmetic expressions:

   A configuration is either intermediate <Aexp, State> or final Z.

   Note we are abusing notation and write 'n' for both a literal (syntax)
   and an integer (semantics). Same goes for arithmetic operators (+,-,*).

   [N]  ----------------
         < n, s > => n

   [V] ------------------------
        < x, s > => < s x, s >

   [+] -----------------------------  where n3 = n1 + n2
        < n1 + n2, s > => < n3, s >

            < a2, s > => < a2', s >
   [+] ----------------------------------
        < n1 + a2, s > => <n1 + a2', s >

            < a1, s > => < a1', s >
   [+] -----------------------------------
        < a1 + a2, s > => < a1' + a2, s >

   The rules for * and - are similar.

-}

-- | We use the algebraic data type 'AexpConfig' to represent the
-- | configuration of the transition system

data AexpConfig = Redex Aexp State  -- a redex is a reducible expression
                | Value Z           -- a value is not reducible; it is in normal form


-- |----------------------------------------------------------------------
-- | Exercise 4.1
-- |----------------------------------------------------------------------

-- | Define a function 'sosAexp' that given a configuration 'AexpConfig'
-- | evaluates the expression in 'AexpConfig' one step and returns the
-- | next configuration.

isValue :: AexpConfig -> Bool
isValue (Value v)   = True
isValue (Redex _ _) = False

sosAexp :: AexpConfig -> AexpConfig

-- n
sosAexp (Redex (N n) _)               = Value n

-- x
sosAexp (Redex (V x) s)               = Value (s x)

-- a1 + a2
sosAexp (Redex (Add (N n1) (N n2)) s) = Value (n1 + n2)

sosAexp (Redex (Add (N n) a2) s)      | isValue next  = Value (n + n')
                                      | otherwise     = Redex (Add (N n) a2') s
  where
    next = sosAexp (Redex a2 s)
    Value n' = sosAexp (Redex a2 s)
    Redex a2' s' = sosAexp (Redex a2 s)

sosAexp (Redex (Add a1 a2) s)         | isValue next  = Redex (Add (N vA1) a2) s
                                      | otherwise     = Redex (Add vA1' a2) s
  where
    next = sosAexp (Redex a1 s)
    Value vA1 = sosAexp (Redex a1 s)
    Redex vA1' s' = sosAexp (Redex a1 s)

-- a1 * a2

sosAexp (Redex (Mult (N n1) (N n2)) s) = Value (n1 * n2)

sosAexp (Redex (Mult (N n) a2) s)     | isValue next = Value (n * n')
                                      | otherwise = Redex (Mult (N n) a2') s
     where
          next = sosAexp (Redex a2 s)
          Value n' = sosAexp (Redex a2 s)
          Redex a2' s' = sosAexp (Redex a2 s)

sosAexp (Redex (Mult a1 a2) s)        | isValue nextA1 = Redex (Mult (N vA1) a2) s
                                      | otherwise = Redex (Mult (vA1') (a2)) s
          where
               nextA1 = sosAexp (Redex a1 s)
               Value vA1 = sosAexp (Redex a1 s)
               Redex vA1' s' = sosAexp (Redex a1 s)

-- a1 - a2

sosAexp (Redex (Sub (N n1) (N n2)) s) = Value (n1 - n2)

sosAexp (Redex (Sub (N n) a2) s)      | isValue next = Value (n - n')
                                      | otherwise = Redex (Sub (N n) a2') s
     where
          next = sosAexp (Redex a2 s)
          Value n' = sosAexp (Redex a2 s)
          Redex a2' s' = sosAexp (Redex a2 s)

sosAexp (Redex (Sub a1 a2) s)         | isValue nextA1 = Redex (Sub (N vA1) a2) s
                                      | otherwise = Redex (Sub (vA1') (a2)) s
          where
               nextA1 = sosAexp (Redex a1 s)
               Value vA1 = sosAexp (Redex a1 s)
               Redex vA1' s' = sosAexp (Redex a1 s)

-- |----------------------------------------------------------------------
-- | Exercise 4.2
-- |----------------------------------------------------------------------

-- | Given the type synonym 'AexpDerivSeq' to represent derivation sequences
-- | of the structural operational semantics for arithmetic expressions 'Aexp':

type AexpDerivSeq = [AexpConfig]

-- | Define a function 'aExpDerivSeq' that given a 'Aexp' expression 'a' and an
-- | initial state 's' returns the corresponding derivation sequence:

aExpDerivSeq :: Aexp -> State -> AexpDerivSeq
aExpDerivSeq a ini  | isValue next = (Redex a ini) : next : []
                    | otherwise    = (Redex a ini) : aExpDerivSeq a' ini
     where
          next = sosAexp (Redex a ini)
          Redex a' ini' = sosAexp (Redex a ini)

-- | To test your code, you can use the function 'showAexpDerivSeq' that
-- | returns a String representation  of a derivation sequence 'dseq':

showAexpDerivSeq :: [Var] -> AexpDerivSeq -> String
showAexpDerivSeq vars dseq = unlines (map showConfig dseq)
  where
    showConfig (Value n) = "Final value:\n" ++ show n
    showConfig (Redex ss s) = show ss ++ "\n" ++ unlines (map (showVal s) vars)
    showVal s x = " s(" ++ x ++ ")= " ++ show (s x)

-- | Therefore, you can print the derivation sequence of an 'Aexp' with:

exp1 :: Aexp
exp1 = ( (V "x") `Add` (V "y") ) `Add` (V "z")

exp2 :: Aexp
exp2 =  (V "x") `Add` ( (V "y") `Add` (V "z") )

exp3 :: Aexp
exp3 = Mult (V "x") (Add (V "y") (Sub (V "z") (N 1)))

sExp :: State
sExp "x" = 1
sExp "y" = 2
sExp "z" = 3
sExp  _  = 0

showAexpSeq :: Aexp -> State -> IO()
showAexpSeq a s = putStrLn $ showAexpDerivSeq ["x", "y", "z"] (aExpDerivSeq a s)

-- | Test you code printing derivation sequences for the expressions above as follows:

showExp1 :: IO ()
showExp1 = showAexpSeq exp1 sExp

-- | For the example above, you should get an output identical to 'derivSeqForExp1.txt'

-- |----------------------------------------------------------------------
-- | Exercise 5 (Optional, not recommended)
-- |----------------------------------------------------------------------

-- | Implement in Haskell the Structural Operational Semantics for the
-- | parallel evaluation of arithmetic expressions 'Aexp'.

{-
   Structural Operational Semantics for the parallel evaluation of arithmetic
   expressions:

   [N]  ----------------
         < n, s > => n

   [V] ------------------------
        < x, s > => < s x, s >

   [+] -----------------------------  where n3 = n1 + n2
        < n1 + n2, s > => < n3, s >

            < a1, s > => < a1', s >
   [+] -----------------------------------
        < a1 + a2, s > => < a1' + a2, s >

            < a2, s > => < a2', s >
   [+] ----------------------------------
        < a1 + a2, s > => <a1 + a2', s >

   The rules for * and - are similar.

-}

-- | Define a function 'sosAexp'' that given a configuration 'AexpConfig'
-- | evaluates the expression in 'AexpConfig' one step and returns a list
-- | with the next configurations.
-- | Note that given an arithmetic expression, a parallel evaluation strategy
-- | can lead to more than one configuration. For example, the following
-- | arithmetic expression 'example':

example :: [AexpConfig]
example = sosAexp' (Redex (Add (Add (Add (N 1) (N 2)) (Add (N 3) (N 4))) (Add (Add (N 5) (N 6)) (Add (N 7) (N 8)))) sInit)

-- | can lead to 4 next configurations:

{-
*Exercises03> showConfigs example
["Add (Add (N 3) (Add (N 3) (N 4))) (Add (Add (N 5) (N 6)) (Add (N 7) (N 8)))",
 "Add (Add (Add (N 1) (N 2)) (N 7)) (Add (Add (N 5) (N 6)) (Add (N 7) (N 8)))",
 "Add (Add (Add (N 1) (N 2)) (Add (N 3) (N 4))) (Add (N 11) (Add (N 7) (N 8)))",
 "Add (Add (Add (N 1) (N 2)) (Add (N 3) (N 4))) (Add (Add (N 5) (N 6)) (N 15))"]
-}

showConfigs :: [AexpConfig] -> [String]
showConfigs = map showConfig
   where
     showConfig (Redex a _) = show a
     showConfig (Value n)   = show n


sosAexp' :: AexpConfig -> [AexpConfig]

-- n
sosAexp' (Redex (N n) _)               = undefined

-- x
sosAexp' (Redex (V x) s)               = undefined

-- a1 + a2
sosAexp' (Redex (Add (N n1) (N n2)) s) = undefined

sosAexp' (Redex (Add a1 a2) s)         = undefined

-- a1 * a2

-- todo

-- a1 - a2

-- todo
