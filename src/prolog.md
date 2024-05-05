$$
   \newcommand{\true}{\mathbf{T}}
   \newcommand{\false}{\mathbf{F}}
   \newcommand{\satisf}{\models}
   \newcommand{\notsatisf}{\nvDash}
   \newcommand{\set}[1]{\lbrace #1 \rbrace}
   \newcommand{\tuple}[1]{< #1 >}
$$
# Prolog

Prolog usa el mecanismo de [resolución SLD](./sld_solv.md) con algunas restricciones más para achicar el espacio de búsqueda:

- regla de búsqueda (recuerdo: qué cláusulas elegir para la resolvente?): se seleccionan las cláusulas de programa de arriba hacia abajo en el orden en el que son introducidas.
- regla de selección (recuerdo: qué literales elimino una vez elegidas las cláusulas?): seleccionar el átomo de más a la izquierda

> Nota: la suma de regla de búsqueda y regla de sellección se conoce como
> **estrategia**, y cada estrategia te determina un árbol de búsqueda o **árbol
> SLD**.

## Arbol SLD

Debido a la estrategia usada por prolog, es posible que al elegir una de las
cláusulas de definición no "lleguemos a buen puerto". O sea que llegue a un
punto en donde se "traba" porque no puedo elegir otra cláusula para unificar /
vuelvo a un paso anterior. Ahí es donde la estrategia a usar es la de un
backtracking. Si unifiqué con la cláusula de más arriba y no me anduvo pruebo
con la siguiente.

Esto lo podemos ver entonces con un arbol de backtracking en el que vamos
llegando a hojas en donde falla, y hojas en donde se llega a una refutación
(usamos el camino de la raíz a la hoja).

![](./img/arbol_sld.png#center)

Esto significa que si construyo el árbol SLD obtengo como resultado un conjunto
de instanciaciones/sustituciones que muestran que la fórmula es
insatisfactible. Pero más aún, con cada uno podría construir distintos valores
que satisfacen la fórmula que quiero (recuerdo que yo quiero saber si algo es
satisfactible y pruebo la insatisfactibilidad para su negación).

Notar que el árbol se construye en base a qué cláusula uso para la resolvente,
pero no para cuál elimino (la regla de selección). Ahora, qué cambio variando
la regla de selección? obtengo nuevos árboles. O sea que la regla de búsqueda
me arma el árbol y la regla de selección me arma distintos árboles. Si vemos el
mismo ejemplo de antes, pero ahora eligiendo en la regla de búsqueda el término
de más a la derecha:

![](./img/arbol_sld_derecha.png#center)

> Esto deja en claro cómo la regla de búsqueda impacta en la performance! Si
> sigo siempre usando la misma regla de búsqueda en este caso diverge. 

Otra cosa a observar es que si bien en algunos casos puede diverger, el árbol
eventualmente va a generar las mismas soluciones.

## Programas lógicos

Recuerdo que SLD parte de un conjunto de cláusulas \\(S = P \cup \set{G}\\) donde

- \\(P\\) es un conjunto de cláusulas de definición con exactamente un literal positivo
- \\(G\\) es una cláusula negativa llamada el goal.

Si nos concentramos un momento en \\(P\\) podemos ver de qué pinta son las cláusulas:

$$
\begin{align}
V \lor \neg A_1 \lor \dots \lor \neg A_n &\iff \neg(A_1 \land \dots \land A_n) \lor B \\\\
&\iff (A_1 \land \dots \land A_n) \supset B 
\end{align}
$$

Por lo tanto en prolog vamos a definirlos como:

- `B :- A_1, ..., A_n.` (reglas)
- `B.` (hechos)

Es decir que los programas de prolog codifican implicaciones.

Luego, si miramos el goal lo que hacemos con prolog es probar alguna propiedad. Por ejemplo "existe V tal que ...". En ese caso lo que terminamos intentando demostrar es que **los programas previamente definidos implican esa propiedad**. Supongamos que la propiedad es un \\(\bar{Q} = \exists x_1. \dots \exists x_n. Q\\). En ese caso:

$$
\begin{align}
P \implies \bar{Q} \text{ es satisfactible } &\iff \neg(P \implies \bar{Q}) \text{ es insatisfactible } \\\\
&\iff \neg(\neg P \lor \bar{Q}) \\\\
&\iff P \land \neg \bar{Q} \\\\
&\iff P \land Q' \text{ donde } Q' = \forall x_1. \dots \forall x_n. \neg Q \\\\
\end{align}
$$

Ese \\(Q'\\) pasa a ser el goal de la resolución SLD y tenemos \\(S = P \cup Q'\\)

### Ejemplo (ya en notación prolog)

```prolog
add(U,0,U).
add(X,succ(Y),succ(Z)) :- add(X,Y,Z). % Si X + Y = Z => X + succ(Y) = succ(Z)
```

Ingresamos el goal

```prolog
?- add(succ(0), V, succ(succ(0))). % Existe un V tal que 1 + V = 2?
```

La respuesta es:

```prolog
V = succ(0)
```

En prolog te da una solución pero le podés ir pidiendo más, a lo que prolog va a ir generando el árbol SLD hasta que no queden más soluciones.

### Ejemplo 2

```prolog
hijo(fred, sally).
hijo(tina, sally).
hijo(sally, john).
hijo(sally, diane).
hijo(sam, bill).
hermanos(A, B) :- hijo(X, A), hijo(X, B), A \= B
```

Ingresamos el goal

```prolog
?- hermanos(john, X)
```

En ese caso la resolución SLD da como resultado la sustitución `{ X <- diane }`

### Corrección y completitud

El sistema de prolog también es correcto y completo sobre los predicados que
respetan el formato de \\(P \cup \set{G}\\) (recuerdo: Prolog era una versión
aún más restringida de la resolución SLD antes vista)

### Búsquedas de refutaciones SLD en prolog

- prolog recorre el árbol SLD en profundidad (dfs)!
- eso significa que se puede implementar de forma eficiente
    - usa una pila para los átomos del goal
        - push del resolvente del átomo del tope de la pila con la cláusula de definición
        - pop cuando el átomo del tope de la pila no unifica con ninguna cláusula
- una desventaja clara es que puede no encontrar una refutación SLD aunque exista porque se queda loopeando infinitamente

## Bonus Track

Prolog ofrece 2 mecanismos extra lógicos que interactúan con la forma que tiene prolog de demostrar cosas.

- `Cut`, que permite realizar podas al árbol SDL (ya sea para evitar loops infinitos o simplemente evitar caminos innecesarios).
- Deducción de información negativa `Not`, que nos permite poder hablar de negaciones (hasta ahora todo lo que vimos para las cláusulas de los programas es todo positivo, algo es verdadero o algo implica algo).

### `Cut`

- Es un predicado 0-ario (notado `!`), siempre unifica y no necesita de otra cláusula para avanzar. Directamente es consumido.
- sólo tiene éxito la primera vez que se invoca
- decimos que es extra-lógico porque no se corresponde con un predicado estándar de la lógica
    - considerando que poda el árbol de soluciones, podemos estar perdiendo soluciones. Por ende hay que usar con cuidado.

#### Ejemplo 1 - Usar para podar soluciones

```prolog
1. p(a).
2. p(b).
3. p(c).
4. q(a, e).
5. q(a, f).
6. q(b, f).
```

Qué pasa si hiciéramos `p(x)`?

```prolog
?- p(x).
x=a; x=b; x=c;
no
```

Si hiciéramos `p(x), !.`?

```prolog
?- p(x), !.
x=a;
no
```

> por qué? Porque la primera vez que buscamos resolver `{ ! }` (inicialmente se
> unificó `p(x)` con `p(a)`), se resuelve ok y se llega a la refutación pero el
> resto de las veces falla. Por ende nos quedamos únicamente con la primer
> solución.
>
> ![](./img/cut_sld_1.png#center)

Y `p(x), q(X,Y).`?

```prolog
?- p(x), q(x, y).
x=a, y=e;
x=a, y=f;
x=b, y=f;
no
```

`p(x), !, q(X,Y).`?

```prolog
?- p(x), !, q(x, y).
x=a, y=e;
x=a, y=f;
no
```

> en este caso, se unifica `p(x)` y le sigue el cut. Eso medio que tiene como
> resultado que el x quede fijo, y sólo se desarrolla el subárbol SLD con `x = a`
>
> ![](./img/cut_sld_2.png#center)

TODO: Ver este ejemplo

```prolog

1. p(a).
2. p(b).
3. p(c).
4. q(a, e).
5. q(a, f).
6. q(b, f).
7. r(x, y) :- p(x), !, q(x, y).
```

### Ejemplo 2 - usar a modo de optimización

Veamos la siguiente definición de `max`:

```prolog
max1(X, Y, Y) :- X =< Y.
max1(X, Y, X) :- X > Y.
```

Es ineficiente, pero por qué?

### Cut - Generalidades

- Cuando se selecciona un cut, tiene éxito inmediatamente
- Si, debido a backtracking, se vuelve a ese cut, su efecto es el de hacer fallar el goal que le dio origen
- El efecto resultante es descartar soluciones de:
    - otras cláusulas del goal padre
    - cualquier goal que ocurre a la izquierda del corte en la cláusula que contiene el corte
    - todos los objetivos intermedios que se ejecutaron durante la ejecución de los goals precedentes

### Negación por falla

Motivación: En el programa \\(P\\), puedo escribir hechos o reglas (que son implicaciones). Pero no tengo forma de escribir la negación para decir que algo no ocurre.

- Se dice que un árbol SLD falla finitamente si es finito y no tiene ramas de éxito
- Dado un programa \\(P\\) el conjunto de falla finita de P son los átomos cerrados tales que si armo el árbol SLD usando el átomo como raíz no tengo ramas de éxito.
    - todos esos átomos cerrados implican la negación del átomo

Esto nos habilita una forma nueva de razonar que en prolog se implementa con el predicado not:

```prolog
not(G) :- call(G), !, fail.
not(G).
```

Esto lo que dice es:

- Si unificás con la primer regla
    - primero intentá evaluar `G`.
    - en caso de poder resolverlo, hacés un cut e inmediatamente después fallás.
    - como agregaste el cut, eso ya te corta todas las otras posibilidades de backtracking.
- Si unificás con la otra regla automáticamente vale eso
    - per sólo voy a unificar con la segunda regla si no pude hacer válido el `G` (porque si no el `!` me cortaba cualquier otro chequeo)

~~~admonish example title="Ejemplo"

Puedo deducir `not(student(mary))` a partir de

```prolog
student(joe).
student(bill).
student(jim).
teacher(mary).
```

~~~

#### Negación por falla **no** es negación lógica

Veamos este ejemplo:

```prolog
animal(perro).
animal(gato).
vegetal(X) :- not(animal(X)).
```

- La consulta `vegetal(perro)` da false, como es esperado
- La consulta `vegetal(pasto)` da si, como es esperado
- Qué devuelve la consulta `vegetal(X)`? Devuelve `false`
    - Nos gustaría que nos devuelva por ejemplo `lechuga`, pero no hay
      definido. El problema es que si recordamos, necesitamos el término
      cerrado de la negación por falla. Al hacer `vegetal(X)` permitimos que se
      instancie con cualquier valor.
- Qué pasa con `not(not(animal(X)))`? `true`

TLDR: Estos predicados que usan el `not` de la negación por falla requieren que esté instanciado lo que yo quiero negar.

Otro ejemplo:

```prolog
firefighter_candidate(X) :- not ( pyromaniac(X) ), punctual(X).
pyromaniac(attila).
punctual(jeanne_d_arc).
```

Qué devuelve `firefighter_candidate(W)`?

De vuelta tengo el problema de llamar al not con algo que no está instanciado! Me da `false`!

Y si lo doy vuelta?

```prolog
firefighter_candidate(X) :- punctual(X), not ( pyromaniac(X) ).
pyromaniac(attila).
punctual(jeanne_d_arc).
```

Ahora el `punctual(X)` me instancia primero el `X` y después se resuelve de la forma esperada devolviendo `X = jeanne_d_arc`
