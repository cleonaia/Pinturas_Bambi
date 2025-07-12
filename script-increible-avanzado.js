// ============================================================================
// PINTURAS BAMBI - SCRIPT AVANZADO DE INTERACTIVIDAD WEB
// Desarrollado para complementar la app móvil
// © 2024 Inversiones Industriales Paraguayo de Pinturas S.A.C.I.
// ============================================================================

class PinturasBambiWebApp {
    constructor() {
        this.isLoading = false;
        this.currentUser = null;
        this.cart = [];
        this.favorites = [];
        this.calculatorData = {};
        this.colorMatcher = null;
        this.currentLanguage = 'es';
        this.theme = 'light';
        
        this.init();
    }

    // ========================================================================
    // INICIALIZACIÓN Y CONFIGURACIÓN
    // ========================================================================
    init() {
        this.setupEventListeners();
        this.loadUserData();
        this.initializeComponents();
        this.setupIntersectionObserver();
        this.initializeAnimations();
        this.setupColorMatcher();
        this.initializeCalculator();
        this.setupSearchFunctionality();
        this.initializeChat();
        this.setupNotifications();
        
        console.log('🎨 Pinturas Bambi Web App inicializada correctamente');
    }

    setupEventListeners() {
        // Eventos del DOM
        document.addEventListener('DOMContentLoaded', () => {
            this.setupNavigation();
            this.setupForms();
            this.setupModals();
            this.setupCarousel();
            this.setupLazyLoading();
        });

        // Eventos de ventana
        window.addEventListener('scroll', this.handleScroll.bind(this));
        window.addEventListener('resize', this.handleResize.bind(this));
        window.addEventListener('online', this.handleOnline.bind(this));
        window.addEventListener('offline', this.handleOffline.bind(this));
    }

    // ========================================================================
    // NAVEGACIÓN Y INTERFAZ
    // ========================================================================
    setupNavigation() {
        const navbar = document.querySelector('.navbar');
        const mobileMenuBtn = document.querySelector('.mobile-menu-btn');
        const mobileMenu = document.querySelector('.mobile-menu');

        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            if (window.scrollY > 50) {
                navbar?.classList.add('scrolled');
            } else {
                navbar?.classList.remove('scrolled');
            }
        });

        // Mobile menu toggle
        mobileMenuBtn?.addEventListener('click', () => {
            mobileMenu?.classList.toggle('active');
            document.body.classList.toggle('menu-open');
        });

        // Smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    }

    // ========================================================================
    // CALCULADORA INTELIGENTE DE PINTURA
    // ========================================================================
    initializeCalculator() {
        const calculator = document.querySelector('.paint-calculator');
        if (!calculator) return;

        const form = calculator.querySelector('.calculator-form');
        const results = calculator.querySelector('.calculator-results');
        const resetBtn = calculator.querySelector('.calculator-reset');

        form?.addEventListener('submit', (e) => {
            e.preventDefault();
            this.calculatePaint();
        });

        resetBtn?.addEventListener('click', () => {
            this.resetCalculator();
        });

        // Eventos de cambio en tiempo real
        const inputs = form?.querySelectorAll('input, select');
        inputs?.forEach(input => {
            input.addEventListener('input', () => {
                this.updateCalculatorPreview();
            });
        });
    }

    calculatePaint() {
        const formData = new FormData(document.querySelector('.calculator-form'));
        const data = Object.fromEntries(formData);
        
        // Validar datos
        if (!this.validateCalculatorData(data)) {
            this.showNotification('Por favor, completa todos los campos requeridos', 'error');
            return;
        }

        this.showLoader();

        // Simular cálculo complejo
        setTimeout(() => {
            const result = this.performPaintCalculation(data);
            this.displayCalculatorResults(result);
            this.hideLoader();
            
            // Guardar en historial
            this.saveCalculationToHistory(data, result);
        }, 1500);
    }

    performPaintCalculation(data) {
        const width = parseFloat(data.width) || 0;
        const height = parseFloat(data.height) || 0;
        const coats = parseInt(data.coats) || 2;
        const surfaces = parseInt(data.surfaces) || 1;
        const surfaceType = data.surfaceType || 'wall';
        const paintType = data.paintType || 'latex';

        // Cálculos base
        const totalArea = width * height * surfaces;
        const doorArea = (parseInt(data.doors) || 0) * 2.0 * 0.8; // Puertas estándar
        const windowArea = (parseInt(data.windows) || 0) * 1.2 * 1.0; // Ventanas estándar
        const netArea = totalArea - doorArea - windowArea;

        // Factores de rendimiento por tipo
        const coverageFactors = {
            'latex': 12,
            'enamel': 8,
            'primer': 10,
            'waterproof': 5
        };

        const coverage = coverageFactors[paintType] || 10;
        const waste = 0.10; // 10% de desperdicio
        const totalLiters = (netArea * coats / coverage) * (1 + waste);

        // Cálculo de costos
        const pricePerLiter = this.getPaintPrice(paintType);
        const paintCost = totalLiters * pricePerLiter;
        const toolsCost = this.calculateToolsCost(netArea);
        const totalCost = paintCost + toolsCost;

        // Recomendaciones de productos
        const recommendations = this.getProductRecommendations(paintType, totalLiters);

        return {
            area: {
                total: totalArea,
                net: netArea,
                doors: doorArea,
                windows: windowArea
            },
            paint: {
                liters: totalLiters,
                cost: paintCost,
                coats: coats,
                coverage: coverage,
                waste: waste * 100
            },
            tools: {
                cost: toolsCost,
                items: this.getToolsRecommendations(netArea)
            },
            total: {
                cost: totalCost,
                time: this.estimateWorkTime(netArea, coats)
            },
            recommendations: recommendations,
            tips: this.getCalculatorTips(surfaceType, paintType)
        };
    }

    displayCalculatorResults(result) {
        const resultsContainer = document.querySelector('.calculator-results');
        if (!resultsContainer) return;

        const html = `
            <div class="results-summary">
                <div class="result-highlight">
                    <h3>Necesitas aproximadamente:</h3>
                    <div class="main-result">
                        <span class="liters">${result.paint.liters.toFixed(1)}</span>
                        <span class="unit">litros</span>
                    </div>
                    <div class="cost-estimate">
                        <span class="cost">₲${result.total.cost.toLocaleString()}</span>
                        <span class="label">Costo total estimado</span>
                    </div>
                </div>
            </div>

            <div class="results-details">
                <div class="detail-section">
                    <h4>Desglose del Cálculo</h4>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <span class="label">Área a pintar:</span>
                            <span class="value">${result.area.net.toFixed(1)} m²</span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Número de manos:</span>
                            <span class="value">${result.paint.coats}</span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Rendimiento:</span>
                            <span class="value">${result.paint.coverage} m²/L</span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Desperdicio:</span>
                            <span class="value">${result.paint.waste}%</span>
                        </div>
                    </div>
                </div>

                <div class="detail-section">
                    <h4>Productos Recomendados</h4>
                    <div class="products-grid">
                        ${result.recommendations.map(product => `
                            <div class="product-card">
                                <img src="${product.image}" alt="${product.name}">
                                <h5>${product.name}</h5>
                                <p class="price">₲${product.price.toLocaleString()}</p>
                                <button class="btn btn-primary add-to-cart" 
                                        data-product-id="${product.id}">
                                    Agregar al carrito
                                </button>
                            </div>
                        `).join('')}
                    </div>
                </div>

                <div class="detail-section">
                    <h4>Herramientas Necesarias</h4>
                    <div class="tools-list">
                        ${result.tools.items.map(tool => `
                            <div class="tool-item">
                                <i class="icon-${tool.icon}"></i>
                                <span>${tool.name}</span>
                                <span class="price">₲${tool.price.toLocaleString()}</span>
                            </div>
                        `).join('')}
                    </div>
                </div>

                <div class="detail-section">
                    <h4>Consejos Profesionales</h4>
                    <div class="tips-list">
                        ${result.tips.map(tip => `
                            <div class="tip-item">
                                <i class="icon-lightbulb"></i>
                                <span>${tip}</span>
                            </div>
                        `).join('')}
                    </div>
                </div>
            </div>

            <div class="results-actions">
                <button class="btn btn-primary save-calculation">
                    <i class="icon-save"></i> Guardar Cálculo
                </button>
                <button class="btn btn-secondary share-calculation">
                    <i class="icon-share"></i> Compartir
                </button>
                <button class="btn btn-outline download-pdf">
                    <i class="icon-download"></i> Descargar PDF
                </button>
            </div>
        `;

        resultsContainer.innerHTML = html;
        resultsContainer.style.display = 'block';
        
        // Animar aparición
        this.animateResults();
        
        // Configurar eventos de los botones
        this.setupResultsButtons();
    }

    // ========================================================================
    // MATCHER DE COLORES CON IA
    // ========================================================================
    setupColorMatcher() {
        const colorMatcher = document.querySelector('.color-matcher');
        if (!colorMatcher) return;

        const uploadBtn = colorMatcher.querySelector('.upload-image');
        const cameraBtn = colorMatcher.querySelector('.camera-capture');
        const fileInput = colorMatcher.querySelector('input[type="file"]');

        uploadBtn?.addEventListener('click', () => {
            fileInput?.click();
        });

        fileInput?.addEventListener('change', (e) => {
            const file = e.target.files[0];
            if (file) {
                this.processColorImage(file);
            }
        });

        cameraBtn?.addEventListener('click', () => {
            this.startCameraCapture();
        });
    }

    processColorImage(file) {
        const reader = new FileReader();
        reader.onload = (e) => {
            const img = new Image();
            img.onload = () => {
                this.analyzeImageColors(img);
            };
            img.src = e.target.result;
        };
        reader.readAsDataURL(file);
    }

    analyzeImageColors(img) {
        this.showLoader('Analizando colores...');
        
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        
        canvas.width = img.width;
        canvas.height = img.height;
        ctx.drawImage(img, 0, 0);
        
        // Extraer colores dominantes
        const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
        const colors = this.extractDominantColors(imageData);
        
        // Simular procesamiento con IA
        setTimeout(() => {
            this.displayColorMatches(colors);
            this.hideLoader();
        }, 2000);
    }

    extractDominantColors(imageData) {
        const pixels = imageData.data;
        const colorCounts = {};
        const step = 4; // Skip pixels for performance
        
        for (let i = 0; i < pixels.length; i += step * 4) {
            const r = pixels[i];
            const g = pixels[i + 1];
            const b = pixels[i + 2];
            const alpha = pixels[i + 3];
            
            if (alpha < 128) continue; // Skip transparent pixels
            
            const color = `${r},${g},${b}`;
            colorCounts[color] = (colorCounts[color] || 0) + 1;
        }
        
        // Obtener colores más frecuentes
        const sortedColors = Object.entries(colorCounts)
            .sort((a, b) => b[1] - a[1])
            .slice(0, 10)
            .map(([color, count]) => {
                const [r, g, b] = color.split(',').map(Number);
                return { r, g, b, count };
            });
        
        return sortedColors;
    }

    displayColorMatches(colors) {
        const resultsContainer = document.querySelector('.color-results');
        if (!resultsContainer) return;

        const matches = colors.map(color => {
            return this.findClosestPaintColor(color);
        });

        const html = `
            <div class="color-matches">
                <h3>Colores Encontrados</h3>
                <div class="colors-grid">
                    ${matches.map(match => `
                        <div class="color-match-card">
                            <div class="color-swatch" 
                                 style="background-color: rgb(${match.original.r}, ${match.original.g}, ${match.original.b})">
                            </div>
                            <div class="color-info">
                                <h4>${match.paint.name}</h4>
                                <p class="color-code">${match.paint.code}</p>
                                <p class="similarity">Similitud: ${match.similarity}%</p>
                                <p class="price">₲${match.paint.price.toLocaleString()}</p>
                                <button class="btn btn-sm btn-primary" 
                                        onclick="app.addToFavorites('${match.paint.id}')">
                                    <i class="icon-heart"></i> Favorito
                                </button>
                            </div>
                        </div>
                    `).join('')}
                </div>
            </div>
        `;

        resultsContainer.innerHTML = html;
        resultsContainer.style.display = 'block';
    }

    findClosestPaintColor(color) {
        // Simulación de catálogo de colores
        const paintColors = [
            { id: 'pb-001', name: 'Blanco Puro', code: 'PB-001', r: 255, g: 255, b: 255, price: 45000 },
            { id: 'pb-002', name: 'Gris Perla', code: 'PB-002', r: 240, g: 240, b: 240, price: 47000 },
            { id: 'pb-003', name: 'Azul Cielo', code: 'PB-003', r: 135, g: 206, b: 235, price: 50000 },
            { id: 'pb-004', name: 'Verde Menta', code: 'PB-004', r: 152, g: 251, b: 152, price: 52000 },
            { id: 'pb-005', name: 'Rosa Suave', code: 'PB-005', r: 255, g: 182, b: 193, price: 48000 },
            { id: 'pb-006', name: 'Amarillo Sol', code: 'PB-006', r: 255, g: 215, b: 0, price: 51000 },
            { id: 'pb-007', name: 'Naranja Vivaz', code: 'PB-007', r: 255, g: 165, b: 0, price: 53000 },
            { id: 'pb-008', name: 'Rojo Pasión', code: 'PB-008', r: 220, g: 20, b: 60, price: 55000 },
            { id: 'pb-009', name: 'Violeta Real', code: 'PB-009', r: 147, g: 112, b: 219, price: 54000 },
            { id: 'pb-010', name: 'Marrón Café', code: 'PB-010', r: 139, g: 69, b: 19, price: 49000 }
        ];

        let closest = paintColors[0];
        let minDistance = Infinity;

        paintColors.forEach(paint => {
            const distance = Math.sqrt(
                Math.pow(color.r - paint.r, 2) +
                Math.pow(color.g - paint.g, 2) +
                Math.pow(color.b - paint.b, 2)
            );
            
            if (distance < minDistance) {
                minDistance = distance;
                closest = paint;
            }
        });

        const similarity = Math.max(0, 100 - (minDistance / 4.4)); // Normalizar a 0-100%

        return {
            original: color,
            paint: closest,
            similarity: Math.round(similarity)
        };
    }

    // ========================================================================
    // BÚSQUEDA INTELIGENTE
    // ========================================================================
    setupSearchFunctionality() {
        const searchInput = document.querySelector('.search-input');
        const searchResults = document.querySelector('.search-results');
        const searchBtn = document.querySelector('.search-btn');
        
        if (!searchInput) return;

        let searchTimeout;
        
        searchInput.addEventListener('input', (e) => {
            clearTimeout(searchTimeout);
            const query = e.target.value.trim();
            
            if (query.length < 2) {
                this.hideSearchResults();
                return;
            }
            
            searchTimeout = setTimeout(() => {
                this.performSearch(query);
            }, 300);
        });

        searchBtn?.addEventListener('click', () => {
            const query = searchInput.value.trim();
            if (query) {
                this.performSearch(query);
            }
        });

        // Cerrar resultados al hacer click fuera
        document.addEventListener('click', (e) => {
            if (!e.target.closest('.search-container')) {
                this.hideSearchResults();
            }
        });
    }

    performSearch(query) {
        this.showSearchLoader();
        
        // Simular búsqueda con delay
        setTimeout(() => {
            const results = this.searchProducts(query);
            this.displaySearchResults(results);
            this.hideSearchLoader();
        }, 500);
    }

    searchProducts(query) {
        // Simulación de base de datos de productos
        const products = [
            { id: 1, name: 'Pintura Latex Interior Premium', category: 'Interior', price: 45000, image: 'latex-interior.jpg' },
            { id: 2, name: 'Esmalte Sintético Brillante', category: 'Esmaltes', price: 52000, image: 'esmalte-sintetico.jpg' },
            { id: 3, name: 'Impermeabilizante Acrílico', category: 'Impermeabilizantes', price: 68000, image: 'impermeabilizante.jpg' },
            { id: 4, name: 'Pintura Antihumedad', category: 'Especiales', price: 58000, image: 'antihumedad.jpg' },
            { id: 5, name: 'Barniz Marino Transparente', category: 'Barnices', price: 74000, image: 'barniz-marino.jpg' }
        ];

        const queryLower = query.toLowerCase();
        return products.filter(product => 
            product.name.toLowerCase().includes(queryLower) ||
            product.category.toLowerCase().includes(queryLower)
        );
    }

    displaySearchResults(results) {
        const resultsContainer = document.querySelector('.search-results');
        if (!resultsContainer) return;

        if (results.length === 0) {
            resultsContainer.innerHTML = `
                <div class="no-results">
                    <i class="icon-search"></i>
                    <p>No se encontraron resultados</p>
                </div>
            `;
        } else {
            resultsContainer.innerHTML = `
                <div class="search-results-list">
                    ${results.map(product => `
                        <div class="search-result-item" onclick="app.viewProduct(${product.id})">
                            <img src="images/products/${product.image}" alt="${product.name}">
                            <div class="product-info">
                                <h4>${product.name}</h4>
                                <p class="category">${product.category}</p>
                                <p class="price">₲${product.price.toLocaleString()}</p>
                            </div>
                        </div>
                    `).join('')}
                </div>
            `;
        }

        resultsContainer.style.display = 'block';
    }

    // ========================================================================
    // CHAT EN VIVO
    // ========================================================================
    initializeChat() {
        const chatWidget = document.querySelector('.chat-widget');
        const chatToggle = document.querySelector('.chat-toggle');
        const chatContainer = document.querySelector('.chat-container');
        const chatInput = document.querySelector('.chat-input');
        const chatSend = document.querySelector('.chat-send');

        if (!chatWidget) return;

        chatToggle?.addEventListener('click', () => {
            chatContainer?.classList.toggle('active');
            this.markChatAsRead();
        });

        chatSend?.addEventListener('click', () => {
            this.sendChatMessage();
        });

        chatInput?.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.sendChatMessage();
            }
        });

        // Simular mensajes del bot
        setTimeout(() => {
            this.addChatMessage('bot', '¡Hola! Soy el asistente virtual de Pinturas Bambi. ¿En qué puedo ayudarte?');
        }, 2000);
    }

    sendChatMessage() {
        const input = document.querySelector('.chat-input');
        const message = input?.value.trim();
        
        if (!message) return;

        this.addChatMessage('user', message);
        input.value = '';

        // Simular respuesta del bot
        setTimeout(() => {
            const response = this.generateBotResponse(message);
            this.addChatMessage('bot', response);
        }, 1000);
    }

    addChatMessage(sender, message) {
        const chatMessages = document.querySelector('.chat-messages');
        if (!chatMessages) return;

        const messageElement = document.createElement('div');
        messageElement.className = `chat-message ${sender}`;
        messageElement.innerHTML = `
            <div class="message-content">
                <p>${message}</p>
                <span class="message-time">${new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}</span>
            </div>
        `;

        chatMessages.appendChild(messageElement);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    generateBotResponse(message) {
        const responses = {
            'hola': '¡Hola! ¿En qué puedo ayudarte hoy?',
            'precio': 'Puedes ver los precios de nuestros productos en el catálogo. ¿Buscas algún producto específico?',
            'colores': 'Tenemos más de 2000 colores disponibles. ¿Te gustaría usar nuestro Color Matcher para encontrar el color perfecto?',
            'calculadora': 'Nuestra calculadora te ayuda a determinar exactamente cuánta pintura necesitas. ¿Quieres que te ayude con un cálculo?',
            'tiendas': 'Tenemos varias sucursales en todo el país. ¿Te gustaría encontrar la más cercana a tu ubicación?',
            'envio': 'Ofrecemos envío a domicilio en gran parte del país. Los costos varían según la ubicación.',
            'default': 'Gracias por tu consulta. Un representante se pondrá en contacto contigo pronto. ¿Hay algo más en lo que pueda ayudarte?'
        };

        const messageLower = message.toLowerCase();
        
        for (const [key, response] of Object.entries(responses)) {
            if (messageLower.includes(key)) {
                return response;
            }
        }
        
        return responses.default;
    }

    // ========================================================================
    // ANIMACIONES Y EFECTOS VISUALES
    // ========================================================================
    initializeAnimations() {
        // Animaciones de entrada
        this.observeElements('.animate-on-scroll', (element) => {
            element.classList.add('animate-in');
        });

        // Parallax effect
        this.setupParallaxEffects();
        
        // Hover effects
        this.setupHoverEffects();
    }

    setupParallaxEffects() {
        const parallaxElements = document.querySelectorAll('.parallax');
        
        window.addEventListener('scroll', () => {
            const scrolled = window.pageYOffset;
            
            parallaxElements.forEach(element => {
                const speed = element.dataset.speed || 0.5;
                const yPos = -(scrolled * speed);
                element.style.transform = `translateY(${yPos}px)`;
            });
        });
    }

    setupHoverEffects() {
        const hoverCards = document.querySelectorAll('.hover-card');
        
        hoverCards.forEach(card => {
            card.addEventListener('mouseenter', () => {
                card.style.transform = 'translateY(-8px)';
                card.style.boxShadow = '0 20px 40px rgba(0,0,0,0.1)';
            });
            
            card.addEventListener('mouseleave', () => {
                card.style.transform = 'translateY(0)';
                card.style.boxShadow = '0 4px 8px rgba(0,0,0,0.05)';
            });
        });
    }

    // ========================================================================
    // NOTIFICACIONES Y ALERTS
    // ========================================================================
    setupNotifications() {
        this.createNotificationContainer();
        
        // Solicitar permiso para notificaciones push
        if ('Notification' in window && Notification.permission === 'default') {
            Notification.requestPermission();
        }
    }

    createNotificationContainer() {
        if (document.querySelector('.notification-container')) return;
        
        const container = document.createElement('div');
        container.className = 'notification-container';
        document.body.appendChild(container);
    }

    showNotification(message, type = 'info', duration = 5000) {
        const container = document.querySelector('.notification-container');
        if (!container) return;

        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.innerHTML = `
            <div class="notification-content">
                <i class="icon-${this.getNotificationIcon(type)}"></i>
                <span>${message}</span>
                <button class="notification-close">&times;</button>
            </div>
        `;

        container.appendChild(notification);

        // Animar entrada
        setTimeout(() => {
            notification.classList.add('show');
        }, 10);

        // Auto-remove
        setTimeout(() => {
            this.removeNotification(notification);
        }, duration);

        // Manual close
        notification.querySelector('.notification-close').addEventListener('click', () => {
            this.removeNotification(notification);
        });
    }

    removeNotification(notification) {
        notification.classList.remove('show');
        setTimeout(() => {
            notification.remove();
        }, 300);
    }

    getNotificationIcon(type) {
        const icons = {
            'success': 'check-circle',
            'error': 'x-circle',
            'warning': 'alert-triangle',
            'info': 'info-circle'
        };
        return icons[type] || 'info-circle';
    }

    // ========================================================================
    // UTILIDADES Y HELPERS
    // ========================================================================
    showLoader(message = 'Cargando...') {
        const loader = document.querySelector('.loader') || this.createLoader();
        loader.querySelector('.loader-text').textContent = message;
        loader.style.display = 'flex';
        this.isLoading = true;
    }

    hideLoader() {
        const loader = document.querySelector('.loader');
        if (loader) {
            loader.style.display = 'none';
        }
        this.isLoading = false;
    }

    createLoader() {
        const loader = document.createElement('div');
        loader.className = 'loader';
        loader.innerHTML = `
            <div class="loader-content">
                <div class="spinner"></div>
                <p class="loader-text">Cargando...</p>
            </div>
        `;
        document.body.appendChild(loader);
        return loader;
    }

    observeElements(selector, callback) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    callback(entry.target);
                    observer.unobserve(entry.target);
                }
            });
        });

        document.querySelectorAll(selector).forEach(element => {
            observer.observe(element);
        });
    }

    // ========================================================================
    // PERSISTENCIA Y ALMACENAMIENTO
    // ========================================================================
    saveToLocalStorage(key, data) {
        try {
            localStorage.setItem(key, JSON.stringify(data));
        } catch (error) {
            console.error('Error saving to localStorage:', error);
        }
    }

    getFromLocalStorage(key) {
        try {
            const data = localStorage.getItem(key);
            return data ? JSON.parse(data) : null;
        } catch (error) {
            console.error('Error reading from localStorage:', error);
            return null;
        }
    }

    // ========================================================================
    // MÉTODOS DE MANEJO DE EVENTOS
    // ========================================================================
    handleScroll() {
        const scrollTop = window.pageYOffset;
        
        // Show/hide scroll to top button
        const scrollTopBtn = document.querySelector('.scroll-to-top');
        if (scrollTopBtn) {
            scrollTopBtn.style.display = scrollTop > 300 ? 'block' : 'none';
        }

        // Update progress bar
        const progressBar = document.querySelector('.reading-progress');
        if (progressBar) {
            const winScroll = document.body.scrollTop || document.documentElement.scrollTop;
            const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
            const scrolled = (winScroll / height) * 100;
            progressBar.style.width = scrolled + '%';
        }
    }

    handleResize() {
        // Recalcular dimensiones si es necesario
        this.recalculateLayouts();
    }

    handleOnline() {
        this.showNotification('Conexión restaurada', 'success');
        this.syncOfflineData();
    }

    handleOffline() {
        this.showNotification('Sin conexión a internet', 'warning');
    }

    // ========================================================================
    // INICIALIZACIÓN DE LA APP
    // ========================================================================
    static init() {
        window.app = new PinturasBambiWebApp();
        return window.app;
    }
}

// Inicializar la aplicación cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', () => {
    PinturasBambiWebApp.init();
});

// Exportar para uso global
window.PinturasBambiWebApp = PinturasBambiWebApp;
