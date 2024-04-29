# Unidad 4 - Programación Funcional

Hasta ahora vimos:

- Paradigma imperativo:
    - estado compuesto por variables.
    - tira de instrucciones que cambia el estado (cambia el valor de las
      variables).
    - ejecuto una a una a llegar a un estado final
- Paradigma funcional
    - tenemos expresiones
    - las expresiones se reducen en otras expresiones
    - así hasta llegar a una forma normal
- Paradigma de objetos
    - modelo objetos de la realidad
    - colaboran mandándose mensajes
    - programar es definir objetos, y principalmente qué mensajes responden y
      cómo
    - acá el modelo de cómputo es resolver un problema haciendo que los objetos
      definidos se manden mensajes

El **Paradigma funcional** se basa en el uso de la lógica para resolver un
problema. Para lograrlo, **en lugar de decir el cómo se resuelve nos vamos a
quedar en el qué**.

- Tenemos un motor que dado el problema especificado con algún tipo de lógica
  (proposicional, primer orden, etc.), va a intentar probarlo como consecuencia
  de hechos (axiomas) y reglas de inferencia.
- tenemos un **goal** que es el objetivo a probar
- es **declarativo** justamente porque no indico cómo se resuelve si no el qué.

## Prolog

- Introducido en el 71'
- Los programas se escriben en un subconjunto de la lógica de primer órden
  llamado cláusulas de Hoare.
- El fundamento teórico de fondo es el **método de resolución**. Esto permite
  ver si dado una fórmula es satisfacible o no.
- Programar se va a reducir a especificar el problema en una fórmula (en
  realidad nosotros definimos varias fórmulas pero por atrás se construye una
  única fórmula grande). Y con el método de resolución se va a ver si dicha
  fórmula es satisfacible o no.

~~~admonish example title="Ejemplo"

```prolog
% Lo de abajo son *Hechos*
habla(ale, ruso).
habla(juan, ingles).
habla(maria, ruso).
habla(maria, ingles).

% puedo definir predicados paramétricos
seComunicaCon(X, Y) :- habla(X, L), habla(Y, L), X \= Y.

% ejemplos de goal: "con quién se puede comunicar ale?", "quiénes se pueden comunicar entre sí?"
seComunicaCon(X, ale)
seComunicaCon(X, Y)
```

~~~

Si bien esto es muy interesante, es mejor arrancar con resolución en proposicional.
