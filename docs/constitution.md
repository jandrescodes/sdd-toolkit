# Constitución — sdd-toolkit

El método SDD que este repo empaqueta viene del curso de MoureDev
(<https://github.com/mouredev/hello-sdd>). Aquí solo se empaqueta y distribuye.

Principios innegociables. Toda spec, plan y tarea de este repo debe cumplirlos.

1. **Fuente única de verdad**: todo el contenido editable vive en
   `plugins/sdd/`. Cualquier otra copia (destinos de `install.sh`, symlinks) es
   derivada y no se edita a mano.
2. **Agnóstico de stack, español para las personas**: el toolkit no asume
   lenguaje ni framework. Las plantillas tienen huecos, nunca ejemplos atados a
   una tecnología. Los textos dirigidos al usuario y la documentación van en
   español; los identificadores y nombres de archivo en inglés.
3. **Cada fase, un artefacto versionado**: constitución, spec, plan, tareas y
   validación producen un archivo Markdown que queda en el repo del proyecto.
   Si un paso no deja rastro, no está hecho.
4. **Sin dependencias de runtime**: solo `bash` y lo que ya traen Claude Code y
   opencode. Para validar JSON se acepta `python3` o `node`, ambos habituales.
   Nada de gestores de paquetes ni binarios extra.
5. **EARS obligatorio**: los criterios de aceptación de toda spec se escriben en
   notación EARS, numerados RF-1, RF-2, … y cada uno debe ser verificable.
6. **Tests como puerta**: `bash tests/validate.sh` debe pasar en verde antes de
   dar por cerrada cualquier tarea. Prohibido avanzar con la puerta en rojo.
7. **La spec manda**: ningún comportamiento se implementa si no está en
   `specs/` activa. Si falta una decisión, se detiene el trabajo y se pregunta.
