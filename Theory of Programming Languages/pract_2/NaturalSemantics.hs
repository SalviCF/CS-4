{-|

Programming Languages
Fall 2018

Implementation in Haskell of the Natural Semantics described in Chapter 2 of
Nielson & Nielson, Semantics with Applications

Author:

-}

module NaturalSemantics where

import           While
import           Exercises01 (Update (..), fvAexp, fvBexp, update)

-- representation of configurations for While

data Config = Inter Stm State  -- <S, s>
            | Final State      -- s

-- representation of the transition relation <S, s> -> s'

nsStm :: Config -> Config

-- x := a

nsStm (Inter (Ass x a) s)      = Final s'
  where s' = update s (x :=>: aVal a s)

-- skip

nsStm (Inter Skip s)           = Final s

-- s1; s2

nsStm (Inter (Comp ss1 ss2) s) = Final s''
  where
    s'  = sNs ss1 s
    s'' = sNs ss2 s'

{- Alternative implementation
nsStm (Inter (Comp ss1 ss2) s) = s''
  where
    Final s'  = nsStm (Inter ss1 s)
    s'' = nsStm (Inter ss2 s')
-}

-- if b then s1 else s2

-- B[b]s = tt
nsStm (Inter (If b ss1 ss2) s)  | bVal b s = Final s'
  where s' = sNs ss1 s

-- B[b]s = ff
nsStm (Inter (If b ss1 ss2) s)  | not $ bVal b s = Final s'
  where s' = sNs ss2 s

-- while b do s

-- B[b]s = ff
nsStm (Inter (While b ss) s)  | not $ bVal b s = Final s

-- B[b]s = tt
nsStm (Inter (While b ss) s)  | bVal b s = Final s''
  where
    s'  = sNs ss s
    s'' = sNs (While b ss) s'

-- repeat S until b

-- B[b]s = ff
nsStm (Inter (Repeat ss b) s)  | not $ bVal b s' = Final s''
  where
    s'  = sNs ss s
    s'' = sNs (Repeat ss b) s'

-- B[b]s = tt
nsStm (Inter (Repeat ss b) s)  | bVal b s' = Final s'
  where
    s'  = sNs ss s

-- for x:= a1 to a2 do S

-- B[x <= a2]s' = ff

nsStm (Inter (For x a1 a2 stm) s)  | not $ bVal (Le (V x) a2) s' = Final s'
  where
    s'  = sNs (Ass x a1) s

-- B[x <= a2]s' = tt
nsStm (Inter (For x a1 a2 stm) s) | bVal (Le (V x) a2) s' = Final s'''
  where
    s'    = sNs (Ass x a1) s
    s''   = sNs stm s'
    inc   = (aVal (V x) s'') + 1
    s'''  = sNs (For x (N inc) a2 stm) s''

-- semantic function for natural semantics
sNs :: Stm -> State -> State
sNs ss s = s'
  where Final s' = nsStm (Inter ss s)

-- Example C.1
sFac :: State
sFac = sNs factorial sInit
-- End Example C.1
