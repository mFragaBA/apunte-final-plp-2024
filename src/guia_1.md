# Guia 1 - Programación funcional

## Currificación y Tipos en Haskell

### Ejercicio 1 ★

Sean las siguientes definiciones de funciones:

```haskell
max2 (x, y) | x >= y = x
            | otherwise = y

normaVectorial (x, y) = sqrt (x^2 + y^2)

substract = flip (-)

predecesor = substract 1

evaluarEnCero = \f -> f 0

dosVeces = \f -> f.f

flipAll = map flip

flipRaro = flip flip
```

**Cuál es el tipo de cada función? Asumir que todos los números son de tipo Float.**

- `max2 :: (Float, Float) -> Float` ya que toma dos números (que asumimos float) y devuelve uno de los dos
- `normaVectorial :: (Float, Float) -> Float` ya que toma dos números, los eleva al cuadrado (siguen siendo floats), los suma obteniendo un float y le aplica `sqrt` que también devuelve un float.
- `substract :: Float -> Float -> Float`
    - `flip :: (a -> b -> c) -> b -> a -> c`
    - `(-) :: a -> a -> a` con `Num a`, y asumiendo que todos los números son floats queda `Float -> Float -> Float`
    - Hago el reorden que hace flip (`Float -> Float -> Float` de `(-)` matchea con el `(a -> b -> c)`) y sigue siendo `Float -> Float -> Float`
- `predecesor :: Float -> Float` ya que es `substract` con la aplicación parcial del primer parámetro
- `evaluarEnCero :: (Float -> a) -> a` ya que recibe una función que toma un número (asumimos float) y a priori puede devolver cualquier cosa.
- `dosVeces :: (a -> a) -> (a -> a)` ya que la función `f` que recibe tiene que poder componerse consigo misma y por ende la salida tiene que tener el mismo tipo de la entrada, y la composición me sigue dando algo que recibe el tipo `a` y devuelve el tipo `a`
- `flipAll :: [(a' -> b' -> c')] -> [(b' -> a' -> c')]`, o sea es una función que recibe una lista de funciones de 2 parámetros y les invierte los argumentos.
    - `map :: (a -> b) -> [a] -> [b]`
    - `flip :: (a' -> b' -> c') -> b' -> a' -> c'` (los `'` están para no confundir que son tipos distintos a los de `map`)
        - acá `a` matchea con `(a' -> b' -> c')`
- `flipRaro :: b -> (a -> b -> c) -> (a -> c)` según ghci, y es porque piensa a flip como una función de 2 parámetros que recibe `(a' -> b' -> c')` y `b'` y devuelve una función `a' -> c'`
    - `flip :: (a -> b -> c) -> b -> a -> c`
    - `flip :: (a' -> b' -> c') -> b' -> (a' -> c')`
    - lo que estaría haciendo es dejarte la función como está, pero le tengas que pasar el segundo parámetro de la función. Es como que podés devolver algo que fija el segundo parámetro de cualquier función. Por ejemplo:

    ```haskell
    -- restaFlippeada === (x - 2)
    restaFlipeada = flipRaro 2 (\x -> \y -> x - y)
    -- (1 - 2 = -1)
    ghci> restaFlipeada 1
    -1
    -- (3 - 2 = 1)
    ghci> restaFlipeada 3
    1
    ```

**Alguna de las funciones anteriores no está currificada? De ser así, escribir la versión currificada junto con su tipo para cada una de ellas.**

Sí, las primeras 2 funciones no están currificadas ya que reciben una tupla que no permite hacer la aplicación parcial. Sus versiones currificadas serían

```haskell
max2 :: Float -> Float -> Float
max2 x y    | x >= y = x
            | otherwise = y

normaVectorial :: Float -> Float -> Float
normaVectorial x y = sqrt (x^2 + y^2)
```

### Ejercicio 2 ★

1. **Definir la función `curry`, que dada una función de dos argumentos, devuelve su equivalente currificada.**

```haskell
-- Primero damos el tipo, uso paréntesis para ser explícito pero puede haber alguno de más
curry :: ((a, b) -> c) -> (a -> (b -> c))
-- A f lo tengo que evaluar con la tupla para que tipe bien, no puedo hacer f x y
curry f = \x -> (\y -> f (x,y))
-- Alternativa: curry f x y = f (x, y)
```

2. **Definir la función `uncurry`, que dada una función currificada de dos argumentos, devuleve su versión no currificada equivalente. Es la inversa de la anterior.**

```haskell
uncurry :: (a -> (b -> c)) -> ((a, b) -> c)
-- Necesito que la nueva función reciba de a tuplas
uncurry f = \(x, y) -> f x y
-- Alternativa: uncurry f (x,y) = f x y
```

3. **Se podría definir una función `curryN`, que tome una función de un número arbitrario de argumentos y devuelva su versión currificada?**

No, esto no es posible, ya que para aceptar funciones de cualquier cantidad de parámetros, la función debería tener un tipo como:

```haskell
curryN :: (x -> c) -> ...
```

para que `x` puede ser una tupla de 1, 2, 3, N parámetros. El problema es que después no tenemos forma de desestructurar eso al otro lado del tipo de la función, ni al definir la función. Otro aproach podría ser el de definir una función recursiva que haga `curry` tantas veces como sea necesario, pero de vuelta eso requiere saber cuándo tenés una función que recibe más de un parámetro vs cuando recibe 1 y no se puede hacer eso.

## Listas por comprensión

### Ejercicio 4 ★

Una tripla pitagórica es una tripla \\((a, b, c)\\) de enteros positivos tal
que \\(a^2 + b^2 = c^2\\). La siguiente expresión intenta ser una definición de
una lista (infinita) de triplas pitagóricas:

```haskell
pitagoricas :: [(Integer, Integer, Integer)]
pitagoricas = [(a, b, c) | a <- [1..], b <- [1..], c <- [1..], a^2 + b^2 == c^2]
```

**Explicar por qué esta definición no es útil. Dar una definición mejor.**

Para entender el problema de esta definición lo mejor es sacarle el syntactic sugar:

```python
def pitagoricas():
    for a in 1..infinity():
        for b in 1..infinity():
            for c in 1..infinity():
                if a*a + b*b == c*c:
                    yield (a, b, c)
```

Esto significa que va a recorrer todos los valores de `c` posibles antes de
probar con otros de `a` y `b`, o lo que es lo mismo tengo `a = b = 1` fijos.
Entonces sólo voy a poder obtener con take las tuplas `(1, 1, c)` con `1*1 +
1*1 = c*c` o `2 = c*c`, lo cual ningún `c` entero cumple. Una mejor forma sería que iteremos sobre `c` y la usemos como cota para no iterar infinitamente sobre `a` y `b`. Nos quedaría:

```haskell
pitagoricas = [(a, b, c) | c <- [1..], a <- [1..c], b <- [1..c], a^2 + b^2 == c^2]
```

### Ejercicio 5 ★

**Generar la lista de los primeros mil números primos. Observar cómo la evaluación lazy facilita la implementación de esta lista**.

```haskell
primerosMilPrimos :: [Integer]
primerosMilPrimos = take 1000 [p | p <- [1..], esPrimo p]

esPrimo entero = null [divisor | divisor <- [2..entero-1], mod entero divisor == 0]
```

Esto se puede generalizar a una función que genera la lista de los primeros `n` primos

```haskell
primerosPrimos :: Integer -> [Integer]
primerosPrimos n = take n [p | p <- [1..], esPrimo p]
```

Esto se ve facilitado por la evaluación lazy ya que el take nos permite generar
la lista infinita de números primos pero cortando la generación cuando
queremos. Es también una forma más declarativa de computar.

### Ejercicio 7 ★

**Escribir la función** `listasQueSuman :: Int -> [[Int]]` **que, dado un número natural** \\(n\\) **, devuelve todas las listas de enteros positivos (es decir mayores o iguales que 1) cuya suma sea** \\(n\\). Para este ejercicio se permite usar recursión explícita.

Idea: En una lista `l` que suma \\(n\\), todos sus valores son más chicos que
\\(n\\). Por lo tanto, `l[1..]` es una lista que suma \\(n - l[0]\\). Pensando
en eso, podemos pensar en que las listas que suman \\(n\\) son listas que suman
algo menor a \\(n\\), y se les agrega un elemento con la diferencia faltante.

```haskell
listasQueSuman :: Integer -> [[Integer]]
listasQueSuman 0 = [[]] -- podría definir el caso base como listasQueSuman 1 = [[1]] también
listasQueSuman n = [i:l | i <- [1..n], l <- listasQueSuman (n - i)]
```

### Ejercicio 8 ★

**Definir en Haskell una lista que contenga todas las listas finitas de enteros positivos (esto es, con elementos mayores o iguales que 1)**.

Idea: Puedo clusterizar todas las listas finitas de enteros positivos en

- las listas que suman 0
- las listas que suman 1
- ...
- las listas que suman n

Se ve a dónde apuntamos? Reusemos código!

```haskell
allFiniteLists = [l | l <- listasQueSuman (n), n <- [1..]]
```

## Esquemas de recursión

### Ejercicio 10 ★

1. **Redefinir usando `foldr` las funciones `sum`, `elem`, `(++)`, `filter` y `map`.**

Voy a anotar una definición recursiva de cada función (que coincidentalmente se ajuste al formato del `foldr`) seguido de su versión *foldificada*™. También para simplificar un poco voy a usar `Integer` para los números donde sea necesario, y asumo que los tipos son listas aunque en haskel hay una generalización de eso que es con la interfaz `Foldable`.

```haskell
sum :: [Integer] -> Integer
sum [] = 0
sum (x:xs) = x + sum xs

sum2 :: [Integer] -> Integer
sum2 = foldr (+) 0
```

Si queremos probarla podemos reusar la función `listasQueSuman`!

```haskell
ghci> map sum2 (listasQueSuman 4)
[4,4,4,4,4,4,4,4]
```

Ahora seguimos con `elem`, que te dice si un elemento pertenece a una lista.

```haskell
elem :: Eq a => a -> [a] -> Bool
elem x [] = False
elem x (y:ys) = (x == y) || elem x xs 

elem3 x = foldr (\y rec -> (x == y) || rec) False
```

Seguimos con `(++)` que es la concatenación de listas. Por simplicidad usemos la versión que no es infija:

```haskell
concatL :: [a] -> [a] -> [a]
concatL [] ys = ys
concatL (x:xs) ys = x:(xs ++ ys)

-- invierto el orden de xs e ys así el append queda bien. Si no quedaría y1:y2:y3:...:y_n:xs
concatL' xs ys = foldr (:) ys xs
```

Ahora `filter`

```haskell
filtrar :: (a -> Bool) -> [a] -> [a]
filtrar f [] = []
filtrar f (x:xs) = if f x then x:rec else rec
    where rec = filtrar f xs

filtrar' f = foldr (\x rec -> if f x then x:rec else rec) []
```

Y por último `map`:

```haskell
mappear :: (a -> b) -> [a] -> [b]
mappear f [] = []
mappear f (x:xs) = (f x):(mappear f xs)

mappear' f = foldr (\x rec -> (f x):rec) []
```

### Ejercicio 12 ★

**El siguiente esquema captura la recursión primitiva sobre listas.**

```haskell
recr :: (a -> [a] -> b -> b) -> b -> [a] -> b
recr _ z [] = z
recr f z (x:xs) = f x xs (recr f z xs)
```

a. **Definir la función `sacarUna :: Eq a => a -> [a] -> [a]` que dados un elemento y una lista devuelve el resultado de eliminar de la lista la primera aparición del elemento (si está presente).**

```haskell
sacarUna :: Eq a => a -> [a] -> [a]
sacarUna t = recr (\x xs rec -> if x == t then xs else x:rec) []
```

b. **Explicar por qué el esquema de `foldr` no es adecuado para implementar la
función `sacarUna` del punto anterior.**

Porque en foldr no tengo forma de recuperar lo que queda de lista. Sólo tengo
el elemento actual y el resultado de la recursión. Y para `sacarUna` necesito
esa data porque el resultado recursivo depende en realidad del valor actual
(cómo sé en la recursión si me queda uno por sacar o no). Si bien es posible
replicar esto con `foldr` haciendo que la función en su segunda componente
devuelva la lista entera / el caso de la recursión si saco el actual y corto +
el caso de la recursión si no saco el actual, resulta poco práctico y es mucho
más cómodo usar `recr` directamente.

c. **Definir la función `insertarOrdenado :: Ord a => a -> [a] -> [a]` que
inserta un elemento en una lista ordenada (de manera creciente), de manera que
se preserva el ordenamiento.**

```haskell
insertarOrdenado :: Ord a => a -> [a] -> [a]
insertarOrdenado t = recr (\x xs rec -> if t < x then t:x:xs else x:rec) [t]
```

d. **La función `listasQueSuman` del ejercicio 7, se ajusta al esquema de recursión `recr`? Por qué o por qué no?**

Recuerdo:

```haskell
listasQueSuman :: Integer -> [[Integer]]
listasQueSuman 0 = [[]]
listasQueSuman n = [i:l | i <- [1..n], l <- listasQueSuman (n - i)]

listasQueSuman n = recr (\x xs rec -> ???) [[]] [n..1]
```

El problema acá es que el resultado de un paso depende de tooooodas las recursiones. No solamente la recursión inmediata:

![](./img/practica_1_ej_12.png#center)

### Ejercicio 14 ★

Definir las siguientes funciones para trabajar sobre listas y dar su tipo. Todas ellas deben poder aplicarse a listas *finitas* e *infinitas*.

1. **`mapPares`, una versión de `map` que toma una función currificada de dos
   argumentos y una lista de pares de valores, y devuelve la lista de
   aplicaciones de la función a cada par. Pista: recordar `curry` y `uncurry`**

```haskell
mapPares :: (a -> b -> c) -> [(a, b)] -> [c]
mapPares f = map (uncurry f)
```

2. **`armarPares`, que dadas dos listas arma una lista de pares que contiene,
   en cada posición, el elemento correspondiente a esa posición en cada una de
   las listas. Si una de las listas es más larga que la otra, ignorar los
   elementos que sobran (el resultado tendrá la longitud de la lista más
   corta). Esta función en haskell se llama `zip`. Pista: aprovechar la
   currificación y utilizar evaluación parcial**.

![](./img/a_rough_one.gif#center)

El tipo de mi función va a ser:

```haskell
armarPares :: [a] -> [b] -> [(a, b)]
```

Creo que el primer paso para sacar esto es usar la sugerencia, asumir que tengo que usar `foldr` y entender qué tipos van a tener mis funciones

```haskell
armarPares xs yx = foldr (...) (...) xs ys
```

`foldr :: (a -> b -> b) -> b -> [a] -> b`, entonces se que `b = [c] -> [(a,
c)]`. Ahora voy a reemplazar esto sobre la definición del `foldr`, para tener
una idea más clara de qué necesito de los parámetros (no sacar fuera de contexto, lo de abajo no es el tipo real de fold, si no que está aplicado a este caso particular):

```haskell
foldr :: (a -> ([c] -> [(a, c)]) -> ([c] -> [(a, c)])) 
        -> ([c] -> [(a, c)]) 
        -> [a] 
        -> [c] -> [(a, c)]
```

Ahora, esto nos dice también que `foldr (...) (...) xs` nos va a dar una
función que al aplicarle `ys` nos reconstruye la lista de pares. Primera
consecuencia de eso, quiero una función que cuando `xs` sea vacío (o sea el
caso base del fold), me devuelva una función que me devuelva vacío sin importar
el valor de ys. Es un buen trabajo para `const []`. Va tomando forma nuestro `armarPares`:

```haskell
armarPares xs yx = foldr (\x rec -> (\listaDeC -> ...)) (const []) xs ys
```

Lo siguiente es ver el otro caso borde, qué pasa si `ys = []`? Para eso podemos agregarle un chequeo a la función recursiva del fold. Si lo tienen todas las iteraciones no me importa mucho:

```haskell
armarPares xs yx = foldr (\x rec -> (\listaDeC -> if null listaDeC then [] else ...)) (const []) xs ys
```

Lo siguiente es entender qué valor tiene `listaDeC`. Considerando que quiero ir agrupando elemento a elemento, puedo pensar que en el llamado más externo voy a tener

```haskell
-- con x instanciado en xs[0]
(\listaDeC -> if null listaDeC then [] else ...) ys
```

A lo que me gustaría entonces poder hacer `(x, head ys):Z`, siendo `Z` el resto de la lista de tuplas que se formaría con los otros valores de `xs[1..]` y el resto de `ys[1..]`. Pero eso es precisamente lo que hace `rec`, es la función que te puede pegar en tuplas `x[1..]` a lo que reciba como parámetro.

```haskell
(\listaDeC -> if null listaDeC then [] else (x, head ys):(rec tail listaDeC)) ys
```

Esto también nos permite darle un (en mi opinión) mejor nombre a `listaDeC`, `restanteY` o `remainingY`. El resultado final entonces nos queda:

```haskell
armarPares :: [a] -> [b] -> [(a, b)]
armarPares xs yx = foldr (\x rec -> 
                            (\restanteY -> 
                                if null restanteY then [] 
                                else (x, head restanteY):(rec tail restanteY)
                            )
                        ) (const []) xs ys
```

3. **`mapDoble`, una variante de `mapPares` que toma una función currificada de
   dos argumentos y dos listas (de igual longitud) y devuelve una lista de
   aplicaciones de la función a cada elemento correspondiente de las dos
   listas. Esta función en Haskell se llama `zipWith`**

```haskell
mapDoble :: (a -> b -> c) -> [a] -> [b] -> [(a, b)]
mapDoble f = (mapPares f) . armarPares
```

### Ejercicio 16 ★

Definimos la función `generate` que genera listas en base a un predicado y una función, de la siguiente manera:

```haskell
generate :: ([a] -> Bool) -> ([a] -> a) -> [a]
generate stop next = generateFrom stop next []

generateFrom :: ([a] -> Bool) -> ([a] -> a) -> [a] -> [a]
generateFrom stop next xs   | stop xs = init xs
                            | otherwise = generateFrom stop next (xs ++ [next xs])
```

1. **Usando `generate`, definir `generateBase :: ([a] -> Bool) -> a -> (a -> a)
   -> [a]` similar a `generate`, pero con un caso base para el elemento
   inicial, y una función que, en lugar de calcular el siguiente elemento en
   base a la lista completa, lo calcula solo a partir del último elemento. Por
   ejemplo: `generateBase (\l -> not (null l) && (last l > 256)) 1 (*2)` es la
   lista de potencias de 2 menores o iguales que 256**.

```haskell
generateBase :: ([a] -> Bool) -> a -> (a -> a) -> [a]
generateBase stop base next = generate stop (\l -> if null l then base else next (last l))
```

2. **Usando `generate`, definir `factoriales :: Int -> [Int]` que dado un
   entero `n` genera la lista de los primeros `n` factoriales.**

```haskell
factoriales :: Int -> [Int]
factoriales n = generate (\l -> length l == n + 1) (\l -> if null l then 1 else last l * (length l + 1))
```

3. **Usando `generateBase`, definir `iterateN :: Int -> (a -> a) -> a -> [a]`
   que, toma un entero `n`, una función `f` y un elemento incial `x`, y
   devuelve la lista `[x, f x, f (f x), ..., f ( f ( ... f ( x )))]` de
   longitud `n`. Nota: `iterateN n f x = take n (iterate f x)`.**

```haskell
iterateN :: Int -> (a -> a) -> a -> [a]
iterateN n f x = generateBase (\l -> length l == n) x f
```

4. **Redefinir `generateFrom` usando `iterate` y `takeWhile`**

```haskell
-- Genero una lista con cada lista parcial [xs, xs ++ [next xs], ...] mientras no me frene la condición y tomo el último para obtener [xs ++ ... [next [xs ++ [next xs]]]]
generateFrom' :: ([a] -> Bool) -> ([a] -> a) -> [a] -> [a]
generateFrom' stop next xs  = last (takeWhile (not . stop) (iterate (\l -> l ++ [next l]) xs))
```

## Otras estructuras de datos

### Ejercicio 17 ★

1. **Definir y dar el tipo del esquema de recursión `foldNat` sobre los naturales. Utilizar el tipo `Integer` de Haskell (la función va a estar definida sólo para los enteros mayores o iguales que 0).**

Primero damos el tipo (lo único que hice fue reemplazar el `[a]` del `foldr` por `Integer`, y lo mismo para `a`):

```haskell
foldNat :: (Integer -> b -> b) -> b -> Integer -> b
```

Y considerando eso podemos pensar en el esquema de recursión:

```haskell
foldNat _ base 0 = base
foldNat f base n = f n foldNat f base (n-1)
```

> Nota: no siempre es más fácil dar el tipo primero.

2. **Utilizando `foldNat`, definir la función `potencia`**.

```haskell
-- potencia a b = a^b
potencia :: Integer -> Integer -> Integer
potencia a = foldNat (\n rec -> a*rec) 1
```

### Ejercicio 18

**Definir el esquema de recursión estructural para el siguiente tipo:**

```haskell
data Polinomio a = X
                 | Cte a
                 | Suma (Polinomio a) (Polinomio a)
                 | Prod (Polinomio a) (Polinomio a)
```

**Luego usar el esquema definido para escribir la función `evaluar :: Num a => a -> Polinomio a -> a`**

Definimos `foldPoli`:

- notar que tenemos una función por cada variante del polinomio (cte, x, suma que combina resultados, prod que combina resultados)

```haskell
foldPoli :: Num a => Num b => (b -> b -> b)             -- Suma
            -> (b -> b -> b)                            -- Prod
            -> (a -> b)                                 -- Const a
            -> b                                        -- X
            -> Polinomio a -> b
foldPoli _ _ baseConst baseX (Cte a) = baseConst a
foldPoli _ _ _ baseX X = baseX
foldPoli fSuma fProd baseConst baseX (Suma p1 p2) = fSuma (foldPoli fSuma fProd baseConst baseX p1) (foldPoli fSuma fProd baseConst baseX p2)
foldPoli fSuma fProd baseConst baseX (Prod p1 p2) = fProd (foldPoli fSuma fProd baseConst baseX p1) (foldPoli fSuma fProd baseConst baseX p2)
```

Luego `evaluar`:

```haskell
evaluar :: Num a => a -> Polinomio a -> a
evaluar a = foldPoli + * id a
```

### Ejercicio 19 ★

Se cuenta con la siguiente representación de conjuntos:

```haskell
type Conj a = (a -> Bool)
```

caracterizados por su función de pretenencia. De este modo, si `c` es un conjunto y `e` un elemento, la expresión `c e` devuelve `True` sii `e` pertenece a `c`.

1. **Definir la constante `vacio :: Conj a`, y la función `agregar :: Eq a => a -> Conj a -> Conj a`.**

Sabiendo que es una función, `vacio` va a ser una función que siempre devuelve falso.

```haskell
vacio :: Conj a
vacio = const False
```

Por otro lado, definamos primero a agregar expandiendo `Conj a`:

```haskell
agregar :: Eq a => a -> (a -> Bool) -> (a -> Bool)
```

Podemos ver entonces que la función que construimos para representar al nuevo conjunto es ver si coincide con el valor que se agrega, o delegar el chequeo a la función del conjunto previamente existente:

```haskell
agregar :: Eq a => a -> Conj a -> Conj a
agregar a c = \elem -> elem == a || c elem
```

2. **Escribir las funciones `intersección` y `unión` (ambas de tipo `Conj a -> Conj a -> Conj a).**

```haskell
interseccion :: Conj a -> Conj a -> Conj a
interseccion u v x = u x && v x 

union :: Conj a -> Conj a -> Conj a
union u v x = u x || v x 
```

3. **Definir un conjunto de funciones que contenga infinitos elementos, y dar su tipo..**

El ejemplo más sencillo que se me viene a la mente es el conjunto de todas las funciones por lo menos unarias. Su tipo sería `Conj (a -> b)`:

```haskell
todasUnariasOMas :: Conj (a -> b)
todasUnariasOMas = const True
```

4. **Definir la función `singleton :: Eq a => a -> Conj a` que dado un valor genere un conjunto con ese valor como único elemento.**

```haskell
singleton :: Eq a => a -> Conj a
singleton a = agregar a vacio
```

5. **Puede definirse un `map` para esta estructura? De qué manera, o por qué no?.**

```haskell
mapConjunto :: Eq a => (a -> b) -> Conj a -> Conj b
mapConjunto f c = \x -> ???
```

El problema es que no tengo forma de observar qué cosas tiene el conjunto `c`
sin probar con todos los enteros, y hay infinitos enteros.

- Alternativa 1, pedir que me pasen en una lista el dominio del conjunto. Puede que no funcione para conjuntos infinitos
- Alternativa 2, puedo asumir que la función que me pasan en realidad es la inversa de la que quiero

```haskell
mapConjunto fInv c = \x -> c (fInv x)
```

### Ejercicio 21 ★

Consideremos el siguiente tipo de datos:

```haskell
data AHD tInterno tHoja = Hoja tHoja
                        | Rama tInterno (AHD tInterno tHoja)
                        | Bin (AHD tInterno tHoja) tInterno (AHD tInterno tHoja)
```

que representa un árbol binario no vacío cuyos nodos internos pueden tener datos de un tipo deiferente al de sus hojas (AHD = árbol con hojas distinguidas). Por ejemplo: 

- `Bin (Hoja "hola") 'b' (Rama 'c' (Hoja "chau))` tiene tipo `AHD Char String`
- `Rama 1 (Bin (Hoja True) -2 (Hoja False))` tiene tipo `AHD Int Bool`

Algunos ejemplos de forma más gráfica:

![](./img/practica_1_ej_21.png#center)

1. **Escribir el esquema de recursión estructural `foldAHD` para este tipo de datos y dar su tipo**.

Consejo antes de empezar, si van a probarlo desde la computadora, métanle un `deriving (Show, Eq)` al final de la definición de `AHD`.

Primero damos el tipo. Recuerdo que necesito una función para cada constructor

```haskell
-- siendo a = tInterno, b = tHoja y c = el tipo resultante
foldAHD :: (a -> c -> c -> c)   -- Bin
        -> (a -> c -> c)        -- Rama
        -> (b -> c)             -- Hoja
        -> AHD a b
        -> c
```

Y luego damos el esquema:

```haskell
foldAHD _ _ fHoja (Hoja a) = fHoja a
foldAHD fBin fRama fHoja (Rama a subarbol) = fRama a (foldAHD fBin fRama fHoja subarbol)
foldAHD fBin fRama fHoja (Bin subarbolIzq a subarbolDer) = fBin a (rec subarbolIzq) (rec subarbolDer)
                                                        where rec = foldAHD fBin fRama fHoja
```

2. **Escribir, usando `foldAHD`, la función `mapAHD :: (a -> b) -> (c -> d) -> AHD a c -> AHD b d`, que actúa de manera análoga al `map` de listas, aplicando la primera función a los nodos internos y la segunda a las hojas. Por ejemplo:**

```haskell
mapAHD :: (a -> b) -> (c -> d) -> AHD a c -> AHD b d
mapAHD fInternos fHojas = foldAHD (\nodo recIzq recDer -> Bin recIzq (fInternos nodo) recDer) 
                                  (Rama . fInternos)
                                  (Hoja . fHojas)
```

### Ejercicio 23 ★

1. **Definir el tipo de datos `RoseTree` de árboles no vacíos, donde cada nodo tiene una cantidad indeterminada de hijos.**

```haskell
data RoseTree t = Nodo t [RoseTree t] deriving (Show, Eq)
```

Cuando la lista es vacía asumimos que tenemos una hoja.

2. **Escribir el esquema de recursión estructural para `RoseTree`. Importante escribir primero su tipo**.

Siguiendo la sugerencia primero el tipo:

```haskell
foldRose :: (a -> [b] -> b) -> RoseTree a -> b
```

A priori no necesito caso base porque las hojas son cuando la lista es vacía, se puede manejar con la misma función.

Luego la definición:

```haskell
foldRose f (Nodo a ts) = f a (map (foldRose f) ts)
```

Extra: con `foldRose` puedo definir `mapRose`:

```haskell
mapRose :: (a -> b) -> RoseTree a -> RoseTree b
mapRose f = foldRose (Nodo . f)
-- equivalente a 
-- mapRose f = foldRose (\nodo recs -> Nodo (f nodo) recs)
```

3. **Usando el esquema definido, escribir las siguientes funciones:**
    - a. `hojas`, que dado un `RoseTree`, devuelva la lista con sus hojas ordenadas de izquierda a derecha según su aparición en el `RoseTree`

    ```haskell
    hojas :: RoseTree a -> [a]
    hojas = foldRose (\nodo recs -> if null recs then [nodo] else concat recs)
    ```

    - b. `distancias`, que dado un `RoseTree`, devuelva las distancias de su raíz a cada una de sus hojas.

    ```haskell
    distancias :: RoseTree a -> [Integer]
    distancias = foldRose (\nodo recs -> if null recs then [0] else concat (map (+1) recs))
    ```

    - c. `altura`, que devuelve la altura de un `RoseTree` (la cantidad de nodos de la rama más larga). Si el `RoseTree` es una hoja, se considera que su altura es 1.

    ```haskell
    altura :: RoseTree a -> Integer
    altura = foldRose (\nodo recs -> if null recs then 1 else 1 + maximum recs)
    ```

### Ejercicio 24 ★

Las máquinas de estados no determinísticas (MEN) se pueden ver como una descripción de un sistema que,
al recibir como entrada una constante de un alfabeto (que en general llamamos \\(\Sigma\\)), y encontrándose en un
estado q, altera su estado según lo indique una función de transición (que en general llamamos \\(\delta\\)). Observemos
que al ser una máquina no determinística, el resultado de esta función de transición no es un único estado sino
un conjunto de ellos.
Modelaremos estos autómatas mediante el tipo `MEN`:

```haskell
data MEN a b = AM { sigma :: [a], delta :: (a -> b -> [b])}
```

Luego, el sistema representado por `m :: MEN a b` que se encuentra en un estado
`q :: b`, después de recibir una entrada `s :: a` tal que `s ∈ sigma m`, se
encontrará en alguno de los estados `delta m s q` (si esta lista es vacía
significa que `s` es una transición inválida, mientras que si contiene muchos
estados, significa que puede alcanzar cualquiera de ellos, sin que podamos
suponer nada sobre cuál será). Por ejemplo,:

![](./img/practica_1_ej_24.png#center)

```haskell
mPlp :: MEN Char Char
mPlp = AM ['l', 'p'] tran
    where tran s e | e == q_0 && s == 'p' = [q_1]
                    | e == q_1 && s == 'l' = [q_2, q_3]
                    | e = q_2 && s == 'p' = [q_3]
                    | otherwise = []
```

Se pide definir las siguientes funciones, **sin usar recursión explícita** (suponer que existe `union` que es como `++` pero sin repetidos):

1. **`agregarTransicion :: a -> b -> b -> MEN a b -> MEN a b` que, dada una
   constante `s` y dos estados `q_0` y `q_f`, agrega al autómata la transición
   por `s` desde `q_0` a `q_f`. Si lo necesita, puede suponer que la transición
   no está previamente definida en el autómata, que `s` ya pertenece al
   alfabeto y que está definida la igualdad para los tipos `a` y `b`, indicando
   qué suposiciones realiza**.

    Primero tenemos que entender bien cómo funciona esta definición de autómata.

    - El tipo `a` de `MEN a b` va a definir los caracteres que acepta
    - El tipo `b` va a representar los estados, que por simplicidad puede que
      asuma que son de tipo `Char` siempre, pero puede ser de cualquier tipo,
      la verdad es indistinto
    - Entonces, si quiero agregar una transición lo único que tengo que hacer
      es redefinir la función delta para que además de los estados a los que ya
      te lleva, sumarle el de la transición agregada (en caso de matchear).

    ```haskell
    agregarTransicion :: Eq a => Eq b => a -> b -> b -> MEN a b -> MEN a b
    agregarTransicion a b c AM { sigma, delta } = AM { sigma, delta = \x y -> (if x == a && y == b then [c] else []) ++ delta x y }
    ```

2. **`interseccion :: Eq a => MEN a b -> MEN a c -> MEN a (b, c)` que dados dos
   autómatas `m` y `n`, devuelve el autómata intersección, cuyo alfabeto es la
   unión de los dos alfabetos, cuyos estados son el producto cartesiano del
   conjunto de estados de cada uno y que puede moverse de `(q_m, q_n)` por el
   símbolo `s` al estado `(q_m', q_n')` si y solo si `m` puede moverse de `q_m`
   a `q_m'` por `s` y `n` puede moverse de `q_n` a `q_n'` por el mismo `s`**.

   ```haskell
    interseccionMEN :: Eq a => MEN a b -> MEN a c -> MEN a (b, c)
    interseccionMEN (AM { sigma = sigma1, delta = delta1 }) 
                    (AM { sigma = sigma2, delta = delta2 }) = AM { 
                      sigma = union sigma1 sigma2, 
                      delta = \x (y, z) -> [(q, q') | q <- delta1 x y, q' <- delta2 x z] 
                    }
   ```

3. **`conTrampa :: b -> MEN a b -> MEN a b`** que, dados un estado `q` y un
   autómata, devuelve un autómata equivalente con el estado trampa `q`
   agregado. Un estado trampa es un estado especial al que se accede después de
   realizar una transición indefinida y del que no se puede salir. Por ejemplo,
   el autómata `conTrampa M_plp`, al leer las cadenas "slp", "pnp", "snp" o
   "plpxxxxxxxxxx" (entre otras), debe terminar en el estado trampa, pues todas
   incluyen por lo menos una transición indefinida.

   ```haskell
    conTrampa :: b -> MEN a b -> MEN a b
    conTrampa q (AM { sigma, delta }) = AM {
                                        sigma,
                                        delta = \x y -> let next = delta x y
                                            in if null next then q else next
                                    }
   ```

   Lo único negativo de esto es que alguien podría agregarle transiciones
   salientes del estado trampa a otro y deja de ser trampa (restricciones de la
   forma en la que implementamos delta).

4. **`consumir :: Eq a => Eq b => MEN a b -> b -> [a] -> [b]` que, dados un autómata `m`, un
   estado `q`, y una cadena de símbolos `ss` (en ese orden), devuelve todos los
   estados en los que se puede encontrar `m` después de haber leido los símbolos
   de `ss` (en ese orden), habiendo partido del estado `q`. Recordar que el
   autómata es no determinístico y, por ende, para cada símbolo y estado, la
   función de transición `delta` devuelve una lista de estados posibles a los que
   se puede mover. Si lo necesita, puede suponer definida la igualdad para los
   tipos `a` y `b`.**.

   Para esto me gustaría usar un fold, pero el problema que tiene el foldr es que procesa al revés de como quiero. Así que puedo, o bien hacerle un reverse a `ss`.

   ```haskell
    consumir :: Eq a => Eq b => MEN a b -> b -> [a] -> [b]
    consumir (AM { sigma, delta }) q ss = foldr (\c rec -> concat (map (delta c) rec)) [q] (reverse ss)
   ```

   O directamente usar `foldl`:

   ```haskell
    consumir :: Eq a => Eq b => MEN a b -> b -> [a] -> [b]
    consumir (AM { sigma, delta }) q = foldl [q] (\rec c -> concat (map (delta c) rec))
   ```

5. **`trazas :: Eq a => Eq b => MEN a b -> b -> [[a]]`** que  dado un autómata `m` y un estado `q`,
   devuelve la lista con todas las trazas posibles en `m` a partir de `q`, es
   decir, todas las cadenas de símbolos que pueden llevar a `m` desde `q` a algún
   estado mediante transiciones válidas. Asumir que existe al menos un ciclo en
   el autómata, por lo que la lista resultante es infinita. Si lo necesita,
   puede suponer que tanto el alfabeto como el resultado de las transiciones
   son finitos, y que está definida la igualdad para los tipos `a` y `b`. Deberá
   indicar qué suposiciones realiza y por qué. En el autómata de ejemplo,
   `trazas mPlp q_0  ~> [['p'], ['p', 'l'], ['p', 'l', 'p']]`

   ```haskell
    trazas :: Eq a => Eq b => MEN a b -> b -> [[a]]
    trazas (AM { sigma, delta }) q = concat (generateBase stop start next)
        where start = [[e] | e <- sigma, not (null (delta e q))]
              stop traces = not (null traces) && null (last traces)
              next current_traces = [ newTrace | 
                                      trace <- current_traces,
                                      e <- sigma, 
                                      let newTrace = trace ++ [e], 
                                      not (null (consumir (AM { sigma, delta }) q newTrace))
                                    ]
   ```

   (llegué a esta solución y me di cuenta tarde de que `generateBase` no se banca generación infinita, si alguien quiere mandar un PR con un generateBase que pueda usar para generar listas infinitas mande un PR y será revisado).
