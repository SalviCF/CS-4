----------------------------------------------------------------------
--
-- ProcNaturalSemantics.hs
-- Programming Languages
-- Fall 2018
--
-- Natural Semantics for Proc
-- [Nielson and Nielson, semantics with applications]
--
-- Author: 
----------------------------------------------------------------------

module ProcNaturalSemantics where

import Proc

----------------------------------------------------------------------
-- Variable Declarations
----------------------------------------------------------------------

-- locations

type Loc = Integer

new :: Loc -> Loc
new l = l + 1

-- variable environment

type EnvVar = Var -> Loc

-- store

-- 'sto [next]' refers to the first available cell in the store 'sto'
next :: Loc
next = 0

type Store = Loc -> Z

-- | Exercise 1.1

-- update a variable environment with a new binding envV [x -> l]
updateV :: EnvVar -> Var -> Loc -> EnvVar
updateV envV x l = newEnv
  where
    newEnv x'  | (x' == x)  = l
               | otherwise = envV x'

-- update a store with a new binding sto [l -> v]
updateS :: Store -> Loc -> Z -> Store
updateS sto l v = newSto
  where
    newSto l' | (l == l') = v
              | otherwise = sto l'

-- variable declaration configurations

data ConfigD = InterD DecVar EnvVar Store  -- <Dv, envV, store>
             | FinalD EnvVar Store         -- <envV, store>

nsDecV :: ConfigD -> ConfigD

-- | Exercise 1.2

-- var x := a
nsDecV (InterD (Dec x a decs) envV store) = nsDecV (InterD decs envV' store')
  where
    envV' = updateV envV x l
    store' = updateS (updateS store l v) next (new l)
    l = store next
    v = aVal a (store . envV)

-- epsilon
nsDecV (InterD EndDec envV store)         = FinalD envV store

----------------------------------------------------------------------
-- Procedure Declarations
----------------------------------------------------------------------

-- procedure environment

--                    p    s    snapshots    previous
--                    |    |     /    \         |
data EnvProc = EnvP Pname Stm EnvVar EnvProc EnvProc
             | EmptyEnvProc

-- | Exercise 2.1

-- update the procedure environment
updP :: DecProc -> EnvVar -> EnvProc -> EnvProc
updP (Proc p s procs) envV envP = updP procs envV envP'
  where
    envP' = EnvP p s envV envP envP

updP EndProc envV envP          = envP

-- | Exercise 2.2

-- lookup procedure p
envProc :: EnvProc -> Pname -> (Stm, EnvVar, EnvProc)
envProc (EnvP q s envV envP envs) p | (p == q) = (s, envV, envP)
                                    | otherwise = envProc envs p
envProc EmptyEnvProc p              = error "envProc: undefined procedure p"

-- representation of configurations for Proc

data Config = Inter Stm Store  -- <S, sto>
            | Final Store      -- sto

-- representation of the transition relation <S, sto> -> stos'

nsStm :: EnvVar -> EnvProc -> Config -> Config

-- | Exercise 3.1

-- x := a

nsStm envV envP (Inter (Ass x a) sto)            = Final (updateS sto l v)
  where
    l = envV x
    v = aVal a (sto . envV)

-- skip

nsStm envV envP (Inter Skip sto)                 = Final sto


-- s1; s2

nsStm envV envP (Inter (Comp ss1 ss2) sto)       = sto''
  where
    Final sto'  = nsStm envV envP (Inter ss1 sto)
    sto'' = nsStm envV envP (Inter ss2 sto')

-- if b then s1 else s2

nsStm envV envP (Inter (If b s1 s2) sto)         = sto'
  where
    sto'  | bVal b (sto . envV) = nsStm envV envP (Inter s1 sto)
          | otherwise = nsStm envV envP (Inter s2 sto)

-- while b do s

nsStm envV envP (Inter (While b s) sto)          = sto''
  where
    Final sto' = nsStm envV envP (Inter s sto)
    sto'' | bVal b (sto . envV) = nsStm envV envP (Inter (While b s) sto')
          | otherwise = Final sto

-- block vars procs s

nsStm envV envP (Inter (Block vars procs s) sto) = sto''
  where
    FinalD envV' sto' = nsDecV $ InterD vars envV sto
    sto'' = nsStm envV' envP' (Inter s sto')
    envP' = updP procs envV' envP

-- non-recursive procedure call
{-
nsStm envV envP (Inter (Call p) sto) = sto'
  where
    (s, envV', envP') = envProc envP p
    sto' = nsStm envV' envP' (Inter s sto)
-}

-- recursive procedure call
nsStm envV envP (Inter (Call p) sto)             = sto'
  where
    (s, envV', envP') = envProc envP p
    sto' = nsStm envV' upEnvP' (Inter s sto)
    upEnvP' = updP (Proc p s EndProc) envV' envP'

-- | Exercise 3.2

emptyEnvV :: EnvVar
emptyEnvV x = error $ "undefined variable " ++ x

sNs :: Stm -> Store -> Store
sNs s sto = sto'
  where
    Final sto' = nsStm emptyEnvV EmptyEnvProc (Inter s sto)
