---
description: Fase 6 SDD — implementa SOLO la tarea Tn indicada, tests primero, ejecuta la suite, marca la tarea y se detiene.
argument-hint: "<número de tarea, p. ej. 3>"
---

Estás en la **fase 6 (Implementación)** del flujo SDD.

Tarea a implementar: T$ARGUMENTS

1. Si el argumento está vacío o no es un número, **pregúntame qué tarea** — no
   asumas T1.
2. Lee `docs/constitution.md`, la spec activa, el plan y `tasks.md`.
3. Verifica que las tareas anteriores estén marcadas `[x]`. Si no, avísame.
4. Implementa **solo** T$ARGUMENTS. Nada de otras tareas ni mejoras no pedidas.
5. **Tests primero.** Escribe los tests que cubren los RF de la tarea, luego el
   código hasta que pasen.
6. Ejecuta la suite completa y **muéstrame el resultado**. Si algo queda en
   rojo, no cierres la tarea.
7. Marca T$ARGUMENTS como `[x]` en `tasks.md` y **detente**. No sigas con la
   siguiente tarea.
