module Repaso where

import           Data.Char
import           Data.Maybe

-- 1. Orden superior
----------------------------------------------------------------

-- |
-- >>> twice (+1) 5
-- 7
--
-- >>> twice (*2) 3
-- 12

twice :: (a -> a) -> a -> a
twice f x = f(f x)

-- |
-- >>> mapTuple (+1) (*2) (3, 4)
-- (4,8)
--
-- >>> mapTuple ord (==5) ('A', 3 + 1)
-- (65,False)

mapTuple :: (a->c) -> (b->d) -> (a,b) -> (c,d)
mapTuple f g (x,y) = (f x, g y)

-- map, filter
-- lambda expresiones
-- secciones

-- |
-- >>> aprobadoGeneral [1..10]
-- [5.0,5.0,5.0,5.0,5.0,6.0,7.0,8.0,9.0,10.0]
--
-- >>> aprobadoGeneral [4.7, 2.5, 7, 10, 8.7]
-- [5.0,5.0,7.0,10.0,8.7]

aprobadoGeneral :: [Double] -> [Double]
aprobadoGeneral xs = map (\x -> max x 5) xs

-- 2. Plegado de listas
----------------------------------------------------------------

-- revisión de la recursión sobre listas

-- |
-- >>> suma [1..10]
-- 55
--
-- >>> suma [7]
-- 7
--
-- >>> suma []
-- 0

suma :: Num a => [a] -> a
suma []     = 0
suma (x:xs) = (+) x (suma xs)

-- |
-- >>> longitud "hola mundo"
-- 10
--
-- >>> longitud [True]
-- 1
--
-- >>> longitud []
-- 0

longitud :: [a] -> Integer
longitud []     = 0
longitud (x:xs) = f x (longitud xs)
  where
    f y ys = 1 + ys

{-
Ejemplo de ejecución:

longitud "hola" =>
f 'h' (longitud "ola") =>
1 + (longitud "ola") =>
1 + (f 'o' (longitud "la")) =>
1 + (1 + (longitud "la")) =>
1 + (1 + (f 'l' (longitud 'a'))) =>
1 + (1 + (1 + (longitud 'a'))) =>
1 + (1 + (1 + (f 'a' (longitud [])))) =>
1 + (1 + (1 + (1 + 0))) =>
4
-}

-- |
-- >>> conjunción [1 == 1, 'a' < 'b', null []]
-- True
--
-- >>> conjunción [1 == 1, 'a' < 'b', null [[]]]
-- False
--
-- >>> conjunción []
-- True

conjunción :: [Bool] -> Bool
--conjunción xs = foldr (&&) True xs
conjunción [] = True
conjunción (x:xs) = (&&) x (conjunción xs)

-- |
-- >>> esPalabra "haskell"
-- True
--
-- >>> esPalabra "haskell 2017"
-- False
--
-- >>> esPalabra "h"
-- True
--
-- >>> esPalabra ""
-- True

esPalabra :: String -> Bool
esPalabra [] = True
esPalabra (x:xs) = f x (esPalabra xs)
  where
    f y ys = (&&) (isLetter y) ys

{-
Ejemplo ejecución

esPalabra "hola" =>
f 'h' (esPalabra "ola") =>
(&&) (isLetter 'h') (esPalabra "ola") =>
(True) && (f 'o' ("la")) =>
(True) && ((isLetter 'o') && (esPalabra "la")) =>
(True) && ((True) && (f 'l' (esPalabra 'a'))) =>
(True) && ((True) && ((isLetter 'l') && (esPalabra 'a'))) =>
(True) && ((True) && ((True) && (f 'a' (esPalabra [])))) =>
(True) && ((True) && ((True) && ((isLetter a) && (True)))) =>
(True) && ((True) && ((True) && ((True) && (True)))) =>
True
-}
-- |
-- >>> todasMayúsculas "WHILE"
-- True
--
-- >>> todasMayúsculas "While"
-- False
--
-- >>> todasMayúsculas ""
-- True

todasMayúsculas :: String -> Bool
todasMayúsculas [] = True
todasMayúsculas (x:xs) = f x (todasMayúsculas xs)
  where
    f y ys = (&&) (isUpper x) (ys)

-- |
-- >>> máximo "hola mundo"
-- 'u'
--
-- >>> máximo [7, -8, 56, 17, 34, 12]
-- 56
--
-- >>> máximo [-8]
-- -8

máximo :: Ord a => [a] -> a
máximo [x] = x
máximo (x:xs) = f x (máximo xs)
  where
    f y ys = (max) y (máximo xs)

-- |
-- >>> mínimoYmáximo "hola mundo"
-- (' ','u')
--
-- >>> mínimoYmáximo [7, -8, 56, 17, 34, 12]
-- (-8,56)
--
-- >>> mínimoYmáximo [1]
-- (1,1)

mínimoYmáximo :: Ord a => [a] -> (a,a)
mínimoYmáximo (x:xs) = foldr f (x,x) xs
  where
    f e (mini,maxi) | (e < mini) = (e,maxi)
                    | (e > maxi) = (mini,e)
                    | otherwise = (mini,maxi)

-- |
-- >>> aplana [[1,2], [3,4,5], [], [6]]
-- [1,2,3,4,5,6]
--
-- >>> aplana [[1,2]]
-- [1,2]
--
-- >>> aplana []
-- []

aplana :: [[a]] -> [a]
aplana [] = []
aplana (x:xs) = (++) x (aplana xs)

-- deducir el patrón de foldr
-- http://hackage.haskell.org/package/base-4.12.0.0/docs/Prelude.html#v:foldr
{-
-- if the list is empty, the result is the initial value z; else
-- apply f to the first element and the result of folding the rest

foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f z []     = z
foldr f z (x:xs) = f x (foldr f z xs)

-}
--                f         base
recLista :: (a -> b -> b) -> b -> [a] -> b
recLista f base [] = base
recLista f base (x:xs) = f x (recLista f base xs)

{-
Ejemplo de ejecución:

foldr (+) 0 [1,2,3] =>
(+) 1 (foldr (+) 0 [2,3]) =>
(+) 1 ((+) 2 (foldr (+) 0 [3])) =>
(+) 1 ((+) 2 ((+) 3 (foldr (+) 0 []))) =>
(+) 1 ((+) 2 ((+) 3 (0))) =>
(+) 1 ((+) 2 (3)) =>
(+) 1 (5) =>
6
-}

-- resolver las anteriores funciones con foldr

-- |
-- >>> sumaR [1..10]
-- 55
--
-- >>> sumaR [7]
-- 7
--
-- >>> sumaR []
-- 0

sumaR :: Num a => [a] -> a
sumaR xs = foldr (+) 0 xs

-- |
-- >>> longitudR "hola mundo"
-- 10
--
-- >>> longitudR [True]
-- 1
--
-- >>> longitudR []
-- 0

longitudR :: [a] -> Integer
longitudR xs = foldr f 0 xs
  where
    f _ sol = 1 + sol

-- |
-- >>> conjunciónR [1 == 1, 'a' < 'b', null []]
-- True
--
-- >>> conjunciónR [1 == 1, 'a' < 'b', null [[]]]
-- False
--
-- >>> conjunciónR []
-- True

conjunciónR :: [Bool] -> Bool
conjunciónR = foldr (&&) True

-- |
-- >>> esPalabraR "haskell"
-- True
--
-- >>> esPalabraR "haskell 2017"
-- False
--
-- >>> esPalabraR "h"
-- True
--
-- >>> esPalabraR ""
-- True

esPalabraR :: String -> Bool
esPalabraR = foldr f True
  where
    f e sol = (&&) (isLetter e) sol

{-
Otra forma con función lambda

esPalabraR :: String -> Bool
esPalabraR = foldr (\ cabeza solCola -> isLetter cabeza && solCola) True
-}

-- |
-- >>> todasMayúsculasR "WHILE"
-- True
--
-- >>> todasMayúsculasR "While"
-- False
--
-- >>> todasMayúsculasR ""
-- True

todasMayúsculasR :: String -> Bool
todasMayúsculasR xs = foldr f True xs
  where
    f e sol = (&&) (isUpper e) sol

-- |
-- >>> máximoR "hola mundo"
-- 'u'
--
-- >>> máximoR [7, -8, 56, 17, 34, 12]
-- 56
--
-- >>> máximoR [-8]
-- -8

-- Maybe y fromMaybe
máximoR :: Ord a => [a] -> a
máximoR (x:xs) = foldr f x xs
  where
    f e sol = max e sol

-- |
-- >>> mínimoYmáximoR "hola mundo"
-- (' ','u')
--
-- >>> mínimoYmáximoR [7, -8, 56, 17, 34, 12]
-- (-8,56)
--
-- >>> mínimoYmáximoR [1]
-- (1,1)

mínimoYmáximoR :: Ord a => [a] -> (a,a)
mínimoYmáximoR (x:xs) = foldr f (x,x) xs
  where
    f e (mini,maxi) | (e < mini) = (e,maxi)
                    | (e > maxi) = (mini,e)
                    | otherwise = (mini,maxi)

-- |
-- >>> aplanaR [[1,2], [3,4,5], [], [6]]
-- [1,2,3,4,5,6]
--
-- >>> aplanaR [[1,2]]
-- [1,2]
--
-- >>> aplanaR []
-- []

aplanaR :: [[a]] -> [a]
aplanaR = foldr (++) []

-- otros ejercicios de foldr

-- |
-- >>> mapR (2^) [0..10]
-- [1,2,4,8,16,32,64,128,256,512,1024]
--
-- >>> mapR undefined []
-- []
--
-- >>> mapR ord  "A"
-- [65]

mapR :: (a -> b) -> [a] -> [b]
mapR f xs = foldr g [] xs
  where
    g e sol = (f e) : sol

-- |
-- >>> filter even [1..20]
-- [2,4,6,8,10,12,14,16,18,20]
--
-- >>> filter undefined []
-- []
--
-- >>> filter even [5]
-- []

filterR :: (a -> Bool) -> [a] -> [a]
filterR p = foldr f []
  where
    f e sol = if (p e) then e:sol else sol

-- |
-- >>> apariciones 'a' "casa"
-- 2
-- >>> apariciones 'u' "casa"
-- 0

apariciones :: Eq a => a -> [a] -> Integer
apariciones x xs = foldr f 0 xs
  where
    f e sol = if (e == x) then sol +1 else sol

-- |
-- >>> purgar "abracadabra"
-- "cdbra"
--
-- >>> purgar [1,2,3]
-- [1,2,3]
--
-- >>> purgar "aaaaaaaaaa"
-- "a"

purgar :: Eq a => [a] -> [a]
purgar xs = foldr f [] xs
  where
    f e sol = if (elem e sol) then sol else e:sol

-- |
-- >>> agrupa "mississippi"
-- ["m","i","ss","i","ss","i","pp","i"]
--
-- >>> agrupa [1,2,2,3,3,3,4,4,4,4]
-- [[1],[2,2],[3,3,3],[4,4,4,4]]
--
-- >>> agrupa []
-- []

agrupa :: Eq a => [a] -> [[a]]
agrupa xs = foldr f [[last xs]] (init xs)
  where
    f e (s:ss) = if (elem e s) then ((e:s):ss) else [e]:(s:ss)
-- 3. Plegado de tipos algebraicos recursivos
----------------------------------------------------------------

data Tree a = Empty
            | Leaf a
            | Node a (Tree a) (Tree a)
            deriving Show

{-
Empty :: Tree a ___________________ e :: b
Leaf :: a -> Tree a _______________ l :: a -> b
Node :: a -> Tree a _______________ n :: a(raíz) -> b(solución izq) -> b(sol dere) -> b
          -> Tree a
          -> Tree a

Busco convertir los Tree a -> b (tipo de la solución) (es lo que hace el plegado)
-}

treeI :: Tree Integer
treeI = Node 1
             (Node 2 (Leaf 4) (Leaf 5))
             (Node 3 Empty (Leaf 6))

treeC :: Tree Char
treeC = Node 'z'
          (Node 't' (Node 's' Empty (Leaf 'a')) (Leaf 'g'))
          (Node 'w' (Leaf 'h') (Node 'p' (Leaf 'f') (Leaf 'n')))

-- |
-- >>> treeSize treeI
-- 6
--
-- >>> treeSize treeC
-- 10

treeSize :: Tree a -> Integer
treeSize Empty = 0
treeSize (Leaf h) = 1
treeSize (Node n l r) = 1 + treeSize l + treeSize r

-- |
-- >>> treeHeight treeI
-- 3
-- >>> treeHeight treeC
-- 4

treeHeight :: Tree a -> Integer
treeHeight Empty = 0
treeHeight (Leaf h) = (const 1) h
treeHeight (Node n l r) = 1 + max (treeHeight l) (treeHeight r)

-- |
-- >>> treeSum treeI
-- 21

treeSum :: Num a => Tree a -> a
treeSum Empty = 0
treeSum (Leaf h) = id h
treeSum (Node n l r) = f n (treeSum l) (treeSum r)
  where
    f x ls rs = n + ls + rs

{-
Ejemplo de ejecución:

treeSum Node 1 (Node 2 (Leaf 4) (Leaf 5)) (Node 3 Empty (Leaf 6)) =>
f 1 (treeSum Node 2 (Leaf 4) (Leaf 5)) (treeSum Node 3 Empty (Leaf 6)) =>
1 + (f 2 (treeSum (Leaf 4)) (treeSum (Leaf 5))) (f 3 (treeSum Empty) (treeSum (Leaf 6))) =>
1 + (2 + 4 + 5) + (3 + 0 + 6) =>
21
-}

-- |
-- >>> treeProduct treeI
-- 720

treeProduct :: Num a => Tree a -> a
treeProduct Empty = 1
treeProduct (Leaf h) = id h
treeProduct (Node x l r) = f x (treeProduct l) (treeProduct r)
  where
    f n ls rs = n * ls * rs

-- |
-- >>> treeElem 5 treeI
-- True
--
-- >>> treeElem 48 treeI
-- False
--
-- >> treeElem 'w' treeC
-- True
--
-- >>> treeElem '*' treeC
-- False

treeElem :: Eq a => a -> Tree a -> Bool
treeElem x Empty = False
treeElem x (Leaf y) = (x ==) y
treeElem x (Node n l r) = f n (treeElem x l) (treeElem x r)
  where
    f e ls rs = (e == x) || ls || rs

-- |
-- >>> treeToList treeI
-- [4,2,5,1,3,6]
--
-- >>> treeToList treeC
-- "satgzhwfpn"

treeToList :: Tree a -> [a]
treeToList Empty = []
treeToList (Leaf h) = [h]
treeToList (Node n l r) = treeToList l ++ [n] ++ treeToList r

-- |
-- >>> treeBorder treeI
-- [4,5,6]
--
-- >>> treeBorder treeC
-- "aghfn"

treeBorder :: Tree a -> [a]
treeBorder Empty = []
treeBorder (Leaf h) = (:[]) h
treeBorder (Node n l r) = treeBorder l ++ treeBorder r

-- introducir el plegado del tipo Tree a

{-
Empty :: Tree a ___________________ e :: b
Leaf :: a -> Tree a _______________ l :: a -> b
Node :: a -> Tree a _______________ n :: a(raíz) -> b(solución izq) -> b(sol dere) -> b
          -> Tree a
          -> Tree a

Busco convertir los Tree a -> b (tipo de la solución) (es lo que hace el plegado)
-}

-- Traduzco los constructores de datos en función
--               n(ode)           l(eaf)   e(mpty)
foldTree :: (a -> b -> b -> b) -> (a -> b) -> b -> Tree a -> b
foldTree n l e Empty        = e
foldTree n l e (Leaf h)     = l h
foldTree n l e (Node x i d) = n x (foldTree n l e i) (foldTree n l e d)

-- resolver los ejercicios anteriores con foldTree

-- |
-- >>> treeSize' treeI
-- 6
--
-- >>> treeSize' treeC
-- 10

treeSize' :: Tree a -> Integer
treeSize' tree = foldTree n (const 1) 0 tree
  where
    n _ sl rl = 1 + sl + rl

{-
Ejemplo de ejecución:

treeSize' Node 1 (Node 2 (Leaf 4) (Leaf 5)) (Node 3 Empty (Leaf 6)) =>
foldTree n (const 1) 0 tree =>
n 1 (foldTree n (const 1) 0 hi) (foldTree n (const 1) hd) =>
n 1 (n 2 (foldTree n (const 1) 0 hi) (foldTree n (const 1) 0 hd)) (n 3 (foldTree n (const 1) hi) (foldTree n (const 1) hd)) =>
n 1 (n 2 (1) (1)) (n 3 (0) (1)) =>
n 1 (1 + 1 + 1) (1 + 0 + 1) =>
1 + 3 + 2 =>
6
-}

-- |
-- >>> treeHeight' treeI
-- 3
-- >>> treeHeight' treeC
-- 4

treeHeight' :: Tree a -> Integer
treeHeight' tree = foldTree n (const 1) 0 tree
  where
    n e si sd = 1 + max si sd

-- |
-- >>> treeSum' treeI
-- 21

treeSum' :: Num a => Tree a -> a
treeSum' = foldTree n id 0
  where
    n e si sd = e + si + sd

-- |
-- >>> treeProduct' treeI
-- 720

treeProduct' :: Num a => Tree a -> a
treeProduct' = foldTree n id 1
  where
    n e si sd = e * si * sd

-- |
-- >>> treeElem' 5 treeI
-- True
--
-- >>> treeElem' 48 treeI
-- False
--
-- >> treeElem' 'w' treeC
-- True
--
-- >>> treeElem' '*' treeC
-- False

treeElem' :: Eq a => a -> Tree a -> Bool
treeElem' x t = foldTree f (x==) False t
  where
    f n sl sr = (n==x) || sl || sr

-- |
-- >>> treeToList' treeI
-- [4,2,5,1,3,6]
--
-- >>> treeToList' treeC
-- "satgzhwfpn"

treeToList' :: Tree a -> [a]
treeToList' = foldTree n (:[]) []
  where
    n e si sr = si ++ (e : sr)

-- |
-- >>> treeBorder' treeI
-- [4,5,6]
--
-- >>> treeBorder' treeC
-- "aghfn"

-- (const (++) 65) [1,2]  [3,4]

treeBorder' :: Tree a -> [a]
treeBorder' t = foldTree (const (++)) (:[]) [] t

--
{-
*Repaso> treeMaximum treeI
Just 6

*Repaso> treeMaximum Empty
Nothing

-}
-- Maybe
treeMaximum :: Ord a => Tree a -> Maybe a
treeMaximum t = foldTree n Just Nothing t -- (\h -> Just h)
  where
    n x sl rl = Just (x `max` fromMaybe x sl `max` fromMaybe x rl)

{-
Ejemplo de ejecución:

treeMaximum Node 1 (Node 2 (Leaf 4) (Leaf 5)) (Node 3 Empty (Leaf 6)) =>
foldTree n Just Nothing Node 1 (Node 2 (Leaf 4) (Leaf 5)) (Node 3 Empty (Leaf 6)) =>
n 1 (foldTree n Just Nothing hi) (foldTree n Just Nothing hd) =>
n 1 (n 2 (foldTree n Just Nothing hi) (foldTree n Just Nothing hd)) (n 3 (foldTree n Just Nothing hi) (foldTree n Just Nothing hi)) =>
n 1 (n 2 (Just 4) (Just 5)) (n 3 (Nothing) (Just 6)) =>
n 1 (Just (2 `max` 4 `max` 5)) (Just (3 `max` 3 `max` 6)) =>
n 1 (Just 5) (Just 6) =>
Just (1 `max` 5 `max` 6) =>
Just 6
-}
