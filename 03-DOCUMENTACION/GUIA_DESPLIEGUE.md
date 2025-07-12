# 🚀 Guía de Despliegue - Pinturas Bambi

## 📋 Índice
1. [Preparación del Entorno](#preparación-del-entorno)
2. [Despliegue Web](#despliegue-web)
3. [Despliegue App React Native](#despliegue-app-react-native)
4. [Despliegue App iOS](#despliegue-app-ios)
5. [Configuración de Dominios](#configuración-de-dominios)
6. [Monitoreo y Mantenimiento](#monitoreo-y-mantenimiento)

## 🛠️ Preparación del Entorno

### Requisitos Previos
- [ ] Cuenta de hosting web (recomendado: Hostinger, SiteGround, o AWS)
- [ ] Dominio registrado (pinturasbambi.com.py)
- [ ] Certificado SSL
- [ ] Cuenta Google Analytics
- [ ] Cuenta Facebook Business (para Pixel)
- [ ] Cuenta WhatsApp Business

### Herramientas Necesarias
- [ ] FTP/SFTP client (FileZilla, WinSCP)
- [ ] Git
- [ ] Node.js y npm
- [ ] Xcode (para iOS)
- [ ] Android Studio (para Android)

## 🌐 Despliegue Web

### Opción 1: Hosting Tradicional

#### Paso 1: Preparar archivos
```bash
# Crear carpeta de producción
mkdir pinturas-bambi-web
cd pinturas-bambi-web

# Copiar archivos necesarios
cp web/index-definitivo.html index.html
cp web/styles-definitivo.css styles.css
cp web/script-definitivo.js script.js
```

#### Paso 2: Optimizar recursos
```bash
# Minificar CSS
npx clean-css-cli styles.css -o styles.min.css

# Minificar JavaScript
npx terser script.js -o script.min.js

# Optimizar imágenes
npx imagemin images/*.{jpg,png} --out-dir=images/optimized
```

#### Paso 3: Configurar hosting
1. Subir archivos vía FTP/SFTP
2. Configurar dominio principal
3. Activar SSL/HTTPS
4. Configurar redirects
5. Habilitar compresión GZIP

### Opción 2: Netlify/Vercel (Recomendado)

#### Netlify
```bash
# Instalar Netlify CLI
npm install -g netlify-cli

# Hacer deploy
netlify deploy --prod --dir=web
```

#### Vercel
```bash
# Instalar Vercel CLI
npm install -g vercel

# Hacer deploy
vercel --prod web/
```

### Configuración DNS
```
# Registros DNS necesarios
A     @           IP_DEL_SERVIDOR
A     www         IP_DEL_SERVIDOR
CNAME blog        pinturasbambi.com.py
CNAME tienda      pinturasbambi.com.py
```

## 📱 Despliegue App React Native

### Preparación del Proyecto
```bash
cd PinturasBambiApp

# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env
# Editar .env con las configuraciones reales
```

### Android

#### Paso 1: Configurar signing
```bash
# Generar keystore
keytool -genkey -v -keystore my-release-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000
```

#### Paso 2: Configurar gradle
```gradle
// android/app/build.gradle
android {
    signingConfigs {
        release {
            storeFile file('my-release-key.keystore')
            storePassword 'PASSWORD'
            keyAlias 'my-key-alias'
            keyPassword 'PASSWORD'
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

#### Paso 3: Generar APK
```bash
cd android
./gradlew assembleRelease
```

### iOS

#### Paso 1: Configurar certificados
1. Abrir Xcode
2. Configurar Team ID
3. Configurar Bundle Identifier
4. Configurar Certificates y Provisioning Profiles

#### Paso 2: Build para App Store
```bash
# Limpiar proyecto
npx react-native run-ios --configuration Release

# Abrir en Xcode para archive
open ios/PinturasBambi.xcworkspace
```

## 🍎 Despliegue App iOS

### Preparación en Xcode
```bash
cd PinturasBambiApp-iOS

# Abrir proyecto
open PinturasBambi.xcodeproj
```

### Configuración del Proyecto
1. **Target Settings**
   - Bundle Identifier: `com.pinturasbambi.app`
   - Version: `1.0.0`
   - Build: `1`

2. **Signing & Capabilities**
   - Team: Seleccionar Apple Developer Team
   - Provisioning Profile: Automatic

3. **Info.plist**
   - Configurar permisos de cámara
   - Configurar esquemas de URL
   - Configurar notificaciones

### Build y Archive
```bash
# Limpiar build
Product -> Clean Build Folder

# Archive
Product -> Archive

# Subir a App Store Connect
Window -> Organizer -> Upload to App Store
```

## 🌍 Configuración de Dominios

### Dominio Principal
- **Producción**: `https://pinturasbambi.com.py`
- **Staging**: `https://staging.pinturasbambi.com.py`
- **Panel Admin**: `https://admin.pinturasbambi.com.py`

### Subdominios
```
www.pinturasbambi.com.py     -> Sitio principal
tienda.pinturasbambi.com.py  -> E-commerce
blog.pinturasbambi.com.py    -> Blog corporativo
api.pinturasbambi.com.py     -> API backend
```

## 📊 Configuración de Analytics

### Google Analytics 4
```javascript
// Código de tracking
gtag('config', 'G-XXXXXXXXXX', {
  page_title: 'Pinturas Bambi',
  page_location: window.location.href
});
```

### Facebook Pixel
```javascript
// Pixel de Facebook
fbq('init', 'XXXXXXXXXX');
fbq('track', 'PageView');
```

### Eventos Personalizados
```javascript
// Eventos importantes
gtag('event', 'calculadora_uso', {
  event_category: 'tools',
  event_label: 'calculadora_pinturas'
});

gtag('event', 'cotizacion_enviada', {
  event_category: 'conversion',
  event_label: 'formulario_cotizacion'
});
```

## 🔒 Configuración de Seguridad

### SSL/HTTPS
```nginx
# Configuración Nginx
server {
    listen 443 ssl;
    server_name pinturasbambi.com.py;
    
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/private.key;
    
    # Configuración SSL moderna
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384;
}
```

### Headers de Seguridad
```apache
# .htaccess
Header always set X-Frame-Options "DENY"
Header always set X-Content-Type-Options "nosniff"
Header always set X-XSS-Protection "1; mode=block"
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
```

## 📈 Monitoreo y Mantenimiento

### Herramientas de Monitoreo
- **Uptime**: UptimeRobot, Pingdom
- **Performance**: GTmetrix, PageSpeed Insights
- **Errores**: Sentry, LogRocket
- **Analytics**: Google Analytics, Hotjar

### Rutinas de Mantenimiento
```bash
# Script de backup diario
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
tar -czf backup_$DATE.tar.gz web/
aws s3 cp backup_$DATE.tar.gz s3://pinturas-bambi-backups/
```

### Actualizaciones Programadas
- **Semanal**: Revisión de seguridad
- **Mensual**: Actualización de contenido
- **Trimestral**: Optimización de performance
- **Anual**: Renovación de certificados

## 📞 Soporte Post-Despliegue

### Contactos de Emergencia
- **Desarrollador**: [email/teléfono]
- **Hosting**: [soporte hosting]
- **Dominio**: [registrar dominio]

### Documentación de Soporte
- Manual de usuario
- Guía de administración
- FAQ técnico
- Procedimientos de emergencia

## ✅ Checklist de Despliegue

### Pre-Despliegue
- [ ] Pruebas en staging completadas
- [ ] Backup de datos actual
- [ ] Certificados SSL válidos
- [ ] DNS configurado
- [ ] Analytics configurado

### Durante el Despliegue
- [ ] Archivos subidos correctamente
- [ ] Base de datos migrada
- [ ] Configuraciones aplicadas
- [ ] Pruebas de funcionalidad
- [ ] Performance verificada

### Post-Despliegue
- [ ] Monitoreo activo
- [ ] Usuarios notificados
- [ ] Documentación actualizada
- [ ] Backup post-despliegue
- [ ] Métricas registradas

---

**🎨 Pinturas Bambi - Guía de Despliegue**
*Asegurando una implementación exitosa y profesional*
