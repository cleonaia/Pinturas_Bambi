# SCRIPT FINAL PARA SUBIR PINTURAS BAMBI A GITHUB
# Ejecuta este script para subir todo correctamente

Write-Host "🎨 PINTURAS BAMBI - SUBIR PROYECTO FINAL" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan

# Verificar que estamos en la carpeta correcta
if (!(Test-Path "index.html")) {
    Write-Host "❌ Error: No se encuentra index.html en la carpeta actual" -ForegroundColor Red
    Write-Host "Por favor, ejecuta este script desde la carpeta del proyecto" -ForegroundColor Yellow
    exit 1
}

# Verificar que el index.html tiene contenido
$indexContent = Get-Content "index.html" -Raw
if ($indexContent.Length -lt 1000) {
    Write-Host "❌ Error: El archivo index.html parece estar vacío o incompleto" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Archivo index.html verificado correctamente" -ForegroundColor Green

# Inicializar Git (si no está inicializado)
if (!(Test-Path ".git")) {
    Write-Host "🔧 Inicializando repositorio Git..." -ForegroundColor Yellow
    git init
    git branch -M main
}

# Configurar Git si es necesario
Write-Host "🔧 Configurando Git..." -ForegroundColor Yellow
git config user.name "Pinturas Bambi"
git config user.email "info@pinturasbambi.com"

# Agregar archivos principales
Write-Host "📂 Agregando archivos principales..." -ForegroundColor Yellow
git add index.html
git add CNAME
git add _config.yml
git add manifest.json
git add robots.txt
git add sitemap.xml
git add README.md
git add LICENSE

# Agregar carpetas importantes
Write-Host "📁 Agregando carpetas del proyecto..." -ForegroundColor Yellow
git add "01-SITIO-WEB-FINAL/"
git add "02-APPS-MOVILES/"
git add "03-DOCUMENTACION/"
git add "04-HERRAMIENTAS/"
git add "05-CONFIGURACION/"

# Commit
Write-Host "💾 Creando commit..." -ForegroundColor Yellow
git commit -m "🎨 Sitio web completo de Pinturas Bambi - Listo para producción en GitHub Pages"

# Verificar estado
Write-Host "📊 Estado del repositorio:" -ForegroundColor Cyan
git status --porcelain

# Mostrar URL del sitio
Write-Host ""
Write-Host "🌐 SITIO WEB ESTARÁ DISPONIBLE EN:" -ForegroundColor Green
Write-Host "   https://pinturasbambi.github.io" -ForegroundColor Cyan
Write-Host "   https://pinturasbambi.com.py" -ForegroundColor Cyan

Write-Host ""
Write-Host "🎯 SIGUIENTE PASO:" -ForegroundColor Yellow
Write-Host "   git remote add origin https://github.com/pinturasbambi/pinturasbambi.github.io.git" -ForegroundColor White
Write-Host "   git push -u origin main" -ForegroundColor White

Write-Host ""
Write-Host "🏆 PROYECTO LISTO PARA ACHIEVEMENTS!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
