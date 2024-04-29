$$
   \newcommand{\true}{\mathbf{T}}
   \newcommand{\false}{\mathbf{F}}
   \newcommand{\satisf}{\models}
   \newcommand{\notsatisf}{\nvDash}
   \newcommand{\set}[1]{\lbrace #1 \rbrace}
$$
# Resolución Proposicional

## Repaso: Sintaxis de la lógica proposicional

Dado un conjunto \\(\mathcal{V}\\) de **variables proposicionales**, podemos
definir inductivamente el conjunto de **fórmulas proposicionales** *Prop* de la
siguiente forma:

1. Una variable proposicional \\(P_0, P_1, \dots\\) es una proposición
2. De forma inductiva, decimos que si \\(A\\) y \\(B\\) son proposiciones, entonces:
    - \\(\neg A\\) es una proposición.
    - \\(A \land B\\) es una proposición.
    - \\(A \lor B\\) es una proposición.
    - \\(A \supset B\\) es una proposición (esta sería la implicación).
    - \\(A \iff B\\) es una proposición.

Por ejemplo:

- \\(A \lor \neg B\\)
- \\((A \land B) \supset (A \lor A)\\)

### Semántica

> Nota: Acá cuando hablamos de semántica nos referimos a ver si una fórmula es verdadera o falsa.

- Una **valuación** es una función \\(v: \mathcal{V} \leftarrow \lbrace \true, \false \rbrace \\) que le asigna un valor de verdads a cada variable proposicional.
- Fijada una valuación, decimos que la misma **satisface** una proposición \\(A\\) si \\(v \satisf A\\), donde también lo definimos inductivamente:

$$
\begin{align}
v \satisf P &\text{ sii } v(P) = \true \\\\
v \satisf \not A &\text{ sii } v \notsatisf A \\\\
v \satisf A \lor B &\text{ sii } v \satisf A \text{ o } v \satisf B \\\\
v \satisf A \land B &\text{ sii } v \satisf A \text{ y } v \satisf B \\\\
v \satisf A \supset B &\text{ sii } v \notsatisf A \text{ o } v \satisf B \\\\
v \satisf A \iff B &\text{ sii } (v \satisf A \text{ sii } v \satisf B) \\\\
\end{align}
$$

### Tautologías y satisfactibilidad

Decimos que una proposición \\(A\\) es 

- **tautología** si independientemente de la valuación es verdadera, o sea \\(\forall v \text{ valuación},\ v \satisf A \\)
    - Ejemplo: \\(P \lor \neg P\\)
- **satisfacible** si existe una valuación que satisface a \\(A\\), o sea \\(\exists v \text{ valuación},\ v \satisf A \\)
    - Ejemplo: \\(P\\)
- **insatisfacible** si no existe una valuación que la satisfaga, o sea \\(\nexists v \text{ valuación},\ v \satisf A \\)
    - Ejemplo: \\(P \land \neg P\\)

Ahora, dado un conjunto de proposiciones \\(S\\), dimos que es:

- **satisfacible** si existe una valuación que esa misma valuación satisface todas las proposiciones de \\(S\\).
    - ej: \\(\lbrace P, Q \rbrace\\).
    - es lo mismo que ver que satisface a la conjunción de todas las proposiciones.
- **insatisfacible** si no es satisfacible (o sea cualquier valuación tiene una proposición que no satisface).
    - ej: \\(\lbrace P, \neg P \rbrace\\).

~~~admonish info title="Recuerdo"

Cómo pruebo que una fórmula es una tautología/satisfacible/insatisfacible? Con la tabla de verdad!

Tautología:

| A    | A > A    |
|--------- | --------------- |
| T    | T    |
| F    | T    |

Satisfacible:

| A    | B    | (A ^ B)    |
|---------------- | --------------- | --------------- |
| T    | T    | T    |
| T    | F    | F    |
| F    | T    | F    |
| F    | F    | F    |

insatisfacible:

| A    | B    | (-A v B) | (-A v -B) | (-A v B) ^ (-A v -B) ^ A    |
|---------------- | --------------- | --------------- | --------------- | --------------- |
| T    | T    | T | F | F    |
| T    | F    | F | T | F    |
| F    | T    | T | T | F    |
| F    | F    | T | T | F    |

~~~

### Tautologías e insatisfactibilidad

Tenemos un teorema que nos permite demostrar que algo es insatisfacible viendo que su negación es una tautología (y viceversa).

(La demo es bastante directa, instanciás las definiciones y reemplazás por \\(\satisf\\) y \\(\notsatisf\\) donde corresponda).

Por qué tiene sentido esto? Bueno, porque en resolución y otros mecanismos suele ser más fácil probar que algo es insatisfacible.

### Validez por refutación

*Principio de demostración por refutación*:

> Probar que \\(A\\) es **válido** mostrando que \\(\neg A\\) es **insatisfactible**

Hay varias técnicas para demostrar por refutación:

- Tableaux semántico (en LyC usamos este)
- Procedimiento de Davis-Putnam (este suelen usar los SAT-solvers)
- Resolución (vamos a ver este)

## Método de resolución

- fácil de entender e implementar
- tiene una regla de inferencia llamada **regla de resolución**.
- si bien no es necesario, vamos a trabajar con fórmulas que están en **forma
  normal conjuntiva**. Esto implica que hacemos un reacomodamiento/reescritura
  equivalente de las fórmulas para que tengan una fórma con la que es más fácil
  trabajar.

~~~admonish info title="Forma normal conjuntiva (FNC)"

- Un **literal** es una variable proposicional o su negación.
- Una proposición \\(A\\) está en FNC si es una **conjunción de cláusulas**
    - Y cada cláusula es una dusyunción de literales

Entonces la fórmula tiene la pinta:

$$
(B_{11} \lor \dots \lor B_{1n_1}) \land \dots \land (B_{m1} \lor \dots \lor B_{mn_m})
$$

Donde cada \\(B_{ij}\\) es \\(P\\) o \\(\neg P\\).

> **QUIZ TIME**: cuáles de las siguientes fórmulas están en FNC?
> 
> -  \\((P \lor Q) \land (P \lor \neg Q)\\) ... -> está en FNC.
> - \\((P \lor Q) \land (P \lor \neg \neg Q)\\) ... -> no está en FNC, porque tenemos el \\(\neg \neg Q\\). Si lo reemplazáramos por \\(Q\\) nomás ahí si.
> - \\((P \land Q) \lor P \\) ... -> no está en FNC, deberíamos tener una única cláusula (por la disyunción) pero en ese caso el \\((P \land Q)\\) no es un literal.

~~~

### Conversión a FNC

Hay un teorema que nos dice que dada una proposición \\(A\\) existe una proposición \\(A'\\) que está en FNC y que es lógicamente equivalente a \\(A\\).

> Nota: por lógicamente equivalente es que \\(A \iff B\\) es tautología.

La forma de probar el teorema es directamente dar la transformación. Y para
construir la transformación nos basamos en que tanto \\(\lor\\) como
\\(\land\\) **son conmutativos, asociativos e idempotentes**. Usando las leyes
de demorgan es transformar la proposición en otra lógicamente equivalente hasta
llegar a la forma que necesito.

Además, vamos a hacer 2 asunciones:

- cada cláusula es única
- podemos escribir las cláusulas como conjuntos

En base a eso, usamos la notación \\(\lbrace C_1, \dots, C_n \rbrace\\), con cada \\(C_i\\) un conjunto de literales \\(\lbrace B_{i1}, \dots, B_{in_i} \rbrace\\). Por ejemplo, la FNC \\((P \lor Q) \land (P \lor \neg Q)\\) se anota:

$$
\lbrace \lbrace P, Q \rbrace, \lbrace P, \neg Q \rbrace \rbrace
$$

Para las transformaciones nos vamos a basar en que la siguiente proposición es una tautología:

$$
(A \lor P) \land (B \lor \neg P) \iff (A \lor P) \land (B \lor \neg P) \land (A \lor B)
$$


> Demo:
> 
> $$
> \begin{align}
> (A \lor P) \land (B \lor \neg P) &\iff_{\text{agrego termino redundante}} (A \lor P) \land (B \lor \neg P) \land ((A \lor B) \lor \neg (A \lor B)) \\\\
> &\iff_{distribuyo} ((A \lor P) \land (B \lor \neg P) \land (A \lor B)) \lor \\\\
> &\ \ \ \ \ \ ((A \lor P) \land (B \lor \neg P) \land (\neg A \land \neg B))
> \end{align}
> $$
>
> Veamos que ese segundo término es insatisfactible (y como está en un \\(\lor\\) lo podemos omitir).
>
> $$
> \begin{align}
> (A \lor P) \land (B \lor \neg P) \land (\neg A \land \neg B) &\iff ((A \lor P) \land \neg A) \land ((B \lor \neg P) \land \neg B) \\\\
> &\iff_{dist} ((A \land \neg A) \lor (P \land \neg A)) \land ((B \land \neg B) \lor (\neg P \land \neg B)) \\\\
> &\iff_{reduzco} ((P \land \neg A)) \land ((\neg P \land \neg B)) \\\\
> &\iff_{saco parent.} P \land \neg P \land \neg A \land \neg B
> \end{align}
> $$
>
> \\(P \land \neg P\\) es insatisfactible!!!! Entonces volviendo a arriba:
>
> $$
> \begin{align}
> (A \lor P) \land (B \lor \neg P) &\iff \dots \\\\
> &\iff ((A \lor P) \land (B \lor \neg P) \land (A \lor B)) \lor \\\\
> &\ \ \ \ \ \ ((A \lor P) \land (B \lor \neg P) \land (\neg A \land \neg B)) \\\\
> &\iff ((A \lor P) \land (B \lor \neg P) \land (A \lor B))
> \end{align}
> $$

Notar que la fórmula derecha es lo mismo más la cláusula \\(A \lor B\\). O sea que agregar o sacar esa cláusula no nos cambia. Eso aplicado a FNC significa que:

$$
\lbrace C_1, \dots, C_m, \lbrace A, P \rbrace, \lbrace B, \neg P \rbrace \rbrace
$$

es insatisfactible sii

$$
\lbrace C_1, \dots, C_m, \lbrace A, P \rbrace, \lbrace B, \neg P \rbrace, \lbrace A, B \rbrace \rbrace
$$

es insatisfactible.

A la cláusula \\(\lbrace A, B \rbrace\\) se la llama **resolvente** de las cláusulas \\(\lbrace A, P \rbrace\\) y \\(\lbrace B, \neg P \rbrace\\). Además, el resolvente de las cláusulas \\(\lbrace P \rbrace\\) y \\(\lbrace \neg P \rbrace\\) es la cláusula vacía y se anota \\(\square\\), que representa el **falso**. O sea que si llegué a esa cláusula \\(\square\\) ya llegué a que es insatisfactible!

### Regla de resolución

- Dado un literal \\(L\\), el **opuesto** \\(\bar{L}\\) se define como:
    - \\(\neg P\\) si \\(L = P\\)
    - \\(P\\) si \\(L = \neg P\\)
- Dadas dos cláusulas \\(C_1, C_2\\), una cláusula \\(C\\) se dice **resolvente** de \\(C_1\\) y \\(C_2\\) sii, para algún literal \\(L\\), \\(L \in C_1, \bar{L} \in C_2\\), y:

$$
C = (C_1 - \lbrace L \rbrace) \cup (C_2 - \lbrace \bar{L} \rbrace)
$$

Formulación:

$$
\frac{\lbrace A_1, \dots, A_m, Q \rbrace\ \ \lbrace B_1, \dots, B_n, \neg Q \rbrace}{\lbrace A_1, \dots, A_m, B_1, \dots, B_n \rbrace}
$$

~~~admonish example title="Ejemplo" 

El resultado de aplicar la regula de resolución a 

$$
\set{\set{P, Q}, \set{P, \neg Q}, \set{\neg P, Q}, \set{\neg P, \neg Q}}
$$

es

$$
\set{\set{P, Q}, \set{P, \neg Q}, \set{\neg P, Q}, \set{\neg P, \neg Q}, \mathbf{\set{P}}}
$$

~~~

### Volviendo al método de resolución

- Voy a mantener el conjunto que representa la fórmula para la que hay que demostrar la infactibilidad
- en cada **paso de resolución**, agrego a mi conjunto \\(S\\) el resolvente de dos cláusulas de \\(S\\)
- es seguro asumir que el resolvente que se agrega a \\(S\\) no pertenece al mismo.
- Por la demo que vimos antes sabemos que agregar el resolvente preserva la insatisfactibilidad.

Decimos que un conjunto de cláusulas es una **refutación** si contiene a la
cláusula vacía \\(\square\\). El método de resolución entonces busca construir
una secuencia de conjuntos de cláusulas usando pasos de resolución hasta llegar
a una refutación.

### Terminación de la regla de resolución

- La aplicación reiterada (inteligente, siempre que se agrega un resolvente
  tiene que ser nuevo), siempre termina
- En el peor de los casos la regla de resolución puede generar una cláusula
  nueva por cada combinación diferente de literales distintos de \\(S\\), o sea
  el conjunto de partes.

> **Teorema**: \\(S\\) es insatisfactible sii tiene una refutación.

## Juntando todo...

Si queremos probar que \\(A\\) es tautología:

1. Calculamos la FNC de \\(\neg A\\).
2. Aplicamos el método de resolución
3. Si hallamos una refutación:
    - \\(\neg A\\) es insatisfactible.
    - Y por lo tanto, \\(A\\) es tautología.
4. Si no:
    - \\(\neg A\\) es satisfactible.
    - Y por lo tanto, \\(A\\) no es tautología.
