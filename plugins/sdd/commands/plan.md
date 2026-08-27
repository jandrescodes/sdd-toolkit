---
description: Fase 4 SDD — genera specs/NNN-<slug>/plan.md con módulos, modelo de datos, decisiones justificadas y estrategia de tests. Sin código.
argument-hint: "[ruta de la spec, si hay varias]"
---

Estás en la **fase 4 (Planificación)** del flujo SDD.

Spec: $ARGUMENTS (si está vacío, usa la spec activa más reciente de `specs/`).

1. **Comprueba prerrequisitos.** Si no existe `docs/constitution.md` o no hay una
   spec activa en `specs/`, **avisa y detente** — no se puede planificar sin
   ellas.
2. Lee la constitución y la spec completas.
3. **NO escribas código.** Genera `specs/NNN-<slug>/plan.md` (mismo NNN que la
   spec) con:
   - Estructura de módulos y su responsabilidad.
   - Modelo de datos / esquema (o "sin estado" si aplica).
   - Algoritmos no triviales con sus casos límite.
   - Decisiones técnicas, **cada una con la alternativa descartada** y por qué.
   - Contrato de interfaz (firmas, entradas/salidas, códigos de error).
   - Estrategia de tests.
   - Tabla de qué RF cubre cada parte.
4. Todo el plan debe respetar la constitución. Si algo de la spec la contradice,
   señálalo en vez de planificarlo.
5. Pide **aprobación explícita** antes de pasar a tareas.
