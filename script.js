// 🎨 PINTURAS BAMBI - GSAP ANIMATIONS INCREÍBLES
// Registrar plugins de GSAP
gsap.registerPlugin(ScrollTrigger, TextPlugin);

// Variables globales
let paintSplatters = [];
let colorPalette = ['#ffd700', '#003366', '#ff6b6b', '#4ecdc4', '#45b7d1', '#f9ca24', '#6c5ce7', '#fd79a8'];

// Inicialización cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', function() {
    console.log('🎨 GSAP Animations Loading...');
    
    // Configurar ScrollTrigger
    ScrollTrigger.defaults({
        toggleActions: "play none none reverse",
        markers: false
    });
    
    // Inicializar todas las animaciones
    initLoaderAnimation();
    initHeroAnimations();
    initProductAnimations();
    initColorGalleryAnimations();
    initScrollAnimations();
    initInteractiveEffects();
    initPaintSplatEffects();
    initTextAnimations();
    initParallaxEffects();
    initHoverEffects();
    
    console.log('🎨 GSAP Animations Loaded Successfully!');
});

// 🎬 ANIMACIÓN DE CARGA INCREÍBLE
function initLoaderAnimation() {
    // Crear loader de pintura
    const loaderHTML = `
        <div id="paint-loader" class="paint-loader-overlay">
            <div class="paint-bucket">
                <div class="paint-drip"></div>
                <div class="paint-drip"></div>
                <div class="paint-drip"></div>
            </div>
            <div class="loader-text">BAMBI</div>
            <div class="loader-subtext">Cargando colores...</div>
        </div>
    `;
    document.body.insertAdjacentHTML('afterbegin', loaderHTML);
    
    // Animación del loader
    const tl = gsap.timeline();
    
    tl.from('.paint-drip', {
        duration: 1,
        y: -100,
        opacity: 0,
        stagger: 0.2,
        ease: "bounce.out"
    })
    .from('.loader-text', {
        duration: 0.8,
        scale: 0,
        rotation: 360,
        ease: "back.out(1.7)"
    }, "-=0.5")
    .from('.loader-subtext', {
        duration: 0.6,
        opacity: 0,
        y: 20
    }, "-=0.3");
    
    // Ocultar loader después de 3 segundos
    setTimeout(() => {
        gsap.to('#paint-loader', {
            duration: 1,
            opacity: 0,
            y: -100,
            ease: "power2.in",
            onComplete: () => {
                document.querySelector('#paint-loader').remove();
            }
        });
    }, 3000);
}

// 🦸‍♂️ ANIMACIONES DEL HERO ÉPICAS
function initHeroAnimations() {
    const hero = document.querySelector('.hero');
    const title = hero.querySelector('h1');
    const subtitle = hero.querySelectorAll('p');
    const button = hero.querySelector('.btn-primary');
    
    // Timeline principal del hero
    const heroTL = gsap.timeline({ delay: 3.5 });
    
    // Animación del fondo con efecto de pintura
    gsap.to(hero, {
        duration: 8,
        backgroundPosition: "200% 50%",
        ease: "none",
        repeat: -1,
        yoyo: true
    });
    
    // Título con efecto de escritura y salpicaduras
    heroTL.from(title, {
        duration: 1.5,
        opacity: 0,
        scale: 0.5,
        rotation: -10,
        ease: "elastic.out(1, 0.3)"
    })
    .addLabel("titleComplete")
    .from(subtitle, {
        duration: 1,
        opacity: 0,
        y: 50,
        stagger: 0.3,
        ease: "power2.out"
    }, "-=0.8")
    .from(button, {
        duration: 1,
        opacity: 0,
        scale: 0,
        rotation: 720,
        ease: "back.out(1.7)"
    }, "-=0.5");
    
    // Efecto de goteo continuo en el hero
    createHeroPaintDrops();
}

// 💧 GOTAS DE PINTURA EN EL HERO
function createHeroPaintDrops() {
    const hero = document.querySelector('.hero');
    
    function createDrop() {
        const drop = document.createElement('div');
        drop.className = 'hero-paint-drop';
        drop.style.left = Math.random() * 100 + '%';
        drop.style.background = colorPalette[Math.floor(Math.random() * colorPalette.length)];
        hero.appendChild(drop);
        
        gsap.fromTo(drop, {
            y: -50,
            opacity: 1
        }, {
            y: window.innerHeight,
            opacity: 0,
            duration: 3 + Math.random() * 2,
            ease: "power2.in",
            onComplete: () => drop.remove()
        });
    }
    
    // Crear gotas cada 500ms
    setInterval(createDrop, 500);
}

// 🎨 ANIMACIONES DE PRODUCTOS ESPECTACULARES
function initProductAnimations() {
    const cards = document.querySelectorAll('.card');
    
    cards.forEach((card, index) => {
        // Animación de entrada
        gsap.from(card, {
            duration: 1,
            y: 100,
            opacity: 0,
            rotation: 10,
            scale: 0.8,
            ease: "back.out(1.7)",
            scrollTrigger: {
                trigger: card,
                start: "top 80%",
                end: "bottom 20%",
                toggleActions: "play none none reverse"
            },
            delay: index * 0.2
        });
        
        // Efectos hover increíbles
        card.addEventListener('mouseenter', () => {
            gsap.to(card, {
                duration: 0.3,
                scale: 1.05,
                rotation: 2,
                boxShadow: "0 20px 40px rgba(0,0,0,0.2)",
                ease: "power2.out"
            });
            
            // Crear salpicaduras
            createPaintSplatter(card);
        });
        
        card.addEventListener('mouseleave', () => {
            gsap.to(card, {
                duration: 0.3,
                scale: 1,
                rotation: 0,
                boxShadow: "0 2px 8px rgba(0,0,0,0.05)",
                ease: "power2.out"
            });
        });
    });
}

// 🌈 ANIMACIONES DE GALERÍA DE COLORES
function initColorGalleryAnimations() {
    const colorSamples = document.querySelectorAll('.color-sample');
    
    // Animación de aparición en cascada
    gsap.from(colorSamples, {
        duration: 1.5,
        scale: 0,
        opacity: 0,
        rotation: 360,
        stagger: {
            amount: 1.5,
            from: "random"
        },
        ease: "elastic.out(1, 0.3)",
        scrollTrigger: {
            trigger: ".color-palette",
            start: "top 80%",
            end: "bottom 20%",
            toggleActions: "play none none reverse"
        }
    });
    
    // Efectos hover únicos para cada color
    colorSamples.forEach((sample, index) => {
        sample.addEventListener('mouseenter', () => {
            gsap.to(sample, {
                duration: 0.4,
                scale: 1.1,
                rotation: 5,
                transformOrigin: "center",
                ease: "power2.out"
            });
            
            // Crear ondas de color
            createColorWaves(sample);
        });
        
        sample.addEventListener('mouseleave', () => {
            gsap.to(sample, {
                duration: 0.4,
                scale: 1,
                rotation: 0,
                ease: "power2.out"
            });
        });
        
        // Animación de pulsación continua
        gsap.to(sample, {
            duration: 2 + Math.random(),
            scale: 1.02,
            ease: "power2.inOut",
            repeat: -1,
            yoyo: true,
            delay: index * 0.3
        });
    });
}

// 🎯 ANIMACIONES DE SCROLL AVANZADAS
function initScrollAnimations() {
    // Animación de secciones
    const sections = document.querySelectorAll('section');
    
    sections.forEach(section => {
        gsap.from(section, {
            duration: 1,
            y: 50,
            opacity: 0,
            ease: "power2.out",
            scrollTrigger: {
                trigger: section,
                start: "top 85%",
                end: "top 15%",
                toggleActions: "play none none reverse"
            }
        });
    });
    
    // Títulos con efecto de escritura
    const titles = document.querySelectorAll('h2, h3');
    titles.forEach(title => {
        gsap.from(title, {
            duration: 1,
            opacity: 0,
            y: 30,
            ease: "power2.out",
            scrollTrigger: {
                trigger: title,
                start: "top 90%",
                toggleActions: "play none none reverse"
            }
        });
    });
}

// 🎪 EFECTOS INTERACTIVOS INCREÍBLES
function initInteractiveEffects() {
    // Botones con efectos líquidos
    const buttons = document.querySelectorAll('.btn-primary, .btn-secondary');
    
    buttons.forEach(button => {
        button.addEventListener('click', (e) => {
            // Crear efecto de explosión de pintura
            createPaintExplosion(e.clientX, e.clientY);
            
            // Animación del botón
            gsap.to(button, {
                duration: 0.1,
                scale: 0.95,
                ease: "power2.out",
                yoyo: true,
                repeat: 1
            });
        });
    });
    
    // Logo con rotación suave
    const logo = document.querySelector('.logo');
    if (logo) {
        logo.addEventListener('mouseenter', () => {
            gsap.to(logo, {
                duration: 0.6,
                rotation: 360,
                scale: 1.1,
                ease: "power2.out"
            });
        });
        
        logo.addEventListener('mouseleave', () => {
            gsap.to(logo, {
                duration: 0.6,
                rotation: 0,
                scale: 1,
                ease: "power2.out"
            });
        });
    }
}

// 💥 CREAR SALPICADURAS DE PINTURA
function createPaintSplatter(element) {
    const rect = element.getBoundingClientRect();
    const splatter = document.createElement('div');
    splatter.className = 'paint-splatter';
    splatter.style.left = rect.left + rect.width / 2 + 'px';
    splatter.style.top = rect.top + rect.height / 2 + 'px';
    splatter.style.background = colorPalette[Math.floor(Math.random() * colorPalette.length)];
    document.body.appendChild(splatter);
    
    gsap.fromTo(splatter, {
        scale: 0,
        opacity: 1
    }, {
        scale: 2,
        opacity: 0,
        duration: 1,
        ease: "power2.out",
        onComplete: () => splatter.remove()
    });
}

// 🎆 EXPLOSIÓN DE PINTURA
function createPaintExplosion(x, y) {
    for (let i = 0; i < 12; i++) {
        const particle = document.createElement('div');
        particle.className = 'paint-particle';
        particle.style.left = x + 'px';
        particle.style.top = y + 'px';
        particle.style.background = colorPalette[Math.floor(Math.random() * colorPalette.length)];
        document.body.appendChild(particle);
        
        const angle = (i / 12) * Math.PI * 2;
        const distance = 50 + Math.random() * 100;
        
        gsap.to(particle, {
            duration: 1 + Math.random(),
            x: Math.cos(angle) * distance,
            y: Math.sin(angle) * distance,
            opacity: 0,
            scale: 0,
            ease: "power2.out",
            onComplete: () => particle.remove()
        });
    }
}

// 🌊 ONDAS DE COLOR
function createColorWaves(element) {
    const wave = document.createElement('div');
    wave.className = 'color-wave';
    wave.style.background = window.getComputedStyle(element).backgroundColor;
    element.appendChild(wave);
    
    gsap.fromTo(wave, {
        scale: 0,
        opacity: 0.8
    }, {
        scale: 3,
        opacity: 0,
        duration: 1,
        ease: "power2.out",
        onComplete: () => wave.remove()
    });
}

// ✨ EFECTOS DE TEXTO ANIMADO
function initTextAnimations() {
    const paintText = document.querySelector('.paint-text');
    if (paintText) {
        const colors = ['#003366', '#ffd700', '#ff6b6b', '#4ecdc4'];
        let colorIndex = 0;
        
        setInterval(() => {
            colorIndex = (colorIndex + 1) % colors.length;
            gsap.to(paintText, {
                duration: 0.5,
                color: colors[colorIndex],
                ease: "power2.out"
            });
        }, 2000);
    }
}

// 🏔️ EFECTOS PARALLAX
function initParallaxEffects() {
    const hero = document.querySelector('.hero');
    
    gsap.to(hero, {
        yPercent: -50,
        ease: "none",
        scrollTrigger: {
            trigger: hero,
            start: "top top",
            end: "bottom top",
            scrub: true
        }
    });
}

// 🎨 EFECTOS HOVER AVANZADOS
function initHoverEffects() {
    const cards = document.querySelectorAll('.card');
    
    cards.forEach(card => {
        const img = card.querySelector('img');
        
        card.addEventListener('mouseenter', () => {
            gsap.to(img, {
                duration: 0.3,
                rotation: 10,
                scale: 1.1,
                ease: "power2.out"
            });
        });
        
        card.addEventListener('mouseleave', () => {
            gsap.to(img, {
                duration: 0.3,
                rotation: 0,
                scale: 1,
                ease: "power2.out"
            });
        });
    });
}

// 🎨 EFECTOS ADICIONALES DE PINTURA
function initPaintSplatEffects() {
    // Crear salpicaduras aleatorias en el fondo
    function createRandomSplat() {
        const splat = document.createElement('div');
        splat.className = 'random-splat';
        splat.style.left = Math.random() * 100 + '%';
        splat.style.top = Math.random() * 100 + '%';
        splat.style.background = colorPalette[Math.floor(Math.random() * colorPalette.length)];
        document.body.appendChild(splat);
        
        gsap.fromTo(splat, {
            scale: 0,
            opacity: 0.3
        }, {
            scale: 1,
            opacity: 0,
            duration: 4,
            ease: "power2.out",
            onComplete: () => splat.remove()
        });
    }
    
    // Crear salpicadura cada 5 segundos
    setInterval(createRandomSplat, 5000);
}

// 🎉 EASTER EGG - Konami Code
let konamiCode = [];
const konamiSequence = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65]; // ↑↑↓↓←→←→BA

document.addEventListener('keydown', (e) => {
    konamiCode.push(e.keyCode);
    if (konamiCode.length > konamiSequence.length) {
        konamiCode.shift();
    }
    
    if (konamiCode.join(',') === konamiSequence.join(',')) {
        // ¡MODO RAINBOW ACTIVADO!
        document.body.style.background = 'linear-gradient(45deg, #ff0000, #ff7f00, #ffff00, #00ff00, #0000ff, #4b0082, #9400d3)';
        document.body.style.backgroundSize = '400% 400%';
        
        gsap.to(document.body, {
            duration: 2,
            backgroundPosition: '400% 0%',
            ease: "none",
            repeat: -1
        });
        
        alert('🎨 ¡MODO RAINBOW BAMBI ACTIVADO! 🌈');
    }
});

console.log('🎨 Pinturas Bambi con GSAP - ¡Efectos increíbles cargados!');
console.log('💡 Tip: Prueba el código Konami para un efecto especial...');
