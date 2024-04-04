$$
   \newcommand{\lcb}{\lambda^b}
   \newcommand{\ifLC}[3]{if\  {#1}\  then\  {#2}\  else\  {#3}}
   \newcommand{\lf}[3]{\lambda{#1}:\ {#2}.{#3}}
   \newcommand{\apply}[2]{{#1}\ {#2}}
   \newcommand{\hastype}[3]{{#1} \triangleright {#2}: {#3}}
   \newcommand{\ttrue}[1]{\frac{}{\hastype{#1}{true}{Bool}} (T-True)}
   \newcommand{\tfalse}[1]{\frac{}{\hastype{#1}{false}{Bool}} (T-False)}
   \newcommand{\tvar}[3]{\frac{{#2}:{#3} \in {#1}}{\hastype{#1}{#2}{#3}} (T-var)}
   \newcommand{\tif}[5]{\frac{\hastype{#1}{#2}{Bool}\ \ \hastype{#1}{#3}{#5}\ \ \hastype{#1}{#4}{#5}}{\hastype{#1}{\ifLC{{#2}}{{#3}}{{#4}}}{#5}} (T-If)}
   \newcommand{\tabs}[5]{\frac{\hastype{{#1},{#2}:{#3}}{#5}{#4}}{\hastype{#1}{\lf{{#2}}{{#3}}{{#5}}}{{#3} \rightarrow {#4}}} (T-abs)}
   \newcommand{\tapp}[5]{\frac{\hastype{#1}{#2}{#3 \rightarrow #4}\ \ \hastype{#1}{#5}{#3}}{\hastype{#1}{\apply{{#2}}{{#5}}}{#4}} (T-app)}
   \newcommand{\eiftrue}[2]{\frac{}{\ifLC{true}{#1}{#2} \rightarrow #1} (E-IfTrue)}
   \newcommand{\eiffalse}[2]{\frac{}{\ifLC{false}{#1}{#2} \rightarrow #2} (E-IfFalse)}
   \newcommand{\eif}[4]{\frac{#1 \rightarrow #2}{\ifLC{#1}{#3}{#4} \rightarrow \ifLC{#2}{#3}{#4}} (E-If)}
   \newcommand{\eift}[4]{\frac{\eiftrue{#3}{#4}}{\ifLC{#1}{#3}{#4} \rightarrow \ifLC{#2}{#3}{#4}} (E-If)}
   \newcommand{\eiff}[4]{\frac{\eiffalse{#3}{#4}}{\ifLC{#1}{#3}{#4} \rightarrow \ifLC{#2}{#3}{#4}} (E-If)}
$$
# Cálculo Lambda Tipado Booleano \\(\lcb\\)

## Expresiones de tipos

Las expresiones de tipos (o simplemente tipos) de \\(\lcb\\) son:

$$
\sigma, \tau ::= Bool | \sigma \rightarrow \tau
$$

En criollo, 

- \\(Bool\\) es el tipo de los booleanos
- \\(\sigma \rightarrow \tau\\) es el tipo de las funciones de tipo
  \\(\sigma\\) en \\(\tau\\)

Por ejemplo, uno puede tener una función \\(Bool \rightarrow Bool\\)

## Términos de \\(\lambda^b\\)

Sea \\(\mathcal{X}\\) un conjunto infinito enumerable de variables y \\(x \in \\mathcal{X}\\). Los términos de \\(\lambda^b\\) están definidos por:

$$
\begin{align}
M,N,P,Q ::=& \ x \\\\
&| \ true \\\\
&| \ false \\\\
&| \ \ifLC{M}{P}{Q} \\\\
&| \ \lf{x}{\sigma}{M} \\\\
&| \ \apply{M}{N}
\end{align}
$$

Es importante entender que estas reglas **sólo definen cómo construir sintácticamente los términos**, pero no necesariamente te va a dar cosas que tengan sentido ni que sean útiles. Veamos algunos ejemplos de términos válidos:

- \\(\lf{x}{Bool}{x}\\)
- \\(\lf{x}{Bool}{\ifLC{x}{false}{true}}\\)
- \\(\lf{f}{Bool \rightarrow Bool \rightarrow Bool}{\lf{x}{Bool}{\apply{f}{x}}}\\)
- \\((\lf{f}{Bool \rightarrow Bool}{\apply{f}{true}})(\lf{y}{Bool}{y})\\)
- \\(\apply{true}{(\lf{x}{Bool}{x})}\\)
- \\(\apply{x}{y}\\)

## Sistema de tipado

- Es un sistema formal de deducción/derivación que usa axiomas y reglas de
  inferencia para caracterizar al conjunto de los conjuntos "bien tipados"
- Lo definimos a partir de reglas de inferencia
    - axiomas de tipado para algunos términos
    - reglas de tipado para otros términos, que derivan (siempre y cuando se
      pueda) el tipado de una expresión en base a sus sub-expresiones.

## Variables libres

Ya vimos que tenemos funciones lambda que se pueden usar en la construcción de
términos. Antes de seguir con otras cosas está bueno definir y distinguir las
**variables libres** de las **variables ligadas**. Una variable \\(x\\) se dice
que ocurre libre si no está bajo el alcance de alguna ocurrencia de un
\\(\lambda x\\). En otro caso decimos que ocurre ligada.

![](./img/var_libre_vs_ligada.png#center)

Más formalmente:

$$
\begin{align}
FV(x) &\stackrel{def}{=} \\{ x \\} \\\\
FV(true) = FV(false) &\stackrel{def}{=} \emptyset \\\\
FV(\ifLC{M}{P}{Q}) &\stackrel{def}{=} FV(M) \cup FV(P) \cup FV(Q) \\\\
FV(\apply{M}{N}) &\stackrel{def}{=} FV(M) \cup FV(N) \\\\
FV(\lf{x}{\sigma}{M}) &\stackrel{def}{=} FV(M) \setminus \\{x\\} \\\\
\end{align}
$$

## Sistema de tipado

Un **juicio de tipado** es una expresión de la forma \\(\Gamma \triangleright M\ :\ \sigma\\) que se lee como: "el término \\(M\\) tiene tipo \\(\sigma\\) asumiendo el contexto de tipado \\(\Gamma\\)"

Un **contexto de tipado** por otro lado es un conjunto de pares \\(x_i\ :\ \sigma_i\\), anotado \\(\\{x_1\ :\ \sigma_1, \dots, x_n\ :\ \sigma_n\\}\\) donde los \\(\\{x_i\\}_{i \in 1 \dots n}\\) son distintos. Usamos letras \\(\Gamma\\), \\(\bigtriangleup\\), ... para contextos de tiapdo.

## Axiomas de tipado de \\(\lcb\\)

Obs: están guiadas por la sintáxis!

$$
\ttrue{\Gamma}
$$

$$
\tfalse{\Gamma}
$$

$$
\tvar{\Gamma}{x}{\sigma}
$$

$$
\tif{\Gamma}{M}{P}{Q}{\sigma}
$$

$$
\tabs{\Gamma}{x}{\sigma}{\tau}{M}
$$

$$
\tapp{\Gamma}{M}{\sigma}{\tau}{N}
$$

- Si \\(\hastype{\Gamma}{M}{\sigma}\\) puede derivarse usando los axiomas y reglas de tipado decimos que es derivable.
- Decimos que \\(M\\) es tipable si el juicio de tiapdo \\(\hastype{\Gamma}{M}{\sigma}\\) puede derivarse, para algún \\(\Gamma\\) y \\(\sigma\\).

## Resultados básicos (demostración con inducción estructural)

### Unicidad de tipos

Si \\(\hastype{\Gamma}{M}{\sigma}\\) y \\(\hastype{\Gamma}{M}{\tau}\\) son derivables, entonces \\(\sigma = \tau\\).

### Weakening + Strengthening

Si \\(\hastype{\Gamma}{M}{\sigma}\\) es derivable y \\(\Gamma \cap \Gamma'\\) contiene a todas las variables libres de \\(M\\), entonces \\(\hastype{\Gamma'}{M}{\sigma}\\).

## Semántica (o sea qué hacen mis cómputos)

Hasta ahora definimos para \\(\lcb\\) con reglas inductivas:

- una sintáxis
- un sistema de tipado

Ahora vamos a darle significado a los términos que para nosotros tengan sentido
(o sea aquellos que estén bien tipados). 

Hay distintas formas de definir la semántica, en particular vamos a dar una
**semántica operacional**. Nota: hay otros tipos de semántica, como la
semántica axiomática (similar a lo que vimos en algo 1 con pre-condición y
post-condición, basada en aserciones), denotacional (le das una denotación a
cada término del lenguaje y definís la semántica dando funciones para los
elementos de la sintaxis).

En qué consiste entonces la semántica operacional:

- interpreto a los términos como estados de una máquina abstracta
- defino reglas para hacer evolucionar (reducir) los términos en otros términos
    - también están guiadas por sintaxis
- el **significado** de un término \\(M\\) es el estado final que alcanza la
  máquina si comienza con el estado inicial \\(M\\)
- hay dos formas de dar la semántica operacional:
    - **small-step**: describo pasos chiquitos. Vamos a ver principalmente
      este.
    - **big-step (o natural semantics)**: la función de transición en un paso
      reduce al resultado.
- definir la semántica tiene que hacerse de forma precisa cosa de poder llevar
  todo a una implementación de un intérprete del lenguaje.

## Semántica small-step

- La hacemos a través de **juicios de evaluación**, a.k.a. reglas de reducción que se leen como "el término \\(M\\) reduce en un paso al término \\(N\\)":

$$
M \rightarrow N
$$

- Uso axiomas de evaluación + reglas de derivación que establecen que algunos
  juicios de evaluación son derivables a partir de otros juicios que también
  son derivables.
- Además de la función de transición, tenemos que definir los **valores**, que
  son los posibles resultados de una evaluación de términos, en tanto sean
  cerrados (no tiene variables libres) y estén bien tipados.

### Valores

Como nuestro lambda cálculo es booleano, nos interesan true y false. O sea que
expresiones complejas también pueden reducir a esos valores. O sea, todo
término bien tiapdo y cerrado de tipo \\(Bool\\) evalúa en cero o más pasos, a
\\(true\\) o \\(false\\).

$$
V ::= true\ |\ false
$$

### Juicio de evaluación en un paso

Al If podemos pensarlo como que lo tenemos que reducir por completo el término
del \\(if\\) hasta un valor, sea \\(true\\) o \\(false\\)

$$
\eiftrue{M_2}{M_3}
$$

$$
\eiffalse{M_2}{M_3}
$$

$$
\eif{M_1}{M_1'}{M_2}{M_3}
$$

~~~admonish info title="Ejemplo"

$$
\eiff{(\ifLC{false}{false}{true})}{true}{false}{true}
$$

Observaciones:

- No hay \\(M\\) tal que \\(true \rightarrow M\\)
- Idem con \\(false\\)

~~~

#### Algunas propiedades Interesantes

- **Lema** (Determinismo del juicio de evaluación en un paso): Si las reglas están bien hechas, y \\(M \rightarrow M'\\) \\(M \rightarrow M''\\) entonces \\(M' = M''\\)
- Una **forma noraml** es un término que no puede evaluarse más (o sea no existe una regla para reducir).
- (recuerdo: un valor es el resultado al que puede evaluar un término bien tipado y cerrado)
- **Lema**: todo valor está en forma normal. No vale el recíproco en \\(\lcb\\). Por ejemplo:
    - \\(\ifLC{x}{true}{false}\\), no tengo cómo reducir porque \\(x\\) ta libre
    - \\(x\\), mismo caso
    - \\(\apply{true}{false}\\), no puedo reducir (tampoco tipa...)
- Lo vemos en un toque, pero el resultado más fuerte es que si una expresión es cerrada y bien tipada eventualmente puedo reducir hasta llegar a un valor.

### Evaluación en muchos pasos

El **juicio de evaluación en muchos pasos** \\(\twoheadrightarrow\\) es la clausura reflexiva y transitiva de \\(\rightarrow\\). O sea es la menor relación tal que:

1. Si \\(M \rightarrow M'\\), entonces \\(M \twoheadrightarrow M'\\)
2. \\(M \twoheadrightarrow M\\) para todo \\(M\\)
3. Si \\(M \twoheadrightarrow M'\\) y \\(M' \twoheadrightarrow M''\\), entonces \\(M \twoheadrightarrow M''\\)

Por ejemplo, tenemos que:

$$
\ifLC{true}{(\ifLC{false}{false}{true})}{true} \twoheadrightarrow true
$$

#### Propiedades

Para el cálculo de expresiones booleanas valen:

- **Lema** (Unicidad de formas normales): Si \\(M \twoheadrightarrow U\\) y \\(M \twoheadrightarrow V\\), con \\(U, V\\) formas normales, entonces \\(U = V\\)
- **Lema** (Terminación): Para todo \\(M\\) existe una forma normal \\(N\\) tal que \\(M \twoheadrightarrow \\).
    - esto es bueno porque me aseguro que mi algoritmo de evaluación no tiene loops infinitos

## Semántica Operacional de \\(\lcb\\)

Ya hablamos antes de que en haskell por ejemplo, las funciones también pueden ser resultados de una evaluación (eso de first class citizen, yada yada yada...). Así que por qué no extendemos nuestro conjunto de valores:

$$
V ::= true\ false\ \lf{x}{\sigma}{M}
$$

Vamos a extender nuestro sistema tal que valgan los lemas previos, pero además valga el siguiente resultado:

~~~admonish tldr title="Teorema"

Para todo término bien tipado y cerrado de tipo:

- \\(Bool\\) evalúa, en cero o más pasos, a \\(true, false\\).
- \\(\sigma \rightarrow \tau\\) evalúa, en cero o más pasos, a \\(\lf{x}{\sigma}{M}\\), para alguna variable \\(x\\) y algún término \\(M\\)
    - en castellano: si tipa como una función eventualmente lo puedo reducir a la forma de una lambda con una variable y un término

~~~

### Juicio de evaluación en un paso

- Primero, una regla que me haga reducir lo más que pueda la "función" que quiero evaluar:

$$
\frac{M_1 \rightarrow M_1'}{\apply{M_1}{M_2} \rightarrow \apply{M_1'}{M_2}} (E-App1 / \mu)
$$

- Segundo, una regla que me haga reducir lo más que pueda al argumento:

$$
\frac{M_2 \rightarrow M_2'}{\apply{(\lf{x}{\sigma}{M})}{M_2} \rightarrow \apply{(\lf{x}{\sigma}{M})}{M_2'}} (E-App1 / v)
$$

- Por último, una regla que se encargue del reemplazo de la evaluación

$$
\frac{}{\apply{(\lf{x}{\sigma}{M})}{V} \rightarrow M \\{x \leftarrow V\\}} (E-AppAbs / \beta)
$$

- Esto último quiere decir agarrar la función lambda, y reemplazar sintácticamente las ocurrencias de \\(x\\) por \\(V\\)
    - sustituyo únicamente las ocurrencias **libres** de \\(x\\)
    - le da semántica a la aplicación de funciones
    - hay que tener cuidado con los ligadores de variable (los \\(\lambda x\\))

Podemos dar una definición basada en la sintaxis:

$$
\begin{align}
x \\{x \leftarrow N\\} &\stackrel{def}{=} N \\\\
a \\{x \leftarrow N\\} &\stackrel{def}{=} a \text{si a } \notin \\{true, false\\} \cup \mathcal{X} \setminus \\{x\\} \\\\
\ifLC{M}{P}{Q} \\{x \leftarrow N\\} &\stackrel{def}{=} \ifLC{M\\{x \leftarrow N\\}}{P\\{x \leftarrow N\\}}{Q\\{x \leftarrow N\\}} \\\\
(\apply{M_1}{M_2}) \\{x \leftarrow N\\} &\stackrel{def}{=} \apply{M_1\\{x \leftarrow N\\}}{M_2\\{x \leftarrow N\\}} \\\\
\lf{y}{\sigma}{M} \\{x \leftarrow N\\} &\stackrel{def}{=} ? \\\\ 
\end{align}
$$

Y ese último? Imaginemos el caso de la sustitución:

$$
\lf{z}{\sigma}{x} \\{x \leftarrow N\\} \stackrel{def}{=} \lf{z}{\sigma}{z}
$$

La convertimos de la función constante en la función identidad! Pero bueno, a
priori no importa qué nombre tenga la variable ligada, no? Entonces, lo que
podemos hacer es renombrar (o asumir que se hizo el renombre para estas
reglas), de manera tal que la variable que se liga en la función lambda **no
ocurre libre** en \\(N\\). De ser así la regla nos queda:

$$
\lf{y}{\sigma}{M} \\{x \leftarrow N\\} \stackrel{def}{=} \lf{y}{\sigma}{M\\{x \leftarrow N\\}}\ \ x \neq y, y \notin FV(N) \\\\ 
$$

Para formalizar esto aparece el concepto de \\(\alpha\\)-equivalencia. Dos
términos son \\(\alpha\\)-equivalentes si **únicamente difieren en el nombre de
sus variables ligadas**. Es una relación de equivalencia.

~~~admonish example title="Algunos ejemplos"

- \\(\lf{x}{Bool}{x} =_{\alpha} \lf{y}{Bool}{y}\\)
- \\(\lf{x}{Bool}{y} =_{\alpha} \lf{z}{Bool}{y}\\)
    - acá \\(y\\) es variable libre en ambos casos
- \\(\lf{x}{Bool}{y} \neq_{\alpha} \lf{x}{Bool}{z}\\)
    - acá tanto \\(y\\) como \\(z\\) son variables libres y son distintas en cada término.
- \\(\lf{x}{Bool}{\lf{x}{Bool}{x}} \neq_{\alpha} \lf{y}{Bool}{\lf{x}{Bool}{y}}\\)
    - acá la lambda interna tiene en su subtérmino a la \\(x\\) ligada, mientras que del lado derecho no.

Llevado a la práctica, esto quiere decir que mientras hagamos las reducciones,
podemos tener que hacer el reemplazo por un término \\(\alpha\\)-equivalente y
después aplicar la sustitución.

~~~

## Estado de error

- Es un estado (término) que **no es** un valor, pero en el que la evaluación está **trabada**.
- Representa un estado en el cual el sistema de runtime en una implementación real generaría una excepción
- Ejemplos:
    - \\(\ifLC{x}{M}{N}\\)
        - obs: no es cerrado
    - \\(\apply{true}{M}\\)
        - obs: no es tipable

## Objetivo de un sistema de tipos

Queremos garantizar la **ausencia** de estados de error. Decimos que un término
**termina** o que es **fuertemente normalizante** si no hay cadenas de
reducción infinitas a partir de él.

~~~admonish theorem title="Teorema"

- Todo término bien tipado termina
- Si un término cerrado está bien tipado, entonces evalúa a un valor

~~~

Tenemos algunas propiedades que nos garantizan este teorema:

- Progreso: Si \\(M\\) es cerrado y bien tipado, entonces:
    - \\(M\\) es un valor
    - o bien existe \\(M'\\) tal que \\(M \rightarrow M'\\) (o sea no se traba si los términos son cerrados y bien tipados, y no son valores)
- Preservación (de tipo): Si \\(\hastype{\Gamma}{M}{\sigma}\\) y \\(M \rightarrow N\\), entonces \\(\hastype{\Gamma}{N}{\sigma}\\) (o sea que la reducción/evaluación preserva tipos).

> **Observación**: parto de progreso. O bien es un valor, o tengo el término al
> que reducir. Luego por preservación de tipos, aplicar la reducción nos dice
> que el nuevo término está bien tipado, y sigue siendo cerrado.
