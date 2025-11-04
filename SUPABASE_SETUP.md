# Configuración de Supabase para Crucigramas con Categorías

## 1. Crear cuenta en Supabase

1. Ve a [https://supabase.com](https://supabase.com)
2. Crea una cuenta gratuita
3. Crea un nuevo proyecto

## 2. Obtener las credenciales

1. En tu proyecto de Supabase, ve a **Settings** > **API**
2. Copia:
   - **Project URL** (será tu `https://vespnopipzsllnvbnzbq.supabase.co`)
   - **anon public** key (será tu `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZlc3Bub3BpcHpzbGxudmJuemJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE3NjI5NDEsImV4cCI6MjA3NzMzODk0MX0.2ddxfqlmdivgti8hXw5e6mQR5Avg5CRZjaia7pbePtk`)

3. Actualiza el archivo `lib/services/supabase_service.dart`:
```dart
static const String supabaseUrl = 'TU_SUPABASE_URL';  // Reemplazar
static const String supabaseAnonKey = 'TU_SUPABASE_ANON_KEY';  // Reemplazar
```

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

## Notas Importantes

- Las palabras deben estar en minúsculas
- Solo se aceptan letras de la 'a' a la 'z' (sin tildes)
- Mínimo 3 letras por palabra
- Se recomienda al menos 25 palabras por categoría para una buena generación
