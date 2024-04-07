$$
   \newcommand{\lft}[2]{\lambda{#1}.{#2}}
   \newcommand{\lf}[3]{\lambda{#1}:\ {#2}.{#3}}
   \newcommand{\ifLC}[3]{if\  {#1}\  then\  {#2}\  else\  {#3}}
   \newcommand{\apply}[2]{{#1}\ {#2}}
   \newcommand{\hastype}[3]{{#1} \triangleright {#2}: {#3}}
   \newcommand{\inference}[1]{\mathbb{W}(#1)}
$$
# Inferencia de tipos

Queremos resolver el problema de recibir términos sin información de tipos o
con información de tipos parcial en términos tipables. Para eso es necesario
**inferir** la información de tipos que falta.

En lenguajes tipados esto permite obviar algunas declaraciones de tipos (e.g
Haskell, Rust, etc.), esto puede resultar en código más simple de entender
(menos complejidad), y no afecta el tiempo de ejecución porque esto se puede
hacer en tiempo de compilación.

## Punto de partida

Primero vamos a modificar la sintaxis de los términos del \\(\lambda\\)-cálculo
eliminando toda anotación de tipos (el único lugar donde teníamos era en la
lambda). O sea la función lambda pasa a ser: \\(\lft{x}{M}\\). A ese conjunto
de términos lo denotamos \\(\Lambda\\).

Para formalizar esto, vamos a usar la función \\(Erase(.):\ \Lambda_{\tau} \rightarrow \Lambda\\) que elimina las anotiaciones de tipos. Por ejemplo:

$$
Erase(\lf{x}{Nat}{\lf{f}{Nat\ \rightarrow Nat}{\apply{f}{x}}}) = \lft{x}{\lft{f}{\apply{f}{x}}}
$$

## Definición formal del problema de la inferencia

Dado \\(U\\) un término sin anotaciones de tipo, encontrar un término con anotaciones de tipos \\(M\\) tal que:

1. \\(\hastype{\Gamma}{M}{\sigma}\\) para algún \\(\Gamma\\) y \\(\sigma\\), y
2. \\(Erase(M) = U\\)

### Ejemplos

- \\(U = \lft{x}{succ(x)}\\), \\(\lf{x}{Nat}{succ(x)}\\) (en este caso no hay otra posibilidad)
- \\(U = \lft{x}{\lft{f}{\apply{f}{x}}}\\) tomamos \\(M_{\sigma,\tau} = \lf{x}{\sigma}{\lf{f}{\sigma \rightarrow \tau}{\apply{f}{x}}}\\) (notar que en este caso hay un \\(M_{\sigma,\tau}\\) por cada par \\(\sigma,\tau\\))
- Si \\(U = \apply{x}{x}\\), en principio no tenemos un término \\(M\\) que satisfaga la propiedad.

~~~admonish warning title="Chequeo != Inferencia"

Es importante poder diferenciar un problema de otro. El problema del chequeo de
tipos es que dado un término \\(M\\) tengo que determinar si existe un contexto
\\(\Gamma\\) y un tipo \\(\sigma\\) tales que \\(\hastype{\Gamma}{M}{\sigma}\\)
es derivable.

- esto es muuuuuucho más fácil que el problema de inferencia, ya que está todo guiado por sintáxis
- de hecho, la forma para chequear eso es seguir la estructura sintáctica para construir una derivación del juicio de tipado.
- es escencialmente lo mismo a que ya te den el \\(\Gamma\\) y el \\(\sigma\\) y veas si \\(\hastype{\Gamma}{M}{\sigma}\\) es derivable.

~~~

## Variables de tipo

Supongamos que tenemos \\(U = \lft{x}{\\lft{f}{\apply{f}{x}}}\\). Entonces dijimos que para cada \\(\sigma\\) tengo definido un \\(M_{\sigma} = \lf{x}{\sigma}{\lf{f}{\sigma \rightarrow \sigma}{\apply{f}{x}}}\\). Y cada uno de esos es una solución posible al problema de la inferencia.

Entonces, estaría bueno tener una forma de agrupar todas esas soluciones en una sola. Para eso, podríamos representar a todas las soluciones con \\(\lf{x}{s}{\lf{f}{s \rightarrow s}{\apply{f}{x}}}\\

- \\(s\\) no es un tipo en si mismo si no que es una variable de tipos.
- la expresión no es una solución en si misma, pero la substitución de \\(s\\)
  por cualquier expresióin de tipos si nos da una solución.

## Extensión de las expresiones de tipo

$$
\sigma ::= s\ |\ Nat\ |\ Bool\ |\ \sigma \rightarrow \tau
$$

- Denotamos con \\(\mathcal{V}\\) al conjunto de variables de tipo.
- Denotamos con \\(\mathcal{T}\\) al conjunto de tipos definidos como arriba.

## Sustitución de tipos

Vamos a definir una función de sustitución que mapea variables de tipo en
expresiones de tipo \\(\mathcal{S}: \mathcal{V} \rightarrow \mathcal{T}\\).
Sólo nos interesan las \\(\mathcal{S}\\) tales que \\(\\{t \in \\mathcal{V}\ |\ St \neq t\\}\\) 
es finito (Es un detalle técnico, lo importante es que no queremos que reemplace infinitas variables)


Además, vamos a querer poder aplicar \\(S\\) a varias cosas:

- expresiones de tipos (dado \\(\sigma\\), escribimos \\(S\sigma\\))
- un término cualquiera (dado \\(M\\) escribimos \\(SM\\))
- un contexto de tipado (dado \\(\Gamma = \\{x_1: \sigma_1, \dots, x_n: \sigma_n\\}\\) escribimos \\(S\Gamma\\) definido como:)

$$
S\Gamma = \\{x_1: S\sigma_1, \dots, x_n: S\sigma_n\\}
$$

Algunas consideraciones extra:

- Llamamos **soporte de** \\(S\\) a \\(\\{t\ |\ St \neq t\\}\\)
- El soporte representa las variables que \\(S\\) "afecta".
- Usamos la notación \\(\\{\sigma_1/t_1, \dots, \sigma_n/t_n\\}\\) para la sustitución con soporte \\(\\{t_1, \dots, t_n\\}\\)
    - los \\(\sigma_i\\) es la cosa por la que reemplazo a los Ts
- La sustitución con soporte \\(\emptyset\\) es la sustitución identidad y la notamos \\(Id\\)

## Juicio de tipado instanciado

Dado un juicio de tipado original \\(\hastype{\Gamma}{M}{\sigma}\\), hablamos del juicio de tipado instanciado \\(\hastype{\Gamma'}{M'}{\sigma'}\\) al resultante de aplicarle una sustitución \\(S\\) al juicio original (en caso de existir tal \\(S\\). Esto es equivalente a que existe \\(S\\) tal que:

$$
S\Gamma \subseteq \Gamma', M' = SM, \sigma' = S\sigma
$$

> **Propiedad**: si \\(\hastype{\Gamma}{M}{\sigma}\\) es derivable, entonces cualquier instancia del mismo juicio de tipado lo es.

## Función de inferencia \\(\inference{.}\\)

Es una función que dado un término \\(U\\) sin anotaciones verifica:

- Corrección: \\(\inference{U} = \hastype{\Gamma}{M}{\sigma}\\) implica
    - \\(Erase(M) = U\\)
    - \\(\hastype{\Gamma}{M}{\sigma}\\) es derivable
- Completitud: Si \\(\hastype{\Gamma}{M}{\sigma}\\) es derivable y \\(Erase(M) = U\\), entonces
    - \\(\inference{U}\\) tiene éxito (si existe lo tiene que encontrar)
    - produce un juicio \\(\hastype{\Gamma'}{M'}{\sigma'}\\) tal que \\(\hastype{\Gamma}{M}{\sigma}\\) es instancia del mismo (se dice que \\(\inference{.}\\)) **computa un tipo principal**. (capaz no encuentra exactamente el mismo término o al menos va a encontrar algo del que mi juicio original sea instancia. O sea que el algoritmo te va a dar la versión más general)

### Algoritmo de inferencia (casos bases)

$$
\begin{align}
\inference{0} &\stackrel{def}{=} \hastype{\emptyset}{0}{Nat} \\\\
\inference{true} &\stackrel{def}{=} \hastype{\emptyset}{true}{Bool} \\\\
\inference{false} &\stackrel{def}{=} \hastype{\emptyset}{false}{Bool} \\\\
\inference{x} &\stackrel{def}{=} \hastype{\\{x: s\\}}{x}{s}, x \text{ variable fresca}
\end{align}
$$

### Algoritmo de inferencia (caso succ)

$$
\inference{succ(U)} \stackrel{def}{=} ? 
$$

- Sea \\(\inference{U} = \hastype{\Gamma}{M}{\tau}\\) ("aplico hipótesis inductiva")
- Tenemos que saber si \\(\tau\\) puede ser un \\(Nat\\)

~~~admonish info title="Unificación"

Al igual que arriba, me puedo encontrar casos en donde tengo que saber si una
expresión de tipos es compatible o unificable con otra. Dicho proceso implica
determinar si existe una sustitución \\(S\\) tal que las expresiones de tipos
(ponele que son \\(\sigma\\) y \\(\tau\\)) son unificables (o sea \\(S\sigma =
S\tau\\))

Por ejemplo, el tipo \\(s \rightarrow t\\) es unificable con \\(Nat \rightarrow u\\)?

- puedo armar una sustitución que tome \\(s\\) y lo transforme en \\(Nat\\), y agarre \\(t\\) y lo transforme en \\(u\\)
- en este caso la estructura lo facilita también, pero se puede replicar para otras expresiones

~~~

## Propiedades de sustituciones

- La composición de sustituciones es equivalente a la composición de funciones. Ejemplo:

![](./img/sust_composicion.png#center)

- Decimos que \\(S = T\\) si tienen el mismo soporte y \\(St = Tt\\) para todo \\(t\\) del soporte.
- la identidad no afecta en la composición
- la composición es asociativa
- decimos que una sustitución \\(S\\) es **más general** que \\(T\\) si existe \\(U\\) tal que \\(T = U \circ S\\)
    - \\(S\\) es más general que \\(T\\) porque \\(T\\) se obtiene instanciando \\(S\\)
    - Ej: una sustitución que reemplaza \\(s\\) por \\(t \rightarrow t\\) es más general que otra que la reemplaza por \\(Nat \rightarrow Nat\\)

## Unificador

Una **expresión de unificación** es algo de la forma `expr1 = expr2`. Una sustitución es una solución de un conjunto de ecuaciones de unificación \\(\\{\sigma_1 = \sigma_1', \dots, \sigma_n = \sigma_n'\\}\\) si \\(S\sigma_1 = S\sigma_1', \dots, S\sigma_n = S\sigma_n'\\)

Veamos unos ejemplos:

- La sustitución \\(\\{Bool/v, Bool \times Nat/u\\}\\) es solución de \\{v \times Nat \rightarrow Nat = u \rightarrow Nat\\}
    - \\(\\{Bool \times Bool/v, (Bool \times Bool) \times Nat/u\\}\\) también es solución, pero es un poco más compleja.
    - \\(\\{v \times Nat/u\\}\\) también... y de hecho es más simple... más **GENERAL**.
- \\(\\{Nat \rightarrow s = t \times u\\}\\) no tiene solución porque no puedo matchear la función con un producto interno.
- \\(\\{u \rightarrow Nat = u\\}\\) no tiene solución porque cualquier cosa por la que reemplace a \\(u\\) me queda distinto.

### Unificador más general (MGU)

Retomemos eso de la solución simple y **más general**. Una sustitución \\(S\\) es un MGU de \\(\\{\sigma_1 = \sigma_1', \dots, \sigma_n = \sigma_n'\\}\\) si:

1. es solución del conjunto de ecuaciones
2. es más general que cualquier otra solución

En el ejemplo anterior \\(\\{v \times Nat/u\\}\\) era la MGU.

### Algoritmo de unificación

Sabiendo que vale el siguiente teorema:

> Si \\(\\{\sigma_1 = \sigma_1', \dots, \sigma_n = \sigma_n'\\}\\) tiene solución, entonces existe MGU y es único salvo por renombre de variables
 
Vamos a armar un algoritmo que cumple:

- entrada: 
    - conjunto de ecuaciones de unificación
- salida: 
    - MGU del conjunto, si tiene solución
    - falla en caso contrario

### Algoritmo de Martelli-Montanari

- es no determinístico (defino reglas para aplicar pero no hay un orden específico establecido)
- consiste en reglas de simplificación, que simplifican conjuntos de pares de tipos a unificar (goals)

$$
G_0 \rightarrow G_1 \rightarrow \dots \rightarrow G_n
$$

- las secuencias que terminan con el goal vacío son las existosas. El resto
  fallan
- algunos pasos usan una substitución que representa una solución parcial, pero
  si la secuencia es exitosa basta con componer todas las substituciones y
  obtenemos el MGU.

#### Reglas del algoritmo

1. Descomposición
    - \\(\\{\sigma_1 \rightarrow \sigma_2 = \tau_1 \rightarrow \tau_2\\} \cup G \rightarrow \\{\sigma_1 = \tau_1, \sigma_2 = \tau2\\} \cup G\\) (igualdad de funciones se descompone en igualdad de cada tipo de la función)
    - \\(\\{Nat = Nat\\} \cup G \rightarrow G\\)
    - \\(\\{Bool = Bool\\} \cup G \rightarrow G\\)
2. Eliminación de par trivial
    - \\(\\{s = s\\} \cup G \rightarrow G\\)
3. Swap: si \\(\sigma\\) no es una variable
    - \\(\\{\sigma = s\\} \cup G \rightarrow \\{s = \sigma\\} \cup G\\) (es un paso intermedio para usar la regla 4)
4. Eliminación de variable: si \\(s \notin FV(\sigma)\\)
    - \\(\\{s = \sigma\\} \cup G \rightarrow_{\\{\sigma/s\\}} \\{\sigma/s\\}G \\) (el objetivo de la regla es eliminar la restricción)
5. Colisión
    - \\(\\{\sigma = \tau\\} \cup G \rightarrow falla\\), con \\((\sigma, \tau) \in T \cup T^{-1}\\) (las permutaciones de matchear Bool, Nat o función) y \\(T = \\{(Bool, Nat), (Nat, \sigma_1 \rightarrow \sigma_2), (Bool, \sigma_1 \rightarrow \sigma_2)\\}\\)
6. Occur check: si \\(s \neq \sigma\\) y \\(s \in FV(\sigma)\\)
    - \\(\\{s = \sigma\\} \cup G \rightarrow falla\\) (es como el ejemplo de \\(s = s \rightarrow Nat\\) que habíamos visto antes)

~~~admonish example title="Ejemplo"

![](./img/ejemplo_montanari.png#center)

Notar que aplicamos 3 sustituciones. Armemos el MGU que es:

$$
\\{Nat \rightarrow (s \rightarrow s)/u\\} \circ \\{s \rightarrow s/r\\} \circ \\{Nat \rightarrow r/t\\} = \\\\
\\{Nat \rightarrow (s \rightarrow s)/t, s \rightarrow s/r, Nat \rightarrow (s \rightarrow s)/u\\}
$$

~~~

#### Propiedades del algoritmo (Teorema)

- El algoritmo siempre termina
- Sea \\(G\\) un conjunto de pares. Si tiene unificador, entonces el algoritmo de Martelli-Montanari termina exitosamente y devuelve un MGU. Y si no tiene  el algoritmo termina con \\(falla\\)

### Volviendo a Succ

$$
\inference{succ(U)} \stackrel{def}{=} ? 
$$

- Sea \\(\inference{U} = \hastype{\Gamma}{M}{\tau}\\) ("aplico hipótesis inductiva")
- Sea \\(S = MGU\\{\tau = Nat\\}\\)

Entonces:

$$
\inference{succ(U)} \stackrel{def}{=} \hastype{S\Gamma}{S\ succ(M)}{Nat}
$$

> Nota: \\(pred\\) es similar

### Algoritmo de inferencia (caso iszero)

- Sea \\(\inference{U} = \hastype{\Gamma}{M}{\tau}\\)
- Sea \\(S = MGU\\{\tau = Nat\\}\\)

Entonces:

$$
\inference{iszero(U)} \stackrel{def}{=} \hastype{S\Gamma}{S\ iszero(M)}{Bool}
$$

### Algoritmo de inferencia (caso ifThenElse)

- Sea \\(\inference{U} = \hastype{\Gamma_1}{M}{\rho}\\)
- Sea \\(\inference{V} = \hastype{\Gamma_2}{P}{\sigma}\\)
- Sea \\(\inference{W} = \hastype{\Gamma_3}{Q}{\tau}\\)
- Sea \\(S = MGU(\\{\rho = Bool, \sigma = \tau\\} \cup \\{\sigma_1 = \sigma_2\ |\ x: \sigma_1 \in \Gamma_i \land x: \sigma_2 \in \Gamma_j, i \neq j\\})\\)
    - el primer conjunto es simplemente forzar que la parte del if sea un booleano y que matcheen los tipos del then y del else para que todo tipe bien. 
    - la segunda parte es para asegurarte que las variables que reciben un tipo en cada término sean consistentes con el resto (notar que el ifThenElse no liga variables así que no hay que tener mucho cuidado respecto a eso).

Entonces:

$$
\inference{\ifLC{U}{V}{W}} \stackrel{def}{=} \hastype{S\Gamma_1 \cup S\Gamma_2 \cup S\Gamma_3}{S\ (\ifLC{M}{P}{Q})}{\sigma}
$$

> Notar que se puede usar tanto \\(\tau\\) como \\(\sigma\\) porque ya tenemos la ecuación de unificación que hace que sean iguales.

### Algoritmo de inferencia (caso aplicación)

- Sea \\(\inference{U} = \hastype{\Gamma_1}{M}{\tau}\\)
- Sea \\(\inference{V} = \hastype{\Gamma_2}{N}{\rho}\\)
- Sea \\(S = MGU(\\{\tau = \rho \rightarrow t\\} \cup \\{\sigma_1 = \sigma_2\ |\ x: \sigma_1 \in \Gamma_i \land x: \sigma_2 \in \Gamma_j, i \neq j\\})\\), con \\(t\\) una variable fresca.
    - el segundo conjunto es el mismo que para el ifThenElse
    - el otro es para asegurarnos que \\(U\\) sea una función que recibe lo que sea que devuelva \\(V\\).

Entonces:

$$
\inference{\apply{U}{V}} \stackrel{def}{=} \hastype{S\Gamma_1 \cup S\Gamma_2}{S(\apply{M}{N})}{St}
$$

### Algoritmo de inferencia (caso abstracción / lambda)

- Sea \\(\inference{U} = \hastype{\Gamma}{M}{\rho}\\)
- Si el contexto tiene información de tipos para \\(x\\) (o sea \\(x: \tau \in \Gamma\\), o lo que es lo mismo, \\(x\\) no puede tomar cualquier valor), entonces:

$$
\inference{\lft{x}{U}} \stackrel{def}{=}  \hastype{\Gamma \setminus \\{x: \tau\\}}{\lf{x}{\tau}{M}}{\tau \rightarrow \rho}
$$

- Si no (o sea \\(x \notin Dom(\Gamma)\\)), elegimos una variable fresca \\(s\\) y entonces:

$$
\inference{\lft{x}{U}} \stackrel{def}{=}  \hastype{\Gamma}{\lf{x}{s}{M}}{s \rightarrow \rho}
$$

> Notar que en este caso sólo le saco cosas al contexto, justamente porque el
> término \\(U\\) es como dejar "libre" a \\(x\\), pero en realidad el valor de
> \\(x\\) va a estar restringido por el tipo que le ligue la función lambda, no
> el contexto.

### Algoritmo de inferencia (caso \\(fix\\))

- Sea \\(\inference{U} \stackrel{def}{=} \hastype{\Gamma}{M}{\rho}\\)
- Recuerdo la regla de tipado de fix:

$$
\frac{\hastype{\Gamma}{M}{\sigma_1 \rightarrow \sigma_1}}{\hastype{\Gamma}{fix\ M}{\sigma_1}} (T-Fix)
$$

- Sea \\(S = MGU \\{\rho = s \rightarrow s\\}\\) con \\(s\\) una variable fresca

Entonces:

$$
\inference{fix(U)} \stackrel{def}{=} \hastype{S\Gamma}{S\ fix(M)}{s}
$$

