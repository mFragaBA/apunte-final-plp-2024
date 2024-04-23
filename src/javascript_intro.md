# Programación orientada a objetos

Así como en la programación imperativa, teníamos la idea de *estado* que tiene
el valor de las variables y nosotros le damos una serie de instrucciones para
modificar el estado. Después vimos el paradigma funcional y el modelo de
cómputo cambio. En ese nuevo paradigma defino funciones, las evalúo en
expresiones y reducimos las expresiones a su forma normal.

En objetos, lo pensamos como que un programa es una simulación. Y cada entidad
(relevante, que quiero modelar) del sistema que se simula se representa en el
programa con un **objeto**. En este paradigma la forma de razonar es hacer que
los objetos "hablen" entre sí.

## Modelo de cómputo

- Sistema formado por objetos.
- El modelo de cómputo consiste en el envío de mensajes.
- Un **mensaje** es una solicitud que se le manda a un objeto para que lleve a
  caba alguna de las operaciones que sabe hacer.
- El **receptor** es el objeto que recibe el mensaje y es quien se encarga de
  determinar **cómo** se resulve esa solicitud/mensaje.
    - Los **métodos** son los que describen ese cómo.
    - La forma en la que se resuleve puede depender del estado interno del
      objeto.
        - Ese estado interno se representa mediante **colaboradores internos**
          (también conocidos como **atributos** o **variables de instancia**)
- El conjunto de mensajes a los que un objeto responde se lo llama **interfaz o
  protocolo**.
- la **única** forma de interactuar con un objeto es mediante el envío de
  mensajes
    - la implementación de un objeto no puede depender de los detalles de
      implementación de otros objetos (confio en que tienen una interfaz que
      resuelve lo que necesito y de manera correcta).
- el estado de un objeto es **privado** y sólo puede ser modificado por medio
  de sus métodos.
    - no todos los lenguajes imponen esta restricción though (ej: en c++ tengo el modifier `friend`)

### Method Dispatch

El método de cómputo se puede describir con los siguientes pasos:

- (reminder) la interacción entre objetos es mediante envío de mensajes
- al recibir un mensaje se activa el método que corresponde
    - para procesar el mensaje, hay un proceso de encontrar el método
      correspondiente para ese mensaje. Dicho proceso se conoce como **method
      dispatch**
    - puede ser tan simple como ver si mi objeto tiene el método para el nombre
      o puedo complejizarlo cuando meto herencia, entre otras features. En esos
      casos el method dispatch tiene un algoritmo no tan sencillo.
- el method dispatch se puede hacer de forma estática (c, no todo. Java híbrido) o dinámica (en tiempo de
  ejecución)

~~~admonish example title="Ejemplo"

objeto `unCirculo`. Si le quiero pedir el radio: `unCirculo radio` en smalltalk, `unCirculo.radio` en c#, etc.

- `unCirculo` es el receptor del mensaje
- `radio` es el mensaje que se le envía

objeto `unRectangulo`

- interfaz: area
- atributos: alto y ancho
- métodos: area = function(){ return alto * ancho }

~~~

## Corrientes

Hablamos de que tenemos mensajes y que tenemos métodos para responder dichos
mensajes. Ahora, dónde ponemos esos métodos? Si tengo un objeto `Estudiante`,
una vez cargada las notas parciales la nota final se calcula siempre igual,
entonces podría reusar esa lógica. las 2 alternativas más conocidas son
**clasificación** y **prototipado**.

### Clasificación

Usan el concepto de **Clase**:

- modelan conceptos abstractos del dominio del problema
- son como un "molde" de los objetos: definen la forma (los colaboradores externos) y el comportamiento de
  los objetos
- todo objeto es instancia de alguna clase (los objetos son distintos pero usan
  los métodos de la misma clase para responder a mensajes)

#### Componentes de una clase

- un nombre
- definición de las variables de instancia
- métodos de instancia
- por cada método se especifica
    - nombre
    - parámetros formales
    - cuerpo

Algunos lenguajes como smalltalk permiten tener tanto métodos de clase como
métodos de instancia.

#### Self (o this según el lenguaje)

Es una pseudo-variable que se resuelve durante la evaluación de un método. Recerencia al receptor del mensaje que activó la evaluación

- no se puede modificar por medio de una asignación
- se liga al receptor ni bien comienza la evaluación del método

#### Jerarquía de clases

- Es común que algunas clases aparezcan como una extensión de otras clases
    - porque se agrega / sobreescribe el comportamiento de algún método
    - porque quiero agregar nuevas variables de instancia / clase
- Se permite que una clase **herede** o **extienda** una clase pre-existente, que conocemos como **superclase**
- La herencia es una relación transitiva, lo cual da origen a la diferenciación entre **ancestros** y **descendientes**

#### Herencia

Hay 2 tipos de herencia:

- Simple: una clase tiene una única clase padre (salvo `Object`)
- Múltiple: una clase puede tener más de una clase padre 
    - ejemplo: un `ProjeforUniversitario` es un `Profesor` y un `Investigador`
- La mayoría de los lenguajes OO usan **herencia simple** ya que la herencia múltiple complica el proceso de method dispatch (qué pasa cuando ambas clases implementan un método)
    - hay soluciones (pero siguen agregando complejidad medio al dope):
        - uso el órden de búsqueda
        - fuerzo a que en esos casos se tenga que redefinir el método de la nueva clase.

## Method Dispatch Estático

Lo que le da power al lenguaje orientado a objetos es la posibilidad de tener
method dispatch dinámico. Sin embargo, hay lenguajes que cuentan com method
dispatch estático. Esto se puede dar por una cuestión de eficiencia o porque se
requiera más allá de la eficiencia, como lo es con `super`.

~~~admonish example title="Method dispatch estático"

Supongamos que queremos extender la clase `point` del siguiente modo:

```
Object subclass: #Point
Métodos de instancia
setX: xValue setY: yValue
    xCoord := xValue.
    yCoord := yValue.

Point subclass: #ColorPoint
Métodos de instancia
setX: xValue setY: yValue setColor: aColor
    xCoord := xValue.
    yCoord := yValue.
    color  := aColor.
```

Duplico código innecesariamente! En lugar de eso puedo usar `super`:

```
Object subclass: #Point
Métodos de instancia
setX: xValue setY: yValue
    xCoord := xValue.
    yCoord := yValue.

Point subclass: #ColorPoint
Métodos de instancia
setX: xValue setY: yValue setColor: aColor
    self setX: xValue setY: yValue.
    color  := aColor.
```

Ahora supongamos que queremos hacer algo similar y definir el objeto `BluePoint`:

```
Object subclass: #Point
Métodos de instancia
setX: xValue setY: yValue
    xCoord := xValue.
    yCoord := yValue.

Point subclass: #BluePoint
instanceVarNames: 'color'
Métodos de instancia
setX: xValue setY: yValue
    self setX: xValue setY: yValue.
    color  := 'blue'.
```

El problema de esto es que al hacer `self setX: _ setY: _` entro en un loop
infinito. Antes funcionaba porque tenía el constructor de 3 variables y llamo
al de la superclase que usa 2. En este caso sin embargo lo que pasa es que ya
pisamos la implementación de `setX: _ setY: _`.

Al usar `super` de la siguiente manera se arregla:

```
Point subclass: #ColorPoint
instanceVarNames: 'color'
Métodos de instancia
setX: xValue setY: yValue
    super setX: xValue setY: yValue.
    color  := 'blue'.
```

**OJO**, `super` **también hace referencia al objeto receptor del mensaje**, la
diferencia es que `super` cambia el comienzo del method lookup para que
arranque a buscar desde la clase padre.

~~~

## Lenguajes basados en objetos

O sea lenguajes que **no usan clases**. Tengo constructores para crear objetos particulares:

```js
let celda {
    contenido: 0,
    get: function () { return this.contenido; },
    set: function (n) { this.contenido = n; },
}
```

Puedo definir procedimientos para generar objetos (es un constructor, pero no una clase):

```js
Celda = function () {
    this.contenido = 0;
    this.get = function () { return this.contenido; };
    this.set = function (n) { this.contenido = n; };
}

otracelda = new Celda ();
```

### Prototipado

Es la idea de construir instancias concretas que son representantes de las instancias (son los prototipas). Las otras instancias se generan mediante clonación (es una shallow copy, sólo copia la primer linea de atributos y métodos. No se mete a fondo):

```js
celdaClonada = Object.create(celda);
```

Los clones además se pueden cambiar:

```js
celdaClonada.set = function (n) {
    this.contenido = this.contenido + n;
}
```

Es posible además implementar herencia a través de prototipos (lo veremos más adelante).
