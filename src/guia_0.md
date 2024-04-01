# Guia 0 - Repaso Haskell

## Ejercicio 1

Dar el tipo y describir el comportamiento de las siguientes funciones del módulo `Prelude` de Haskell:

Hago un par nomás (recomiendo primero jugar un poco con las funciones y si no les queda claro pueden usar `:doc NOMBRE_DE_LA_FUNCIÓN`):

- `null`:

```haskell
ghci> :type null
null :: Foldable t => t a -> Bool
ghci> null []
True
ghci> null [1, 2 , 3]
False
```

Devuelve si una estructura está vacía o no

- `head`

```haskell
ghci> :type head
head :: GHC.Stack.Types.HasCallStack => [a] -> a
ghci> head []
*** Exception: Prelude.head: empty list
CallStack (from HasCallStack):
  error, called at libraries/base/GHC/List.hs:1646:3 in base:GHC.List
  errorEmptyList, called at libraries/base/GHC/List.hs:85:11 in base:GHC.List
  badHead, called at libraries/base/GHC/List.hs:81:28 in base:GHC.List
  head, called at <interactive>:9:1 in interactive:Ghci3
ghci> head [1, 2]
1
```

Devuelve el primer elemento de una lista

- `take`

```haskell
ghci> :type take
take :: Int -> [a] -> [a]
ghci> take 3 [1, 2 , 3, 4]
[1,2,3]
ghci> take 3 [1, 2]
[1,2]
ghci> take 3 []
[]
```

Recibe un número `n` y una lista, y devuelve los primeros `n` elementos de dicha lista.

- `!!`

```haskell
ghci> :type (!!)
(!!) :: GHC.Stack.Types.HasCallStack => [a] -> Int -> a
ghci> [1, 2, 3, 4] !! 2
3
ghci> [1, 2, 3, 4] !! 3
4
ghci> [1, 2, 3, 4] !! 0
1
```

Es el operador de indexado.

## Ejercicio 2

Definir las siguientes funciones:

- `valorAbsoluto :: Float -> Float` que dado un número devuelve su valor absoluto.

```haskell
valorAbsoluto :: Float -> Float
valorAbsoluto = abs
```

- `bisiesto :: Int -> Bool` que dado un número que representa un año, indica si el mismo es bisiesto.

```haskell
bisiesto :: Int -> Bool
bisiesto anio | mod anio 4 == 0 = True
              | otherwise       = False
```

- `factorial :: Int -> Int` definida únicamente para enteros positivos, que computa el factorial.

```haskell
factorial :: Int -> Int
factorial 1 = 1
factorial n = n * factorial (n-1)
```

- `cantDivisoresPrimos :: Int -> Int`, que dado un entero positivo devuelve la cantidad de divisores primos

```haskell
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
```

### Ejercicio 3

Contamos con los tipos `Maybe` y `Either` definidos como sigue:

```haskell
data Maybe a = Nothing | Just a
data Either a b = Left a | Right b
```

- Definir la función `inverso :: Float -> Maybe Float` que dado un número devuelve su inverso multiplicativo si está definido, o `Nothing` en caso contrario.

```haskell
inverso :: Float -> Maybe Float
inverso 0.0 = Nothing
inverso x = Just (1.0 / x)
```

- Definir la función `aEntero :: Either Int Bool -> Int` que convierte a entero una expresión que puede ser booleana o entera. En el caso de los booleanos, el entero que corresponde es 0 para `False` y 1 para `True`.

```haskell
aEntero :: Either Int Bool -> Int
aEntero (Left unEntero) = unEntero
aEntero (Right True) = 1
aEntero (Right False) = 0
```

### Ejercicio 4

Definir las siguientes funciones sobre listas:

- `limpiar :: String -> String -> String`, que elimina todas las apariciones de cualquier carácter de la primera cadena en la segunda. Por ejemplo, `limpiar "susto" "puerta"` evalúa a `"pera"`. Nota: `String` es un renombre de `[Char]`. La notación `"hola"` es equivalente a `['h', 'o', 'l', 'a']` y a `'h':'o':'l':'a':[]`

```haskell
limpiar :: String -> String -> String
limpiar [] fromStr = fromStr 
limpiar (unChar:restoDelPatron) fromStr = limpiar restoDelPatron (filter (/= unChar) fromStr) 
```

- `difPromedio :: [Float] -> [Float]` que dada una lista de números devuelve la diferencia de cada uno con el promedio general. Por ejemplo, `difPromedio [2, 3, 4]` evalúa a `[-1, 0, 1]`.

```haskell
difPromedio :: [Float] -> [Float]
difPromedio xs = map (\x -> x - promedioXs) xs
              where promedioXs = promedio xs

promedio :: [Float] -> Float
promedio [] = 0.0
promedio xs = sum xs / fromIntegral (length xs)
```

- `todosIguales :: [Int] -> Bool` que indica si una lista de enteros tiene todos sus elementos iguales.

```haskell
todosIguales :: [Int] -> Bool
todosIguales [] = True
todosIguales (x:xs) = all (== x) xs
```

### Ejercicio 5

Dado el siguiente modelo para árboles binarios:

```haskell
data AB a = Nil | Bin (AB a) a (AB a)
```

definir las siguientes funciones:

- `vacioAB :: AB a -> Bool` que indica si un árbol es vacío (i.e. no tiene nodos)

```haskell
vacioAB :: AB a -> Bool
vacioAB Nil = True
vacioAB _ = False
```

- `negacionAB :: AB bool -> AB Bool` que dado un árbol de booleanos construye otro formulado por la negación de cada uno de los nodos.

```haskell
negacionAB :: AB Bool -> AB Bool
negacionAB Nil = Nil
negacionAB (Bin (hijoIzq) nodo (hijoDer)) = Bin (negacionAB hijoIzq) (not nodo) (negacionAB hijoDer)
```

- `productoAB :: AB Int -> Int` que calcula el producto de todos los nodos del árbol

```haskell
productoAB :: AB Int -> Int
productoAB Nil = 1
productoAB (Bin hijoIzq nodo hijoDer) = productoAB hijoIzq * nodo * productoAB hijoDer
```
