# 🔧 Manual de Mantenimiento y Soporte - Pinturas Bambi

## 📋 Índice
1. [Mantenimiento Preventivo](#mantenimiento-preventivo)
2. [Resolución de Problemas](#resolución-de-problemas)
3. [Actualizaciones y Mejoras](#actualizaciones-y-mejoras)
4. [Backup y Restauración](#backup-y-restauración)
5. [Monitoreo y Alertas](#monitoreo-y-alertas)
6. [Documentación Técnica](#documentación-técnica)

## 🛠️ Mantenimiento Preventivo

### Rutina Diaria
```bash
# Script de verificación diaria
#!/bin/bash
echo "=== Verificación Diaria - $(date) ==="

# Verificar disponibilidad del sitio
curl -s -o /dev/null -w "%{http_code}" https://pinturasbambi.com.py
if [ $? -eq 200 ]; then
    echo "✅ Sitio web disponible"
else
    echo "❌ Sitio web no disponible - ALERTA"
fi

# Verificar espacio en disco
df -h | grep -E "/$|/var/www"

# Verificar logs de error
tail -n 50 /var/log/nginx/error.log | grep -E "(ERROR|CRITICAL)"

# Verificar certificado SSL
openssl x509 -in /path/to/cert.pem -text -noout | grep "Not After"
```

### Rutina Semanal
- [ ] Revisar métricas de Google Analytics
- [ ] Verificar formularios de contacto
- [ ] Probar calculadora de pinturas
- [ ] Revisar enlaces rotos
- [ ] Verificar velocidad de carga
- [ ] Actualizar contenido si es necesario

### Rutina Mensual
- [ ] Backup completo del sitio
- [ ] Actualizar dependencias de seguridad
- [ ] Revisar y optimizar imágenes
- [ ] Análisis de performance
- [ ] Revisión de logs de seguridad
- [ ] Actualizar información de productos

### Rutina Trimestral
- [ ] Auditoría completa de seguridad
- [ ] Optimización de base de datos
- [ ] Revisión de UX/UI
- [ ] Actualización de tecnologías
- [ ] Planificación de mejoras

## 🚨 Resolución de Problemas

### Problemas Comunes

#### 1. Sitio web no carga
```bash
# Diagnóstico
ping pinturasbambi.com.py
nslookup pinturasbambi.com.py
curl -I https://pinturasbambi.com.py

# Soluciones
# 1. Verificar servidor web
systemctl status nginx
# 2. Revisar configuración DNS
# 3. Verificar certificado SSL
# 4. Revisar logs de error
```

#### 2. Formularios no funcionan
```javascript
// Verificar en consola del navegador
console.log('Formulario test');

// Verificar envío
fetch('/contact', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({test: 'data'})
})
.then(response => console.log(response.status))
.catch(error => console.error('Error:', error));
```

#### 3. Calculadora de pinturas no funciona
```javascript
// Verificar función de cálculo
function testCalculator() {
    const area = 100;
    const coats = 2;
    const coverage = 10;
    
    const result = (area * coats) / coverage;
    console.log('Resultado esperado:', result);
    
    // Llamar función real
    const actualResult = calculatePaint(area, coats, coverage);
    console.log('Resultado actual:', actualResult);
}
```

#### 4. Problemas de performance
```bash
# Verificar recursos
du -sh /var/www/html/*
find /var/www/html -name "*.jpg" -size +1M
find /var/www/html -name "*.png" -size +1M

# Optimizar imágenes
mogrify -resize 1920x1080> -quality 85 *.jpg
```

### Códigos de Error Comunes

#### Error 404 - Página no encontrada
```nginx
# Configurar redirects en nginx
location / {
    try_files $uri $uri/ /index.html;
}

# Página 404 personalizada
error_page 404 /404.html;
```

#### Error 500 - Error interno del servidor
```bash
# Revisar logs
tail -f /var/log/nginx/error.log
tail -f /var/log/php/error.log

# Verificar permisos
chmod 755 /var/www/html
chown -R www-data:www-data /var/www/html
```

#### Error SSL/HTTPS
```bash
# Verificar certificado
openssl x509 -in cert.pem -text -noout
openssl verify -CAfile ca-bundle.crt cert.pem

# Renovar certificado (Let's Encrypt)
certbot renew --dry-run
```

## 🔄 Actualizaciones y Mejoras

### Proceso de Actualización
1. **Preparación**
   ```bash
   # Crear backup
   tar -czf backup_$(date +%Y%m%d).tar.gz /var/www/html
   
   # Ambiente de staging
   rsync -av /var/www/html/ /var/www/staging/
   ```

2. **Implementación**
   ```bash
   # Aplicar cambios en staging
   # Probar funcionalidad
   # Aplicar a producción
   ```

3. **Verificación**
   ```bash
   # Verificar sitio
   curl -s https://pinturasbambi.com.py | grep -o "<title>.*</title>"
   
   # Verificar funcionalidades críticas
   # Revisar métricas
   ```

### Mejoras Sugeridas

#### Corto Plazo (1-3 meses)
- [ ] Implementar chat en vivo
- [ ] Agregar más productos al catálogo
- [ ] Optimizar para Core Web Vitals
- [ ] Implementar lazy loading
- [ ] Agregar testimonios de clientes

#### Mediano Plazo (3-6 meses)
- [ ] Desarrollar tienda en línea
- [ ] Implementar sistema de citas
- [ ] Agregar blog corporativo
- [ ] Integrar CRM
- [ ] Implementar notificaciones push

#### Largo Plazo (6-12 meses)
- [ ] App móvil completa
- [ ] Realidad aumentada para colores
- [ ] Sistema de fidelidad
- [ ] Integración con ERP
- [ ] Marketplace de productos

## 💾 Backup y Restauración

### Estrategia de Backup

#### Backup Automático Diario
```bash
#!/bin/bash
# backup-daily.sh
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups/daily"
SITE_DIR="/var/www/html"

# Crear directorio si no existe
mkdir -p $BACKUP_DIR

# Backup de archivos
tar -czf $BACKUP_DIR/files_$DATE.tar.gz $SITE_DIR

# Backup de base de datos (si aplica)
# mysqldump -u user -p database > $BACKUP_DIR/db_$DATE.sql

# Subir a la nube
aws s3 cp $BACKUP_DIR/files_$DATE.tar.gz s3://pinturas-bambi-backups/daily/

# Limpiar backups antiguos (mantener 7 días)
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup completado: $DATE"
```

#### Configurar Cron Job
```bash
# Editar crontab
crontab -e

# Agregar backup diario a las 2 AM
0 2 * * * /home/scripts/backup-daily.sh >> /var/log/backup.log 2>&1

# Backup semanal los domingos a las 3 AM
0 3 * * 0 /home/scripts/backup-weekly.sh >> /var/log/backup.log 2>&1
```

### Proceso de Restauración
```bash
# Restaurar desde backup
cd /var/www
tar -xzf /backups/files_20241201_020000.tar.gz
chown -R www-data:www-data html/
chmod -R 755 html/

# Verificar restauración
curl -s https://pinturasbambi.com.py | head -10
```

## 📊 Monitoreo y Alertas

### Herramientas de Monitoreo

#### UptimeRobot
```javascript
// Configurar webhook para Slack/Discord
{
  "text": "🚨 ALERTA: Sitio web de Pinturas Bambi no responde",
  "username": "UptimeRobot",
  "icon_emoji": ":warning:"
}
```

#### Google Analytics
```javascript
// Configurar alertas personalizadas
ga('create', 'UA-XXXXXXXXX-1', 'auto');
ga('send', 'pageview');

// Eventos críticos
ga('send', 'event', 'Error', '404', document.location.pathname);
ga('send', 'event', 'Form', 'Submit', 'Contact');
```

#### Logs Personalizados
```javascript
// Logger personalizado
class Logger {
    static log(level, message, data = {}) {
        const timestamp = new Date().toISOString();
        const logEntry = {
            timestamp,
            level,
            message,
            data,
            url: window.location.href,
            userAgent: navigator.userAgent
        };
        
        // Enviar a servidor de logs
        if (level === 'error') {
            fetch('/api/logs', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(logEntry)
            });
        }
    }
}

// Uso
Logger.log('info', 'Calculadora utilizada', {area: 100, coats: 2});
Logger.log('error', 'Formulario falló', {form: 'contact', error: 'validation'});
```

## 📚 Documentación Técnica

### Estructura del Proyecto
```
pinturas-bambi/
├── web/
│   ├── index-definitivo.html    # Sitio corporativo
│   ├── index-increible.html     # Sitio avanzado
│   ├── styles-definitivo.css    # Estilos corporativos
│   ├── styles-increible.css     # Estilos avanzados
│   └── scripts/
│       ├── script-definitivo.js
│       └── script-increible-avanzado.js
├── apps/
│   ├── PinturasBambiApp/        # React Native
│   └── PinturasBambiApp-iOS/    # iOS nativo
├── docs/
│   ├── PROYECTO_FINAL.md
│   ├── GUIA_DESPLIEGUE.md
│   └── MANUAL_MANTENIMIENTO.md
└── scripts/
    ├── backup-daily.sh
    ├── monitor.sh
    └── deploy.sh
```

### APIs y Servicios
```javascript
// Endpoints principales
const API_ENDPOINTS = {
    contact: '/api/contact',
    quote: '/api/quote',
    calculator: '/api/calculator',
    products: '/api/products',
    colors: '/api/colors'
};

// Configuración de servicios
const SERVICES = {
    whatsapp: {
        number: '+595XXXXXXXXX',
        message: 'Hola, me interesa información sobre pinturas'
    },
    email: {
        contact: 'contacto@pinturasbambi.com.py',
        sales: 'ventas@pinturasbambi.com.py'
    },
    maps: {
        location: 'Asunción, Paraguay',
        coords: [-25.2637, -57.5759]
    }
};
```

### Configuraciones Importantes
```javascript
// Configuración de producción
const CONFIG = {
    environment: 'production',
    debug: false,
    analytics: {
        google: 'G-XXXXXXXXXX',
        facebook: 'XXXXXXXXXX'
    },
    features: {
        calculator: true,
        colorMatcher: true,
        whatsapp: true,
        forms: true
    }
};
```

## 📞 Contacto de Soporte

### Equipo de Soporte
- **Desarrollador Principal**: [email/teléfono]
- **Administrador de Sistemas**: [email/teléfono]
- **Soporte Técnico**: [email/teléfono]

### Horarios de Soporte
- **Lunes a Viernes**: 8:00 AM - 6:00 PM
- **Sábados**: 9:00 AM - 1:00 PM
- **Emergencias**: 24/7 (solo para problemas críticos)

### Procedimiento de Escalación
1. **Nivel 1**: Problemas menores - Resolver en 2 horas
2. **Nivel 2**: Problemas moderados - Resolver en 4 horas
3. **Nivel 3**: Problemas críticos - Resolver en 1 hora
4. **Nivel 4**: Emergencias - Resolver inmediatamente

---

**🎨 Pinturas Bambi - Manual de Mantenimiento**
*Manteniendo la excelencia técnica y la satisfacción del cliente*
