@echo off
echo 🎨 Pinturas Bambi - Script de Subida a GitHub Pages
echo ================================================

echo.
echo 1. Configurando Git...
git config user.name "UAB Developer"
git config user.email "1707505@uab.cat"

echo.
echo 2. Inicializando repositorio...
git init

echo.
echo 3. Agregando archivos...
git add .

echo.
echo 4. Haciendo commit inicial...
git commit -m "🎨 Initial commit: Pinturas Bambi - Sitio web profesional con apps móviles"

echo.
echo 5. Renombrando README para GitHub...
if exist README_GITHUB.md (
    move README_GITHUB.md README.md
    git add README.md
    git commit -m "📝 Update README with badges and documentation"
)

echo.
echo ✅ Repositorio local configurado correctamente!
echo.
echo 📋 PRÓXIMOS PASOS:
echo.
echo 1. Crear repositorio en GitHub:
echo    - Ve a https://github.com/new
echo    - Nombre: pinturas-bambi
echo    - Descripción: 🎨 Sitio web profesional de Pinturas Bambi
echo    - Público: ✅
echo    - Crear repositorio
echo.
echo 2. Conectar con GitHub (reemplaza TU-USUARIO):
echo    git remote add origin https://github.com/TU-USUARIO/pinturas-bambi.git
echo    git branch -M main
echo    git push -u origin main
echo.
echo 3. Activar GitHub Pages:
echo    - Settings → Pages → Source: Deploy from branch
echo    - Branch: main, Folder: / (root)
echo    - Save
echo.
echo 4. Tu sitio estará en: https://TU-USUARIO.github.io/pinturas-bambi
echo.
echo 🏆 ¡Todas las insignias están configuradas!
echo.
pause
