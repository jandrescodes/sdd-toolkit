---
description: Fase 6 SDD — implementa SOLO la tarea Tn indicada, verificación primero (tests o checklist), la ejecuta, marca la tarea y se detiene.
argument-hint: "<número de tarea, p. ej. 3>"
---

Estás en la **fase 6 (Implementación)** del flujo SDD.

Tarea a implementar: T$ARGUMENTS

1. Si el argumento está vacío o no es un número, **pregúntame qué tarea** — no
   asumas T1.
2. Lee `docs/constitution.md`, la spec activa, el plan y `tasks.md`.
3. Verifica que las tareas anteriores estén marcadas `[x]`. Si no, avísame.
4. Implementa **solo** T$ARGUMENTS. Nada de otras tareas ni mejoras no pedidas.
   Esta fase implementa tareas `Tn`; los ítems del bloque "Cierre de la feature"
   de `tasks.md` no se implementan aquí.
5. **Verificación primero.** Escribe los tests que cubren los RF de la tarea,
   luego el código hasta que pasen. Si el proyecto no tiene suite automatizada,
   ejecuta la verificación que indique la constitución / `AGENTS.md`.
6. Ejecuta la verificación completa (suite o checklist) y **muéstrame el
   resultado / la evidencia**. Si algo queda en rojo o sin evidencia, no cierres
   la tarea.
7. Marca T$ARGUMENTS como `[x]` en `tasks.md` y **detente**. No sigas con la
   siguiente tarea.
