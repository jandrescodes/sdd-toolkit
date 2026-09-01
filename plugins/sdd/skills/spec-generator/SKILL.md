---
name: spec-generator
description: Usa esta skill cuando el usuario pida crear, redactar o revisar una especificación (spec) de una funcionalidad. Guía una entrevista de requisitos de una pregunta a la vez y produce un spec.md con requisitos en notación EARS siguiendo la plantilla incluida.
---

<!--
  Derivado de la skill `spec-generator` del curso de SDD de MoureDev
  (https://github.com/mouredev/hello-sdd), bajo Apache License 2.0 — ver
  LICENSE-APACHE y NOTICE. Modificado: texto de `description`; regla de
  numeración de `specs/NNN` y campo `**Estado:**` en el paso de redacción.
-->

# Generador de specs

Convierte una idea vaga en una especificación acordada. La spec es el
contrato: si algo no está aquí, no se implementa.

## Proceso

1. **Lee el contexto.** `docs/constitution.md` si existe, y las specs previas
   de `specs/` para respetar convenciones y no contradecir lo ya acordado.
2. **Entrevista al usuario.** Preguntas de **UNA en UNA**, máximo 6, esperando
   respuesta antes de la siguiente. Céntrate en casos límite, comportamiento
   ante errores y qué queda fuera. No propongas soluciones técnicas: si el
   usuario pregunta "¿cómo lo harías?", redirige al QUÉ.
   Prioriza preguntas cuya respuesta cambie lo que hay que construir; descarta
   las que tengan una respuesta obvia por defecto.
3. **Elige el número.** Contador propio de `specs/`, tres dígitos, monótono y
   sin reutilizar números borrados: usa el siguiente libre
   (`specs/NNN-<nombre-en-kebab-case>/spec.md`). En un repo nuevo empieza en
   `001`; al adoptar SDD sobre una serie ya numerada, continúala (la decisión
   se anota en `AGENTS.md`). El número **no** es el ordinal de `docs/roadmap.md`
   ni un RF histórico. Lee `docs/roadmap.md` si existe.
4. **Redacta** usando `spec-template.md` de esta skill, sin saltarte
   secciones. Añade bajo el título una línea
   `**Estado:** <propuesta | en curso | implementada ✅>`.
   Criterios de aceptación **siempre en notación EARS**, numerados
   como RF-1, RF-2, … Cada requisito debe ser verificable: si no se te ocurre
   cómo comprobarlo, está mal escrito.
5. **Marca lo que no sepas** como `[NECESITA ACLARACIÓN: pregunta concreta]`.
   Nunca rellenes un hueco inventando: un hueco visible es información,
   una suposición silenciosa es deuda.
6. **Pide aprobación explícita** al terminar. No pases al plan ni escribas
   código hasta tenerla.

## Reglas

- La spec describe **QUÉ** y **POR QUÉ**. Prohibido incluir stack, arquitectura,
  nombres de archivos, esquemas de datos, algoritmos o firmas de funciones:
  eso va en el plan.
- Incluye **siempre** la sección "Fuera de alcance". Es la que evita que la
  funcionalidad crezca sola.
- Un requisito, una frase. Si necesitas un "y" para unir dos comportamientos,
  son dos requisitos.
- Sin adjetivos no medibles: "rápido", "intuitivo", "robusto" no son
  requisitos. Escribe el umbral o no lo escribas.
- Idioma: el de la constitución del proyecto. Si no la hay, el del usuario.

## Notación EARS

Cinco patrones. Elige el que corresponda, no mezcles:

| Patrón              | Forma                                          | Cuándo                 |
| ------------------- | ---------------------------------------------- | ---------------------- |
| Ubicuo              | EL SISTEMA \<hará\>                            | siempre cierto         |
| Dirigido por evento | CUANDO \<disparador\>, EL SISTEMA \<hará\>     | responde a algo        |
| Estado              | MIENTRAS \<estado\>, EL SISTEMA \<hará\>       | durante una condición  |
| Opcional            | DONDE \<característica\>, EL SISTEMA \<hará\>  | solo si está presente  |
| No deseado          | SI \<condición\>, ENTONCES EL SISTEMA \<hará\> | errores y casos límite |

Ejemplo bien escrito:

> RF-4: SI el nombre ya existe (comparación ignorando mayúsculas y espacios
> exteriores), ENTONCES EL SISTEMA no creará un duplicado e informará del
> conflicto (salida 1).

Mal escrito, para contrastar:

> ~~RF-4: El sistema debe manejar bien los duplicados y ser rápido.~~
> Sin patrón EARS, sin criterio verificable, dos ideas en una frase y un
> adjetivo no medible.

## Al revisar una spec existente

Si el usuario pide revisar en vez de crear, no reescribas: **detecta y lista**,
numerado, en cuatro bloques — (1) ambigüedades, (2) contradicciones entre
requisitos, (3) casos límite no cubiertos, (4) conflictos con la constitución.
No propongas soluciones hasta que te lo pidan.
