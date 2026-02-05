# INSTRUCCIONES PASO A PASO - LABORATORIO CI/CD

## PARTE 1: Configuración Inicial del Repositorio GitHub

### Paso 1.1: Crear el repositorio en GitHub
1. Ir a https://github.com
2. Clic en el botón "+" → "New repository"
3. Nombre: `demo-cicd-api`
4. Descripción: "API con CI/CD - Laboratorio 6"
5. Visibilidad: **Public** (importante para que GHCR funcione sin problemas)
6. **NO** inicializar con README, .gitignore ni licencia
7. Clic en "Create repository"

### Paso 1.2: Subir el código al repositorio

Abrir PowerShell en la carpeta del proyecto y ejecutar:

```powershell
# Inicializar repositorio Git
git init

# Agregar todos los archivos
git add .

# Hacer el primer commit
git commit -m "init: Configuración inicial del proyecto CI/CD"

# Cambiar a rama main
git branch -M main

# Agregar el repositorio remoto (REEMPLAZAR con tu usuario)
git remote add origin https://github.com/TU_USUARIO/demo-cicd-api.git

# Subir el código
git push -u origin main
```

### Paso 1.3: Configurar permisos de GitHub Actions

1. En tu repositorio de GitHub, ir a **Settings**
2. En el menú lateral, ir a **Actions** → **General**
3. Scroll hasta "Workflow permissions"
4. Seleccionar **"Read and write permissions"**
5. Marcar **"Allow GitHub Actions to create and approve pull requests"**
6. Clic en **Save**

### Paso 1.4: Verificar que el CI se ejecutó

1. Ir a la pestaña **Actions** en tu repositorio
2. Deberías ver el workflow "CI-CD API" ejecutándose o completado
3. Clic en el workflow para ver los detalles
4. Verificar que todos los pasos estén en verde ✓

**Si el workflow falla:**
- Revisar los logs en la pestaña Actions
- Verificar que los permisos estén configurados correctamente
- Asegurarse de que el código esté en la rama `main`

---

## PARTE 2: Despliegue Continuo Local

### Paso 2.1: Verificar requisitos locales

Abrir PowerShell y ejecutar:

```powershell
# Verificar Docker
docker --version
# Debe mostrar: Docker version XX.X.X

# Verificar Docker Compose
docker compose version
# Debe mostrar: Docker Compose version vX.X.X

# Verificar que Docker Desktop esté ejecutándose
docker ps
# Debe mostrar una tabla (puede estar vacía)
```

**Si hay errores:**
- Asegurarse de que Docker Desktop esté abierto y ejecutándose
- Reiniciar Docker Desktop si es necesario

### Paso 2.2: Crear Personal Access Token (PAT)

Para descargar imágenes de GitHub Container Registry necesitas un token:

1. En GitHub, clic en tu avatar (esquina superior derecha)
2. **Settings** → **Developer settings** (al final del menú lateral)
3. **Personal access tokens** → **Tokens (classic)**
4. Clic en **Generate new token** → **Generate new token (classic)**
5. Nombre: `Docker GHCR Access`
6. Seleccionar los siguientes scopes:
   - ✓ `read:packages` (Descargar paquetes del Container Registry)
   - ✓ `write:packages` (Opcional, para subir paquetes manualmente)
7. Clic en **Generate token**
8. **IMPORTANTE:** Copiar el token y guardarlo en un lugar seguro (no se podrá ver de nuevo)

### Paso 2.3: Autenticarse en GitHub Container Registry

En PowerShell:

```powershell
docker login ghcr.io
```

Cuando te pida:
- **Username:** Tu usuario de GitHub (ej: `juan-perez`)
- **Password:** El Personal Access Token que acabas de crear

Deberías ver: `Login Succeeded`

### Paso 2.4: Hacer público el paquete (Recomendado)

Para facilitar el acceso:

1. Ir a tu perfil de GitHub
2. Clic en **Packages**
3. Buscar y seleccionar `demo-cicd-api`
4. Clic en **Package settings** (lado derecho)
5. Scroll hasta "Danger Zone"
6. Clic en **Change visibility**
7. Seleccionar **Public**
8. Confirmar escribiendo el nombre del paquete

### Paso 2.5: Actualizar docker-compose.yml

Abrir el archivo `docker-compose.yml` y reemplazar `USUARIO_GH` con tu usuario de GitHub:

```yaml
services:
  api:
    image: ghcr.io/tu-usuario-github/demo-cicd-api:latest  # ← CAMBIAR AQUÍ
    container_name: demo-cicd-api
    ports:
      - "8080:8080"
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - GIT_SHA=local
```

**O usar el script automático:**

```powershell
.\deploy-local.ps1 -Usuario "tu-usuario-github"
```

### Paso 2.6: Desplegar la API

Opción A - Manual:
```powershell
# Descargar la imagen
docker compose pull

# Iniciar el contenedor
docker compose up -d

# Ver el estado
docker compose ps

# Ver logs
docker compose logs -f
```

Opción B - Con script:
```powershell
.\deploy-local.ps1 -Usuario "tu-usuario-github"
```

### Paso 2.7: Verificar el despliegue

Abrir un navegador y probar los siguientes endpoints:

1. **Health Check:**
   ```
   http://localhost:8080/health
   ```
   Debe responder: `OK`

2. **Ping:**
   ```
   http://localhost:8080/api/v1/ping
   ```
   Debe responder: `{"ok":true,"ts":"2026-02-04T..."}`

3. **Version:**
   ```
   http://localhost:8080/version
   ```
   Debe responder:
   ```json
   {
     "service": "Demo.CICD.Api",
     "env": "Development",
     "build": "abc123..." // Hash del commit de GitHub
   }
   ```

4. **Swagger (Documentación):**
   ```
   http://localhost:8080/swagger
   ```

---

## PARTE 3: Validar el Ciclo CI/CD Completo

### Paso 3.1: Realizar un cambio en el código

Abrir `Demo.CICD.Api/Program.cs` y modificar el endpoint `/version`:

**ANTES:**
```csharp
app.MapGet("/version", () => Results.Ok(new
{
    service = "Demo.CICD.Api",
    env = app.Environment.EnvironmentName,
    build = Environment.GetEnvironmentVariable("GIT_SHA") ?? "local"
}));
```

**DESPUÉS:**
```csharp
app.MapGet("/version", () => Results.Ok(new
{
    service = "Demo.CICD.Api",
    env = app.Environment.EnvironmentName,
    build = Environment.GetEnvironmentVariable("GIT_SHA") ?? "local",
    version = "1.0.1",                    // ← NUEVO
    lastUpdate = "2026-02-04",            // ← NUEVO
    timestamp = DateTime.UtcNow,          // ← NUEVO
    author = "Grupo 1"                    // ← NUEVO (cambiar por tu grupo)
}));
```

### Paso 3.2: Verificar el cambio localmente (opcional)

```powershell
cd Demo.CICD.Api
dotnet run
```

Abrir http://localhost:5000/version y verificar los nuevos campos.

Presionar `Ctrl+C` para detener.

### Paso 3.3: Subir el cambio a GitHub

```powershell
# Ver archivos modificados
git status

# Agregar cambios
git add .

# Hacer commit con mensaje descriptivo
git commit -m "feat: Agregar información de versión y autor al endpoint /version"

# Subir a GitHub
git push
```

### Paso 3.4: Monitorear el pipeline CI

1. Ir a tu repositorio en GitHub
2. Clic en la pestaña **Actions**
3. Deberías ver un nuevo workflow ejecutándose con el nombre de tu commit
4. Clic en el workflow para ver el progreso en tiempo real
5. Esperar a que todos los pasos estén en verde ✓
6. El proceso completo tarda aproximadamente 2-5 minutos

**Pasos del pipeline:**
- ✓ Checkout (descargar código)
- ✓ Setup .NET (instalar SDK)
- ✓ Restore (restaurar dependencias)
- ✓ Build (compilar)
- ✓ Test (ejecutar pruebas)
- ✓ Log in to GHCR (autenticarse)
- ✓ Build and push Docker image (crear y publicar imagen)

### Paso 3.5: Actualizar el despliegue local

Una vez que el pipeline termine exitosamente:

```powershell
# Detener el contenedor actual
docker compose down

# Descargar la nueva imagen
docker compose pull

# Iniciar con la nueva versión
docker compose up -d

# Verificar que se actualizó
docker compose logs -f
```

### Paso 3.6: Verificar que el cambio se reflejó

Abrir http://localhost:8080/version

Deberías ver los nuevos campos:
```json
{
  "service": "Demo.CICD.Api",
  "env": "Development",
  "build": "xyz789...",  // ← Este hash cambió
  "version": "1.0.1",    // ← NUEVO
  "lastUpdate": "2026-02-04",  // ← NUEVO
  "timestamp": "2026-02-04T15:30:00.123Z",  // ← NUEVO
  "author": "Grupo 1"    // ← NUEVO
}
```

---

## PARTE 4: Evidencias para el Informe

### 4.1. Captura del repositorio GitHub
- Captura de pantalla del repositorio mostrando los archivos

### 4.2. Captura del workflow de GitHub Actions
- Captura del workflow ejecutándose o completado exitosamente
- Captura de los detalles de cada paso (todos en verde)

### 4.3. Captura del GitHub Container Registry
- Ir a tu perfil → Packages
- Captura del paquete `demo-cicd-api`

### 4.4. Capturas de los endpoints funcionando
- Captura de `/health` respondiendo "OK"
- Captura de `/api/v1/ping` con el timestamp
- Captura de `/version` mostrando todos los campos
- Captura de `/swagger` con la documentación

### 4.5. Capturas del despliegue local
- Captura de `docker compose ps` mostrando el contenedor ejecutándose
- Captura de `docker compose logs` mostrando los logs de la API

### 4.6. Capturas del cambio validado
- Captura del código modificado en `Program.cs`
- Captura del commit en GitHub
- Captura del nuevo workflow ejecutándose
- Captura de `/version` con los nuevos campos

---

## COMANDOS ÚTILES

### Docker
```powershell
# Ver contenedores ejecutándose
docker compose ps

# Ver logs en tiempo real
docker compose logs -f

# Ver logs de los últimos 100 líneas
docker compose logs --tail 100

# Reiniciar contenedor
docker compose restart

# Detener contenedor
docker compose down

# Detener y eliminar volúmenes
docker compose down -v

# Forzar recreación del contenedor
docker compose up -d --force-recreate
```

### Git
```powershell
# Ver estado
git status

# Ver historial
git log --oneline

# Ver diferencias
git diff

# Deshacer cambios no guardados
git checkout -- .

# Ver ramas
git branch -a
```

### .NET
```powershell
# Compilar
dotnet build

# Ejecutar
dotnet run

# Ejecutar con watch (recarga automática)
dotnet watch run

# Limpiar
dotnet clean
```

---

## SOLUCIÓN DE PROBLEMAS COMUNES

### Problema 1: "docker: command not found"
**Solución:** 
- Abrir Docker Desktop
- Esperar a que inicie completamente
- Reiniciar PowerShell

### Problema 2: "Error response from daemon: pull access denied"
**Solución:**
- Verificar autenticación: `docker login ghcr.io`
- Verificar que el paquete sea público o que tengas acceso
- Verificar que el nombre de usuario en `docker-compose.yml` sea correcto

### Problema 3: El workflow de GitHub Actions falla
**Solución:**
- Verificar permisos en Settings → Actions → General
- Asegurarse de estar en la rama `main`
- Revisar los logs detallados en Actions

### Problema 4: "Port 8080 is already in use"
**Solución:**
```powershell
# Ver qué proceso usa el puerto
netstat -ano | findstr :8080

# Detener contenedores
docker compose down

# Si persiste, cambiar el puerto en docker-compose.yml
ports:
  - "8081:8080"  # Usar 8081 localmente
```

### Problema 5: Los cambios no se reflejan después de actualizar
**Solución:**
```powershell
# Forzar descarga de nueva imagen
docker compose pull

# Forzar recreación del contenedor
docker compose up -d --force-recreate

# Si persiste, limpiar cache de Docker
docker system prune -a
```

### Problema 6: "Cannot connect to the Docker daemon"
**Solución:**
- Abrir Docker Desktop
- Verificar que esté ejecutándose (ícono en la bandeja del sistema)
- Si no inicia, reiniciar Windows

---

## ESTRUCTURA FINAL DEL PROYECTO

```
Lab2_Grupo1/
├── .github/
│   └── workflows/
│       └── ci-cd.yml              # Pipeline de CI/CD
├── Demo.CICD.Api/
│   ├── bin/                       # (ignorado por git)
│   ├── obj/                       # (ignorado por git)
│   ├── Properties/
│   │   └── launchSettings.json
│   ├── appsettings.json
│   ├── appsettings.Development.json
│   ├── Demo.CICD.Api.csproj      # Configuración del proyecto
│   ├── Demo.CICD.Api.http        # Peticiones HTTP de prueba
│   ├── Dockerfile                # Imagen Docker
│   └── Program.cs                # Código de la API
├── .gitignore                    # Archivos a ignorar por Git
├── docker-compose.yml            # Orquestación local
├── deploy-local.ps1              # Script de despliegue
├── INSTRUCCIONES.md              # Este archivo
└── README.md                     # Documentación principal
```

---

## FLUJO COMPLETO RESUMIDO

```
1. DESARROLLADOR escribe código
   ↓
2. GIT: commit + push a GitHub
   ↓
3. GITHUB ACTIONS (CI) se activa automáticamente:
   - Compila el proyecto
   - Ejecuta tests
   - Construye imagen Docker
   - Publica en GitHub Container Registry
   ↓
4. DESARROLLADOR ejecuta despliegue local (CD):
   - docker compose pull (descarga nueva imagen)
   - docker compose up -d (despliega)
   ↓
5. API ejecutándose en http://localhost:8080
   ↓
6. VERIFICACIÓN: Probar endpoints y confirmar cambios
```

---

## PREGUNTAS PARA EL INFORME

### 1. ¿Qué es CI/CD y cuáles son sus beneficios?
**Respuesta esperada:**
- CI = Integración Continua: proceso automatizado de compilar y probar código frecuentemente
- CD = Despliegue Continuo: automatización del despliegue de aplicaciones
- Beneficios: detección temprana de errores, mayor velocidad de entrega, menos errores humanos

### 2. ¿Qué hace el workflow de GitHub Actions en este proyecto?
**Respuesta esperada:**
- Se activa con cada push a main
- Compila el proyecto .NET
- Ejecuta las pruebas
- Construye una imagen Docker
- Publica la imagen en GHCR

### 3. ¿Cómo se realiza el Despliegue Continuo local?
**Respuesta esperada:**
- Se descarga la imagen desde GHCR usando `docker compose pull`
- Se despliega localmente con `docker compose up -d`
- Docker Compose orquesta el contenedor según la configuración

### 4. ¿Qué ventajas tiene usar Docker para el despliegue?
**Respuesta esperada:**
- Consistencia entre entornos (desarrollo, staging, producción)
- Aislamiento de dependencias
- Facilidad de escalado
- Portabilidad

---

## CONTACTO Y SOPORTE

Para dudas sobre el laboratorio:
- Revisar los logs: `docker compose logs -f`
- Revisar GitHub Actions para errores de CI
- Consultar con el docente: Armando Ortiz

**¡Éxito en tu laboratorio!** 🚀
