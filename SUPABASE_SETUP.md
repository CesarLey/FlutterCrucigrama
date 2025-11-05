# Configuración de Supabase para Crucigramas con Categorías

## 1. Crear cuenta en Supabase

1. Ve a [https://supabase.com](https://supabase.com)
2. Crea una cuenta gratuita
3. Crea un nuevo proyecto

## 2. Obtener las credenciales

1. En tu proyecto de Supabase, ve a **Settings** > **API**
2. Copia:
  - **Project URL** (ejemplo: `https://kmkhyipsxuwmusuvthyp.supabase.co`)
  - **anon public** key (ejemplo: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtta2h5aXBzeHV3bXVzdXZ0aHlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE3NDUzODMsImV4cCI6MjA3NzMyMTM4M30.H6hc8gakOP_oIHxycBqYHtDNq0GyDi3nrrL3KQRh9dg`)

3. Actualiza el archivo `lib/services/supabase_service.dart`:
```dart
static const String supabaseUrl = 'TU_SUPABASE_URL';  // Reemplazar
static const String supabaseAnonKey = 'TU_SUPABASE_ANON_KEY';  // Reemplazar
```

> Nota: las credenciales actuales están definidas en `lib/services/supabase_service.dart` (si las cambiaste ahí, este documento se ha actualizado para mostrar ejemplos). Para mayor seguridad, considera usar variables de entorno o un archivo de configuración que no subas al repositorio.

## 3. Crear las tablas en Supabase

### Tabla: `word_categories`

Ejecuta este SQL en el **SQL Editor** de Supabase:

```sql
-- Crear tabla de categorías de palabras
CREATE TABLE word_categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  name_es TEXT NOT NULL,
  words TEXT[] NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar Row Level Security (RLS)
ALTER TABLE word_categories ENABLE ROW LEVEL SECURITY;

-- Política para permitir lectura a todos
CREATE POLICY "Allow public read access" 
ON word_categories FOR SELECT 
TO public 
USING (true);

-- Insertar categorías de ejemplo
INSERT INTO word_categories (name, name_es, words) VALUES
('fruits', 'Frutas', ARRAY['manzana', 'banana', 'naranja', 'pera', 'uva', 'sandia', 'melon', 'fresa', 'cereza', 'durazno', 'mango', 'papaya', 'kiwi', 'limon', 'lima', 'pomelo', 'ciruela', 'higo', 'dátil', 'coco', 'piña', 'granada', 'mora', 'frambuesa', 'arandano']),

('animals', 'Animales', ARRAY['perro', 'gato', 'leon', 'tigre', 'elefante', 'jirafa', 'cebra', 'mono', 'oso', 'lobo', 'zorro', 'conejo', 'ardilla', 'raton', 'caballo', 'vaca', 'cerdo', 'oveja', 'gallina', 'pato', 'pavo', 'aguila', 'halcon', 'loro', 'buho']),

('cities', 'Ciudades', ARRAY['madrid', 'barcelona', 'valencia', 'sevilla', 'bilbao', 'malaga', 'murcia', 'palma', 'granada', 'cordoba', 'vigo', 'gijon', 'cadiz', 'toledo', 'burgos', 'leon', 'salamanca', 'avila', 'segovia', 'cuenca', 'teruel', 'huesca', 'soria', 'zamora', 'logroño']),

('cars', 'Autos', ARRAY['toyota', 'honda', 'ford', 'chevrolet', 'nissan', 'mazda', 'bmw', 'audi', 'mercedes', 'volkswagen', 'seat', 'peugeot', 'renault', 'citroen', 'fiat', 'alfa', 'ferrari', 'lamborghini', 'porsche', 'tesla', 'volvo', 'hyundai', 'kia', 'subaru', 'suzuki']),

('colors', 'Colores', ARRAY['rojo', 'azul', 'verde', 'amarillo', 'naranja', 'morado', 'rosa', 'negro', 'blanco', 'gris', 'marron', 'beige', 'turquesa', 'cyan', 'magenta', 'dorado', 'plateado', 'bronce', 'violeta', 'indigo', 'coral', 'salmon', 'crema', 'ocre', 'oliva']),

('countries', 'Países', ARRAY['españa', 'francia', 'italia', 'alemania', 'portugal', 'grecia', 'suiza', 'austria', 'belgica', 'holanda', 'suecia', 'noruega', 'dinamarca', 'finlandia', 'polonia', 'chequia', 'hungria', 'rumania', 'bulgaria', 'croacia', 'serbia', 'eslovenia', 'estonia', 'letonia', 'lituania']),

('sports', 'Deportes', ARRAY['futbol', 'baloncesto', 'tenis', 'voleibol', 'natacion', 'atletismo', 'ciclismo', 'boxeo', 'golf', 'rugby', 'beisbol', 'hockey', 'esqui', 'surf', 'escalada', 'judo', 'karate', 'taekwondo', 'esgrima', 'remo', 'vela', 'equitacion', 'gimnasia', 'halterofilia', 'badminton']),

('professions', 'Profesiones', ARRAY['medico', 'enfermero', 'profesor', 'ingeniero', 'abogado', 'arquitecto', 'contador', 'programador', 'diseñador', 'escritor', 'periodista', 'fotografo', 'pintor', 'musico', 'actor', 'chef', 'panadero', 'carpintero', 'electricista', 'fontanero', 'mecanico', 'piloto', 'bombero', 'policia', 'soldado']),

('dark_rippers', 'Dark Rippers', ARRAY['kirito', 'eromechi', 'pablini', 'secuaz', 'niño', 'celismor', 'wesuangelito']);
```

### Tabla: `saved_crosswords`

```sql
-- Crear tabla para guardar crucigramas generados
CREATE TABLE saved_crosswords (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  category_id UUID REFERENCES word_categories(id) ON DELETE CASCADE,
  crossword_data JSONB NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar Row Level Security
ALTER TABLE saved_crosswords ENABLE ROW LEVEL SECURITY;

-- Política para permitir lectura a todos
CREATE POLICY "Allow public read access" 
ON saved_crosswords FOR SELECT 
TO public 
USING (true);

-- Política para permitir inserción a todos (puedes restringir esto después)
CREATE POLICY "Allow public insert access" 
ON saved_crosswords FOR INSERT 
TO public 
WITH CHECK (true);

-- Índice para mejorar consultas por categoría
CREATE INDEX idx_saved_crosswords_category 
ON saved_crosswords(category_id, created_at DESC);
```

## 4. Probar la conexión

1. Ejecuta la app
2. Si hay conexión a internet, verás un ícono de categorías en el AppBar
3. Haz clic para ver las categorías disponibles
4. Selecciona una categoría para generar un crucigrama con esas palabras

## 5. Modo Offline

- Si no hay internet, el ícono mostrará "Sin conexión a internet"
- La app usará automáticamente la lista de palabras por defecto (words.txt)
- Las funciones de categorías estarán deshabilitadas

## 6. Agregar más categorías

Puedes agregar más categorías ejecutando:

```sql
INSERT INTO word_categories (name, name_es, words) VALUES
('tu_categoria', 'Tu Categoría', ARRAY['palabra1', 'palabra2', 'palabra3', ...]);
```

### Tabla: `scores` (opcional: tabla dedicada para puntuaciones)

Si prefieres guardar puntuaciones en una tabla dedicada (recomendado), ejecuta este SQL en el SQL Editor de Supabase:

```sql
-- Tabla para guardar puntuaciones de jugadores
CREATE TABLE scores (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  player_name TEXT NOT NULL,
  score INTEGER NOT NULL,
  category_id UUID REFERENCES word_categories(id) ON DELETE SET NULL,
  words TEXT[] DEFAULT ARRAY[]::text[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar Row Level Security
ALTER TABLE scores ENABLE ROW LEVEL SECURITY;

-- Política para permitir lectura pública (ajusta según seguridad requerida)
CREATE POLICY "Allow public read scores"
ON scores FOR SELECT
TO public
USING (true);

-- Política para permitir inserción pública (puedes restringir esto a usuarios autenticados)
CREATE POLICY "Allow public insert scores"
ON scores FOR INSERT
TO public
WITH CHECK (true);

-- Índice por puntuación para obtener top scores rápidamente
CREATE INDEX idx_scores_score_desc ON scores(score DESC, created_at DESC);
```

Después de ejecutar el SQL, actualiza el código para usar la nueva tabla o usa el método provisto que inserta en `scores`.


## Notas Importantes

- Las palabras deben estar en minúsculas
- Solo se aceptan letras de la 'a' a la 'z' (sin tildes)
- Mínimo 3 letras por palabra
- Se recomienda al menos 25 palabras por categoría para una buena generación

## Nota sobre la creación de la tabla de puntuaciones

- Si ejecutaste el script SQL para crear una tabla de puntuaciones y viste "Success. No rows returned" en el editor de SQL, eso es normal: las instrucciones DDL (CREATE TABLE / CREATE POLICY / CREATE INDEX) no devuelven filas — el mensaje indica que la sentencia se ejecutó correctamente.
- En la interfaz de Supabase, el estado "Unrestricted" (o un badge parecido) en la tabla significa que las políticas de RLS permiten acceso (lectura/escritura). Revisa las políticas que creaste: si dejaste políticas públicas (TO public ... USING (true)) la tabla estará accesible desde cualquier cliente que use la URL/anon key. Esto es conveniente para pruebas, pero considera restringir INSERT si quieres evitar entradas anónimas en producción.
- Si renombraste la tabla a `gamescores` (o a otro nombre) asegúrate de que el código de la app use ese nombre. En este repo añadimos métodos para `gamescores` en `lib/services/supabase_service.dart` (métodos `saveScoreRecord` y `getTopScores`).

- Si renombraste la tabla a `GameScores` (o a otro nombre) asegúrate de que el código de la app use ese nombre. En este repo añadimos métodos para `GameScores` en `lib/services/supabase_service.dart` (métodos `saveScoreRecord` y `getTopScores`).

Si quieres que cambie los nombres en el código para apuntar a otro nombre de tabla (por ejemplo `my_scores`), dímelo y lo actualizo.
