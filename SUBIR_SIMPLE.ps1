# Script para subir Pinturas Bambi a GitHub
Write-Host "PINTURAS BAMBI - SUBIR A GITHUB" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Cyan

# Verificar que tenemos el archivo principal
if (!(Test-Path "index.html")) {
    Write-Host "Error: No se encuentra index.html" -ForegroundColor Red
    exit 1
}

Write-Host "Verificando archivos..." -ForegroundColor Green

# Inicializar Git si no existe
if (!(Test-Path ".git")) {
    Write-Host "Inicializando Git..." -ForegroundColor Yellow
    git init
    git branch -M main
}

# Configurar Git
Write-Host "Configurando Git..." -ForegroundColor Yellow
git config user.name "cleonaia"
git config user.email "cleonaia@users.noreply.github.com"

# Agregar todos los archivos
Write-Host "Agregando archivos..." -ForegroundColor Yellow
git add .

# Crear commit
Write-Host "Creando commit..." -ForegroundColor Yellow
git commit -m "Pinturas Bambi - Sitio web completo con apps moviles"

# Verificar remote
Write-Host "Configurando remote..." -ForegroundColor Yellow
git remote remove origin 2>$null
git remote add origin https://github.com/cleonaia/Pinturas_Bambi.git

# Subir a GitHub
Write-Host "Subiendo a GitHub..." -ForegroundColor Yellow
git push -u origin main

Write-Host ""
Write-Host "PROYECTO SUBIDO EXITOSAMENTE!" -ForegroundColor Green
Write-Host "Sitio web: https://cleonaia.github.io/Pinturas_Bambi/" -ForegroundColor Cyan
Write-Host "Todos los achievements desbloqueados!" -ForegroundColor Green
