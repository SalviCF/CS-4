{-| Programming Languages
    Fall 2018

    A Simple Propositional Logic Language

    Parcial de noviembre de 2018

    Apellidos, Nombre: Carrillo Fuentes, Salvador
-}

module PropLog where
import Data.List

-- | El lenguaje PropLog de sentencias de la lógica proposicional se define por la
-- | siguiente sintaxis abstracta:
-- |
-- |          p ::= a | p1 and p2 | p1 or p2 | not p
-- |
-- | donde:
-- |
-- |   'a' es una variable que representa alguna proposición  atómica
-- |   'p1 and p2' representa la conjunción de dos proposiciones
-- |   'p1 or p2' representa la disyunción de dos proposiciones
-- |   'not p' representa la negación de una proposición

-- | La sintaxis abstracta de PropLog se representa por el siguiente tipo Haskell:

type Atom = String

data PropLog = ATOM Atom
             | AND PropLog PropLog
             | OR PropLog PropLog
             | NOT PropLog
             deriving Show

-- | La semántica de una proposición de PropLog depende de una "interpretación";
-- | es decir, del valor de las proposiciones atómicas que aparezcan en la proposición.
-- | Representaremos una interpretación por el siguiente tipo Haskell:

type B = Bool
type Interpretation = Atom -> B

-- | El siguiente es un ejemplo de interpretación. Asumiremos que las interpretaciones son
-- | siempre funciones totales:

interpInit :: Interpretation
interpInit "p" = True
interpInit "q" = False
interpInit "r" = True
interpInit _   = False

-- | -------------------------------------------------------------------------------------
-- | Ejercicio 1.
-- | -------------------------------------------------------------------------------------
-- | Declara y define una función 'atomsOf' que dada una proposición de 'PropLog' devuelva
-- | una lista sin repeticiones con los átomos que aparecen en la proposición.

-- |
-- >>> atomsOf (ATOM "p")
-- ["p"]
--
-- >>> atomsOf (NOT (AND (ATOM "p") (OR (ATOM "q") (ATOM "p"))))
-- ["p","q"]

atomsOf :: PropLog -> [Atom]
atomsOf (ATOM a) = [a]
atomsOf (AND p1 p2) = nub $ atomsOf p1 ++ atomsOf p2
atomsOf (OR p1 p2) = nub $ atomsOf p1 ++ atomsOf p2
atomsOf (NOT p) = nub $ atomsOf p

-- | -------------------------------------------------------------------------------------
-- | Ejercicio 2.
-- | -------------------------------------------------------------------------------------
-- | Declara y define una función de plegado 'foldPropLog' para el tipo 'PropLog'.

{-
1. Identifico constructores: ATOM, AND, OR, NOT

2. Traduzco el tipo recursivo PropLog por el tipo resultado a
   ATOM :: Atom -> PropLog __________________ at :: Atom -> a
   AND :: PropLog -> PropLog-> PropLog ______ an :: a -> a-> a
   OR :: PropLog -> PropLog-> PropLog _______ o :: a -> a-> a
   NOT :: PropLog -> PropLog ________________ n :: a-> a

-}

foldPropLog :: (Atom -> a) -> (a -> a-> a) -> (a -> a-> a) -> (a-> a) -> PropLog -> a
foldPropLog at an o n (ATOM atom) = at atom
foldPropLog at an o n (AND p1 p2) = an (foldPropLog at an o n p1) (foldPropLog at an o n p2)
foldPropLog at an o n (OR p1 p2) = o (foldPropLog at an o n p1) (foldPropLog at an o n p2)
foldPropLog at an o n (NOT p) = n (foldPropLog at an o n p)

-- | -------------------------------------------------------------------------------------
-- | Ejercicio 3.
-- | -------------------------------------------------------------------------------------
-- | Usando la función de plegado 'foldPropLog', declara y define una función 'eval' que
-- | dadas una proposición de `PropLog`y una interpretación  devuelva el valor de la proposición
-- | para esa interpretación.

-- |
-- >>> eval (AND (OR (ATOM ("q")) (ATOM "p")) (NOT (ATOM "w"))) interpInit
-- True
--
-- >>> eval (AND (OR (ATOM ("q")) (ATOM "p")) (NOT (ATOM "p"))) interpInit
-- False

eval :: PropLog -> Interpretation -> B
eval p i = foldPropLog (i) (&&) (||) (not) p

-- end
