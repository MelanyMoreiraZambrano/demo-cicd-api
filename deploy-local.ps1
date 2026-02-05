# Script de despliegue local para Demo.CICD.Api
# Uso: .\deploy-local.ps1 -Usuario "tu-usuario-github"

param(
    [Parameter(Mandatory=$false)]
    [string]$Usuario = "USUARIO_GH"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Despliegue Local - Demo.CICD.Api" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar Docker
Write-Host "1. Verificando Docker..." -ForegroundColor Yellow
$dockerVersion = docker --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "   [ERROR] Docker no está instalado o no está en el PATH" -ForegroundColor Red
    exit 1
}
Write-Host "   [OK] $dockerVersion" -ForegroundColor Green
Write-Host ""

# Verificar Docker Compose
Write-Host "2. Verificando Docker Compose..." -ForegroundColor Yellow
$composeVersion = docker compose version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "   [ERROR] Docker Compose no está disponible" -ForegroundColor Red
    exit 1
}
Write-Host "   [OK] $composeVersion" -ForegroundColor Green
Write-Host ""

# Actualizar docker-compose.yml si se proporcionó usuario
if ($Usuario -ne "USUARIO_GH") {
    Write-Host "3. Actualizando docker-compose.yml con usuario: $Usuario" -ForegroundColor Yellow
    $composeContent = Get-Content "docker-compose.yml" -Raw
    $composeContent = $composeContent -replace "USUARIO_GH", $Usuario
    $composeContent | Set-Content "docker-compose.yml"
    Write-Host "   [OK] docker-compose.yml actualizado" -ForegroundColor Green
    Write-Host ""
}

# Verificar autenticación en GHCR
Write-Host "4. Verificando autenticación en GitHub Container Registry..." -ForegroundColor Yellow
Write-Host "   Si no estás autenticado, ejecuta: docker login ghcr.io" -ForegroundColor Gray
Write-Host ""

# Descargar imagen
Write-Host "5. Descargando última imagen..." -ForegroundColor Yellow
docker compose pull
if ($LASTEXITCODE -ne 0) {
    Write-Host "   [ERROR] No se pudo descargar la imagen" -ForegroundColor Red
    Write-Host "   Asegúrate de estar autenticado: docker login ghcr.io" -ForegroundColor Yellow
    exit 1
}
Write-Host "   [OK] Imagen descargada" -ForegroundColor Green
Write-Host ""

# Desplegar
Write-Host "6. Desplegando contenedor..." -ForegroundColor Yellow
docker compose up -d
if ($LASTEXITCODE -ne 0) {
    Write-Host "   [ERROR] No se pudo desplegar el contenedor" -ForegroundColor Red
    exit 1
}
Write-Host "   [OK] Contenedor desplegado" -ForegroundColor Green
Write-Host ""

# Esperar un momento
Write-Host "7. Esperando que la API inicie..." -ForegroundColor Yellow
Start-Sleep -Seconds 3
Write-Host "   [OK] API lista" -ForegroundColor Green
Write-Host ""

# Verificar estado
Write-Host "8. Estado de contenedores:" -ForegroundColor Yellow
docker compose ps
Write-Host ""

# Endpoints disponibles
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   API Desplegada Exitosamente" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Endpoints disponibles:" -ForegroundColor Yellow
Write-Host "  - Health:   http://localhost:8080/health" -ForegroundColor White
Write-Host "  - Ping:     http://localhost:8080/api/v1/ping" -ForegroundColor White
Write-Host "  - Version:  http://localhost:8080/version" -ForegroundColor White
Write-Host "  - Swagger:  http://localhost:8080/swagger" -ForegroundColor White
Write-Host ""
Write-Host "Comandos útiles:" -ForegroundColor Yellow
Write-Host "  - Ver logs:    docker compose logs -f" -ForegroundColor Gray
Write-Host "  - Detener:     docker compose down" -ForegroundColor Gray
Write-Host "  - Reiniciar:   docker compose restart" -ForegroundColor Gray
Write-Host ""

# Intentar hacer una petición de prueba
Write-Host "9. Probando endpoint /health..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/health" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "   [OK] API respondiendo correctamente: $($response.Content)" -ForegroundColor Green
    }
} catch {
    Write-Host "   [WARN] No se pudo contactar la API aún (puede tardar unos segundos)" -ForegroundColor Yellow
    Write-Host "   Verifica manualmente: http://localhost:8080/health" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
