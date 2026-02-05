# Demo.CICD.Api

API REST con CI/CD implementado usando GitHub Actions, Docker y GitHub Container Registry.

## Práctica de Laboratorio 6
**Curso:** Programación Avanzada  
**Tema:** Implementación de un flujo CI/CD

## Descripción

Esta API demuestra un flujo completo de CI/CD:
- **CI (Integración Continua):** Compilación, pruebas y creación de imagen Docker automatizada
- **CD (Despliegue Continuo):** Publicación de imagen en GHCR y despliegue local

## Endpoints

- `GET /health` - Verificación de salud de la API
- `GET /api/v1/ping` - Ping con timestamp
- `GET /version` - Información de versión y build
- `/swagger` - Documentación interactiva de la API

## Requisitos

- .NET 10.0 SDK
- Docker Desktop
- Git
- Cuenta de GitHub

## Ejecución Local (sin Docker)

```bash
cd Demo.CICD.Api
dotnet restore
dotnet build
dotnet run
```

La API estará disponible en `http://localhost:5000`

## Construcción de Imagen Docker

```bash
cd Demo.CICD.Api
docker build -t demo-cicd-api .
docker run -p 8080:8080 demo-cicd-api
```

## Despliegue con Docker Compose

### 1. Autenticarse en GitHub Container Registry

```bash
docker login ghcr.io
```

- **Usuario:** Tu usuario de GitHub
- **Contraseña:** Personal Access Token (con permisos `read:packages`)

### 2. Actualizar docker-compose.yml

Reemplaza `USUARIO_GH` en `docker-compose.yml` con tu usuario de GitHub:

```yaml
image: ghcr.io/TU_USUARIO/demo-cicd-api:latest
```

### 3. Descargar y ejecutar

```bash
docker compose pull
docker compose up -d
```

### 4. Verificar

```bash
docker compose ps
docker compose logs -f
```

Acceder a:
- http://localhost:8080/health
- http://localhost:8080/api/v1/ping
- http://localhost:8080/version
- http://localhost:8080/swagger

### 5. Detener

```bash
docker compose down
```

## Flujo CI/CD

### 1. Integración Continua (CI)

Cada vez que se hace `push` a la rama `main`:

1. GitHub Actions ejecuta el workflow `.github/workflows/ci-cd.yml`
2. Compila el proyecto .NET
3. Ejecuta las pruebas
4. Construye la imagen Docker
5. Publica la imagen en GitHub Container Registry (GHCR)

### 2. Despliegue Continuo (CD) Local

1. Autenticarse en GHCR: `docker login ghcr.io`
2. Descargar última imagen: `docker compose pull`
3. Desplegar: `docker compose up -d`
4. Verificar: Acceder a los endpoints

## Configuración del Repositorio GitHub

### 1. Crear repositorio

```bash
git init
git add .
git commit -m "init: Configuración inicial del proyecto CI/CD"
git branch -M main
git remote add origin https://github.com/USUARIO/demo-cicd-api.git
git push -u origin main
```

### 2. Configurar permisos de paquetes

1. Ir a `Settings` del repositorio
2. `Actions` → `General`
3. En "Workflow permissions", seleccionar "Read and write permissions"
4. Guardar

### 3. Hacer público el paquete (opcional)

1. Ir a tu perfil de GitHub
2. `Packages` → Seleccionar `demo-cicd-api`
3. `Package settings` → `Change visibility` → Public

## Validación del Flujo CI/CD

### Paso 1: Realizar un cambio

Editar `Program.cs` y agregar un campo al endpoint `/version`:

```csharp
app.MapGet("/version", () => Results.Ok(new
{
    service = "Demo.CICD.Api",
    env = app.Environment.EnvironmentName,
    build = Environment.GetEnvironmentVariable("GIT_SHA") ?? "local",
    version = "1.0.1",  // ← NUEVO
    timestamp = DateTime.UtcNow
}));
```

### Paso 2: Subir cambios

```bash
git add .
git commit -m "feat: Agregar versión y timestamp al endpoint /version"
git push
```

### Paso 3: Verificar CI

1. Ir a `Actions` en GitHub
2. Ver el workflow en ejecución
3. Esperar a que termine exitosamente

### Paso 4: Actualizar despliegue local

```bash
docker compose pull
docker compose up -d
```

### Paso 5: Verificar cambio

Acceder a `http://localhost:8080/version` y verificar los nuevos campos.

## Estructura del Proyecto

```
Lab2_Grupo1/
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # Workflow de GitHub Actions
├── Demo.CICD.Api/
│   ├── Program.cs             # Endpoints de la API
│   ├── Dockerfile             # Imagen Docker
│   ├── Demo.CICD.Api.csproj   # Configuración del proyecto
│   ├── appsettings.json
│   └── appsettings.Development.json
├── docker-compose.yml         # Orquestación para despliegue local
├── .gitignore
└── README.md
```

## Solución de Problemas

### Error al hacer pull de la imagen

```bash
# Verificar autenticación
docker logout ghcr.io
docker login ghcr.io
```

### La API no responde

```bash
# Ver logs
docker compose logs -f

# Verificar contenedores
docker compose ps
```

### Cambios no se reflejan

```bash
# Forzar recreación de contenedor
docker compose pull
docker compose up -d --force-recreate
```

## Autores

**Grupo 1** - Práctica de Laboratorio 6  
Tecnologías de la Información - ESPE

## Licencia

Este proyecto es parte de un ejercicio académico.
