# Cálculo Sigma

Vamos a ver una formalización del cálculo de objetos (parcial)

- Basada en la formalización de Abadi & Cardelli del 98'
- Basáda en semántica operacional big step (recuerdo: son dar pasos grandes para llegar al resultado) 
- **No tipado** (y con un aire a funcional)
    - En el mismo libro de Abadi&Cardelli dan una versión imperativa
- Objetos como única estructura computacional
    - son colecciones de atributos (como los registros del funcional)
    - **todos** los atributos son métodos
- Cada método tiene una única variable ligada que representa a `self/this` y un cuerpo que produce un resultado.
- Los objetos proveen 2 operaciones:
    - envío de mensajes
    - redefinición de un método (actualizar atributos, a.k.a modificar el estado)

## Sintaxis

$$
\begin{alignat}{2}
o,b ::=\& x\ &\text{variable} \\\\
|&\ \[l_i = \zeta(x_i)b_i^i\in{1\dots n}\] \ &\text{objeto} \\\\
|&\ o.l\ &\text{selección / envío de mensaje} \\\\
|&\ o.l \leftarrow \zeta(x)b\ &\text{redefinición de método}
\end{alignat}
$$

~~~admonish example title="Un objeto"

$$
o \stackrel{def}{=} \[l_1 = \zeta(x_1)[],\ l_2 = \zeta(x_2).l_1\]
$$

\\(o\\) tiene 2 métodos:

- \\(l_1\\) retorna un objeto vacío \\(\[\]\\)
- \\(l_2\\) es un método que envía el mensaje \\(l_1\\) a \\(\text{self}\\) (representado por \\(x_2\\))

~~~

## Atributos vs métodos

El cálculo \\(\sigma\\) no incluye explícitamente atributos. Peeeeero podemos definir atributos como métodos que no usan \\(\text{self}\\). En el ejemplo anterior, \\(l_1\\) era un atributo. De esta forma podemos interpretar que 

- un envío de mensaje puede ser la selección de un atributo
- redefinir un método puede ser modificar el atributo

Para simplificar la notación, tomamos algunos atajos:

- Definición de atributo: \\(\[\dots, l = b, \dots\]\\) lo usamos como abreviatura de \\(\[\dots, l = \zeta(x)b, \dots\]\\)
- Asignación de atributo: \\(o.l := b\\) lo usamos como abreviatura de \\(o.l \leftarrow \zeta(x)b\\)

## Variables Libres

Pdemos ver a \\(\zeta\\) como el ligador de \\(x_i\\) en el cuerpo \\(b_i\\) (similar a como hacíamos con \\(\lambda\\) en funcional) de la expresión \\(\zeta(x_i)b_i\\):

$$
\begin{align}
fv(\zeta(x)b) &= fv(b) \setminus \\{x\\} \\\\
fv(x) &= \\{x\\} \\\\
fv(\[l_i = \zeta(x_i)b_i^i\in{1\dots n}\]) &= \bigcup^{i\in1\dots n} fv(\zeta(x_i)b_i) \\\\
fv(o.l) &= fv(o) \\\\
fv(o.l \leftarrow \zeta(x)b) &= fv(o.l) \cup fv(\zeta(x)b)
\end{align}
$$

> Duda pendiente: en el último caso no tendría que sacarle las que estuviesen
> libres previamente en \\(o.l\\) y no estén libres en el método con el que se
> pisa?

Un término se dice **cerrado** si su conjunto de variables libres es vacío.

## Sustitución

Asumamos que c es alguna expresión arbitraria.

$$
\begin{align}
x\\{c/x\\} &= c \\\\
y\\{c/x\\} &= y \text{si} x \neq y \\\\
\[l_i = \zeta(x_i)b_i^i\in{1\dots n}\]\\{c/x\\} &= \[l_i = (\zeta(x_i)b_i)\\{c/x\\}^i\in{1\dots n}\] \\\\
o.l\\{c/x\\} &= (o\\{c/x\\}).l \\\\
(o.l \leftarrow \zeta(x)b)\\{c/x\\} &= (o.l\\{c/x\\}) \leftarrow (\zeta(x)b\\{c/x\\}) \\\\
\zeta(y)b\\{c/x\\} &= \zeta(y')(b\\{y'/y\\}\\{c/x\\}) \\\\
&\text{si } y' \notin fv(\zeta(y)b) \cup fv(c) \cup \\{x\\} \\\\
\end{align}
$$

(Notar que esto es parecido a las alfa conversiones del cálculo lambda)

~~~admonish info title="Equivalencia de términos"

- Los términos \\(\zeta(x)b\\) y \\(\zeta(y)(b\\{y/x\\})\\) con \\(y \notin fv(b)\\) se consideran equivalentes (\\(\alpha\\)-conversión)
- Dos objetos que difieren sólo en el orden de los componentes son equivalentes (vimos algo similar con subtipado de registros). Ej:
    - \\(o_1 \stackrel{def}{=} \[l_1 = \zeta(x_1)\[\],\ l_2 = \zeta(x_2)x_2.l_1\] \\)
    - \\(o_2 \stackrel{def}{=} \[l_2 = \zeta(x_2)x_2.l_1,\ l_1 = \zeta(x_1)\[\]\]\\)

~~~

## Semántica operacional

$$
v ::= \[l_i = \zeta(x_i)b_i^{i\in 1 \dots n}\]
$$

- La semántica operacional es big-step.
    - Esto significa que de una expresión vamos **a un valor** en un único paso.
- A diferencia de la semántica small-step, no obtengo los detalles de cómo se llega de un estado a otro.

El caso base de la reducción:

$$
\frac{}{v \rightarrow v} \[Obj\]
$$

La regla para la selección:

$$
\frac{o \rightarrow v'\ \ \ \ v' \equiv \[l_i = \zeta(x_i)b_i^{i \in 1 \dots n}\]\ \ \ \ b_j\\{v'/x_j\\} \rightarrow v\ \ \ \ j \in 1 \dots n}{o.l_j \rightarrow v} \[Sel\]
$$

Si el objeto reduce a un valor, tomo el body correspondiente al índice del
label seleccionado y al aplicar el reemplazo del self (en ese caso ya el valor
\\(v'\\)) reduzco al valor al que reduce la selección.

Y la regla para el update:

$$
\frac{o \rightarrow \[l_i = \zeta(x_i)b_i^{i \in 1 \dots n}\]\ \ \ \ j \in 1 \dots n}{o.l_j \leftarrow \zeta(x)b \rightarrow \[l_j = \zeta(x)b,\ l_i = \zeta(x_i)b_i^{i \in 1 \dots n - \\{j\\}}\]} \[Sel\]
$$

Pido que mi objeto reduzca a algún valor que sea un objeto. Al hacer el update
queda todo igual salvo la componente \\(j\\) que es reemplazada por el valor
que te dan \\(\zeta(x)b\\)

~~~admonish example title="Ejemplos"

![](./img/sigma_reduction.png#center)

- Lo desarrollo/expando de abajo para arriba
    - Si bien voy de abajo para arriba para demostrar, medio que el a qué reduce no lo conozco al final y después lo voy agregando
- Guiado por sintáxis

![](./img/sigma_reduction_2.png#center)

Un ejemplo más, qué pasa con \\(\[a = \zeta(x)x.a\].a \rightarrow \dots\\)? Loop infinito, es parecido al `fix \x: sigma.x`

~~~

# Extensiones

## Naturales

- Vamos a asumir que existen los objetos \\(true\\) y \\(false\\) que corresponden a los booleanos.
- Entonces, podemos definir al \\(zero\\) como:

$$
zero \stackrel{def}{=} \[ iszero = true,\ pred = \zeta(x)x, succ = \zeta(x)(x.iszero := false).pred := x\]
$$

Primero marco que ya no soy 0, y después pongo al objeto actual como el predecesor del objeto creado. Con esa definición podemos crear el resto de los números naturales a partir del 0:

$$
uno \stackrel{def}{=} zero.succ \rightarrow \[iszero = false, pred = zero, succ = \zeta(x)(x.iszero := false).pred := x\]
$$

Notar que la función `succ` nunca cambia en realidad, sólo `iszero` y `pred`.

$$
dos \stackrel{def}{=} uno.succ = zero.succ.succ \rightarrow \[iszero = false, pred = uno, succ = \zeta(x)(x.iszero := false).pred := x\]
$$

~~~admonish info title="Definiendo true y false"

Una impl suuuuper reducida sería

$$
true = \[and = f(x)f(y)y, or = f(x)f(y)x\] \\\\
false = \[and = f(x)f(y)x, or = f(x)f(y)y\]
$$

Pero antes hay que ver cómo hacemos para definir funciones con varios argumentos...

~~~

## Funciones

Vamos a poder codificar los términos del lambda-cálculo (sin tipado):

$$
M\ N\ |\ \lambda x.M\ | x
$$

Por qué querría eso? Bueno, como mencionamos en el ejemplo de true y false
anterior, necesitamos tener funciones con varios argumentos.

La idea es representar a las funciones como objetos también:

$$
\[arg = \dots, val = \dots\]
$$

- Al aplicar una función, primero asigno el argumento y después envío el mensaje `val` para que evalúe el cuerpo de la función.
- Con eso en cuenta, `f(v)` se traduce en `(o_f.arg := o_v).val`

### Función codificadora del cálculo lambda

Vamos a definir la codificación del LC en términos de nuestro lenguaje de objetos \\(\unicode{x27E6} - \unicode{x27E7} : M \rightarrow a\\)

$$
\begin{align}
\unicode{x27E6} x \unicode{x27E7} &\stackrel{def}{=} x \\\\
\unicode{x27E6} M\ N \unicode{x27E7} &\stackrel{def}{=} (\unicode{x27E6} M \unicode{x27E7}.arg := \unicode{x27E6} N \unicode{x27E7}).val \\\\
\unicode{x27E6} \lambda x.M \unicode{x27E7} &\stackrel{def}{=} \[ val = \zeta(y)\unicode{x27E6} M \unicode{x27E7}\\{y.arg/x\\}, arg = \zeta(y)y.arg \]\ y \notin fv(M) \\\\
\end{align}
$$

(No se cuelga porque al evaluar voy a pisar el valor de \\(arg\\))

## Métodos con parámetros

Usando el mecanismo de codificación, podemos extender ahora nuestro lenguaje para tener métodos que tomen parámetros además de self:

$$
\zeta(y) \unicode{x27E6} \lambda x.M \unicode{x27E7}
$$

Hacemos un abuso de notación igual y escribimos:

- \\(\lambda x.M\\) en lugar de \\(\unicode{x27E6} \lambda x.M \unicode{x27E7}\\) (ojo, el primer \\(\zeta\\) lo dejamos así queda claro cuál es el self)
- \\(M(N)\\) en lugar de \\(\unicode{x27E6} M\ N \unicode{x27E7}\\)

~~~admonish example title="Punto en el plano"

```
origen = [
    x = 0,
    y = 0,
    mv_x = self -> \d_x p.x := p.x + d_x,
    mv_y = self -> \d_y p.y := p.y + d_y
]
```

~~~

## Traits

Si usaron lenguajes como Rust, Haskell (Type Classes), Smalltalk se habrán
topado con traits. Los traits son colecciones de métodos. Otros lenguajes optan
por usar jerarquías de clases para agrupar funcionalidad pero en este caso el
trait no lo tengo asociado a un objeto, si no que algunos objetos implementan
algunos traits.

Nosotros nos vamos a concentrar en los que tienen la particularidad de que son
**stateless** o sea que no manejan estado, no usan `self`. 

Además, puedo combinar traits para generar interfaces más complejas. Por
ejemplo, puedo armar una función que recibe un parámetro cuya única restricción
es que implemente el trait `PartialEq` (que se pueda comparar) y el trait
`Display` (que se pueda imprimir en pantalla).

Un ejemplo de un trait formalizado:

$$
\begin{align}
CompT \stackrel{def}{=} \[ &eq = \zeta(t)\lambda(x)\lambda(y)(x.comp(y)) == 0, \\\\
&\ lt = \zeta(t)\lambda(x)\lambda(y)(x.comp(y)) < 0\]
\end{align}
$$

> Notar que si bien ambos métodos tienen el \\(t\\), no lo usa ninguno.

Por una cuestión de notación, omitimos el \\(\zeta(t)\\)

### Constructores a partir de traits

Podemos a partir de un trait \\(t = \[l_i = \lambda(y_i)b_i^{i \in 1 \dots n}\]\\) podemos definir un constructor de objetos.

$$
new \stackrel{def}{=} \lambda(z)\[l_i = \zeta(s)z.l_i(s)^{i \in 1 \dots n}\]
$$

La idea es que a partir del trait construya un objeto donde el self si importe en las funciones del trait. Veamos qué pasa cuando lo aplico a un trait fijado:

$$
\begin{align}
o &\stackrel{def}{=} new(t) \\\\
&= \[l_i = \zeta(s)t.l_i(s)^{i \in 1 \dots n}\] \\\\
&=_{\text{reemplazo t.l_i}} \[l_i = \zeta(s)(\lambda(y_i)b_i(s))^{i \in 1 \dots n}\] \\\\
&= \[l_i = \zeta(s)(b_i \\{ s / y \\})^{i \in 1 \dots n}\]
\end{align}
$$

Si usamos de ejemplo a `CompT` nos quedaría:

![](./img/trait_constructor.png#center)

> Notar que los métodos de 2 parámetros en métodos de 1 (con self bindeados)

## Clases

Con toda esta parafarnalia que vimos antes podemos definir clases dentro de nuestro modelo de objetos. Una clase es un trait que además provee un método `new`:

$$
\begin{align}
c \stackrel{def}{=} \[\ &new = \zeta(z)\[l_i = \zeta(s)z.l_i(s)^{i \in 1 \dots n}\]\], \\\\
&l_i = \lambda(s)b_i^{i \in 1 \dots n}\]
\end{align}
$$

> Notar que el new tiene bindeado el self, mientras que los `l_i` no (o más bien son stateless)

Luego,

$$
\begin{align}
o &\stackrel{def}{=} c.new \\\\
&\rightarrow \[l_i = \zeta(s)c.l_i(s)^{i \in 1 \dots n}\] \\\\
&= \[l_i = \zeta(s)b_i^{i \in 1 \dots n}\]
\end{align}
$$

~~~admonish example title="Ejemplo Contador"

![](./img/class_contador.png#center)

Notar que el trabajo nuestro debería ser definir el trait de abajo (que de hecho son definir las funciones normales, pero sin bindear self), y lo que va adentro del `new` es un reemplazo sintáctico

~~~

### Herencia

Supongamos que tenemos la clase \\(c\\):

$$
\begin{align}
c \stackrel{def}{=} \[\ &new = \zeta(z)\[l_i = \zeta(s)z.l_i(s)^{i \in 1 \dots n}\]\], \\\\
&l_i = \lambda(s)b_i^{i \in 1 \dots n}\]
\end{align}
$$

Y queremos definir \\(c'\\) como subclase de \\(c\\) que agrega los "pre-métodos" \\(\lambda(s)b_k^{k \in n+1 \dots n + m}\\)

$$
\begin{align}
c \stackrel{def}{=} \[\ &new = \zeta(z)\[l_i = \zeta(s)z.l_i(s)^{i \in 1 \dots n+m}\]\], \\\\
&l_i = c.l_j^{j \in 1 \dots n} \\\\
&l_k = \lambda(s)b_k^{k \in n+1 \dots n+m}\]
\end{align}
$$

- Los métodos los puedo definir a partir de la clase original
- Los nuevos métodos son simplemente nuevos pre-métodos
- La definición de `new` no cambia

También se podrían redefinir pre-métodos (sumo \\(l_k\\) y descarto los \\(l_i\\) viejos)
