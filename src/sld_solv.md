$$
   \newcommand{\true}{\mathbf{T}}
   \newcommand{\false}{\mathbf{F}}
   \newcommand{\satisf}{\models}
   \newcommand{\notsatisf}{\nvDash}
   \newcommand{\set}[1]{\lbrace #1 \rbrace}
   \newcommand{\tuple}[1]{< #1 >}
$$
# Resolución SLD

## Resolución lineal

El método de resolución lineal surge como alternativa al método de resolución que vimos antes. Si bien es completo (o sea llego a una refutación o es insatisfactible), el método tiene 2 problemas grandes para llevarlo a una implementación:

- El espacio de búsqueda puede ser muy grande (exponencial en la cantidad de variables)
- Hay un grado muy alto de no-determinismo, a la hora de tomar las decisiones de:
    - qué cláusulas elegir para la resolvente? Esto lo llamamos la **regla de búsqueda**
    - qué literales elimino una vez elegidas las cláusulas? Esto lo llamamos la **regla de selección**

Para llevarlo a una implementación usable, queremos restringir ese espacio **sin romper completitud**.

Vamos a decir que una secuencia de pasos de resolución es **lineal** si tiene esta pinta:

![](./img/res_lineal.png#center)

Donde \\(C_0\\) es un elemento del conjunto inicial y cada \\(B_i\\) es o bien un elemento del conjunto inicial o es alguno de los \\(C_j\\) con \\(j < i\\).

Por ejemplo:

![](./img/res_lineal_ejemplo.png#center)

Algunas ventajas:

- reduzco el espacio de búsqueda (no elijo 2 cláusulas cualquiera, tengo que usar sí o si la última cláusula y en el peor caso pruebo una vez nomás contra todas las cláusulas)
- preserva completitud, esto es que si la fórmula es insatisfactible entonces existe una resolución lineal.

Pero quedaun problema:

- sigue siendo no determinístico. Puedo mejorar todavía la regla de búsqueda e implementar una regla de selección

## Cláusulas de Horn

El método que vamos a ver nos va a dar más eficiencia para producir
refutaciones, que no pierde completitud peeeeeero sólo para una subclase de
fórmulas. Una de esas subclases es la de **cláusulas de Horn**.

Una cláusula de Horn es una disyunción de literales en donde hay **a lo sumo un literal positivo**. Por ejemplo:

- \\(\set{A, B}\\) no es una cláusula de horn porque hay 2 cláusulas positivas
- \\(\set{A, \neg B}\\) es una cláusula de horn porque hay 1 cláusula positivas (\\(\leq 1\\))
- \\(\set{\neg A, \neg B}\\) es una cláusula de horn porque no hay cláusulas positivas (\\(\leq 1\\))

Recordemos que luego de pasar a forma clausal en primer orden, tenemos algo como:

$$
(\forall x_1 \dots \forall x_n. C_1) \land \dots \land (\forall x_1 \dots \forall x_n. C_m)
$$

Y la forma clausal se escribe como \\(\set{C_1', \dots, C_k'}\\) donde \\(C_i'\\) es el conjunto de literales en \\(C_i\\) (ya que era una disyunción de literales).

Entonces, aplucando la definición de antes al contexto de la forma clausal, decimos que una cláusula de Horn entonces va a ser de la forma

$$
\forall x_1 \dots \forall x_n. C
$$

tal que la disyunción de literales tiene a lo sumo un literal positivo. Notar que esto nos restringe bastante la pinta que puede tener \\(C\\). Porque ahora sólo podría ser:

- \\(\set{B, \neg A_1, \dots, \neg A_n}\\). A esta se la suele llamar **cláusula de definición**
- \\(\set{B}\\) **es una forma de decir verdades o hechos**
- \\(\set{\neg A_1, \dots, \neg A_n}\\). A esta **se la suele llamar cláusula goal, objetivo o negativa**

### Expresividad de las cláusulas de Horn

No toda fórmula de primer orden puede expresarse como una cláusula de Horn. Por
ejemplo \\(\forall x. (P(x) \lor Q(x))\\). Sin embargo, son lo suficientemente
expresivas commo para representar programas, usando la resolución como
mecanismo de cómputo.

### Resolución SLD

Vamos a llamar **Cláusula de definición** (Definite Clause) a aquellas que tienen **exactamente** un literal positivo. Además definimos \\(S = P \cup \set{G}\\) un conjunto de cláusulas de Horn tal que

- \\(P\\) es un conjunto de cláusulas de definición, va a contener los "programas" o lo que llamamos base de conocimiento
- \\(G\\) es una cláusula negativa, que va a ser el goal

Una secuencia de pasos de **resolución SLD** para \\(S\\) es una secuencia:

$$
\tuple{N_0, N_1, \dots, N_p}
$$

de **cláusulas negativas** tales que:

- \\(N_0\\) es el goal \\(G\\)
- En cada paso \\(N_i\\), si \\(N_i = \set{\neg A_1, \dots, \neg A_{k-1}, \neg A_k, \neg A_{k+1}, \dots, \neg A_n}\\), entonces hay una cláusula de definición \\(C_i\\) de la forma \\(\set{A, \neg B_1, \dots, \neg B_m}\\) en \\(P\\) tal que \\(A\\) y \\(A_k\\) son unificables con \\(MGU(A, A_k) = \sigma\\) y (dependiendo de si \\(C_i\\) tiene cláusulas negativas o no) si:
    - \\(m = 0\\), entonces \\(N_{i+1} = \set{\sigma(\neg A_1, \dots, \neg A_{k-1}, \neg A_{k+1}, \dots, \neg A_n)}\\)
    - \\(m > 0\\), entonces \\(N_{i+1} = \set{\sigma(\neg A_1, \dots, \neg A_{k-1}, \neg B_1, \dots, \neg B_m, \neg A_{k+1}, \dots, \neg A_n)}\\)

Notar que esto sigue siendo una resolución lineal, salvo que un poco más restringida:

![](./img/res_sld_lineal.png#center)

#### Sustitución respuesta

En cada paso \\(i\\) hacemos un paso de resolución en la que unificamos como dijimos un átomo \\(A_k\\) con otro \\(A\\) mediante un \\(MGU(A, A_k) = \sigma_i\\).

- Al literal \\(A_k\\) lo llamamos **átomo seleccionado** de \\(N_i\\)
- La **sustitución respuesta** es la resultante de componer todas las sustituciones, y es lo que prolog usa para extraer la salida del programa

    $$
    \sigma_p \circ \dots \circ \sigma_1
    $$

### Corrección y completitud

- Si un conjunto de cláusulas de Horn tiene refutación SLD, entonces es insatisfactible.
- Si un conjunto de cláusulas de Horn \\(P \cup \set{G}\\) es insatisfactible, entonces existe una refutación SLD cuya primera cláusula es \\(G\\).
