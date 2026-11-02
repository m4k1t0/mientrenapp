# Mi Entrenamiento — versión reparada

## Qué corrige
- Guarda el perfil, inventario/discos, cargas, rutinas, registros diarios y sesiones en Supabase, asociados al usuario autenticado.
- Al iniciar sesión, recupera los datos guardados y rellena el formulario; no comienza de cero.
- Al guardar el perfil, genera y guarda una rutina semanal usando el equipo registrado.
- Permite regenerar la rutina después de cambiar equipo/cargas.
- Permite cargar GIF reales por ejercicio. Se suben a Supabase Storage y se ven en otros dispositivos.
- Si un GIF todavía no existe, la guía muestra instrucciones de ejecución, puntos técnicos, series, repeticiones y descanso. No muestra un dibujo falso.
- La interfaz está diseñada primero para móvil.

## Configuración obligatoria de Supabase
1. Abre el proyecto Supabase que ya usas.
2. En SQL Editor ejecuta el contenido COMPLETO de `supabase.sql`. Esto crea/actualiza tabla, RLS y bucket para GIF.
3. Abre Project Settings → API (o Connect) y copia Project URL y publishable/anon public key.
4. Pega ambas en `config.js`. No uses service_role/secret key.
5. Sube todos los archivos a GitHub y publica desde Settings → Pages.

## Importante si ya tenías una tabla previa
Este código utiliza `public.training_data` con columnas `user_id` (uuid, PK), `data` (jsonb), `updated_at` (timestamptz). Si la tabla anterior tenía otro esquema, no basta con que el login funcione: ejecuta el SQL y verifica que esa tabla tenga exactamente esas columnas.

## Cómo verificar guardado
Después de guardar tu perfil:
- Debe aparecer “Datos guardados en Supabase y rutina generada.”
- En Supabase → Table Editor → training_data debe aparecer una fila para tu UUID con `data.profile`, `data.equipment`, `data.loads` y `data.routines`.
- Si falla, la app muestra el error de Supabase en lugar de fingir que guardó.

## GIFs
En Rutinas abre Guía en un ejercicio y elige Cargar GIF. Solo acepta GIF de hasta 8 MB. Se almacena en el bucket `exercise-gifs`, dentro de una carpeta con tu UUID. Para ejercicios sin GIF se muestra una guía textual con ejecución y puntos de técnica.

## Persistencia
Los datos no se guardan en localStorage ni IndexedDB ni en un JSON local. Supabase es el almacenamiento central, accesible desde cualquier dispositivo al iniciar sesión.
