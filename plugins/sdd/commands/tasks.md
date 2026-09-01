---
description: Fase 5 SDD — divide el plan en tareas de <30 min ordenadas por dependencia, cada una con sus RF, checkbox y una línea "Hecho cuando:" verificable.
argument-hint: "[ruta del plan, si hay varios]"
---

Estás en la **fase 5 (Tareas)** del flujo SDD.

Plan: $ARGUMENTS (si está vacío, usa el `plan.md` de la spec activa más reciente).

1. Lee `docs/constitution.md`, la spec y el plan.
2. Genera `specs/NNN-<slug>/tasks.md` (mismo NNN):
   - Tareas de **menos de 30 minutos** cada una.
   - **Ordenadas por dependencia** (T1 no depende de nada, etc.).
   - Cada tarea: `- [ ] Tn. <descripción>. (RF-…)` seguido de una línea
     `Hecho cuando: <criterio verificable>`.
   - El criterio "Hecho cuando" debe ser comprobable (un test, un comando, un
     archivo que existe), no "cuando funcione".
3. Cubre todos los RF de la spec entre las tareas.
4. Añade siempre al final el bloque `## Cierre de la feature` de la plantilla
   (checkboxes fuera de la numeración `Tn`: validación, roadmap, y los que
   apliquen para CHANGELOG / despliegue / convención nueva). Deja como `<hueco>`
   lo que dependa del proyecto; no inventes pasos que la constitución o
   `AGENTS.md` no respalden.
5. No implementes nada todavía. Muéstrame la lista y espera el visto bueno.
