# Constitución — <proyecto>

Principios innegociables. Toda spec, plan y tarea debe cumplirlos.
Máximo ~15 líneas. Cada principio corto y verificable.

1. **Alcance del producto**: <qué es en una frase>. NO es: <2-3 límites>.
   (Si el repo tiene README público, la versión larga va ahí y esto la resume.)
2. **<Simplicidad / stack>**: <lenguaje y versión, dependencias permitidas y
   prohibidas>.
3. **La spec manda**: ningún comportamiento se implementa si no está en la spec
   activa. Si falta una decisión, se detiene el trabajo y se pregunta.
4. **<Separación de capas>**: <p. ej. el núcleo no imprime ni lee de consola; la
   interfaz es una capa fina y testeable sin ella>.
5. **Verificación como puerta**: cada tarea termina verificada —
   <suite automatizada en verde | checklist manual documentado con evidencia
   pegada>. Prohibido avanzar sin ello.
6. **<Datos / persistencia>**: <formato, dónde, qué está prohibido>.
7. **Idioma**: <código e identificadores en X; mensajes al usuario y
   documentación en Y>.
