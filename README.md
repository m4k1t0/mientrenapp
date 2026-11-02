# Mi Entrenamiento — frontend móvil + datos centralizados

## Importante: dónde se guardan los datos
Los datos NO se guardan en el navegador ni en un JSON del repositorio. GitHub Pages es un hosting estático: no permite que el JavaScript del sitio escriba de forma segura archivos en el repositorio. Si guardáramos los datos mediante un token de GitHub dentro del frontend, cualquier visitante podría extraerlo y modificar el repositorio.

Esta versión utiliza Supabase como base de datos centralizada. El perfil, el inventario, las cargas y los registros diarios se guardan como un documento JSONB asociado a la cuenta autenticada. Puedes iniciar sesión desde varios dispositivos y recuperar los mismos datos.

## Configuración (una sola vez)
1. Crea un proyecto en https://supabase.com (el plan gratuito basta para empezar).
2. Abre **SQL Editor** y ejecuta el contenido completo de `supabase.sql`.
3. En Supabase, entra a **Project Settings → API** (o Connect) y copia:
   - Project URL
   - Publishable key (o anon public key)
4. Edita `config.js` y pega esos dos valores.
   - No uses `service_role` ni secret key.
5. Sube TODOS los archivos del proyecto a la raíz de un repositorio GitHub.
6. En GitHub: **Settings → Pages → Deploy from a branch → main → /(root)**.
7. Abre la URL de Pages, crea tu cuenta e inicia sesión.

## Funcionalidad actual
- Autenticación con correo y contraseña.
- Perfil inicial capturado desde la app.
- Registro de objetivo, peso, altura, días disponibles, minutos por sesión.
- Registro de meta de agua y caminata.
- Inventario editable: discos, mancuernas, barras, banco y otros; peso y cantidad.
- Registro de cargas actuales por movimiento.
- Registro diario de agua y caminata.
- Panel de progreso básico.
- Diseño responsive pensado primero para celular.

## GIFs de ejercicios
La interfaz de rutinas está preparada para incorporar demostraciones reales por ejercicio. Los GIF se alojarán como archivos estáticos en `assets/gifs/` y se referenciarán desde los ejercicios. No se sustituyen por animaciones CSS o dibujos genéricos. Los GIF se añadirán cuando se definan los ejercicios correctos.

## IA futura
El frontend está desacoplado de cualquier proveedor. Para IA online se agregará una función backend (Supabase Edge Function) que guarde la clave del proveedor en Secrets y devuelva propuestas validadas. Nunca se expone una API key privada en GitHub Pages. Para IA local se puede añadir un conector opcional, pero solo funcionará en un equipo que tenga ese runtime.

## Nota
El archivo `config.js` contiene únicamente la URL y la clave pública de Supabase. Las políticas RLS del SQL impiden que un usuario lea o modifique el documento JSON de otro usuario.
