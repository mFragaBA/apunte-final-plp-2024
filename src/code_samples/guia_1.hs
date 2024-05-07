-- EJERCICIO 1
flipRaro = flip flip

max2 :: Float -> Float -> Float
max2 x y    | x >= y = x
            | otherwise = y

normaVectorial :: Float -> Float -> Float
normaVectorial x y = sqrt (x^2 + y^2)

-- Ejercicio 2

-- Primero damos el tipo, uso paréntesis para ser explícito pero puede haber alguno de más
curry' :: ((a, b) -> c) -> (a -> (b -> c))
-- A f lo tengo que evaluar con la tupla para que tipe bien, no puedo hacer f x y
curry' f = \x -> (\y -> f (x,y))
-- Alternativa: curry f x y = f (x, y)

uncurry' :: (a -> (b -> c)) -> ((a, b) -> c)
-- Necesito que la nueva función reciba de a tuplas
uncurry' f = \(x, y) -> f x y
-- Alternativa: uncurry f x y = f x y

-- EJERCICIO 4
pitagoricas :: [(Integer, Integer, Integer)]
pitagoricas = [(a, b, c) | a <- [1..], b <- [1..], c <- [1..], a^2 + b^2 == c^2]

pitagoricas2 :: [(Integer, Integer, Integer)]
pitagoricas2 = [(a, b, c) | c <- [1..], a <- [1..c], b <- [1..c], a^2 + b^2 == c^2]

-- Ejercicio 5
primerosMilPrimos :: [Integer]
primerosMilPrimos = take 1000 [p | p <- [1..], esPrimo p]

esPrimo entero = null [divisor | divisor <- [2..entero-1], mod entero divisor == 0]

-- Ejercicio 7
listasQueSuman :: Integer -> [[Integer]]
listasQueSuman 0 = [[]]
listasQueSuman n = [i:l | i <- [1..n], l <- listasQueSuman (n - i)]

-- Ejercicio 8
allFiniteLists :: [[Integer]]
allFiniteLists = [l | n <- [1..], l <- listasQueSuman n]

-- Ejercicio 10
---- sum
sum2 :: [Integer] -> Integer
sum2 [] = 0
sum2 (x:xs) = x + sum2 xs

sum3 :: [Integer] -> Integer
sum3 = foldr (+) 0

---- elem
elem2 :: Eq a => a -> [a] -> Bool
elem2 x [] = False
elem2 x (y:ys) = (x == y) || elem x ys 

elem3 :: Eq a => a -> [a] -> Bool
elem3 x = foldr (\y rec -> (x == y) || rec) False

---- ++
concatL :: [a] -> [a] -> [a]
concatL [] ys = ys
concatL (x:xs) ys = x:(xs ++ ys)

concatL' xs ys = foldr (:) ys xs

---- filter
filtrar :: (a -> Bool) -> [a] -> [a]
filtrar f [] = []
filtrar f (x:xs) = if f x then x:rec else rec
    where rec = filtrar f xs

filtrar' f = foldr (\x rec -> if f x then x:rec else rec) []

---- map
mappear :: (a -> b) -> [a] -> [b]
mappear f [] = []
mappear f (x:xs) = (f x):(mappear f xs)

mappear' f = foldr (\x rec -> (f x):rec) []

-- EJERCICIO 12

recr :: (a -> [a] -> b -> b) -> b -> [a] -> b
recr _ z [] = z
recr f z (x:xs) = f x xs (recr f z xs)

sacarUna :: Eq a => a -> [a] -> [a]
sacarUna t = recr (\x xs rec -> if x == t then xs else x:rec) []

insertarOrdenado :: Ord a => a -> [a] -> [a]
insertarOrdenado t = recr (\x xs rec -> if t < x then t:x:xs else x:rec) [t]

-- EJERCICIO 14
mapPares :: (a -> b -> c) -> [(a, b)] -> [c]
mapPares f = map (uncurry' f)

armarPares :: [a] -> [b] -> [(a, b)]
armarPares xs ys = foldr (\x rec -> \yss -> case yss of
                            [] -> []
                            (y:restanteY) -> (x,y):(rec restanteY)
                         ) (const []) xs ys

-- EJERCICIO 16
generate :: ([a] -> Bool) -> ([a] -> a) -> [a]
generate stop next = generateFrom' stop next []

generateFrom :: ([a] -> Bool) -> ([a] -> a) -> [a] -> [a]
generateFrom stop next xs   | stop xs = init xs
                            | otherwise = generateFrom stop next (xs ++ [next xs])

generateBase :: ([a] -> Bool) -> a -> (a -> a) -> [a]
generateBase stop base next = generate stop (\l -> if null l then base else next (last l))

factoriales :: Int -> [Int]
factoriales n = generate (\l -> length l == n + 1) (\l -> if null l then 1 else last l * (length l + 1))

iterateN :: Int -> (a -> a) -> a -> [a]
iterateN n f x = generateBase (\l -> length l == n) x f

generateFrom' :: ([a] -> Bool) -> ([a] -> a) -> [a] -> [a]
generateFrom' stop next xs  = last (takeWhile (not . stop) (iterate (\l -> l ++ [next l]) xs))

-- EJERCICIO 17
foldNat :: (Integer -> b -> b) -> b -> Integer -> b
foldNat _ base 0 = base
foldNat f base n = f n (foldNat f base (n-1))

potencia :: Integer -> Integer -> Integer
potencia a = foldNat (\n rec -> a*rec) 1

-- EJERCICIO 18
data Polinomio a = X
                 | Cte a
                 | Suma (Polinomio a) (Polinomio a)
                 | Prod (Polinomio a) (Polinomio a)

foldPoli :: Num a => Num b => (b -> b -> b)             -- Suma
            -> (b -> b -> b)                            -- Prod
            -> (a -> b)                                 -- Const a
            -> b                                        -- X
            -> Polinomio a -> b
foldPoli _ _ baseConst baseX (Cte a) = baseConst a
foldPoli _ _ _ baseX X = baseX
foldPoli fSuma fProd baseConst baseX (Suma p1 p2) = fSuma (foldPoli fSuma fProd baseConst baseX p1) (foldPoli fSuma fProd baseConst baseX p2)
foldPoli fSuma fProd baseConst baseX (Prod p1 p2) = fProd (foldPoli fSuma fProd baseConst baseX p1) (foldPoli fSuma fProd baseConst baseX p2)

evaluar :: Num a => a -> Polinomio a -> a
evaluar = foldPoli (+) (*) id

-- para pruebas de evaluar
cuadratica = Suma (Prod X X) (Suma (Prod (Cte 2) X) (Cte 1))

-- EJERCICIO 19
type Conj a = (a -> Bool)

vacio :: Conj a
vacio = const False

agregar :: Eq a => a -> Conj a -> Conj a
agregar a c elem = elem == a || c elem

conjuntoConPrimerosN n = foldr agregar vacio [1..n]

interseccion :: Conj a -> Conj a -> Conj a
interseccion u v x = u x && v x 

union :: Conj a -> Conj a -> Conj a
union u v x = u x || v x 

todasUnariasOMas :: Conj (a -> b)
todasUnariasOMas = const True

-- EJERCICIO 21
data AHD tInterno tHoja = Hoja tHoja
                        | Rama tInterno (AHD tInterno tHoja)
                        | Bin (AHD tInterno tHoja) tInterno (AHD tInterno tHoja) deriving (Show, Eq)

foldAHD :: (a -> c -> c -> c)   -- Bin
        -> (a -> c -> c)        -- Rama
        -> (b -> c)             -- Hoja
        -> AHD a b
        -> c

foldAHD _ _ fHoja (Hoja a) = fHoja a
foldAHD fBin fRama fHoja (Rama a subarbol) = fRama a (foldAHD fBin fRama fHoja subarbol)
foldAHD fBin fRama fHoja (Bin subarbolIzq a subarbolDer) = fBin a (rec subarbolIzq) (rec subarbolDer)
                                                        where rec = foldAHD fBin fRama fHoja

mapAHD :: (a -> b) -> (c -> d) -> AHD a c -> AHD b d
mapAHD fInternos fHojas = foldAHD (\nodo recIzq recDer -> Bin recIzq (fInternos nodo) recDer) 
                                  (Rama . fInternos)
                                  (Hoja . fHojas)


ejemploAHD = Bin(Rama 1 (Hoja False)) 2 (Bin(Hoja False) 3 (Rama 5 (Hoja True)))
expectedEjemploMapeado = Bin (Rama 2 (Hoja True)) 3 (Bin (Hoja True) 4 (Rama 6 (Hoja False)))

-- EJERCICIO 23
data RoseTree t = Nodo t [RoseTree t] deriving (Show, Eq)

foldRose :: (a -> [b] -> b) -> RoseTree a -> b
foldRose f (Nodo a ts) = f a (map (foldRose f) ts)

mapRose :: (a -> b) -> RoseTree a -> RoseTree b
mapRose f = foldRose (Nodo . f)

hojas :: RoseTree a -> [a]
hojas = foldRose (\nodo recs -> if null recs then [nodo] else concat recs)

distancias :: RoseTree a -> [Integer]
distancias = foldRose (\nodo recs -> if null recs then [0] else map (+1) (concat recs))

altura :: RoseTree a -> Integer
altura = foldRose (\nodo recs -> if null recs then 1 else 1 + maximum recs)

ejemploRose = Nodo 0 [Nodo 1 [], Nodo 2 [], Nodo 3 []]
