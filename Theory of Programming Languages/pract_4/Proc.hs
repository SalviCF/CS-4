----------------------------------------------------------------------
--
-- Proc.hs
-- Programming Languages
-- Fall 2018
--
-- An implementation of Proc
-- [Nielson and Nielson, Semantics with Applications]
--
-- Author: Pablo López
--- -------------------------------------------------------------------

-- -------------------------------------------------------------------
-- Abstract syntax
-- -------------------------------------------------------------------

module Proc  where

type  Var   =  String
type  Pname =  String

data  Aexp  =  N Integer
            |  V Var
            |  Add Aexp Aexp
            |  Mult Aexp Aexp
            |  Sub Aexp Aexp
            deriving (Show, Eq)

data  Bexp  =  TRUE
            |  FALSE
            |  Eq Aexp Aexp
            |  Le Aexp Aexp
            |  Neg Bexp
            |  And Bexp Bexp
            deriving (Show, Eq)

data DecVar = Dec Var Aexp DecVar
            | EndDec
            deriving Show

data DecProc = Proc Pname Stm DecProc
             | EndProc
             deriving Show

data  Stm   =  Ass Var Aexp
            |  Skip
            |  Comp Stm Stm
            |  If Bexp Stm Stm
            |  While Bexp Stm
            |  Block DecVar DecProc Stm
            |  Call Pname
            deriving Show

-- Example B.1

factorial :: Stm
factorial = Block (Dec "x" (N 5)
                  (Dec "y" (N 1)
                   EndDec))

                  EndProc

                  (While (Neg (Eq (V "x") (N 1)))
                              (Comp (Ass "y" (Mult (V "y") (V "x")))
                              (Ass "x" (Sub (V "x") (N 1)))))

-- End Example B.1

---------------------------------------------------------------------
-- Evaluation of expressions
---------------------------------------------------------------------

type Z = Integer
type T = Bool
type State = Var -> Z

-- Example B.3

sInit :: State
sInit "x" =  3
sInit _   =  0

-- End Example B.3

aVal :: Aexp -> State -> Z
aVal (N n) _        =  n
aVal (V x) s        =  s x
aVal (Add a1 a2) s  =  aVal a1 s + aVal a2 s
aVal (Mult a1 a2) s =  aVal a1 s * aVal a2 s
aVal (Sub a1 a2) s  =  aVal a1 s - aVal a2 s

bVal :: Bexp -> State -> T
bVal TRUE _        =  True
bVal FALSE _       =  False
bVal (Eq a1 a2) s  =  aVal a1 s == aVal a2 s  -- equivalent but smaller
bVal (Le a1 a2) s  =  aVal a1 s <= aVal a2 s  -- equivalent but smaller
bVal (Neg b) s     =  not(bVal b s)           -- equivalent but smaller
bVal (And b1 b2) s =  bVal b1 s && bVal b2 s  -- equivalent but smaller
