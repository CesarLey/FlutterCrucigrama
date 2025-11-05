# generate_crossword

A new Flutter project.
# CrossWords — Juego de crucigramas

Una aplicación de crucigramas hecha con Flutter. Esta rama contiene la app cliente, generador de crucigramas, integración con Supabase para guardar puntuaciones y utilidades para reproducir música y sonidos de juego.
# CrossWords — Juego de crucigramas

Descripción
-----------
CrossWords es una aplicación de crucigramas desarrollada en Flutter. Incluye un generador de crucigramas, una interfaz para jugar, un sistema de puntuaciones persistente usando Supabase y soporte para audio (música de fondo y efectos).

Objetivo
--------
Proveer una app ligera y multiplataforma que permita generar y jugar crucigramas, registrar puntajes y mostrar un leaderboard global.

Tecnologías
-----------
- Flutter + Dart
- Riverpod (gestión de estado)
- Supabase (base de datos y backend)
- Paquetes auxiliares: `audioplayers`, `flutter_launcher_icons`, `flutter_native_splash`.

Arquitectura y componentes clave
-------------------------------
- `lib/` — código principal en Dart.
	- `widgets/` — UI (pantallas del juego, diálogo de leaderboard, pantalla de completado).
	- `services/` — integración con Supabase (`supabase_service.dart`) y audio (`audio_service.dart`).
	- `models/` — modelos de datos (categorías, puzzles, etc.).
	- `providers.dart` — providers de Riverpod para estado compartido.
- `assets/` — recursos: palabras, audios, iconos y splash.

Flujo básico
-----------
1. El generador usa `assets/words.txt` para construir un crucigrama.
2. El jugador completa palabras en la UI.
3. Al finalizar, la app muestra un formulario para guardar nombre y puntaje.
4. El puntaje se inserta en la tabla `GameScores` en Supabase.
5. El leaderboard (Top 5) se obtiene desde Supabase y se muestra en un diálogo.

Instalación y ejecución (desarrollo)
-----------------------------------
1. Clona el repositorio y entra en la carpeta del proyecto.

```powershell
git clone <tu-repo-url>
cd CrossWords
```

2. Instala dependencias:

```powershell
flutter pub get
```

3. Corre la app en un dispositivo conectado o emulador:

```powershell
flutter run -d <deviceId>
```

4. Nota: para que los iconos o splash nativos se actualicen en Android/iOS puede ser necesario desinstalar la app previamente.

Configurar Supabase
-------------------
1. Crea un proyecto en https://supabase.com.
2. Crea la tabla `GameScores` con al menos las columnas:
	 - `player_name` (text)
	 - `category_id` (text, nullable)
	 - `score` (integer)
	 - `words` (text[] o text)
	 - `created_at` (timestamp)
3. Copia la URL del proyecto y la anon key.
4. Actualiza `lib/services/supabase_service.dart` con esas credenciales, o sigue los pasos en `SUPABASE_SETUP.md`.

Assets (audio, iconos y splash)
-------------------------------
- Música de fondo: `assets/audio/background.mp3` (nombre por defecto usado por `AudioService`).
- Efecto al completar: `assets/audio/completed.mp3`.
- Icono de la app: `assets/icons/app_icon.png` (1024×1024 recomendado).
- Splash: `assets/splash/splash.png` (imagen grande centrada, p.ej. 2048×2048).

Generar iconos y splash (opcional)
----------------------------------
Se incluyen utilidades para generar recursos nativos automáticamente:

```powershell
flutter pub add flutter_launcher_icons
flutter pub run flutter_launcher_icons:main

flutter pub add flutter_native_splash
flutter pub run flutter_native_splash:create
```

Contribuir
---------
- Abre issues para bugs o propuestas de mejora.
- Crea PRs contra `main` y sigue las convenciones de lint.
- Incluye tests cuando cambies lógica del generador o la persistencia.

Contacto
--------
Si necesitas ayuda para desplegar, integrar más features o revisar PRs, abre un issue o contáctame por el repo.

Licencia
--------
Incluye aquí la licencia del proyecto si corresponde (por ejemplo MIT).

--
_README actualizado para describir el proyecto y facilitar a nuevos colaboradores su puesta en marcha._
