---
description: Fase 8 SDD — ante un requisito nuevo, actualiza primero la spec y muestra el diff. No toca código hasta aprobar el cambio de spec.
argument-hint: "<requisito o cambio nuevo>"
---

Estás en la **fase 8 (Cambio)** del flujo SDD.

Cambio solicitado: $ARGUMENTS

1. **NO toques código.**
2. Lee `docs/constitution.md` y la spec activa.
3. Determina qué RF se añaden, modifican o eliminan por este cambio. Comprueba
   que no contradiga la constitución ni otros RF; si lo hace, dímelo antes de
   seguir.
4. Actualiza la spec (RF en EARS, y "Fuera de alcance" si el cambio recorta
   algo) y **muéstrame el diff**.
5. Espera mi aprobación del diff.
6. Solo entonces: actualiza el plan, las tareas afectadas y `validation.md` si
   ya existía, y sigue con la fase 6 para implementar los RF nuevos o cambiados.
