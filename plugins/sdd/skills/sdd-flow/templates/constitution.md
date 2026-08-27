# Constitución — <proyecto>

Principios innegociables. Toda spec, plan y tarea debe cumplirlos.
Máximo ~15 líneas. Cada principio corto y verificable.

1. **<Simplicidad / stack>**: <lenguaje y versión, dependencias permitidas y
   prohibidas>.
2. **La spec manda**: ningún comportamiento se implementa si no está en la spec
   activa. Si falta una decisión, se detiene el trabajo y se pregunta.
3. **<Separación de capas>**: <p. ej. el núcleo no imprime ni lee de consola; la
   interfaz es una capa fina y testeable sin ella>.
4. **Tests como puerta**: cada tarea termina con sus tests en verde. Prohibido
   avanzar con tests en rojo.
5. **<Datos / persistencia>**: <formato, dónde, qué está prohibido>.
6. **Idioma**: <código e identificadores en X; mensajes al usuario y
   documentación en Y>.
