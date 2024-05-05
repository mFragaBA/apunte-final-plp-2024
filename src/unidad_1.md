# Unidad 1 - Paradigma funcional

![](./img/hold_up.png#center)

La materia se llama "Paradigmas de Programación. Qué es un paradigma de programación:

- **paradigma**: es una forma de pensamiento (a.k.a un marco teórico, un
  conjunto de creencias).
- **lenguaje de programación**: el lenguaje que usamos para comunicar
  instrucciones a una computadora.
    - describen **cómputos** (más de a qué me refiero con esto adelante)
    - es **turing completo** si puede expresar todas las funciones computables
      (LyC war flashbacks). Los DSLs son ejemplos de lenguajes de programación
      que no necesariamente son turing completos.
    - tiene que poder describir lo que hay que hacer de forma explícita y no
      ambigua.
- Entonces un **paradigma de lenguaje de programación** lo vamos a entender
  como un estilo de programación, que impacta en la forma en la que se encaran
  las soluciones
    - Está muuuuuy vinculado al **modelo de cómputo**
        - A partir de un estado inicial llegar a un estado final.
        - En orga, por ejemplo parto de un estado inicial **y aplico secuencias
          de instrucciones para modificar el estado**

Entender de paradigmas de programación es una herramienta muy útil a la hora de
decidir qué lenguaje elijo para resulver un problema.

En este resumen (y porque es lo visto en clase) voy a hablar de los paradigmas:

- imperativo
- funcional (vamos a usar haskell)
- orientado a objetos (javascript)
- lógico (vamos a usar prolog)

Pero sepan que exiten más: concurrente, eventos, basado en continuaciones,
probabilístico, cuántico. Además, hoy en día los lenguajes más modernos suelen
tomar features de distintos paradigmas (por ejemplo: rust 🦀. Otro ejemplo es
la incorporación de funciones anónimas en los distintos lenguajes, que antes
estaba medio reservado a los lenguajes funcionales) entonces la linea entre un
paradigma y otro dentro de un lenguaje se vuelve más difusa.
