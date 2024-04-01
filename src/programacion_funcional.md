# Programación Funcional

Si bien vamos a ver todo con lenguaje "haskelloso", la mayoría de conceptos
aplican a los lenguajes funcionales en general. Vamos a ver más formal el
modelo de cómputo de lenguajes funcionales cuando veamos cálculo lambda.

- Programar: Definir funciones
- Ejecutar: Evaluar expresiones

    ```
    # Programando
    factorial(1) = 1
    factorial(n) = factorial(n - 1) * n


    # Evaluando
    factorial(4) => factorial(3) * 4 
                 => factorial(2) * 3 * 4 
                 => factorial(1) * 2 * 3 * 4
                 => 1 * 2 * 3 * 4
                 => 6 * 4
                 => 24
    ```

- Un programa es un conjunto de ecuaciones
- Expresiones 
    - Si se puede definir, toda expresión denota un valor
    - El valor depende únicamente del valor de sus subexpresiones
    - Evaluar/Reducir una expresión es obtener su valor (en el ejemplo `factorial(4) ~> 24`)
    - No toda expresión denota un valor (si no puedo reducir no tengo un valor)
- Valores
    - Los podemos pensar como expresiones que no se pueden seguir reduciendo

## Tipos

En Haskell organizamos los valores en **tipos**. El tipo tiene operaciones asociadas. En haskell se tienen:

- tipos básicos: `Int`, `Char`, `Float`, `Bool`
- tipos compuestos: 
    - Listas: `[Int]`
    - Tuplas: `(Int, Bool)`
    - Funciones: `Int -> Int`
- **todo expresión bien formada tiene un tipo asociado** (esto también, más
  adelante vamos a ver que si no se le puede otorgar tipo a una expresión
  entonces no se va a poder reducir) y el tipo depende del tipo de sus
  subexpresiones.

## Funciones

```admonish title="Definición"

- Definición con ecuación orientada:

    ```haskell
    doble :: Int -> Int
    doble x = x + x
    ```

- Definición con guardas:

    ```haskell
    signo :: Int -> Bool
    signo n | n >= 0    = True
            | otherwise = False
    ```

- Definiciones locales:

    ```haskell
    f(x, y) = g x + y
            where g z = z + 2
    ```

- Expresiones Lambda:

    ```haskell
    -- con un parámetro
    \x -> x + 1
    -- con muchos parámetros
    \x -> \y -> x + y
    -- escritura más simple, separo parámetros con espacios
    \x y -> x + y
    ```

```

## Polimorfismo paramétrico

Dada la siguiente función `id`, cuál es su tipo?

```haskell
id x = x
```

Rta: `id :: a -> a`, donde `a` es una variable de tipo (es algo así como un meta-tipo)

## Clases de Tipos

Cuál es el tipo de `máximo`?

```haskell
maximo x y | x > y      = x
maximo _ y              = y
```

Puedo probar de evaluar a `máximo`:

```bash
# La evalúo con enteros y funciona
> maximo 1 2
2
# La evalúo con decimales y también funciona
> maximo 1.2 3.4
3.4
```

Una **clase** es una suerte de interface que define un conjunto de operaciones. Por ejemplo:

- `Eq`: `(==)`, `(/=)`
- `Ord`: `(<)`, `(<=)`, `(>=)`, `(>)`, `max`, `min`, `compare`

pVolviendo a `maximo`, tenemos que `maximo :: Ord a => a -> a -> a`. O sea que
en máximo puedo recibir cualquier tipo en tanto pertenezca a la clase `Ord`
(cosa de tener el comparador)

## Instancia de una clase de tipos

Notar que haskell permite usar el `deriving` que deriva automáticamente una
"implementación por default" de todas las funciones de `Eq`. En el caso de `Eq`
compara cada caso, si es `Circulo` compara el valor, y si es `Rectangulo`
compara ambos valores.

```haskell
data Figura = Circulo Float | Rectangulo Float Float
deriving Eq
```

Pero también se pueden definir instancias con la lógica que quiera:

```haskell
instance Ord Figura where
    (<=) = \x -> \y -> area x <= area y
```

## Alto Orden

En haskell, las funciones son lo que se conoce como first-class citizens, eso
significa que las funciones **son un valor más**. O sea que podés pasarlas como
parámetro, pueden ser el resultado de una función.

Por ejemplo, a `id` le puedo pasar `id`. Entonces, cuál sería el tipo de `id id`? 

El tipo es `(id id) :: a -> a`

## Currificación

Veámoslo con 2 ejemplos:

```haskell
suma :: ??
suma x y = x + y

suma' :: ??
suma' (x, y) = x + y
```

Si reviso los tipos obtengo que:

```haskell
suma :: Int -> Int -> Int
suma' :: (Int, Int) -> Int
```

Cuál es la diferencia? Que la primera implementación puedo hacer por ejemplo
`suma 5` y obtengo una función que incrementa en 5. Eso no lo puedo hacer con
`suma'`. Esta feature de poder evaluar parcialmente las funciones es lo que se
conoce como **currificación**.

![](./img/currification.png#center)

(No, ese Curry no...)

Veamos cómo se ve esto en ghci:

```
> :type suma
suma :: Int -> Int -> Int
> :type suma 4
(suma 4) :: Int -> Int
```

O sea que puedo definir por ejemplo `inc = suma 1`

### Viendo curry/uncurry como una función

```haskell
curry :: ((a, b) -> c) -> (a -> (b -> c))
curry f = \x -> \y -> f (x,y)
-- versión alternativa --
curry f x = \y -> f (x, y)

uncurry :: (a -> b -> c) -> ((a, b) -> c)
uncurry f (a, b) = f x y
```
## Tipos Algebráicos

Puedo definir los tipos por enumeración definiendo:

- el nombre del tipo
- los constructores


```haskell
data Dia = Lunes | Martes | Miercoles | Jueves | Viernes | Sabado | Domingo

data Bool = True | False
```

Los constructores también pueden tener parámetros. En la definición tengo que aclarar los tipos de sus argumentos:

```haskell
data Figura = Circulo Float | Rectangulo Float Float
```

Algunos ejemplos de tipos:

- `Lunes :: Dia`
- `Circulo 1.0 :: Figura`
- `Circulo :: Float -> Figura`

## Pattern matching

Es un mecanismo para comparar un valor con un patrón y deconstruir un valor en
sus partes. Por ejemplo:

```haskell
area :: Figura -> Float
area (Circulo radio) = PI * radio^2 
area (Rectangulo base altura) = base * altura
```

Si no hay un match directo, lo que va a hacer haskell es seguir reduciendo.
Eventualmente va a matchear o no se va a poder reducir la expresión (y vamos a
tener un error).

```admonish info title="El patrón debe ser lineal"

- **Lineal** quiere decir que una variable debe aparecer una única vez a la izquierda.

    ```haskell
    esCuadrado :: Figura -> Bool
    esCuadrado (Circulo _) = False
    esCuadrado (Rectangulo x y) | x == y =>     = True
                                | otherwise     = False
    -- alternativa
    esCuadrado (Rectangulo x y) | x == y =>     = True
    esCuadrado _                                = False

    -- alternativa también valida
    esCuadrado (Rectangulo x y) = x == y
    esCuadrado _                = False
    ```

- `esCuadrado (Rectangulo x x)` sería más simple pero no está permitido en
  haskell (ej: en erlang/elixir esto es posible)

Observaciones:

- `_` coincide con cualquier forma (ver que en la alternativa agarro tanto el caso de `Circulo` como el de `Rectangulo` que no es cuadrado)
- los casos se evalúan en el orden que están escritos
- Puedo definir funciones parciales:

    ```haskell
    -- en este caso radio (Rectangulo _ _) va a dar error
    radio (Circulo radio) = radio
    ```
```

## Tipos Recursivos

La definición de un tipo tpuede tener uno o más parámetros de tipo:

```haskell
data Natural = Zero | Succ Natural

Zero :: Natural
Succ Zero :: Natural
Succ (Succ (Succ Zero)) :: Natural
```

## Listas

Es un tipo algebráico paramétrico y recursivo con 2 constructores:

```haskell
[] :: [a]               -- Constructor de la lista vacía
(:) :: a -> [a] -> [a]  -- Append Front
```

Ejemplos de pattern matching:

```haskell
esVacia :: [a] -> Bool
esVacia [] = True
esVacia _ = False
```

```haskell
longitud :: [a] -> Int
longitud [] = 0
longitud (x:xs) _ = 1 + longitud xs
```

## No terminación y orden de evaluación

Veamos la siguiente función:

```haskell
inf1 :: [Int]
inf1 = 1 : inf1
```

Se reduce infinitamente, entonces para qué quiero tener algo así? De qué me sirve? Veamos esta función:

```haskell
const :: a -> b -> a
const x y = x
```

Qué pasa si hago `const 42 inf1`? Da 42. Pero en realidad depende del mecanismo
de reducción que tenga el lenguaje, porque haskell resuelve primero el pattern
matching en lugar de reducir los parámetros. Si no me quedaba reduciendo
infinitamente.

### Evaluación Lazy (Orden Normal)

- Tiene que ver con el modelo de cómputo que usa haskell, que es el de la
  `Reducción`
    - Se reemplaza un redex (expresión reducible) por otra usando las
      ecuaciones orientadas. Un redex es una sub-expresión que no esté en forma
      normal.
    - El redex tiene que ser una instancia del lado izquiero de alguna de las
      ecuaciones (si no da error), y se reemplaza por el lado derecho asociando
      las variables correspondientes.
    - El resto de la expresión no cambia
- La evaluación Lazy, consiste en seleccionar las funciones más externas y
  luego los argumentos (pero sólo si se necesitan)

## Ejercicios

### Ejercicio 1

Definir `dobleL :: [Float] -> Float` tal que `doble xs` es la lista que contiene el doble de cada elemento en xs

```haskell
doble [] = []
doble x:xs = (x * 2) : (doble xs)
```

### Ejercicio 2

Definir `esPar :: [Int] -> [Bool]` tal que `esParL xs` indica si el correspondiente elemento en xs es par o no

```haskell
esPar [] = []
esPar x:xs = (even x) : (esPar xs)
```

### Ejercicio 3

Definir `longL :: [[a]] -> [Int]` tal que `longL xs` es la lista que contiene las longitudes de las listas en xs

```haskell
longL [] = []
longL x:xs = (length x) : (longL xs)
```

```admonish title="Generalizando..."

- Notar que en los ejercicios el patrón era siempre el mismo con la diferencia de que en el primero hacíamos `* 2`, en el segundo `even x` y en el tercero `length x`
- Podemos generalizar este comportamiento (gracias funciones de alto orden!) en la siguiente función:

    ```haskell
    map :: (a -> b) -> [a] -> [b]
    map _ [] = []
    map f x:xs = (f x) : (map f xs)
    ```
- Podemos redefinir las funciones de antes con `map`:

    ```haskell
    -- Ni tengo que agregar el parámetro a la definición!
    doble = map (\x -> 2 * x)
    esPar = map even
    longL = map length
    ```

```

### Ejercicio 4

Definir `negativos :: [Float] -> [Float]` tal que `negativos xs` contiene los elementos negativos de xs

```haskell
negativos [] = []
negativos x:xs  | x < 0     = x : (negativos xs)
                | otherwise = negativos xs
```

### Ejercicio 5

Definir `noVacias :: [[a]] -> [[a]]` tal que `noVacias xs` contiene las listas no vacías de `xs` 

```haskell
noVacias [] = []
noVacias x:xs   | length x > 0     = x : (noVacias xs)
                | otherwise = noVacias xs
```

```admonish title="Generalizando..."

- Notar que en los ejercicios el patrón era siempre el mismo: el caso base
  devuelve vacío, y para el otro chequeo una condición booleana para saber si
  agregar o no.
- Podemos generalizar este comportamiento (gracias funciones de alto orden again!) en
  la siguiente función:

    ```haskell
    filter :: (a -> Bool) -> [a] -> [b]
    filter _ [] = []
    filter f x:xs   | (f x)     = x : (filter f xs)
                    | otherwise = filter f xs
    ```
- Podemos redefinir las funciones de antes con `filter`:

    ```haskell
    -- Ni tengo que agregar el parámetro a la definición!
    negativos = filter (\x -> x < 0)
    noVacias = filter (\x -> length x > 0)
    ```

```

## Transparencia referencial

Una propiedad de haskell (y otros lenguajes funcionales) es la de la
**transparencia referencial**. Esto qué significa? Que el resultado de evaluar
una expresión sólo depende de sus subexpresiones. Eso tiene la implicancia de
que si yo tengo 2 veces la misma subexpresión ambas van a evaluar al mismo
valor.

Un ejemplo para ver qué no tiene transparencia referencial es en un lenguaje imperativo como C puedo hacer:

```c
algunaFuncion(x++, x++);
```

Estoy llamando a `algunaFuncion` y los parámetros son ambos `x++` pero no van a
tener el mismo valor.
