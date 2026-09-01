<!--
  Bloque listo para pegar en el AGENTS.md del proyecto. Trabajo propio del
  toolkit (MIT). Ajusta las <…> y borra las notas en cursiva.
-->

## Planificación de features (Spec-Driven Development)

Este proyecto se lleva con SDD: primero la spec, luego el plan, luego las
tareas, y solo entonces el código. **La spec es el contrato: si algo no está en
ella, no se implementa.**

### Artefactos

```
docs/constitution.md          ← principios del proyecto (nivel proyecto)
docs/roadmap.md               ← qué hay hecho / en curso / en backlog (nivel proyecto)
specs/NNN-<slug>/
├── spec.md                   ← QUÉ y POR QUÉ (RF en EARS) + § Clarificaciones
├── plan.md                   ← CÓMO (módulos, datos, decisiones, riesgos)
├── tasks.md                  ← tareas <30 min + bloque de cierre
└── validation.md             ← recorrido RF por RF + veredicto (lo deja la fase 7)
```

Una feature no está cerrada hasta que existen sus cuatro archivos.

### Fases

| #   | Fase           | Command (plugin / script)                   |
| --- | -------------- | ------------------------------------------- |
| 1   | Constitución   | `/sdd:constitution` · `/sdd-constitution`   |
| 2   | Especificación | `/sdd:spec` · `/sdd-spec`                   |
| 3   | Clarificación  | `/sdd:clarify` · `/sdd-clarify`             |
| 4   | Planificación  | `/sdd:plan` · `/sdd-plan`                   |
| 5   | Tareas         | `/sdd:tasks` · `/sdd-tasks`                 |
| 6   | Implementación | `/sdd:implement <n>` · `/sdd-implement <n>` |
| 7   | Validación     | `/sdd:validate` · `/sdd-validate`           |
| 8   | Cambio         | `/sdd:change <req>` · `/sdd-change <req>`   |

### Reglas

- **Numeración `specs/NNN`**: contador propio de `specs/`, tres dígitos,
  monótono, sin reutilizar números borrados. <Empieza en `001` | continúa la
  serie heredada desde `NNN` — decisión de adopción>. No es el ordinal del
  roadmap ni un RF histórico.
- **Verificación como puerta**: ninguna tarea se marca `[x]` sin
  <suite automatizada en verde | ejecutar `<comando o skill>` y pegar la
  evidencia>.
- **Precedencia**: `docs/constitution.md` manda sobre specs y planes. Ante
  conflicto entre `docs/`/`specs/` y este archivo, este archivo es la fuente
  operativa del **código** y `docs/`/`specs/` la capa de **planificación**.
- **`docs/` y `specs/` se versionan pero no se despliegan**: exclúyelos del
  artefacto de deploy y del docroot.
- No modificar `specs/` fuera de su fase salvo petición explícita.
