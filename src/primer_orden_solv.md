$$
   \newcommand{\true}{\mathbf{T}}
   \newcommand{\false}{\mathbf{F}}
   \newcommand{\satisf}{\models}
   \newcommand{\notsatisf}{\nvDash}
   \newcommand{\set}[1]{\lbrace #1 \rbrace}
$$
# Repaso: Lógica de primer orden

## Lenguaje de primer orden

Un **lenguaje de primer orden (LPO)** \\(\mathcal{L}\\) consiste en:

1. Un conjunto numerable de **constantes** \\(c_0, c_1, \dots\\)
2. Un conjunto numerable de símbolos de **función con aridad** \\(n > 0\\) (indica el nro de argumentos) \\(f_0, f_1, \dots\\)
3. Un conjunto numerable de símbolos de **predicado con aridad** \\(n \geq 0\\), \\(P_0, P_1, \dots\\)

Por ejemplo, un lenguaje de primer orden para la aritmética sería:

- constantes: \\(0\\),
- Símbolos de función: \\(S, +, *\\)
- Símbolos de predicado: \\(<, =\\)

## Términos de primer orden

Los definimos de forma inductiva. Dado un conjunto de variables \\(\mathcal{V} = \set{x_0, x_1, \dots}\\) y \\(\mathcal{L}\\) un LPO. El conjunto de \\(\mathcal{L}\\)-términos se define como:

1. Toda constante de \\(\mathcal{L}\\) y toda variable es un \\(\mathcal{L}\\)-término.
2. Si \\(t_1, \dots, t_n \in \mathcal{L}\\)-términos y \\(f\\) es un símbolo de función de aridad \\(n\\), entonces \\(f(t_1, \dots, t_n) \in \mathcal{L}\\)-términos.

Siguiendo con el ejemplo de la aritmética, tendríamos los términos \\(S(0), +(S(0), S(S(0))), *(S(x_1), +(x_2, S(x_3)))\\)

## Fórmulas atómicas

Lo mismo que antes pero para predicados:

1. Todo símbolo de predicado de aridad 0 es una \\(\mathcal{L}\\)-fórmula atómica.
2. Si \\(t_1, \dots, t_n \in \mathcal{L}\\)-términos y \\(P\\) es un símbolo de predicado de aridad \\(n\\), entonces \\(f(t_1, \dots, t_n) \in \mathcal{L}\\)-fórmulas atómicas.

Again, tomando a la aritmética tendríamos por ejemplo \\(<(0, S(0)), <(x_1, +(S(0), x_2))\\)

## Fórmulas de primer orden

Dado un conjunto numerable de variables \\(\mathcal{V}\\) y \\(\mathcal{L}\\) un LPO. El conjunto de \\(\mathcal{L}\\)-fórmulas se define como:

1. Toda \\(\mathcal{L}\\)-fórmula atómica es una \\(\mathcal{L}\\)-fórmula.
2. Si \\(A, B \in \mathcal{L}\\)-fórmulas, entonces \\((A \land B), (A \lor B), (A \supset B), (A \iff B) y \neg A\\) son \\(\mathcal{L}\\)-fórmulas.
3. (cuantificadores) Para toda variable \\(x_i\\), y cualquier \\(\mathcal{L}\\)-fórmula A, \\(\forall x_i.A\\) y \\(\exists x_i.A\\) son \\(\mathcal{L}\\)-fórmulas

De vuelta pensando en la aritmética, tendríamos por ejemplo \\(\forall x. \forall y. (x < y \supset \exists z. y = x + z)\\)

## Variables libres y ligadas

- Los cuantificadores ligan variables
- Usamos \\(FV(A)\\) y \\(BV(A)\\) para referirnos a las variables libres y ligadas de \\(A\\) (F de free, B de bounded).
- \\(FV(A)\\) y \\(BV(A)\\) se pueden definir por inducción estructural (La noción es la misma que la que vimos para cálculo sigma o cálculo lambda, salvo que ahora estamos trabajando con el lenguaje del cálculo de primer orden).

Decimos que una fórmula está **rectificada** si 

- Su conjunto de variables libres y ligadas es disjunto (o sea no hay confución
  de qué es libre y qué ligado).
- Cuantifictintasadores distintos de la fórmula ligan variables dis

> Detalle no menor: toda fórmula se puede **rectificar** a una fórmula
> lógicamente equivalente (similar a lo que hicimos cuando vimos lambda
> cálculo).

## Sentencias

Una **sentencia** es una fórmula cerrada.

- muchos de los resultados se formulan para sentencias
- esto no suele tener pérdida de generalidad porque toda fórmula es lógicamente equivalente a su **clausura universal**.

~~~admonish info title="Clausura universal"

La clausura universal es aquella que tiene que tiene cuantificadores al principio para todas sus variables. Ej:

$$
\forall x. \forall y. P(x, y) \iff P(x, y)
$$

~~~

## Semántica

### Estructura de primer orden

La estructura viene a ser una forma de darle significado a nuestra lógica para
que las constantes correspondan a constantes, los símbolos de función a
funciones que corresponden a cierto dominio y a los predicados a predicados
booleanos definidos sobre un dominio.

Para un LPO \\(\mathcal{L}\\), una estructura para \\(\mathcal{L}\\), \\(\mathbf{M}\\) es un par \\(\mathbf{M} = (M, I)\\) donde:

- \\(M\\) (el dominio) es un conjunto no vacío
- \\(I\\) (la función de interpretación) asigna funciones y predicados sobre el dominio \\(M\\) a símbolos de \\(\mathcal{L}\\) de la siguiente manera:
    1. para toda constante \\(c\\), \\(I(c) \in M\\)
    2. para toda \\(f\\) de aridad \\(n > 0\\), \\(I(f): M^n \rightarrow M\\)
    3. para todo predicado \\(P\\) de aridad \\(n \geq 0\\), \\(I(P) : M^n \rightarrow \set{\true, \false}\\)

### Satisfactibilidad

~~~admonish info title="Asignación"

Para hablar de satisfactibilidad como lo hicimos para la lógica proposicional,
tenemos que hablar antes de las asignaciones. Dada \\(\mathbf{M}\\) una
estructura para \\(\mathcal{L}\\), una **asignación** es una función \\(s : \mathcal{V} \rightarrow M\\).

Si \\(a \in M\\), usamos la notación \\(s\[x \leftarrow a\]\\) para denotar la
asignación que es igual a \\(s\\) salvo que para \\(x\\) devuelve \\(a\\)

~~~

La relación \\( s \satisf_{\mathbf{M}} A\\) establece que la asignación \\(s\\) satisface la fórmula \\(A\\) bajo la estructura \\(\mathbf{M}\\). Vamos a definirla de forma informal usando inducción estructural:

$$
\begin{align}
s \satisf_{\mathbf{M}} P(t_1, \dots, t_n) &\text{sii} P(s(t_1), \dots, s(t_n)) \\\\
s \satisf_{\mathbf{M}} \neg A &\text{ sii } s \notsatisf_{\mathbf{M}} A \\\\
s \satisf_{\mathbf{M}} (A \land B) &\text{ sii } s \satisf_{\mathbf{M}} A \text{ y } s \satisf_{\mathbf{M}} B \\\\
s \satisf_{\mathbf{M}} (A \lor B) &\text{ sii } s \satisf_{\mathbf{M}} A \text{ o } s \satisf_{\mathbf{M}} B \\\\
s \satisf_{\mathbf{M}} (A \supset B) &\text{ sii } s \notsatisf_{\mathbf{M}} A \text{ o } s \satisf_{\mathbf{M}} B \\\\
s \satisf_{\mathbf{M}} (A \iff B) &\text{ sii } (s \satisf_{\mathbf{M}} A \text{ sii } s \satisf_{\mathbf{M}} B) \\\\
s \satisf_{\mathbf{M}} \forall x_i. A &\text{ sii } s\[x_i \leftarrow a\] \satisf_{\mathbf{M}} A \text{ para todo } a \in M \\\\
s \satisf_{\mathbf{M}} \exists x_i. A &\text{ sii } s\[x_i \leftarrow a\] \satisf_{\mathbf{M}} A \text{ para algún } a \in M
\end{align}
$$

### Validez

Una fórmula \\(A\\) es **satisfacible en** \\(\mathbf{M}\\) sii existe una asignación \\(s\\) tal que

$$
s \satisf_{\mathbf{M}} A
$$

Ahora, si no fijamos el \\(\mathbf{M}\\), una fórmula \\(A\\) **es satisfactible** (a secas) sii existe un \\(\mathbf{M}\\) tal que \\(A\\) es satisfactible en \\(\mathbf{M}\\). En caso contrario decimos que es **insatisfactible**.

Por último, decimos que una fórmula \\(A\\) es **válida en** \\(\mathbf{M}\\) (fijado el M, es tautología) sii

$$
s \satisf_{\mathbf{M}} A, \text{ para toda asignación } s
$$

> **Obs**: \\(A\\) es válida sii \\(\neg A\\) es insatisfactible.

~~~admonish info title="Teorema de Church"

**No existe** un algoritmo que pueda determinar si una fórmula de primer orden es válida.

![](./img/ohno.png#center)

O sea que sonamos? Bueno no, a medias.

- El método de resolución que vamos a ver **no es un procedimiento efectivo**,
- Es un problema de **semi-decisión**. Vamos a lograr que
    - si una sentencia es insatisfactible, encuentro una refutación.
    - pero si es satisfactible puede no terminar.

~~~

# Resolución en lógica de primer orden

Vamos a aplicar la misma idea del método de resolución que aplicamos para
proposicional, pero ahora para primer orden. Eso si, como el lenguaje es más
complicado que lógica proposicional vamos a tener que aplicar un par de pasos
extra.

## Forma ~Normal~ Clausal

Al igual que para proposicional queremos que nuestra fórmula tenga cierta pinta
para que sea más fácil trabajar con ella. La diferencia es que en este caso
tenemos más lenguaje (sobre todo tenemos que incorporar el uso de
cuantificadores).

Para pasar a forma clausal tenemos que pasar por varios pasos intermedios:

1. Re-escribir la fórmula en términos de \\(\land, \lor, \neg, \forall, \exists\\)
    - termina siendo eliminar el implica (P => Q === -P v Q).
2. Pasar a **forma normal negada**
3. Pasar a **forma normal prenexa** (opcional)
4. Pasar a **forma normal de Skolem**
5. Pasar matriz a forma normal conjuntiva
6. Distribuir los cuantificadores universales

Veamos paso por paso.

### Forma normal negada

Una forma normal negada es una forma en donde lo que queremos es que las negaciones aparezcan lo más adentro posible. Para eso podemos definir el conjunto de fórmulas que están en FNN inductivamente:

1. Para cada fórmula atómica \\(A\\), \\(A\\) y \\(\neg A\\) están en \\(FNN\\).
2. Si \\(A, B \in FNN\\), entonces \\((A \lor B), (A \land B)\\) están en \\(FNN\\).
3. Si \\(A \in FNN\\), entonces \\(\forall x.A, \exists x.A \in FNN\\).

Ejemplos:

- \\(\neg \exists x.((P(x) \lor \exists y. R(x, y)) \supset (\exists z.R(x, z) \lor P(a)))\\) no está en FNN porque el existencial no es una fórmula atómica por lo tanto ni 1, ni 2, ni 3 aplican.
- \\(\forall x.((P(x) \lor \exists y. R(x, y)) \land (\forall z. \neg R(x, z) \land \neg P(a)))\\) si lo está
    - notar que es lógicamente equivalente a la primera pero convertida a FNN

~~~admonish abstract title="Propiedad"

Toda fórmula de lógica de primer orden es lógicamente equivalente a otra que está en FNN.

La demostración es dar un algoritmo basado en inducción estructural para convertirla:

$$
\begin{align}
\neg(A \land B) &\iff \neg A \lor \neg B \\\\
\neg(A \lor B) &\iff \neg A \land \neg B \\\\
\neg\neg A &\iff A \\\\
\neg \forall x.A &\iff \exists x. \neg A \\\\
\neg \exists x.A &\iff \forall x. \neg A
\end{align}
$$

Nota: no estamos perdiendo satisfactibilidad en esta transformación. (keep in mind y'all)

~~~

### Forma normal prenexa

Es una forma de escribir tu fórmula de forma tal que "quede ordenada". En qué
sentido? Que quedan *todos* los cuantificadores adelante y recién después del
último cuantificador el resto. Qué pinta tiene?

$$
Q_1x_1 \dots Q_nx_n.B, n \geq 0
$$

siendo:

- \\(B\\) una fórmula sin cuantificadores (la llamamos **matriz**)
- \\(x_i\\) variables
- \\(Q_i \in \lbrace \forall, \exists \rbrace\\)

~~~admonish abstract title="Propiedad"

Toda fórmula [rectificada](#variables-libres-y-ligadas) es lógicamente
equivalente a otra en forma prenexa. Es importante lo de rectificada para no
cagarla cuando metemos/sacamos una parte de la fórmula al cuantificador.

La demostración también es dar un algoritmo basado en inducción estructural para convertirla:

$$
\begin{alignat}{3}
(\forall x.A) \land B &\iff \forall x.(A \land B)\ \ \ \ \ \ \ \ \ \ &(\forall x.A) \lor B &\iff \forall x.(A \lor B) \\\\
(\exists x.A) \land B &\iff \exists x.(A \land B)\ \ \ \ \ \ \ \ \ \ &(\exists x.A) \lor B &\iff \exists x.(A \lor B)
\end{alignat}
$$

- Nota: no estamos perdiendo satisfactibilidad en esta transformación. (keep in mind y'all)
- Nota 2: Recordar que hay varias operaciones que son asociativas y conmutativas (así que hay más combinaciones para la demostración de arriba)

~~~

### Forma normal de Skolem (also known as "Eskolemizar")

Por qué skolemizar? Nuestro objetivo a largo plazo es tener
[sentencias](#sentencias) ya que los existenciales nos pueden complicar la
vida. Skolemizar consiste en eliminar los cuantificadores existenciales, **sin
eliminar satisfactibilidad**.

Cómo elimino cuantificadores existenciales? Mediante **testigos**, que son
constantes o funciones de skolem que instanciamos. Por ejemplo:

- \\(\exists x. P(x)\\) se skolemiza a \\(P(c)\\) donde \\(c\\) es una nueva
  constante que se agrega al lenguaje de primer orden. Esa constante vendría a
  representar el valor que se evalúa al valor que quiero. Como sólo busco
  satisfactibilidad me alcanza con dar alguna estructura, por lo tanto extender
  con esa constante al lenguaje no debería hacerme perder la satisfactibilidad.
- Esas funciones/constantes también se las conoce como parámetros

~~~admonish abstract title="Propiedad"

Si \\(A'\\) es el resultado de skolemizar \\(A\\), entonces \\(A\\) es satisfactible sii \\(A'\\) es satisfactible. (no vamos a ver la demo).

Como consecuencia tenemos que la skolemización preserva insatisfactibilidad. Esto ya debería de ser suficiente para poder aplicar el método de resolución.

> **Pregunta**: Será posible eliminar cuantificadores preservando no sólo satisfactibilidad si no también la **validez**? 
>
> En general, No. Por ejemplo \\(\exists x.(P(a) \supset P(x))\\) es válida, pero una vez que fijo el \\(x\\) ya no: \\(P(a) \supset P(b)\\) depende de la estructura.
>
> Pero de vuelta, no nos importa porque a nosotros sólo nos interesaba la satisfactibilidad.

~~~

#### Formalización

Formalizando todo, en la skolemización cáda ocurrencia de una subfórmula

$$
\exists x.B
$$

en \\(A\\) se reemplaza por

$$
B \lbrace x \leftarrow f(x_1, \dots, x_n) \rbrace
$$

que representa la operación de sustitución aplicada sobre la expresión \\(B\\)
y donde \\(f\\) es un símbolo de función nuevo, y \\(x_1, \dots, x_n\\) son las
variables de las que depende \\(x\\) en \\(B\\). Esto implica que si el
existencial está adentro de una fórmula más grande puede que \\(B\\) tenga
variables libres y en ese caso \\(x\\) va a depender de ellas (para la
satisfactibilidad).

Definimos entonces la forma de skolem \\(\mathbf{SK}(A)\\) como:

- tomo un \\(A'\\) subfórmula de \\(A\\)
- Si \\(A'\\) es una fórmula atómica o su negación no cambio anda 

$$
\mathbf{SK}(A') = A'
$$

- Si \\(A'\\) es de la forma \\((B * C)\\) con \\(* \in \lbrace \lor, \land \rbrace\\), entonces 

$$
\mathbf{SK}(A') = (\mathbf{SK}(B) * \mathbf{SK}(C))
$$

- Si \\(A'\\) es un cuantificador (\\(\forall x. B\\)), entonces

$$
\mathbf{SK}(A') = \forall x. \mathbf{SK}(B)
$$


- Si \\(A'\\) es un cuantificador existencial (\\(\exists x. B\\)) y \\(\lbrace x, y_1, \dots, y_m \rbrace\\) son variables libres de \\(B\\), entonces
    1. si \\(m > 0\\), crear un nuevo símbolo de función de Skolem, \\(f_x\\) de aridad \\(m\\) y definir

    $$
    \mathbf{SK}(A') = \mathbf{SK}(B \lbrace x \leftarrow f_x(y_1, \dots, y_m) \rbrace)
    $$
    2. si \\(m = 0\\), crear una nueva constante de Skolem, \\(c_x\\) y

    $$
    \mathbf{SK}(A') = \mathbf{SK}(B \lbrace x \leftarrow c_x \rbrace)
    $$

> Nota: como asumimos que \\(A\\) está rectificada, cada \\(f_x\\) y \\(c_x\\)
> son únicos.

> Nota 2/Pregunta: por qué necesito tanto constantes como funciones de Skolem?
> No podría simplemente tomar el cuantificador "de más afuera" y listo? Bueno,
> a priori la skolemización está definida para fórmulas rectificadas, no
> necesariamente son fórmulas resultantes de pasar a forma prenexa. Pero si
> vengo de prenexa **puedo usar únicamente constantes?** Casi, pero no porque
> puedo tener \\(\forall\\) al principio de todo y no tengo forma de "meterlo"
> para adentro en la fórmula ("para todo x existe y ..." no es lo mismo que
> "existe un y tal que para todo x ...", no conmutan los cuantificadores).
> Dicho eso, es más fácil skolemizar de afuera hacia adentro de todos modos.

### Forma clausal 

Hasta ahora llegamos a una fórmula:

$$
\forall x_1 \dots \forall x_n. B
$$

- con las negaciones lo más al fondo posibles (por forma normal negada)
- con los cuantificadores lo más afuera posible (por forma normal prenexa)
- sin existenciales (por la skolemización)
- o sea que lo de adentro está como en el punto de partida de la lógica proposicional!

Para llegar a la forma clausal vamos a hacer un par de pasos más:

1. Lo primero que hacemos es pasar \\(B\\) (la raíz) a FNC \\(B'\\) como si fuera proposicional.

$$
\forall x_1 \dots \forall x_n. B'
$$

2. Segundo, distribuimos los cuantificadores sobre cada conjunción de la FNC. O sea, si tenemos

$$
\forall x_1 \dots \forall x_n. C_1 \land \dots \land C_m
$$

ahora lo expresamos como

$$
(\forall x_1 \dots \forall x_n. C_1) \land \dots \land (\forall x_1 \dots \forall x_n. C_m)
$$

donde los \\(C_i\\) son disyunciones de literales.

3. La notación similar a proposicional queda:

$$
\lbrace C_1, \dots, C_m \rbrace
$$

o sea que están, pero en la representación "me olvido" de los cuantificadores.

~~~admonish warning title="Cuidado!"

Si bien está el abuso de notación, hay que tener cuidado con qué variables son de los cuantificadores y cuales son constantes

~~~

## La receta de resolución en primer orden

Para probar que \\(A\\) es una tautología pasamos por los siguientes pasos:

1. Calculamos la forma normal conjuntiva \\(B\\) de \\(\neg A\\)
2. Pasamos \\(B\\) a forma clausal
3. Aplicamos el método de resolución.
4. Si hallamos una refutación:
    - \\(\neg A\\) es insatisfactible, entonces \\(A\\) es tautología
5. Si no hallamos una refutación:
    - \\(\neg A\\) es satisfactible y por lo tanto \\(A\\) no es tautología

### Método de resolución en proposicional

Recuerdo: 

- La refutación era una secuencia de pasos de resolución que nos llevan a la cláusula vacía (+ el resto)
- Los pasos de resolución eran de la forma:

$$
\frac{\lbrace A_1, \dots, A_m, Q \rbrace\ \ \lbrace B_1, \dots, B_n, \neg Q \rbrace}{\lbrace A_1, \dots, A_m, B_1, \dots, B_n \rbrace}
$$

Podemos aplicarlo así como viene en primer orden (asumiendo que los \\(A_i, B_i, Q\\) son predicados atómicos o sus negaciones)? Para responderlo veamos un ejemplo:

$$
(\forall x. P(x)) \land \neg P(a)
$$

- Es satisfactible? No, si para todo \\(x\\) vale \\(P(x)\\), entonces no puede a la vez valer \\(\neg P(a)\\) para ningún \\(a\\)
- Y su forma clausal es

$$
\lbrace \lbrace P(x) \rbrace, \lbrace \neg P(a) \rbrace \rbrace
$$

Claramente no puedo aplicar taaan directamente la regla de la resolución. Voy a
tener que relacionar el \\(x\\) que es variable con el \\(a\\) que es
constante. Si bien \\(P(x)\\) y \\(P(a)\\) no son iguales, son **unificables**.

#### Nueva regla de resolución:

$$
\frac{\lbrace B_1, \dots, B_k, A_1, \dots A_m \rbrace\ \ \lbrace \neg D_1, \dots, \neg D_j, C_1, \dots, C_n \rbrace}{\sigma(\lbrace A_1, \dots, A_m, C_1, \dots, C_n \rbrace)}
$$

donde \\(\sigma = MGU(\lbrace B_1 = B_2, \dots, B_{k-1} = B_k, B_k = D_1, \dots, D_{j-1} = D_j \rbrace)\\), o sea que me deje a **todos** iguales.

- notar que \\(\sigma(B_i) = \sigma(D_j)\\) para todos \\(i\\) y \\(j\\)
- La cláusula \\(\sigma(\lbrace A_1, \dots, A_m, C_1, \dots, C_n \rbrace)\\) es la que se llama **resolvente** en este caso.

~~~admonish info title="Teorema"

El teorema de Herbrand-Skolem-Godel, nos dice que cada uno de los pasos de la resolución en primer orden preserva satisfactibilidad.

~~~

### Diferencias con proposicional

- puedo unificar de a varios a la vez
- esta regla de resolución es **incompleta**, o sea que no es un insatisfactible sii el método encuentra refutación (se puede arreglar)
