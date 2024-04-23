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
