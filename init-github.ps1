# Script para inicializar y subir el proyecto a GitHub
# Uso: .\init-github.ps1 -Usuario "tu-usuario" -Repo "demo-cicd-api"

param(
    [Parameter(Mandatory=$true)]
    [string]$Usuario,
    
    [Parameter(Mandatory=$false)]
    [string]$Repo = "demo-cicd-api"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Inicialización de GitHub" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar Git
Write-Host "1. Verificando Git..." -ForegroundColor Yellow
$gitVersion = git --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "   [ERROR] Git no está instalado" -ForegroundColor Red
    Write-Host "   Descarga Git desde: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}
Write-Host "   [OK] $gitVersion" -ForegroundColor Green
Write-Host ""

# Verificar si ya es un repositorio Git
if (Test-Path ".git") {
    Write-Host "2. [WARN] Ya existe un repositorio Git" -ForegroundColor Yellow
    Write-Host "   ¿Quieres reinicializarlo? (S/N)" -ForegroundColor Yellow
    $respuesta = Read-Host
    
    if ($respuesta -eq "S" -or $respuesta -eq "s") {
        Remove-Item -Path ".git" -Recurse -Force
        Write-Host "   [OK] Repositorio eliminado" -ForegroundColor Green
    } else {
        Write-Host "   [INFO] Usando repositorio existente" -ForegroundColor Cyan
    }
    Write-Host ""
}

# Inicializar Git
if (-not (Test-Path ".git")) {
    Write-Host "2. Inicializando repositorio Git..." -ForegroundColor Yellow
    git init
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   [ERROR] No se pudo inicializar el repositorio" -ForegroundColor Red
        exit 1
    }
    Write-Host "   [OK] Repositorio inicializado" -ForegroundColor Green
    Write-Host ""
}

# Configurar usuario Git (si no está configurado)
Write-Host "3. Verificando configuración de Git..." -ForegroundColor Yellow
$gitUserName = git config --global user.name 2>$null
$gitUserEmail = git config --global user.email 2>$null

if ([string]::IsNullOrWhiteSpace($gitUserName) -or [string]::IsNullOrWhiteSpace($gitUserEmail)) {
    Write-Host "   [WARN] Configuración de Git incompleta" -ForegroundColor Yellow
    Write-Host ""
    
    if ([string]::IsNullOrWhiteSpace($gitUserName)) {
        $nombre = Read-Host "   Ingresa tu nombre completo"
        git config --global user.name "$nombre"
    }
    
    if ([string]::IsNullOrWhiteSpace($gitUserEmail)) {
        $email = Read-Host "   Ingresa tu email"
        git config --global user.email "$email"
    }
    
    Write-Host "   [OK] Configuración de Git completada" -ForegroundColor Green
} else {
    Write-Host "   [OK] Usuario: $gitUserName ($gitUserEmail)" -ForegroundColor Green
}
Write-Host ""

# Actualizar docker-compose.yml con el usuario
Write-Host "4. Actualizando docker-compose.yml..." -ForegroundColor Yellow
$composeContent = Get-Content "docker-compose.yml" -Raw
$composeContent = $composeContent -replace "USUARIO_GH", $Usuario
$composeContent | Set-Content "docker-compose.yml"
Write-Host "   [OK] Usuario actualizado: $Usuario" -ForegroundColor Green
Write-Host ""

# Agregar archivos
Write-Host "5. Agregando archivos al repositorio..." -ForegroundColor Yellow
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Host "   [ERROR] No se pudieron agregar los archivos" -ForegroundColor Red
    exit 1
}
Write-Host "   [OK] Archivos agregados" -ForegroundColor Green
Write-Host ""

# Verificar archivos agregados
Write-Host "6. Archivos que se subirán:" -ForegroundColor Yellow
git status --short
Write-Host ""

# Hacer commit
Write-Host "7. Creando commit inicial..." -ForegroundColor Yellow
git commit -m "init: Configuración inicial del proyecto CI/CD - Lab 6"
if ($LASTEXITCODE -ne 0) {
    Write-Host "   [ERROR] No se pudo crear el commit" -ForegroundColor Red
    exit 1
}
Write-Host "   [OK] Commit creado" -ForegroundColor Green
Write-Host ""

# Cambiar a rama main
Write-Host "8. Cambiando a rama main..." -ForegroundColor Yellow
git branch -M main
Write-Host "   [OK] Rama main configurada" -ForegroundColor Green
Write-Host ""

# Configurar remote
$repoUrl = "https://github.com/$Usuario/$Repo.git"
Write-Host "9. Configurando repositorio remoto..." -ForegroundColor Yellow
Write-Host "   URL: $repoUrl" -ForegroundColor Gray

# Verificar si ya existe un remote
$existingRemote = git remote get-url origin 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   [WARN] Ya existe un remote configurado: $existingRemote" -ForegroundColor Yellow
    Write-Host "   Eliminando remote anterior..." -ForegroundColor Yellow
    git remote remove origin
}

git remote add origin $repoUrl
if ($LASTEXITCODE -ne 0) {
    Write-Host "   [ERROR] No se pudo configurar el repositorio remoto" -ForegroundColor Red
    exit 1
}
Write-Host "   [OK] Repositorio remoto configurado" -ForegroundColor Green
Write-Host ""

# Información para el usuario
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Configuración Completada" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "IMPORTANTE: Antes de continuar" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Crea el repositorio en GitHub:" -ForegroundColor White
Write-Host "   - Ve a: https://github.com/new" -ForegroundColor Gray
Write-Host "   - Nombre: $Repo" -ForegroundColor Gray
Write-Host "   - Visibilidad: Public" -ForegroundColor Gray
Write-Host "   - NO inicialices con README, .gitignore ni licencia" -ForegroundColor Gray
Write-Host ""

Write-Host "2. Luego ejecuta:" -ForegroundColor White
Write-Host "   git push -u origin main" -ForegroundColor Cyan
Write-Host ""

Write-Host "3. Después de hacer push:" -ForegroundColor White
Write-Host "   - Ve a Settings → Actions → General" -ForegroundColor Gray
Write-Host "   - Workflow permissions → Read and write permissions" -ForegroundColor Gray
Write-Host "   - Save" -ForegroundColor Gray
Write-Host ""

Write-Host "¿Quieres hacer push ahora? (S/N)" -ForegroundColor Yellow
$respuesta = Read-Host

if ($respuesta -eq "S" -or $respuesta -eq "s") {
    Write-Host ""
    Write-Host "Subiendo código a GitHub..." -ForegroundColor Yellow
    Write-Host ""
    
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "   ¡Éxito! Código subido a GitHub" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Siguiente paso:" -ForegroundColor Yellow
        Write-Host "  1. Ve a tu repositorio: https://github.com/$Usuario/$Repo" -ForegroundColor White
        Write-Host "  2. Verifica que el workflow se esté ejecutando en Actions" -ForegroundColor White
        Write-Host "  3. Configura los permisos (Settings → Actions → General)" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "[ERROR] No se pudo subir el código" -ForegroundColor Red
        Write-Host "Verifica que hayas creado el repositorio en GitHub" -ForegroundColor Yellow
        Write-Host "Y que tengas permisos para subir código" -ForegroundColor Yellow
    }
} else {
    Write-Host ""
    Write-Host "Recuerda ejecutar cuando estés listo:" -ForegroundColor Yellow
    Write-Host "  git push -u origin main" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
