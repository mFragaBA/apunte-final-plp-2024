-- EJERCICIO 2

valorAbsoluto :: Float -> Float
valorAbsoluto = abs

bisiesto :: Int -> Bool
bisiesto anio | mod anio 4 == 0 = True
              | otherwise       = False

factorial :: Int -> Int
factorial 1 = 1
factorial n = n * factorial (n-1)

cantDivisoresPrimos :: Int -> Int
cantDivisoresPrimos n = cantDivisoresPrimosMenoresA n n

cantDivisoresPrimosMenoresA :: Int -> Int -> Int
cantDivisoresPrimosMenoresA _ 1 = 0
cantDivisoresPrimosMenoresA n divisorCandidato | esPrimo divisorCandidato && mod n divisorCandidato == 0 = 1 + divisoresMenores
                                               | otherwise                   = divisoresMenores
                                              where divisoresMenores = cantDivisoresPrimosMenoresA n (divisorCandidato - 1)

esPrimo :: Int -> Bool
esPrimo n = cantDivisoresMenoresA n n == 2

cantDivisoresMenoresA :: Int -> Int -> Int
cantDivisoresMenoresA _ 1 = 1
cantDivisoresMenoresA n divisorCandidato | mod n divisorCandidato == 0 = 1 + divisoresMenores
                                         | otherwise                   = divisoresMenores
                                         where divisoresMenores = cantDivisoresMenoresA n (divisorCandidato - 1)

-- Ejercicio 3

-- data Maybe a = Nothing | Just a
-- data Either a b = Left a | Right b

inverso :: Float -> Maybe Float
inverso 0.0 = Nothing
inverso x = Just (1.0 / x)

aEntero :: Either Int Bool -> Int
aEntero (Left unEntero) = unEntero
aEntero (Right True) = 1
aEntero (Right False) = 0

-- Ejercicio 4

limpiar :: String -> String -> String
limpiar [] fromStr = fromStr 
limpiar (unChar:restoDelPatron) fromStr = limpiar restoDelPatron (filter (/= unChar) fromStr) 

difPromedio :: [Float] -> [Float]
difPromedio xs = map (\x -> x - promedioXs) xs
              where promedioXs = promedio xs

promedio :: [Float] -> Float
promedio [] = 0.0
promedio xs = sum xs / fromIntegral (length xs)

todosIguales :: [Int] -> Bool
todosIguales [] = True
todosIguales (x:xs) = all (== x) xs

-- Ejercicio 5

data AB a = Nil | Bin (AB a) a (AB a) deriving Show

vacioAB :: AB a -> Bool
vacioAB Nil = True
vacioAB _ = False

negacionAB :: AB Bool -> AB Bool
negacionAB Nil = Nil
negacionAB (Bin hijoIzq nodo hijoDer) = Bin (negacionAB hijoIzq) (not nodo) (negacionAB hijoDer)

productoAB :: AB Int -> Int
productoAB Nil = 1
productoAB (Bin hijoIzq nodo hijoDer) = productoAB hijoIzq * nodo * productoAB hijoDer
