@echo off
echo ===============================================
echo    🚀 SUBIENDO PINTURAS BAMBI A GITHUB
echo ===============================================
echo.

echo 📋 Paso 1: Configurando Git...
git config user.name "cleonaia"
git config user.email "1707505@uab.cat"

echo.
echo 📋 Paso 2: Agregando archivos...
git add .

echo.
echo 📋 Paso 3: Haciendo commit...
git commit -m "🚀 Complete Pinturas Bambi project with all features and documentation"

echo.
echo 📋 Paso 4: Configurando rama main...
git branch -M main

echo.
echo ===============================================
echo    ⚠️  IMPORTANTE: AHORA DEBES HACER ESTO:
echo ===============================================
echo.
echo 1. Ve a: https://github.com/cleonaia
echo 2. Haz clic en "New repository"
echo 3. Nombre: pinturas-bambi
echo 4. Descripción: "Complete paint company website with mobile apps and documentation"
echo 5. Marca como PUBLIC
echo 6. NO inicialices con README (ya tenemos uno)
echo 7. Haz clic en "Create repository"
echo.
echo Después ejecuta estos comandos:
echo.
echo git remote add origin https://github.com/cleonaia/pinturas-bambi.git
echo git push -u origin main
echo.
echo ===============================================
echo    🏆 PARA ACTIVAR TODAS LAS INSIGNIAS:
echo ===============================================
echo.
echo 1. Ve a Settings del repositorio
echo 2. Activa GitHub Pages (source: GitHub Actions)
echo 3. Activa Issues
echo 4. Activa Discussions
echo 5. Activa Projects
echo 6. Ve a Actions y permite workflows
echo 7. Ve a Security y activa Dependabot
echo.
pause
