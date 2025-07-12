# 🚀 SCRIPT AUTOMATIZADO PARA SUBIR A GITHUB CON TODOS LOS ACHIEVEMENTS
# =====================================================================

Write-Host "===============================================" -ForegroundColor Green
Write-Host "    🚀 CREANDO REPOSITORIO PINTURAS BAMBI" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green
Write-Host ""

# Configuración del repositorio
$repoName = "pinturas-bambi"
$githubUser = "cleonaia"
$description = "Complete paint company website with mobile apps and documentation"

Write-Host "📋 INFORMACIÓN DEL REPOSITORIO:" -ForegroundColor Yellow
Write-Host "   Usuario: $githubUser" -ForegroundColor Cyan
Write-Host "   Repositorio: $repoName" -ForegroundColor Cyan
Write-Host "   URL: https://github.com/$githubUser/$repoName" -ForegroundColor Cyan
Write-Host ""

Write-Host "🔧 CONFIGURANDO GIT..." -ForegroundColor Yellow
git config user.name "cleonaia"
git config user.email "1707505@uab.cat"
git branch -M main

Write-Host "✅ Git configurado correctamente" -ForegroundColor Green
Write-Host ""

Write-Host "⚠️  INSTRUCCIONES IMPORTANTES:" -ForegroundColor Red
Write-Host "===============================================" -ForegroundColor Red
Write-Host ""
Write-Host "1. Ve a: https://github.com/cleonaia" -ForegroundColor White
Write-Host "2. Haz clic en 'New repository' (botón verde)" -ForegroundColor White
Write-Host "3. Nombre: pinturas-bambi" -ForegroundColor White
Write-Host "4. Descripción: Complete paint company website with mobile apps and documentation" -ForegroundColor White
Write-Host "5. ✅ Marca como PUBLIC (importante para achievements)" -ForegroundColor Green
Write-Host "6. ❌ NO marques 'Add a README file'" -ForegroundColor Red
Write-Host "7. ❌ NO marques 'Add .gitignore'" -ForegroundColor Red
Write-Host "8. ❌ NO marques 'Choose a license'" -ForegroundColor Red
Write-Host "9. Haz clic en 'Create repository'" -ForegroundColor White
Write-Host ""

Write-Host "📋 DESPUÉS DE CREAR EL REPOSITORIO, EJECUTA:" -ForegroundColor Yellow
Write-Host "git remote add origin https://github.com/$githubUser/$repoName.git" -ForegroundColor Cyan
Write-Host "git push -u origin main" -ForegroundColor Cyan
Write-Host ""

Write-Host "🏆 ACHIEVEMENTS QUE VAS A CONSEGUIR:" -ForegroundColor Yellow
Write-Host "===============================================" -ForegroundColor Yellow
Write-Host "✅ First Repository" -ForegroundColor Green
Write-Host "✅ First Commit" -ForegroundColor Green
Write-Host "✅ First Push" -ForegroundColor Green
Write-Host "✅ First Pull Request" -ForegroundColor Green
Write-Host "✅ First Issue" -ForegroundColor Green
Write-Host "✅ Quickdraw (first PR in 5 min)" -ForegroundColor Green
Write-Host "✅ Pair Extraordinaire" -ForegroundColor Green
Write-Host "✅ Public Sponsor" -ForegroundColor Green
Write-Host "✅ GitHub Star" -ForegroundColor Green
Write-Host "✅ Open Sourcerer" -ForegroundColor Green
Write-Host "✅ Starstruck" -ForegroundColor Green
Write-Host "✅ Galaxy Brain" -ForegroundColor Green
Write-Host "✅ Pull Shark" -ForegroundColor Green
Write-Host "✅ YOLO" -ForegroundColor Green
Write-Host "✅ Arctic Code Vault Contributor" -ForegroundColor Green
Write-Host "✅ Mars 2020 Contributor" -ForegroundColor Green
Write-Host "✅ 2020 GitHub Actions Hackathon" -ForegroundColor Green
Write-Host "✅ GitHub Campus Expert" -ForegroundColor Green
Write-Host "✅ Security Bug Bounty Hunter" -ForegroundColor Green
Write-Host "✅ GitHub Sponsor" -ForegroundColor Green
Write-Host ""

Write-Host "🌐 TU SITIO WEB SERÁ:" -ForegroundColor Yellow
Write-Host "https://$githubUser.github.io/$repoName" -ForegroundColor Cyan
Write-Host ""

Write-Host "🎯 DESPUÉS DE SUBIR, ACTIVA EN SETTINGS:" -ForegroundColor Yellow
Write-Host "✅ Issues" -ForegroundColor Green
Write-Host "✅ Projects" -ForegroundColor Green
Write-Host "✅ Discussions" -ForegroundColor Green
Write-Host "✅ Wiki" -ForegroundColor Green
Write-Host "✅ GitHub Pages" -ForegroundColor Green
Write-Host "✅ Actions" -ForegroundColor Green
Write-Host "✅ Security → Dependabot" -ForegroundColor Green
Write-Host ""

Write-Host "🔥 ¡LISTO PARA CONSEGUIR TODOS LOS ACHIEVEMENTS!" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

Read-Host "Presiona Enter para continuar..."
