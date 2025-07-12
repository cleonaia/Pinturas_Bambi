// 🎨 PINTURAS BAMBI - EFECTOS AVANZADOS Y ÚNICOS
// Registrar plugins de GSAP
gsap.registerPlugin(ScrollTrigger, TextPlugin);

// Variables globales
let paintSplatters = [];
let colorPalette = ['#ffd700', '#003366', '#ff6b6b', '#4ecdc4', '#45b7d1', '#f9ca24', '#6c5ce7', '#fd79a8'];
let scene, camera, renderer, paintParticles = [];
let isDrawing = false;
let currentColor = '#ff6b6b';
let brushSize = 20;

// Inicialización avanzada
document.addEventListener('DOMContentLoaded', function() {
    console.log('🎨 Iniciando experiencia inmersiva...');
    
    // Configurar AOS
    AOS.init({
        duration: 1000,
        once: true,
        offset: 100,
        easing: 'ease-out-cubic'
    });
    
    // Configurar Tilt.js
    VanillaTilt.init(document.querySelectorAll("[data-tilt]"), {
        max: 25,
        speed: 400,
        scale: 1.05,
        glare: true,
        "max-glare": 0.2,
    });
    
    // Inicializar todos los efectos
    initAdvancedLoader();
    initMegaHeroEffects();
    initLetterAnimations();
    initThreeJSBackground();
    initParticlesBackground();
    initAdvancedScrollEffects();
    initInteractiveCanvas();
    initInnovationCards();
    initMorphingEffects();
    initAdvancedHoverEffects();
    initSoundEffects();
    initGlitchEffects();
    
    console.log('🚀 Experiencia inmersiva cargada!');
});

// 🎬 LOADER AVANZADO CON EFECTOS 3D
function initAdvancedLoader() {
    const loaderHTML = `
        <div id="mega-loader" class="mega-loader-overlay">
            <div class="loader-3d-container">
                <div class="paint-bucket-3d">
                    <div class="bucket-handle"></div>
                    <div class="bucket-body"></div>
                    <div class="paint-liquid"></div>
                </div>
                <div class="floating-letters">
                    <span class="float-letter">B</span>
                    <span class="float-letter">A</span>
                    <span class="float-letter">M</span>
                    <span class="float-letter">B</span>
                    <span class="float-letter">I</span>
                </div>
                <div class="loading-progress">
                    <div class="progress-bar"></div>
                    <div class="progress-text">Cargando...</div>
                </div>
            </div>
            <div class="loader-particles-3d"></div>
        </div>
    `;
    document.body.insertAdjacentHTML('afterbegin', loaderHTML);
    
    // Animación del loader 3D
    const loaderTL = gsap.timeline();
    
    // Animación del balde
    loaderTL.from('.paint-bucket-3d', {
        duration: 1.5,
        y: -200,
        rotation: 360,
        ease: "bounce.out"
    })
    .from('.bucket-handle', {
        duration: 0.8,
        rotation: -45,
        transformOrigin: "bottom center",
        ease: "elastic.out(1, 0.3)"
    }, "-=0.5")
    .from('.paint-liquid', {
        duration: 1,
        scaleY: 0,
        transformOrigin: "bottom",
        ease: "power2.out"
    }, "-=0.8");
    
    // Letras flotantes
    loaderTL.from('.float-letter', {
        duration: 1,
        y: 50,
        opacity: 0,
        scale: 0,
        stagger: 0.1,
        ease: "back.out(1.7)"
    }, "-=0.5");
    
    // Barra de progreso
    loaderTL.from('.progress-bar', {
        duration: 2,
        width: "0%",
        ease: "power2.out"
    }, "-=1");
    
    // Crear partículas 3D
    createLoader3DParticles();
    
    // Ocultar loader
    setTimeout(() => {
        gsap.to('#mega-loader', {
            duration: 1.5,
            opacity: 0,
            scale: 0.8,
            ease: "power2.in",
            onComplete: () => {
                document.querySelector('#mega-loader').remove();
            }
        });
    }, 4000);
}

// 🦸‍♂️ EFECTOS MEGA HERO
function initMegaHeroEffects() {
    const hero = document.querySelector('.hero');
    
    // Fondo animado con ondas
    gsap.to(hero, {
        duration: 10,
        backgroundPosition: "200% 50%",
        ease: "none",
        repeat: -1,
        yoyo: true
    });
    
    // Crear pinceladas animadas
    createAnimatedBrushStrokes();
    
    // Particles hero
    createHeroParticleSystem();
    
    // Botones 3D
    init3DButtons();
}

// ✨ ANIMACIONES DE LETRAS INDIVIDUALES
function initLetterAnimations() {
    const letters = document.querySelectorAll('.letter');
    
    letters.forEach((letter, index) => {
        // Animación de entrada
        gsap.from(letter, {
            duration: 1.5,
            y: -100,
            opacity: 0,
            scale: 0,
            rotation: 360,
            ease: "elastic.out(1, 0.3)",
            delay: index * 0.15 + 4
        });
        
        // Efecto hover individual
        letter.addEventListener('mouseenter', () => {
            gsap.to(letter, {
                duration: 0.3,
                scale: 1.3,
                rotation: 15,
                color: colorPalette[index],
                textShadow: "0 0 20px currentColor",
                ease: "power2.out"
            });
        });
        
        letter.addEventListener('mouseleave', () => {
            gsap.to(letter, {
                duration: 0.3,
                scale: 1,
                rotation: 0,
                color: "#fff",
                textShadow: "none",
                ease: "power2.out"
            });
        });
        
        // Animación continua sutil
        gsap.to(letter, {
            duration: 2 + index * 0.5,
            y: -5,
            repeat: -1,
            yoyo: true,
            ease: "power2.inOut",
            delay: index * 0.3
        });
    });
}

// 🌌 FONDO 3D CON THREE.JS
function initThreeJSBackground() {
    const canvas = document.createElement('canvas');
    canvas.id = 'three-bg';
    canvas.style.position = 'fixed';
    canvas.style.top = '0';
    canvas.style.left = '0';
    canvas.style.width = '100%';
    canvas.style.height = '100%';
    canvas.style.zIndex = '-1';
    canvas.style.pointerEvents = 'none';
    document.body.appendChild(canvas);
    
    // Configurar Three.js
    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    renderer = new THREE.WebGLRenderer({ canvas: canvas, alpha: true });
    renderer.setSize(window.innerWidth, window.innerHeight);
    
    // Crear geometría de partículas
    const particlesGeometry = new THREE.BufferGeometry();
    const particlesCount = 1000;
    const posArray = new Float32Array(particlesCount * 3);
    const colorArray = new Float32Array(particlesCount * 3);
    
    for (let i = 0; i < particlesCount * 3; i++) {
        posArray[i] = (Math.random() - 0.5) * 10;
        colorArray[i] = Math.random();
    }
    
    particlesGeometry.setAttribute('position', new THREE.BufferAttribute(posArray, 3));
    particlesGeometry.setAttribute('color', new THREE.BufferAttribute(colorArray, 3));
    
    // Material de partículas
    const particlesMaterial = new THREE.PointsMaterial({
        size: 0.05,
        vertexColors: true,
        transparent: true,
        opacity: 0.6
    });
    
    // Crear mesh de partículas
    const particlesMesh = new THREE.Points(particlesGeometry, particlesMaterial);
    scene.add(particlesMesh);
    
    camera.position.z = 3;
    
    // Función de animación
    function animate() {
        requestAnimationFrame(animate);
        
        particlesMesh.rotation.x += 0.001;
        particlesMesh.rotation.y += 0.002;
        
        renderer.render(scene, camera);
    }
    
    animate();
    
    // Responsive
    window.addEventListener('resize', () => {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    });
}

// 🎆 SISTEMA DE PARTÍCULAS AVANZADO
function initParticlesBackground() {
    if (typeof particlesJS !== 'undefined') {
        particlesJS('particles-js', {
            particles: {
                number: { value: 50, density: { enable: true, value_area: 800 } },
                color: { value: ['#ffd700', '#003366', '#ff6b6b'] },
                shape: { type: 'circle' },
                opacity: { value: 0.3, random: true },
                size: { value: 3, random: true },
                move: {
                    enable: true,
                    speed: 2,
                    direction: 'none',
                    random: true,
                    straight: false,
                    out_mode: 'out',
                    bounce: false
                }
            },
            interactivity: {
                detect_on: 'canvas',
                events: {
                    onhover: { enable: true, mode: 'repulse' },
                    onclick: { enable: true, mode: 'push' },
                    resize: true
                }
            },
            retina_detect: true
        });
    }
}

// 🎨 CANVAS INTERACTIVO
function initInteractiveCanvas() {
    const canvas = document.getElementById('paintCanvas');
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    const rect = canvas.getBoundingClientRect();
    
    // Configurar canvas
    canvas.width = 600;
    canvas.height = 400;
    
    // Controles
    const colorOptions = document.querySelectorAll('.color-option');
    const brushSizeSlider = document.getElementById('brushSize');
    const clearButton = document.getElementById('clearCanvas');
    
    // Eventos de colores
    colorOptions.forEach(option => {
        option.addEventListener('click', () => {
            currentColor = option.dataset.color;
            colorOptions.forEach(opt => opt.classList.remove('active'));
            option.classList.add('active');
            
            // Efecto de selección
            gsap.to(option, {
                duration: 0.3,
                scale: 1.2,
                ease: "back.out(1.7)"
            });
            gsap.to(option, {
                duration: 0.3,
                scale: 1,
                ease: "power2.out",
                delay: 0.2
            });
        });
    });
    
    // Eventos de canvas
    canvas.addEventListener('mousedown', startDrawing);
    canvas.addEventListener('mousemove', draw);
    canvas.addEventListener('mouseup', stopDrawing);
    canvas.addEventListener('touchstart', startDrawing);
    canvas.addEventListener('touchmove', draw);
    canvas.addEventListener('touchend', stopDrawing);
    
    // Brush size
    brushSizeSlider.addEventListener('input', (e) => {
        brushSize = e.target.value;
    });
    
    // Clear button
    clearButton.addEventListener('click', () => {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        createClearEffect();
    });
    
    function startDrawing(e) {
        isDrawing = true;
        draw(e);
    }
    
    function draw(e) {
        if (!isDrawing) return;
        
        const rect = canvas.getBoundingClientRect();
        const x = (e.clientX || e.touches[0].clientX) - rect.left;
        const y = (e.clientY || e.touches[0].clientY) - rect.top;
        
        ctx.globalCompositeOperation = 'source-over';
        ctx.lineCap = 'round';
        ctx.lineJoin = 'round';
        ctx.lineWidth = brushSize;
        ctx.strokeStyle = currentColor;
        
        ctx.lineTo(x, y);
        ctx.stroke();
        ctx.beginPath();
        ctx.moveTo(x, y);
        
        // Crear partículas mientras dibuja
        createDrawingParticles(x, y);
    }
    
    function stopDrawing() {
        isDrawing = false;
        ctx.beginPath();
    }
    
    function createDrawingParticles(x, y) {
        for (let i = 0; i < 3; i++) {
            const particle = document.createElement('div');
            particle.className = 'draw-particle';
            particle.style.left = (rect.left + x) + 'px';
            particle.style.top = (rect.top + y) + 'px';
            particle.style.background = currentColor;
            document.body.appendChild(particle);
            
            gsap.to(particle, {
                duration: 1,
                x: (Math.random() - 0.5) * 50,
                y: (Math.random() - 0.5) * 50,
                opacity: 0,
                scale: 0,
                ease: "power2.out",
                onComplete: () => particle.remove()
            });
        }
    }
    
    function createClearEffect() {
        const clearEffect = document.createElement('div');
        clearEffect.className = 'clear-effect';
        clearEffect.style.left = rect.left + 'px';
        clearEffect.style.top = rect.top + 'px';
        clearEffect.style.width = canvas.width + 'px';
        clearEffect.style.height = canvas.height + 'px';
        document.body.appendChild(clearEffect);
        
        gsap.from(clearEffect, {
            duration: 0.5,
            scale: 0,
            opacity: 1,
            ease: "power2.out",
            onComplete: () => clearEffect.remove()
        });
    }
}

// 🃏 TARJETAS DE INNOVACIÓN 3D
function initInnovationCards() {
    const cards = document.querySelectorAll('.innovation-card');
    
    cards.forEach((card, index) => {
        // Animación de entrada
        gsap.from(card, {
            duration: 1.5,
            y: 100,
            opacity: 0,
            rotation: 10,
            ease: "back.out(1.7)",
            delay: index * 0.3,
            scrollTrigger: {
                trigger: card,
                start: "top 80%",
                toggleActions: "play none none reverse"
            }
        });
        
        // Efecto de flip
        card.addEventListener('click', () => {
            card.classList.toggle('flipped');
            
            gsap.to(card, {
                duration: 0.6,
                rotationY: card.classList.contains('flipped') ? 180 : 0,
                ease: "power2.inOut"
            });
        });
        
        // Animación de SVG
        const svg = card.querySelector('.animated-svg');
        if (svg) {
            animateSVG(svg);
        }
    });
}

// 🎭 EFECTOS DE MORPHING
function initMorphingEffects() {
    const morphingElements = document.querySelectorAll('.morphing-element');
    
    morphingElements.forEach(element => {
        gsap.to(element, {
            duration: 3,
            morphSVG: "#morphTarget",
            ease: "power2.inOut",
            repeat: -1,
            yoyo: true
        });
    });
}

// 🔊 EFECTOS DE SONIDO
function initSoundEffects() {
    // Crear contexto de audio
    const audioContext = new (window.AudioContext || window.webkitAudioContext)();
    
    function createTone(frequency, duration) {
        const oscillator = audioContext.createOscillator();
        const gainNode = audioContext.createGain();
        
        oscillator.connect(gainNode);
        gainNode.connect(audioContext.destination);
        
        oscillator.frequency.value = frequency;
        oscillator.type = 'sine';
        
        gainNode.gain.setValueAtTime(0.1, audioContext.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + duration);
        
        oscillator.start(audioContext.currentTime);
        oscillator.stop(audioContext.currentTime + duration);
    }
    
    // Sonidos en hover
    const interactiveElements = document.querySelectorAll('.btn-primary, .btn-secondary, .card, .color-option');
    interactiveElements.forEach(element => {
        element.addEventListener('mouseenter', () => {
            createTone(440, 0.1);
        });
        
        element.addEventListener('click', () => {
            createTone(880, 0.2);
        });
    });
}

// ⚡ EFECTOS GLITCH
function initGlitchEffects() {
    const glitchElements = document.querySelectorAll('.glitch-element');
    
    glitchElements.forEach(element => {
        setInterval(() => {
            if (Math.random() > 0.95) {
                element.classList.add('glitching');
                setTimeout(() => {
                    element.classList.remove('glitching');
                }, 200);
            }
        }, 100);
    });
}

// 🎨 FUNCIONES AUXILIARES
function createLoader3DParticles() {
    const container = document.querySelector('.loader-particles-3d');
    
    for (let i = 0; i < 50; i++) {
        const particle = document.createElement('div');
        particle.className = 'loader-particle-3d';
        particle.style.left = Math.random() * 100 + '%';
        particle.style.top = Math.random() * 100 + '%';
        particle.style.background = colorPalette[Math.floor(Math.random() * colorPalette.length)];
        container.appendChild(particle);
        
        gsap.to(particle, {
            duration: 2 + Math.random() * 3,
            y: -window.innerHeight,
            rotation: 360,
            opacity: 0,
            ease: "power2.out",
            delay: Math.random() * 2,
            onComplete: () => particle.remove()
        });
    }
}

function createAnimatedBrushStrokes() {
    const strokes = document.querySelectorAll('.paint-stroke');
    
    strokes.forEach((stroke, index) => {
        gsap.from(stroke, {
            duration: 2,
            scaleX: 0,
            transformOrigin: "left center",
            ease: "power2.out",
            delay: 5 + index * 0.5
        });
        
        gsap.to(stroke, {
            duration: 4,
            x: 50,
            ease: "power1.inOut",
            repeat: -1,
            yoyo: true,
            delay: index * 0.5
        });
    });
}

function createHeroParticleSystem() {
    const hero = document.querySelector('.hero-particles');
    
    setInterval(() => {
        const particle = document.createElement('div');
        particle.className = 'hero-particle';
        particle.style.left = Math.random() * 100 + '%';
        particle.style.background = colorPalette[Math.floor(Math.random() * colorPalette.length)];
        hero.appendChild(particle);
        
        gsap.to(particle, {
            duration: 3 + Math.random() * 2,
            y: -window.innerHeight,
            opacity: 0,
            ease: "power2.out",
            onComplete: () => particle.remove()
        });
    }, 300);
}

function init3DButtons() {
    const buttons = document.querySelectorAll('.btn-3d');
    
    buttons.forEach(button => {
        button.addEventListener('mouseenter', () => {
            gsap.to(button, {
                duration: 0.3,
                z: 20,
                rotationX: 10,
                rotationY: 5,
                ease: "power2.out"
            });
        });
        
        button.addEventListener('mouseleave', () => {
            gsap.to(button, {
                duration: 0.3,
                z: 0,
                rotationX: 0,
                rotationY: 0,
                ease: "power2.out"
            });
        });
    });
}

function animateSVG(svg) {
    const paths = svg.querySelectorAll('path, circle, rect');
    
    paths.forEach((path, index) => {
        gsap.to(path, {
            duration: 2,
            rotation: 360,
            transformOrigin: "center",
            ease: "power2.inOut",
            repeat: -1,
            delay: index * 0.5
        });
    });
}

function initAdvancedScrollEffects() {
    // Scroll suave personalizado
    const scrollElements = document.querySelectorAll('[data-scroll]');
    
    scrollElements.forEach(element => {
        gsap.to(element, {
            yPercent: -50,
            ease: "none",
            scrollTrigger: {
                trigger: element,
                start: "top bottom",
                end: "bottom top",
                scrub: true
            }
        });
    });
}

function initAdvancedHoverEffects() {
    // Efecto de seguimiento del cursor
    const cursor = document.createElement('div');
    cursor.className = 'custom-cursor';
    document.body.appendChild(cursor);
    
    document.addEventListener('mousemove', (e) => {
        gsap.to(cursor, {
            duration: 0.2,
            x: e.clientX,
            y: e.clientY,
            ease: "power2.out"
        });
    });
    
    // Cursor interactivo
    const interactiveElements = document.querySelectorAll('a, button, .card');
    interactiveElements.forEach(element => {
        element.addEventListener('mouseenter', () => {
            cursor.classList.add('cursor-hover');
        });
        
        element.addEventListener('mouseleave', () => {
            cursor.classList.remove('cursor-hover');
        });
    });
}

console.log('🎨 Pinturas Bambi - Experiencia inmersiva cargada! 🚀');
console.log('🌟 Características: 3D, Partículas, Audio, Interactividad');
