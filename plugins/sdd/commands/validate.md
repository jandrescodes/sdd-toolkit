---
description: Fase 7 SDD — recorre la spec RF por RF con su verificación y resultado, escribe specs/NNN/validation.md y emite un veredicto de cumplimiento.
argument-hint: "[ruta de la spec, si hay varias]"
allowed-tools: Read, Grep, Glob, Bash, Write, Skill
---

Estás en la **fase 7 (Validación)** del flujo SDD.

Spec: $ARGUMENTS (si está vacío, usa la spec activa más reciente de `specs/`).

1. Lee la spec y verifica el proyecto: ejecuta la suite de tests, o —si el
   proyecto no tiene suite automatizada— la verificación que indique su
   constitución / `AGENTS.md` (comando o skill/checklist manual). Si no hay
   ninguna declarada, **para y pregunta**; no inventes un comando.
2. Recorre **cada RF en orden**. Para cada uno, una fila:
   `RF-n | <resumen> | <test(s) o evidencia que lo cubren> | <PASA / FALLA / SIN COBERTURA>`.
3. Lista aparte los RF sin ninguna verificación asociada.
4. Comprueba los criterios de finalización de la spec uno a uno.
5. **Veredicto final**: ¿spec cumplida? Si no, qué falta exactamente.
6. Escribe `specs/NNN-<slug>/validation.md` (mismo `NNN` que la spec) con:
   la tabla RF por RF del paso 2, la lista de RF sin cobertura, el checklist de
   criterios de finalización y el veredicto. Si la fase no deja este archivo, no
   está hecha.
7. No cambies código en esta fase. Si detectas un fallo, repórtalo; se corrige
   volviendo a la fase 6.
