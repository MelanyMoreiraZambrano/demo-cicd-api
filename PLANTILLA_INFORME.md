# PLANTILLA DE INFORME - LABORATORIO 6
## Implementación de un flujo CI/CD

---

**DEPARTAMENTO:** Ciencias de la Computación  
**CARRERA:** Tecnologías de la Información  
**ASIGNATURA:** Programación Avanzada  
**PERÍODO LECTIVO:** 202551  
**NIVEL:** 7  
**DOCENTE:** Armando Ortiz  
**NRC:** 30776  
**PRÁCTICA N°:** 6  

**TEMA:** Implementación de un flujo CI/CD  
**LABORATORIO:** LB101 (Lab 5)

---

## INTEGRANTES DEL GRUPO

| Nombre | Código |
|--------|--------|
| [Nombre 1] | [Código 1] |
| [Nombre 2] | [Código 2] |
| [Nombre 3] | [Código 3] |
| [Nombre 4] | [Código 4] |

---

## 1. INTRODUCCIÓN

### 1.1. Contexto
[Describir brevemente qué es CI/CD y por qué es importante en el desarrollo moderno]

### 1.2. Objetivos

**Objetivo General:**
- Implementar un flujo completo de CI/CD para una API REST en .NET utilizando GitHub Actions y Docker.

**Objetivos Específicos:**
- Crear una API REST con endpoints versionados
- Contenerizar la aplicación usando Docker
- Configurar un pipeline de Integración Continua (CI)
- Implementar Despliegue Continuo (CD) en entorno local
- Validar el ciclo completo de cambios en el código

---

## 2. MARCO TEÓRICO

### 2.1. ¿Qué es CI/CD?

**Integración Continua (CI):**
[Explicar qué es CI, su propósito y beneficios]

**Despliegue Continuo (CD):**
[Explicar qué es CD, diferencia entre Continuous Delivery y Continuous Deployment]

### 2.2. GitHub Actions
[Explicar qué es GitHub Actions y cómo funciona]

### 2.3. Docker y Contenedorización
[Explicar qué es Docker, imágenes, contenedores y sus ventajas]

### 2.4. GitHub Container Registry (GHCR)
[Explicar qué es GHCR y su rol en el flujo CI/CD]

---

## 3. MATERIALES Y EQUIPOS

### 3.1. Hardware
- Computador: HP ProDesk 600 G2 DM (x64)
- Procesador: Intel® Core™ i7-6700T 2.8 GHz
- Memoria RAM: 8GB
- Almacenamiento: 480GB SSD
- Sistema Operativo: Windows 10

### 3.2. Software
- .NET 10.0 SDK
- Docker Desktop
- Git
- Visual Studio Code
- Navegador Web (Chrome/Edge/Firefox)

### 3.3. Servicios Cloud
- GitHub (repositorio y GitHub Actions)
- GitHub Container Registry

---

## 4. PROCEDIMIENTO

### 4.1. Parte A - Preparación del Proyecto (API)

#### 4.1.1. Creación del proyecto
[Explicar los comandos ejecutados para crear el proyecto]

**Comandos ejecutados:**
```powershell
dotnet new webapi -n Demo.CICD.Api
cd Demo.CICD.Api
dotnet build
```

**Evidencia:**
[INSERTAR CAPTURA: Pantalla mostrando la creación del proyecto]

#### 4.1.2. Implementación de endpoints
[Explicar los endpoints implementados: /health, /api/v1/ping, /version]

**Código implementado:**
```csharp
[Insertar el código de Program.cs]
```

**Evidencia:**
[INSERTAR CAPTURA: Código del archivo Program.cs]

### 4.2. Parte B - Dockerización

#### 4.2.1. Creación del Dockerfile
[Explicar las etapas del Dockerfile: build y runtime]

**Contenido del Dockerfile:**
```dockerfile
[Insertar contenido del Dockerfile]
```

**Evidencia:**
[INSERTAR CAPTURA: Contenido del Dockerfile]

#### 4.2.2. Creación de docker-compose.yml
[Explicar la configuración del docker-compose]

**Evidencia:**
[INSERTAR CAPTURA: Contenido del docker-compose.yml]

### 4.3. Parte C - Repositorio y CI (Build + Tests)

#### 4.3.1. Creación del repositorio en GitHub
[Explicar el proceso de creación del repositorio]

**Evidencia:**
[INSERTAR CAPTURA: Repositorio en GitHub mostrando los archivos]

#### 4.3.2. Configuración del workflow de GitHub Actions
[Explicar cada paso del workflow]

**Contenido del workflow:**
```yaml
[Insertar contenido de .github/workflows/ci-cd.yml]
```

**Evidencia:**
[INSERTAR CAPTURA: Archivo ci-cd.yml en el repositorio]

#### 4.3.3. Ejecución del pipeline CI
[Explicar qué sucede cuando se hace push al repositorio]

**Evidencias:**
[INSERTAR CAPTURA: GitHub Actions ejecutándose]
[INSERTAR CAPTURA: Todos los pasos del workflow en verde ✓]
[INSERTAR CAPTURA: Imagen publicada en GitHub Container Registry]

### 4.4. Parte D - CD Local (Despliegue Continuo)

#### 4.4.1. Autenticación en GitHub Container Registry
[Explicar el proceso de autenticación]

**Comando ejecutado:**
```powershell
docker login ghcr.io
```

**Evidencia:**
[INSERTAR CAPTURA: Login exitoso en GHCR]

#### 4.4.2. Despliegue de la API
[Explicar los comandos de despliegue]

**Comandos ejecutados:**
```powershell
docker compose pull
docker compose up -d
```

**Evidencias:**
[INSERTAR CAPTURA: docker compose ps mostrando el contenedor ejecutándose]
[INSERTAR CAPTURA: docker compose logs mostrando los logs de inicio]

#### 4.4.3. Verificación del despliegue
[Explicar cómo se verificaron los endpoints]

**Evidencias:**
[INSERTAR CAPTURA: Endpoint /health respondiendo "OK"]
[INSERTAR CAPTURA: Endpoint /api/v1/ping con respuesta JSON]
[INSERTAR CAPTURA: Endpoint /version mostrando la información]
[INSERTAR CAPTURA: Swagger UI funcionando]

---

## 5. VALIDACIÓN DEL CICLO CI/CD COMPLETO

### 5.1. Cambio en el código
[Explicar el cambio realizado en el código]

**Modificación realizada:**
```csharp
[Mostrar el código antes y después del cambio]
```

**Evidencia:**
[INSERTAR CAPTURA: Código modificado en el editor]

### 5.2. Commit y push a GitHub
[Explicar el proceso de subida del cambio]

**Comandos ejecutados:**
```powershell
git add .
git commit -m "feat: Agregar información adicional al endpoint /version"
git push
```

**Evidencia:**
[INSERTAR CAPTURA: Commit visible en GitHub]

### 5.3. Ejecución automática del pipeline
[Explicar cómo se activó automáticamente el workflow]

**Evidencias:**
[INSERTAR CAPTURA: Nuevo workflow ejecutándose automáticamente]
[INSERTAR CAPTURA: Pipeline completado exitosamente]

### 5.4. Actualización del despliegue local
[Explicar el proceso de actualización]

**Comandos ejecutados:**
```powershell
docker compose down
docker compose pull
docker compose up -d
```

**Evidencia:**
[INSERTAR CAPTURA: Actualización del contenedor]

### 5.5. Verificación del cambio
[Explicar cómo se verificó que el cambio se reflejó]

**Evidencias:**
[INSERTAR CAPTURA: Endpoint /version mostrando los nuevos campos]
[INSERTAR CAPTURA: Campo "build" con nuevo hash de commit]

---

## 6. ANÁLISIS DEL FLUJO CI/CD

### 6.1. Flujo completo
[Describir el flujo desde el cambio de código hasta la ejecución]

**Diagrama del flujo:**
```
Desarrollador → Git Push → GitHub → GitHub Actions → Build → Test → 
Docker Build → Publish GHCR → Pull Local → Deploy → Verificación
```

### 6.2. Rol de GitHub Actions
[Explicar específicamente qué hace GitHub Actions en este flujo]

### 6.3. Despliegue Continuo Local
[Explicar cómo se realiza el CD en el entorno local]

### 6.4. Ventajas observadas
[Listar las ventajas identificadas durante la práctica]

1. **Automatización:** [Explicar]
2. **Detección temprana de errores:** [Explicar]
3. **Consistencia:** [Explicar]
4. **Velocidad:** [Explicar]

---

## 7. RESULTADOS OBTENIDOS

### 7.1. API funcional
✓ API REST implementada con 3 endpoints principales
✓ Documentación automática con Swagger
✓ Endpoints respondiendo correctamente

### 7.2. Dockerización exitosa
✓ Dockerfile configurado con multi-stage build
✓ Imagen Docker creada exitosamente
✓ Contenedor ejecutándose sin errores

### 7.3. Pipeline CI implementado
✓ Workflow de GitHub Actions configurado
✓ Compilación automática en cada push
✓ Tests ejecutándose automáticamente
✓ Imagen publicada en GHCR automáticamente

### 7.4. Despliegue CD local
✓ Descarga de imagen desde GHCR
✓ Despliegue local con Docker Compose
✓ Endpoints accesibles en localhost:8080

### 7.5. Ciclo CI/CD validado
✓ Cambio de código realizado
✓ Pipeline activado automáticamente
✓ Nueva imagen generada
✓ Cambio reflejado en el despliegue local

### 7.6. Tabla resumen de pruebas

| Endpoint | Método | URL | Estado | Respuesta Esperada |
|----------|--------|-----|--------|--------------------|
| Health | GET | /health | ✓ 200 | "OK" |
| Ping | GET | /api/v1/ping | ✓ 200 | JSON con ok y timestamp |
| Version | GET | /version | ✓ 200 | JSON con service, env, build |
| Swagger | GET | /swagger | ✓ 200 | Interfaz de documentación |

---

## 8. CONCLUSIONES

1. [Conclusión propia 1: Relacionada con la importancia de CI/CD]

2. [Conclusión propia 2: Relacionada con la experiencia práctica]

3. La implementación de un flujo CI/CD permite automatizar procesos repetitivos y reducir significativamente la probabilidad de errores humanos en el despliegue de aplicaciones.

4. GitHub Actions proporciona una plataforma robusta y fácil de configurar para implementar pipelines de CI/CD sin necesidad de infraestructura adicional.

5. Docker facilita la portabilidad y consistencia de las aplicaciones entre diferentes entornos, desde desarrollo hasta producción.

---

## 9. RECOMENDACIONES

1. [Recomendación propia 1: Relacionada con mejoras al flujo]

2. [Recomendación propia 2: Relacionada con buenas prácticas]

3. Implementar tests unitarios más exhaustivos para aumentar la confianza en el proceso de CI/CD.

4. Considerar la implementación de stages adicionales en el pipeline, como análisis de código estático y escaneo de vulnerabilidades.

5. Evaluar la posibilidad de implementar CD en un servidor real (VPS) para un flujo completamente automatizado.

---

## 10. BIBLIOGRAFÍA

1. Microsoft. (2024). *ASP.NET Core documentation*. https://docs.microsoft.com/aspnet/core/
2. GitHub. (2024). *GitHub Actions documentation*. https://docs.github.com/actions
3. Docker. (2024). *Docker documentation*. https://docs.docker.com/
4. Fowler, M. (2006). *Continuous Integration*. https://martinfowler.com/articles/continuousIntegration.html
5. Humble, J., & Farley, D. (2010). *Continuous Delivery: Reliable Software Releases through Build, Test, and Deployment Automation*. Addison-Wesley.

---

## 11. ANEXOS

### Anexo A: Código fuente completo
[Incluir archivos principales: Program.cs, Dockerfile, docker-compose.yml, ci-cd.yml]

### Anexo B: Capturas de pantalla adicionales
[Incluir capturas adicionales que complementen el informe]

### Anexo C: Logs y salidas de consola
[Incluir logs relevantes del proceso]

### Anexo D: Enlace al repositorio
**Repositorio GitHub:** [https://github.com/USUARIO/demo-cicd-api](https://github.com/USUARIO/demo-cicd-api)

---

**Fecha de entrega:** [Fecha]  
**Firma de los integrantes:**

[Espacio para firmas]
