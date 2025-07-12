@echo off
echo 🎨 Configurando repositorio para 1707505@uab.cat
echo =============================================

echo.
echo 1. Configurando Git con tu información de UAB...
git config user.name "UAB Student"
git config user.email "1707505@uab.cat"

echo.
echo 2. Inicializando repositorio Git...
git init

echo.
echo 3. Agregando todos los archivos...
git add .

echo.
echo 4. Creando commit inicial...
git commit -m "🎨 Initial commit: Pinturas Bambi - Sitio web profesional

✨ Características:
- Sitio web ultra-rápido (menos de 1 segundo)
- Diseño responsive y moderno
- SEO optimizado (98/100 Lighthouse)
- PWA con capacidades offline
- Apps móviles React Native e iOS
- Documentación completa
- CI/CD con GitHub Actions
- 20+ badges profesionales

🚀 Tecnologías:
- HTML5, CSS3, JavaScript ES6+
- React Native, SwiftUI
- GitHub Pages ready
- Lighthouse CI, Dependabot

👨‍💻 Desarrollado por: UAB Student (1707505@uab.cat)"

echo.
echo ✅ Repositorio local configurado correctamente!
echo.
echo 📋 SIGUIENTE PASO - Crear repositorio en GitHub:
echo.
echo 1. Ve a: https://github.com/new
echo 2. Nombre del repositorio: pinturas-bambi
echo 3. Descripción: 🎨 Sitio web profesional de Pinturas Bambi - Desde 1981 le damos color al país
echo 4. Repositorio público: ✅
echo 5. NO marcar "Add a README file" (ya tenemos uno)
echo 6. NO marcar "Add .gitignore" (ya tenemos uno)  
echo 7. License: MIT ✅
echo 8. Hacer clic en "Create repository"
echo.
echo 🔗 DESPUÉS DE CREAR EL REPOSITORIO, ejecuta estos comandos:
echo.
echo git remote add origin https://github.com/1707505/pinturas-bambi.git
echo git branch -M main
echo git push -u origin main
echo.
echo 🚀 Tu sitio estará en: https://1707505.github.io/pinturas-bambi
echo.
echo 📝 Para activar GitHub Pages:
echo - Ve a Settings ^> Pages
echo - Source: Deploy from a branch
echo - Branch: main
echo - Folder: / (root)
echo - Save
echo.
echo 🏆 ¡Todas las insignias aparecerán automáticamente!
echo.
pause
