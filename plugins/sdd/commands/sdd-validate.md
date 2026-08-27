---
description: Fase 7 SDD — recorre la spec RF por RF indicando qué test cubre cada uno y su resultado, y emite un veredicto de cumplimiento.
argument-hint: "[ruta de la spec, si hay varias]"
---

Estás en la **fase 7 (Validación)** del flujo SDD.

Spec: $ARGUMENTS (si está vacío, usa la spec activa más reciente de `specs/`).

1. Lee la spec y ejecuta la suite de tests del proyecto.
2. Recorre **cada RF en orden**. Para cada uno, una fila:
   `RF-n | <resumen> | <test(s) que lo cubren> | <PASA / FALLA / SIN COBERTURA>`.
3. Lista aparte los RF sin ningún test asociado.
4. Comprueba los criterios de finalización de la spec uno a uno.
5. **Veredicto final**: ¿spec cumplida? Si no, qué falta exactamente.
6. No cambies código en esta fase. Si detectas un fallo, repórtalo; se corrige
   volviendo a la fase 6.
