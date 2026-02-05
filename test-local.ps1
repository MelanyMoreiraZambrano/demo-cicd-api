# Prueba local de la API (sin Docker)
# Este script te permite probar la API localmente antes de hacer commit

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Prueba Local - Demo.CICD.Api" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Cambiar al directorio de la API
Set-Location -Path "Demo.CICD.Api"

Write-Host "1. Compilando proyecto..." -ForegroundColor Yellow
dotnet build
if ($LASTEXITCODE -ne 0) {
    Write-Host "   [ERROR] La compilación falló" -ForegroundColor Red
    exit 1
}
Write-Host "   [OK] Compilación exitosa" -ForegroundColor Green
Write-Host ""

Write-Host "2. Ejecutando tests..." -ForegroundColor Yellow
dotnet test
if ($LASTEXITCODE -ne 0) {
    Write-Host "   [ERROR] Los tests fallaron" -ForegroundColor Red
    exit 1
}
Write-Host "   [OK] Tests pasaron" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Todo listo para hacer commit" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Siguiente paso - Subir a GitHub:" -ForegroundColor Yellow
Write-Host "  git add ." -ForegroundColor Gray
Write-Host "  git commit -m 'tu mensaje'" -ForegroundColor Gray
Write-Host "  git push" -ForegroundColor Gray
Write-Host ""

Write-Host "¿Quieres ejecutar la API localmente? (S/N)" -ForegroundColor Yellow
$respuesta = Read-Host

if ($respuesta -eq "S" -or $respuesta -eq "s") {
    Write-Host ""
    Write-Host "Iniciando API..." -ForegroundColor Yellow
    Write-Host "Presiona Ctrl+C para detener" -ForegroundColor Gray
    Write-Host ""
    Write-Host "La API estará disponible en:" -ForegroundColor Yellow
    Write-Host "  - http://localhost:5000/health" -ForegroundColor White
    Write-Host "  - http://localhost:5000/api/v1/ping" -ForegroundColor White
    Write-Host "  - http://localhost:5000/version" -ForegroundColor White
    Write-Host "  - http://localhost:5000/swagger" -ForegroundColor White
    Write-Host ""
    Start-Sleep -Seconds 2
    dotnet run
}

Set-Location -Path ".."
