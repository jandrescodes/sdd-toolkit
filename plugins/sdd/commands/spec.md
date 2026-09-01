---
description: Fase 2 SDD — entrevista de requisitos (una pregunta a la vez, máx. 6) y genera specs/NNN-<slug>/spec.md con RF en notación EARS.
argument-hint: "<funcionalidad a especificar>"
---

Estás en la **fase 2 (Especificación)** del flujo SDD. Usa la skill
`spec-generator`.

Funcionalidad: $ARGUMENTS

Reglas de esta fase:

- **NO escribas código.**
- Lee `docs/constitution.md`, `docs/roadmap.md` y las specs previas de `specs/`
  antes de empezar.
- Hazme preguntas **de una en una**, máximo 6, esperando respuesta. Céntrate en
  casos límite, comportamiento ante errores y qué queda fuera de alcance.
- Solo el **QUÉ** y el **POR QUÉ**. Si te pregunto "¿cómo lo harías?", redirige
  al qué.
- Al terminar, genera `specs/NNN-<slug>/spec.md` con la plantilla de la skill:
  línea `**Estado:**`, RF numerados en **EARS**, sección "Fuera de alcance" y
  criterios de finalización. Marca huecos como `[NECESITA ACLARACIÓN: ...]`.
  `NNN` es el siguiente libre del contador de `specs/` (tres dígitos, monótono,
  sin reutilizar borrados); **no** es el ordinal del roadmap ni un RF histórico.
  En un repo nuevo empieza en `001`; si el repo continúa una serie heredada,
  respétala.
- Pide **aprobación explícita** antes de pasar a la fase de plan.
