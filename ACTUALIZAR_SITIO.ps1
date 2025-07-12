# Script para forzar actualización del sitio web
Write-Host "ACTUALIZANDO SITIO WEB EN GITHUB" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan

# Verificar archivos
Write-Host "Verificando archivos..." -ForegroundColor Yellow
if (!(Test-Path "index.html")) {
    Write-Host "Error: index.html no encontrado" -ForegroundColor Red
    exit 1
}

$indexSize = (Get-Item "index.html").Length
Write-Host "Tamaño de index.html: $indexSize bytes" -ForegroundColor Green

if ($indexSize -lt 1000) {
    Write-Host "Error: index.html parece estar vacío" -ForegroundColor Red
    exit 1
}

# Forzar actualización
Write-Host "Forzando actualización..." -ForegroundColor Yellow
git add -A
git commit -m "UPDATE: Sitio web completo de Pinturas Bambi - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push origin main --force

Write-Host ""
Write-Host "SITIO WEB ACTUALIZADO!" -ForegroundColor Green
Write-Host "URL: https://cleonaia.github.io/Pinturas_Bambi/" -ForegroundColor Cyan
Write-Host "Espera 2-3 minutos para que GitHub Pages se actualice" -ForegroundColor Yellow
