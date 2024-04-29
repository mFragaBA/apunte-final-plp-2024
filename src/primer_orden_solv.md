$$
   \newcommand{\true}{\mathbf{T}}
   \newcommand{\false}{\mathbf{F}}
   \newcommand{\satisf}{\models}
   \newcommand{\notsatisf}{\nvDash}
   \newcommand{\set}[1]{\lbrace #1 \rbrace}
$$
# Resolución en lógica de primer orden

# Repaso

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

Una fórmula \\(A\\) es **satisfacible en** \\(mathbf{M}\\) sii existe una asignación \\(s\\) tal que

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
