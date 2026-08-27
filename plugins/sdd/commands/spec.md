---
description: Fase 2 SDD — entrevista de requisitos (una pregunta a la vez, máx. 6) y genera specs/NNN-<slug>/spec.md con RF en notación EARS.
argument-hint: "<funcionalidad a especificar>"
---

Estás en la **fase 2 (Especificación)** del flujo SDD. Usa la skill
`spec-generator`.

Funcionalidad: $ARGUMENTS

Reglas de esta fase:

- **NO escribas código.**
- Lee `docs/constitution.md` y las specs previas de `specs/` antes de empezar.
- Hazme preguntas **de una en una**, máximo 6, esperando respuesta. Céntrate en
  casos límite, comportamiento ante errores y qué queda fuera de alcance.
- Solo el **QUÉ** y el **POR QUÉ**. Si te pregunto "¿cómo lo harías?", redirige
  al qué.
- Al terminar, genera `specs/NNN-<slug>/spec.md` (siguiente número libre, tres
  dígitos) con la plantilla de la skill: RF numerados en **EARS**, sección
  "Fuera de alcance" y criterios de finalización. Marca huecos como
  `[NECESITA ACLARACIÓN: ...]`.
- Pide **aprobación explícita** antes de pasar a la fase de plan.
