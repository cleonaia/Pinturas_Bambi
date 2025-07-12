Write-Host "🚀 SUBIENDO PINTURAS BAMBI A GITHUB..." -ForegroundColor Green
Write-Host ""

# Agregar remote de GitHub
Write-Host "📋 Agregando remote de GitHub..." -ForegroundColor Yellow
git remote add origin https://github.com/cleonaia/pinturas-bambi.git

# Subir al repositorio
Write-Host "📋 Subiendo archivos a GitHub..." -ForegroundColor Yellow
git push -u origin main

Write-Host ""
Write-Host "🎉 ¡COMPLETADO! Tu repositorio está en:" -ForegroundColor Green
Write-Host "https://github.com/cleonaia/pinturas-bambi" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 Tu sitio web será:" -ForegroundColor Green
Write-Host "https://cleonaia.github.io/pinturas-bambi" -ForegroundColor Cyan
Write-Host ""
Write-Host "🏆 Ahora ve a Settings del repositorio y activa GitHub Pages" -ForegroundColor Yellow
Write-Host ""
Read-Host "Presiona Enter para continuar"
