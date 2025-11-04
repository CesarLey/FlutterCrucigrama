# Guía de Uso - Crucigrama con Categorías

## 📱 Funcionalidades de la App

### 1. **Modo Online (Con Internet)**

Cuando la app detecta conexión a internet, tendrás acceso a:

#### Selector de Categorías 📂
- **Ubicación**: Ícono de categoría en el AppBar (esquina superior derecha)
- **Función**: Permite seleccionar categorías temáticas de palabras
- **Indicador**: 
  - 🟢 Verde cuando hay una categoría seleccionada
  - ⚪ Gris cuando usa palabras por defecto

#### Categorías Disponibles:
1. 🍎 **Frutas** - Manzanas, bananas, naranjas, etc.
2. 🐕 **Animales** - Perros, gatos, leones, etc.
3. 🏙️ **Ciudades** - Madrid, Barcelona, Valencia, etc.
4. 🚗 **Autos** - Toyota, Ford, BMW, etc.
5. 🎨 **Colores** - Rojo, azul, verde, etc.
6. 🌍 **Países** - España, Francia, Italia, etc.
7. ⚽ **Deportes** - Fútbol, tenis, natación, etc.
8. 👨‍⚕️ **Profesiones** - Médico, profesor, ingeniero, etc.

#### Cómo Usar:
1. Toca el ícono de categorías 📂
2. Selecciona la categoría deseada
3. La app regenerará el crucigrama con palabras de esa categoría
4. El título cambiará a "Crucigrama: [Categoría]"

---

### 2. **Modo Offline (Sin Internet)**

Cuando no hay conexión:
- **Indicador**: Ícono de WiFi desconectado (📡❌)
- **Funcionalidad**: Las categorías no están disponibles
- **Comportamiento**: La app usa automáticamente la lista completa de palabras por defecto
- **Crucigramas**: Se pueden generar y jugar normalmente

---

### 3. **Configuración de Tamaño** ⚙️

- **Ubicación**: Ícono de ajustes en el AppBar
- **Tamaños disponibles**:
  - Small: 20 x 11 (rápido, ~10-30 segundos)
  - Medium: 40 x 22 (moderado, ~1-3 minutos)
  - Large: 80 x 44 (lento, ~5-15 minutos)
  - XLarge: 160 x 88 (muy lento)
  - XXLarge: 500 x 500 (extremadamente lento)

**Recomendación**: Usa Small o Medium para pruebas rápidas

---

### 4. **Estados de la App**

#### 🔄 Generando
- Se muestra el grid con puntos (•)
- Los puntos indican dónde se están colocando palabras
- Espera a que termine la generación

#### 🎮 Jugando
- Grid con celdas vacías
- Toca cualquier celda para ver opciones de palabras
- Selecciona la palabra correcta del menú
- Las letras aparecen en mayúsculas

#### 🎉 Completado
- Mensaje "Puzzle Completed!"
- Aparece cuando todas las palabras están correctamente colocadas

---

### 5. **Jugar el Crucigrama**

1. **Espera a que termine la generación**
2. **Toca una celda** con letra
3. **Aparece un menú** con 5 opciones:
   - 1 palabra correcta
   - 4 palabras alternativas (del mismo largo)
4. **Selecciona una palabra**
5. **La palabra se coloca** si es válida
6. **Repite** hasta completar todo el crucigrama

#### Menú de Palabras:
- **Across**: Palabras horizontales
- **Down**: Palabras verticales
- ✅ **Radio marcado**: Palabra ya seleccionada
- ⭕ **Radio vacío**: Palabra disponible

---

### 6. **Guardado Automático** (Online)

Cuando usas categorías con internet:
- Los crucigramas se guardan automáticamente en Supabase
- Puedes recuperarlos más tarde (funcionalidad futura)

---

## 🔧 Solución de Problemas

### No aparece el selector de categorías
- ✅ Verifica tu conexión a internet
- ✅ Asegúrate de que Supabase esté configurado correctamente
- ✅ Revisa que las credenciales estén en `supabase_service.dart`

### La generación tarda mucho
- ✅ Reduce el tamaño del crucigrama
- ✅ Usa tamaño "Small" para pruebas
- ✅ Las categorías con menos palabras pueden tardar más

### No puedo seleccionar una palabra
- ✅ Verifica que no entre en conflicto con otras palabras ya colocadas
- ✅ Solo se pueden seleccionar palabras que encajen con las demás

### El crucigrama no se completa
- ✅ Intenta con diferentes combinaciones de palabras
- ✅ Algunas palabras pueden tener múltiples soluciones válidas

---

## 💡 Consejos

1. **Empieza con Small** para ver cómo funciona
2. **Prueba diferentes categorías** para temas variados
3. **Sin internet** la app funciona igual con todas las palabras
4. **Lee el tutorial** de Supabase si quieres agregar categorías propias
5. **Sé paciente** - Los crucigramas grandes tardan varios minutos

---

## 📞 Soporte

Si encuentras problemas o tienes sugerencias:
- Revisa el archivo `SUPABASE_SETUP.md` para configuración
- Verifica los logs de la consola para errores
- Asegúrate de tener las dependencias actualizadas

¡Disfruta del crucigrama! 🎯
