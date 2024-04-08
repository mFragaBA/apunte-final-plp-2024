$$
   \newcommand{\ifLC}[3]{if\  {#1}\  then\  {#2}\  else\  {#3}}
   \newcommand{\lf}[3]{\lambda{#1}:\ {#2}.{#3}}
   \newcommand{\apply}[2]{{#1}\ {#2}}
   \newcommand{\hastype}[3]{{#1} \triangleright {#2}: {#3}}
   \newcommand{\tapp}[5]{\frac{\hastype{#1}{#2}{#3 \rightarrow #4}\ \ \hastype{#1}{#5}{#3}}{\hastype{#1}{\apply{{#2}}{{#5}}}{#4}} (T-app)}
$$
# Subtipado

## Por qué?

Arrancamos con un cálculo lambda bastante simple, y le fuimos agregando
extensiones para hacer cosas más interesantes (registros, referencias, side
effects, fix, etc.). Ahora vamos a ver una extensión más, que va a flexibilizar
un poco el sistema de tipos.

Qué quiere decir esto? Bueno, que hay casos donde sabemos que el programa no va
a "romper", pero nuestro sistema de tipos rechaza ese término. Pensar que el
objetivo del sistema de tipos en parte es rechazar términos que no tienen
sentido. Veamos un ejemplo:

$$
\apply{\lf{x}{\\{a: Nat\\}}{x.a}}{\\{a = 1, b = true\\}}
$$

A simple vista parece que funciona, pero el término es rechazado porque el tipo
del registro también incluye lo que pasa con \\(b\\). Pero a mi qué me importa
que tenga \\(b\\) en el contexto de la lambda?

## Principio de sustitutividad

Definimos la siguiente expresión:

$$
\sigma <: \tau
$$

Que quiere decir que en todo contexto donde se espera una expresión de tipo
\tau, puedo pasarle una de tipo \sigma y también funciona. Es mucho muy
importante entender esto y ante la duda hacer con un ejemplo (o tomar el caso
puntual) y preguntarte, con qué tipo anda y con qué tipo quiero que también
funcione.

Esto mismo se expresa con la regla de tipado de Subsumption (Subsumisión):

$$
\frac{\hastype{\Gamma}{M}{\sigma}\ \ \ \sigma <: \tau}{\hastype{\Gamma}{M}{\tau}} (T-Subs)
$$

~~~admonish info title="Subtipado de tipos básicos"

- \\(Nat <: Float\\)
    - "Siempre que tenga un término que acepta float puedo usar un nat y no debería romper"
- \\(Int <: Float\\)
    - "Siempre que tenga un término que acepta float puedo usar un int y no debería romper"
- \\(Bool <: Nat\\)
    - "Siempre que tenga un término que acepta Nat puedo usar un bool y no debería romper"

~~~

Algo interesante que agrega este operador es que induce un pre-orden, o sea que es reflexiva y transitiva:

<div style="width:330px;">

$$
\frac{}{\sigma <: \sigma} (T-Refl) \\\\
\frac{\sigma <: \tau\ \ \ \tau <: \rho}{\sigma <: \rho} (T-Trans)
$$

</div>

<div style="float:right;margin-left:2rem;margin-bottom:3rem;margin-top:-10rem;width:330px">

> Nota: No es ni antisimétrica ni simétrica

~~~admonish question title="Querríamos tener un orden total?"

A priori suena medio raro, porque hay cosas que ni tienen sentido comparar. No
tiene mucho sentido comparar por ejemplo un entero con una función, o un
booleano con una función. Pero capaz si tiene sentido comparar las funciones
según su tipo de entrada y salida.

~~~

</div>

## Revisitando las reglas de tipado para lambdacálculo con registros

A priori las reglas más básicas \\(T-Var\\), \\(T-Var\\), \\(T-Abs\\) y
\\(T-App\\) no requieren cambios.

Por otro lado teníamos las [reglas de tipado](./lambda_calc_extendido.md#reglas-de-tipado) para registros \\(T-Rcd\\) y \\(T-Proj\\) para los registros y su proyección:

</br>
</br>

$$
\frac{\Gamma \triangleright M_i : \sigma_i\ \text{para cada } i \in 1 \dots n}{\Gamma \triangleright \\{l_i = M_i^{i \in 1 \dots n} \\} : \\{l_i : \sigma_i^{i \in 1 \dots n}\\}} (T-RCD) \\\\
\frac{\Gamma \triangleright M_i : \\{l_i : \sigma_i^{i \in 1 \dots n}\\}\ j \in 1 \dots n}{\Gamma \triangleright M.I_j : \sigma_j} (T-Proj)
$$

Ahora, lo siguiente que vamos a hacer es introducir la regla \\(T-Trans\\), y
la vamos a usar para agregar nuevas reglas.

### Subtipados de registros a lo "ancho"

Idea de la regla: si yo tengo algo que tipa para un registro, agregarle más
cosas a dicho registro no debería de cambiar nada. Por ejemplo: `{nombre:
String, edad: Int} <: {nombre: String}`.

Generalizando, nos quedaría:

$$
\frac{}{\\{l_i: \sigma_i\ |\ i \in 1\dots n + k\\} <: \\{l_i: \sigma_i\ |\ i \in 1\dots n\\}} (S-RcdWidth)
$$

- Nota: \\(\sigma <: \\{\\}\\) para todo registro \\(\sigma\\).
- Hay algún tipo registro \\(t\\) tal que \\(\tau <: \sigma\\) para todo tipo registro \\(\sigma\\).
    - yo creo que no, porque basta con agarrar un registro que tenga una etiqueta que \\(t\\) no use y armar un registro con eso.

### Subtipado "en profundidad"

Si yo tuviese `{a: Nat, b: Int} ? {a: Float, b: Int}`. Qué va en el `?`? Bueno,
si yo cuando espero un `Float` me pasan un `Nat` y anda, debería de pasar lo
mismo si para una etiqueta el tipo es `Float` y me pasan algo que para esa
etiqueta el tipo es `Nat`. Generalizando eso se escribe como:

$$
\frac{\sigma_i <: \tau_i\ i \in \\{1 \dots n\\}}{\\{l_i: \sigma_i\ |\ i \in 1\dots n\\} <: \\{l_i: \tau_i\ |\ i \in 1\dots n\\}} (S-RcdDepth)
$$

- Notar que la restricción la hacemos sobre todos los campos (como el subtipado
  es reflexivo no nos trae muchos problemas y no perdemos flexibilidad vs
  escribir la regla sobre un label puntual).
- Ejemplo: `{x: {a: Nat, b: Nat}, y: {m: Nat}} <: {x: {a: Nat}, y: {}}`. Vale pues:
    - `{m: Nat} <: {}` (value para cualquier cosa que ponga a la izquierda).
    - `{a: Nat, b: Nat} <: {a: Nat}` ya que es agregarle `b: Nat` a `{a: Nat}` (\\(S-RcdWidth\\))
    - Como para `x` e `y`, los tipos del término de la izquierda son subtipos de los de la derecha, + \\(S-RcdDepth\\) obtenemos que el término de la izquierda es subtipo del de la derecha

### Permutaciones de campos

Más que nada para simplificar el lenguaje, cuando definimos los registros
teníamos la restricción de que el tipo te fijaba el órden de las etiquetas, a
pesar de que con las etiquetas ya debería de ser suficiente independientemente
del orden. O sea, me da lo mismo tener `{a: String, b: Int}` que `{b: Int, a: String}`. Generalizando:

$$
\frac{\\{k_j: \sigma_j\ j \in 1 \dots n\\} \text{ es permutación de } \\{l_i: \tau_i\ i \in 1 \dots n\\}}{\\{k_j: \sigma_j\ j \in 1 \dots n\\} <: \\{l_i: \tau_i\ i \in 1 \dots n\\}} (S-RcdPerm)
$$

~~~admonish info title="Nota: Eliminando etiquetas"

Usando \\(S-RcdWidth\\) + \\(S-Trans\\) + \\(S-RcdPerm\\) puedo eliminar campos en cualquier parte del registro

- lo puedo lograr reordenando los campos que no quiero al fondo y después eliminandolos
- podría armar una regla nueva también, pero ya con lo que tenemos tenemos una base

$$
\frac{\\{l_i: \tau_i\ i \in 1 \dots n\\} \subseteq \\{k_j: \sigma_j\ j \in 1 \dots m\\}\ \ \ \ k_j = l_i \implies \sigma_j <: \tau_i}{\\{k_j: \sigma_j\ j \in 1 \dots n\\} <: \\{l_i: \tau_i\ i \in 1 \dots n\\}} (S-Rcd)
$$

O sea que si:

- tengo un subconjunto de las etiquetas (está implícito que tiene más campos) y
- en aquellas que coincide su tipo correspondiente es subtipo del otro

Entonces un tipo registro es subtipo del otro. Para hacer las pruebas vamos a usar esta regla (más que nada para ahorrarnos pasos y que quede una demo más directa)

~~~

## Subtipado de tipos función

Cómo funcionaría para las funciones? Si yo quiero que \\(\sigma_1 \rightarrow \tau_1 <: \sigma_2 \rightarrow \tau_2\\), qué le tengo que pedir a \\(\sigma_1, \sigma_2, \tau_1, \tau_2\\)?

Primero, hay que tener como base que lo que quiero es que a una función que acepta \\(\sigma_2 \rightarrow \tau_2\\) le pueda pasar algo de tipo \\(\sigma_1 \rightarrow \tau_1\\). Esto significaría:

- Que el dominio tiene que ser compatible, o sea que las cosas de \\(\sigma_2\\) que se le pasaban a la función funcionen con cosas de \\(sigma_1\\).
    - o sea \\(\sigma_2 <: \sigma_1\\)
- Que el resultado de la función funcione en lugar del tipo que devolvía lo otra función.
    - o sea \\(\tau_1 <: \tau_2\\)

Veamos dos casos:

- Supongamos que tenemos los tipos `Nat` e `Int`, y mi código usaba una función
  de tipo `Int -> Int` (por ejemplo, la función `sumar_2 x = x + 2`). Si yo le
  pasara la función raíz cuadrada que es de tipo `Nat -> Nat` y en algún
  momento se le pasaba un número negativo, explotaba!.
- Mismos tipos que antes pero mi código usa una función de tipo `Nat -> Nat`.
  Si yo le paso una función de tipo `Int -> Int` podría pasar que al resultado
  de llamar a la función se lo pasara a la función raíz cuadrada, y de vuelta
  si en alguna situación mi nueva función daba como resultado un número
  negativo, también explotaría.

La regla entonces que sacamos de esto es (en la teórica están al revés los tipos):

$$
\frac{\sigma' <: \sigma\ \ \tau <: \tau'}{\sigma \rightarrow \tau <: \sigma' \rightarrow \tau'} (S-Arrow)
$$

Se dice que el constructor de tipos función es **contravariante** en su primer argumento y **variante** en el segundo.

## Subtipado de referencias

Es covariante? Veamos cómo sería la regla (covariante):

$$
\frac{\sigma <: \tau}{Ref \sigma <: Ref \tau}
$$

Qué pasa?

- La desreferencia tiene sentido que ande
- Pero y si intento escribir? Veámos un ejemplo:

```
let r = ref 3 (*r: Ref Int*)
in r := 2.1;
!r
```

- En el ejemplo, tengo que `Int <: Float`, y sin embargo `Ref Int <: Ref Float`
  no vale porque a la hora de asignar estaría asignándole un `Float` a algo a
  lo que sólo puede recibir un `Int`

Por lo tanto es contravariante, no?

$$
\frac{\tau <: \sigma}{Ref \sigma <: Ref \tau}
$$

Qué pasa con:

```
let r = ref 3.2 (*r: Ref Float*)
in succ(!r)
```

Ahora tengo el otro problema: si asumo que es contravariante, como `Int <:
Float`, obtengo que `Ref Float <: Ref Int`, lo cual significaría que donde
espere una referencia a un entero puedo pasarle una referencia a un float y
anda. Claramente en el ejemplo no puedo pasar una referencia a un float porque
`succ` no tipa.

### La desilusión...

Ah, que bien esto de subtipado, no me sirve para nada!!!!!

![](./img/nacagada.png#center)

Pero a no desesperar. Vamos a hacer un último empujón para hacerlo andar. Qué
pasa si a la regla le pedimos que los tipos sean equivalentes. Eso resolvería
nuestros problemas porque al leer de un tipo coerciono contra el otro, y al
escribir hago lo mismo a la inversa. Eso quedaría:

$$
\frac{\sigma <: \tau\ \ \tau <: \sigma}{Ref \sigma <: Ref \tau}
$$

Notar que el orden de los refs abajo es intercambiable. O sea que si dos tipos
son equivalentes, sus referencias también lo serán. Cuando esto sucede, decimos
que el tipo (Ref en este caso) es **Invariante**.

### Refinando \\(Ref\\)

La solución anterior no me deja del todo satisfecho porque lo que trae
problemas es la co-existencia de la lectura y la escritura, ya que esas nos
restringen a ser covariante o contravariante. Y en muchos casos, puedo
únicamente querer leer o únicamente escribir.

Entonces, vamos a separar las referencias dependiendo de si son de lectura o de
esritura. Vamos a definir 2 tipos de referencias nuevos:

- \\(Source\ \sigma\\) para las referencias de lectura
- \\(Sink\ \sigma\\) para las referencias de escritura

Las reglas de tipado para ambos términos son:

$$
\frac{\hastype{\Gamma|\Sigma}{M}{Source \sigma}}{\hastype{\Gamma|\Sigma}{!M}{\sigma}} \\\\
\frac{\hastype{\Gamma|\Sigma}{M}{Sink\ \sigma}\ \hastype{\Gamma|\Sigma}{N}{\sigma}}{\hastype{\Gamma|\Sigma}{M := N}{Unit}}
$$

Ahora, estoy forzando a que a un source únicamente le hago la desreferencia, y
a un sink le hago una asignación. Además, por la lógica vista anteriormente,
nos quedaría que el source va a ser covariante (\\(S-Source\\)) y el sink contravariante (\\(S-Sink\\)):

$$
\frac{\sigma <: \tau}{Source \sigma <: Source \tau} \\\\
\frac{\sigma <: \tau}{Sink \tau <: Sink \sigma}
$$

Un último detalle, porque recuerdo que el ejemplo era:

```
let r = ref 3
in r := 2.1;
!r
```

Acá estoy tanto leyendo como escribiendo en la referencia! A priori no me
funciona mi abstracción... o sí? Bueno, hay que agregar una cosa más, y es
poder "downgradear" las referencias a \\(Sink\\) o \\(Source\\) dependiendo de
lo que se necesite.

Para eso sumamos las reglas:

$$
\frac{}{Ref\ \sigma <: Source\ \sigma} \\\\
\frac{}{Ref\ \sigma <: Sink\ \sigma}
$$

Con eso en el ejemplo tendría:

```
let r = ref 3 (* el ref 3 va a ser de tipo Ref Int*)
in r := 2.1; (* esto lo tipo como sink, y uso que ref es subtipo*)
!r
```

## Dándole un uso

[Al principio de todo](#principio-de-sustitutividad) dijimos que agregábamos la
regla de subsumption. Esto cambia en parte la lógica de nuestro algoritmo de
chequeo de tipos, porque hasta ahora todas las reglas estaban guiadas por
sintáxis, y la regla que introducimos está guiada por la "oportunidad" del tipo
(o sea según te convenga). Cómo haríamos con eso para implementar un algoritmo
de chequeo de tipos? Idealmente, me gustaría poder sacar la regla \\(T-Subs\\).
Entonces, para eso vamos a mirar en qué casos pueden haber incompatibilidades
de tipos. Si revisamos la reglas, todas son de la pinta "instancio un tipo y le
asigno el tipo abajo y restrinjo el tipo arriba". La única regla que parecería
agregar nuevos tipos es la de la aplicación \\(T-App\\):

$$
\tapp{\Gamma}{M}{\tau}{\sigma}{N}
$$

Entonces la idea es tomar esa regla, y cambiar lo que nos da problemas, que es
el tipo de \\(N\\). Vamos a pedir que el tipo de \\(N\\) sea subtipo de lo que
sea que acepta \\(M\\):

$$
\frac{\hastype{\Gamma}{M}{\sigma \rightarrow \tau}\ \ \hastype{\Gamma}{N}{\rho}\ \ \rho <: \tau}{\hastype{\Gamma}{\apply{M}{N}}{\tau}} (T-App')
$$

Hay un resultado que nos dice que:

- Si en este nuevo sistema de tipado pude asignar un tipo válido a un término,
  entonces también lo puedo hacer con el que tiene la regla de subsumption
  libre (lo cual tiene sentido, ya que el otro me permite hacer lo mismo y
  meter la regla de subsumption donde se me cante. 
- Pero además, el resulado dice que en el recíproco, si vos probaste que tu
  término tiene tipo \\(\sigma\\), entonces con esta variante podés probar que
  tiene tipo \\(\rho\\), con \\(\rho <: \tau\\) (o sea que capaz es un poquito
  más restrictivo, pero al menos tengo una implementación más directa).

### Más problemas

Si bien me saqué de encima \\(T-Subs\\), todavía me quedan algunas reglas que no están guiadas por sintáxis. En particular \\(S-Refl\\) y \\(S-Trans\\) (ponele que en \\(S-Func\\) podría llegar a zafar porque tengo funciones). Por suerte hay solución:

~~~admonish warning title="Ojo"

Que no están guiadas por sintáxis en este caso no refiere al término si no a la
sintáxis de los tipos. A esas reglas les da lo mismo si tengo \\(Nat\\) o si
tengo \\(Nat -> Nat\\).

~~~

- se puede probar que \\(\sigma <: \sigma\\) se puede derivar si tengo
  reflexividad para tipos escalares (asumidos como axiomas):
    - \\(Nat <: Nat\\)
    - \\(Int <: Int\\)
    - \\(Bool <: Bool\\)
    - \\(Float <: Float\\)
- además recuerdo que tengo un par de reglas axiomáticas que relacionan los
  tipos escalares:
    - \\(Nat <: Float\\)
    - \\(Int <: Float\\)
    - \\(Bool <: Float\\)
- de forma similar se puede probar que no hace falta la regla de transitividad \\(S-Trans\\), ya que tenemos transitividad en las reglas de tipado (ojo, no es tan directo pero tampoco voy a ahondar mucho en esto).

### Función `subtype`

Obviando los casos base para tipos escalares, nos quedaría algo así:

```python
subtype(S, T):
    # Manejar casos base
    if S == S1 -> S2 and T = T1 -> T2:
        subtype(T1, S1) and subtype(S2, T2)
    else:
        if S == {k_j: S_j, j in (1..m)} and T == {l_i: T_i, i in (1..n)}:
            subseteq({l_i, i in (1..n)}, {k_j, j in (1..m)}) and all(i in (1..n) -> exists(j in (1..m) -> k_j = l_i and subtype(S_j, T_i)))
        else: 
            false
```

