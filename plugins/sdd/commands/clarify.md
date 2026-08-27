---
description: Fase 3 SDD — revisa la spec activa como QA profesional y lista ambigüedades, contradicciones, casos límite ausentes y conflictos con la constitución. No resuelve.
argument-hint: "[ruta de la spec, si hay varias]"
allowed-tools: Read, Grep, Glob
---

Estás en la **fase 3 (Clarificación)** del flujo SDD.

Spec a revisar: $ARGUMENTS (si está vacío, usa la spec activa más reciente de
`specs/`).

1. Lee `docs/constitution.md` y la spec.
2. Revísala como un **QA profesional**. **Solo detecta, no resuelvas ni
   reescribas.** Lista, numerado, en cuatro bloques:
   1. Ambigüedades (frases con más de una interpretación).
   2. Contradicciones entre requisitos.
   3. Casos límite no cubiertos (vacíos, duplicados, datos corruptos, límites,
      concurrencia).
   4. Conflictos con la constitución.
3. Para cada punto, cita el RF o la línea concreta.
4. No propongas soluciones hasta que te lo pida. Cuando lo haga, aplicaremos los
   cambios a la spec y anotaremos la resolución.
