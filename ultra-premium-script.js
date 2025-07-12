// ============================================
// PINTURAS BAMBI - SISTEMA DE ANIMACIONES ULTRA-PREMIUM
// ============================================

class PremiumAnimationSystem {
  constructor() {
    this.isLoaded = false;
    this.particleSystem = null;
    this.fluidSystem = null;
    this.hologramSystem = null;
    this.morphLoader = null;
    this.audioSystem = null;
    this.init();
  }

  async init() {
    await this.initLoader();
    await this.initParticleSystem();
    await this.initFluidSystem();
    await this.initHologramSystem();
    await this.initAdvancedCursor();
    await this.initAudioSystem();
    await this.initMorphingElements();
    await this.initVirtualLab();
    await this.initShowroom360();
    await this.initTrendsAnalysis();
    await this.initShaderEffects();
    
    this.isLoaded = true;
    this.hideLoader();
  }

  // ============================================
  // MORPHING LOADER SYSTEM
  // ============================================
  async initLoader() {
    const loader = document.getElementById('morphing-loader');
    const morphPath = document.getElementById('morphPath');
    const morphCircle = document.getElementById('morphCircle');
    const morphText = document.getElementById('morphText');
    const percentage = document.querySelector('.loader-percentage');
    
    if (!loader || !morphPath) return;

    const morphShapes = [
      "M100,20 Q180,100 100,180 Q20,100 100,20 Z",
      "M100,10 L190,100 L100,190 L10,100 Z",
      "M100,50 Q150,50 150,100 Q150,150 100,150 Q50,150 50,100 Q50,50 100,50 Z",
      "M100,30 Q170,30 170,100 Q170,170 100,170 Q30,170 30,100 Q30,30 100,30 Z",
      "M100,20 Q180,100 100,180 Q20,100 100,20 Z"
    ];

    let currentShape = 0;
    let progress = 0;

    const animateLoader = () => {
      // Animar el path morphing
      gsap.to(morphPath, {
        duration: 0.8,
        ease: "power2.inOut",
        attr: { d: morphShapes[currentShape] },
        onComplete: () => {
          currentShape = (currentShape + 1) % morphShapes.length;
          if (progress < 100) {
            setTimeout(animateLoader, 200);
          }
        }
      });

      // Animar el círculo interno
      gsap.to(morphCircle, {
        duration: 0.5,
        scale: 1.5,
        opacity: 0.3,
        yoyo: true,
        repeat: 1,
        ease: "power2.inOut"
      });

      // Actualizar porcentaje
      progress += Math.random() * 15 + 5;
      if (progress > 100) progress = 100;
      
      gsap.to(percentage, {
        duration: 0.3,
        textContent: Math.floor(progress) + '%',
        ease: "power2.out"
      });
    };

    animateLoader();
  }

  hideLoader() {
    const loader = document.getElementById('morphing-loader');
    if (loader) {
      gsap.to(loader, {
        duration: 1,
        opacity: 0,
        scale: 0.8,
        ease: "power2.inOut",
        onComplete: () => {
          loader.style.display = 'none';
        }
      });
    }
  }

  // ============================================
  // PARTICLE SYSTEM AVANZADO
  // ============================================
  async initParticleSystem() {
    const canvas = document.getElementById('particleSystem');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    const particles = [];
    const particleCount = 100;

    class Particle {
      constructor() {
        this.x = Math.random() * canvas.width;
        this.y = Math.random() * canvas.height;
        this.vx = (Math.random() - 0.5) * 2;
        this.vy = (Math.random() - 0.5) * 2;
        this.radius = Math.random() * 3 + 1;
        this.color = this.getRandomColor();
        this.life = Math.random() * 100 + 100;
        this.decay = Math.random() * 0.02 + 0.005;
      }

      getRandomColor() {
        const colors = ['#003366', '#ffd700', '#00ffff', '#ff00ff'];
        return colors[Math.floor(Math.random() * colors.length)];
      }

      update() {
        this.x += this.vx;
        this.y += this.vy;
        this.life -= this.decay;

        if (this.x < 0 || this.x > canvas.width) this.vx *= -1;
        if (this.y < 0 || this.y > canvas.height) this.vy *= -1;

        if (this.life <= 0) {
          this.x = Math.random() * canvas.width;
          this.y = Math.random() * canvas.height;
          this.life = Math.random() * 100 + 100;
        }
      }

      draw() {
        ctx.save();
        ctx.globalAlpha = this.life / 100;
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
        ctx.fillStyle = this.color;
        ctx.fill();
        ctx.shadowColor = this.color;
        ctx.shadowBlur = 10;
        ctx.fill();
        ctx.restore();
      }
    }

    for (let i = 0; i < particleCount; i++) {
      particles.push(new Particle());
    }

    const animate = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      
      particles.forEach(particle => {
        particle.update();
        particle.draw();
      });

      requestAnimationFrame(animate);
    };

    animate();
  }

  // ============================================
  // SISTEMA DE FLUIDOS
  // ============================================
  async initFluidSystem() {
    const canvas = document.getElementById('fluidCanvas');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    const fluid = {
      points: [],
      viscosity: 0.99,
      speed: 0.05
    };

    for (let i = 0; i < 50; i++) {
      fluid.points.push({
        x: Math.random() * canvas.width,
        y: Math.random() * canvas.height,
        vx: (Math.random() - 0.5) * 2,
        vy: (Math.random() - 0.5) * 2,
        radius: Math.random() * 20 + 10,
        color: `hsl(${Math.random() * 60 + 200}, 70%, 60%)`
      });
    }

    const animateFluid = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      fluid.points.forEach((point, index) => {
        // Actualizar posición
        point.x += point.vx * fluid.speed;
        point.y += point.vy * fluid.speed;

        // Aplicar viscosidad
        point.vx *= fluid.viscosity;
        point.vy *= fluid.viscosity;

        // Rebote en bordes
        if (point.x < 0 || point.x > canvas.width) point.vx *= -1;
        if (point.y < 0 || point.y > canvas.height) point.vy *= -1;

        // Interacción entre puntos
        fluid.points.forEach((other, otherIndex) => {
          if (index !== otherIndex) {
            const dx = other.x - point.x;
            const dy = other.y - point.y;
            const distance = Math.sqrt(dx * dx + dy * dy);
            
            if (distance < 100) {
              const force = (100 - distance) / 100;
              point.vx += dx * force * 0.01;
              point.vy += dy * force * 0.01;
            }
          }
        });

        // Dibujar
        ctx.save();
        ctx.globalAlpha = 0.3;
        ctx.beginPath();
        ctx.arc(point.x, point.y, point.radius, 0, Math.PI * 2);
        ctx.fillStyle = point.color;
        ctx.fill();
        ctx.restore();
      });

      requestAnimationFrame(animateFluid);
    };

    animateFluid();
  }

  // ============================================
  // SISTEMA DE HOLOGRAMAS
  // ============================================
  async initHologramSystem() {
    const lines = document.querySelectorAll('.hologram-line');
    
    lines.forEach((line, index) => {
      gsap.set(line, {
        scaleX: 0,
        opacity: 0
      });

      gsap.to(line, {
        duration: 2,
        scaleX: 1,
        opacity: 1,
        ease: "power2.inOut",
        delay: index * 0.5,
        repeat: -1,
        yoyo: true
      });
    });
  }

  // ============================================
  // CURSOR AVANZADO
  // ============================================
  async initAdvancedCursor() {
    const trail = document.querySelector('.cursor-trail');
    const dot = document.querySelector('.cursor-dot');
    
    if (!trail || !dot) return;

    let mouseX = 0;
    let mouseY = 0;
    let trailX = 0;
    let trailY = 0;

    document.addEventListener('mousemove', (e) => {
      mouseX = e.clientX;
      mouseY = e.clientY;
    });

    const animateCursor = () => {
      trailX += (mouseX - trailX) * 0.1;
      trailY += (mouseY - trailY) * 0.1;

      trail.style.left = trailX + 'px';
      trail.style.top = trailY + 'px';
      dot.style.left = mouseX + 'px';
      dot.style.top = mouseY + 'px';

      requestAnimationFrame(animateCursor);
    };

    animateCursor();

    // Efectos en hover
    document.querySelectorAll('a, button, .morphing-card').forEach(el => {
      el.addEventListener('mouseenter', () => {
        gsap.to(trail, { duration: 0.3, scale: 2, opacity: 0.8 });
        gsap.to(dot, { duration: 0.3, scale: 2 });
      });

      el.addEventListener('mouseleave', () => {
        gsap.to(trail, { duration: 0.3, scale: 1, opacity: 0.5 });
        gsap.to(dot, { duration: 0.3, scale: 1 });
      });
    });
  }

  // ============================================
  // SISTEMA DE AUDIO
  // ============================================
  async initAudioSystem() {
    const canvas = document.getElementById('audioVisualizer');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    canvas.width = 200;
    canvas.height = 100;

    // Simulación de visualizador de audio
    const bars = 20;
    const barData = new Array(bars).fill(0);

    const animateAudio = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      const barWidth = canvas.width / bars;
      
      barData.forEach((height, index) => {
        // Simular datos de audio
        barData[index] = Math.random() * canvas.height;
        
        const x = index * barWidth;
        const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
        gradient.addColorStop(0, '#ffd700');
        gradient.addColorStop(1, '#003366');
        
        ctx.fillStyle = gradient;
        ctx.fillRect(x, canvas.height - height, barWidth - 2, height);
      });

      requestAnimationFrame(animateAudio);
    };

    animateAudio();
  }

  // ============================================
  // ELEMENTOS MORPHING
  // ============================================
  async initMorphingElements() {
    const morphingCards = document.querySelectorAll('.morphing-card');
    
    morphingCards.forEach(card => {
      const wrapper = card.querySelector('.card-3d-wrapper');
      
      card.addEventListener('mouseenter', () => {
        gsap.to(wrapper, {
          duration: 0.6,
          rotateY: 180,
          ease: "power2.inOut"
        });
      });

      card.addEventListener('mouseleave', () => {
        gsap.to(wrapper, {
          duration: 0.6,
          rotateY: 0,
          ease: "power2.inOut"
        });
      });
    });
  }

  // ============================================
  // LABORATORIO VIRTUAL
  // ============================================
  async initVirtualLab() {
    const sliders = document.querySelectorAll('.viscosity-slider, .pigment-slider, .shine-slider');
    const canvas = document.getElementById('paintMixerCanvas');
    const molecules = document.querySelectorAll('.molecule');
    
    if (canvas) {
      const ctx = canvas.getContext('2d');
      canvas.width = canvas.offsetWidth;
      canvas.height = canvas.offsetHeight;

      const animateMixer = () => {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        // Simular mezcla de pintura
        const centerX = canvas.width / 2;
        const centerY = canvas.height / 2;
        const time = Date.now() * 0.001;
        
        for (let i = 0; i < 50; i++) {
          const angle = (i / 50) * Math.PI * 2 + time;
          const radius = 50 + Math.sin(time + i * 0.1) * 30;
          const x = centerX + Math.cos(angle) * radius;
          const y = centerY + Math.sin(angle) * radius;
          
          ctx.beginPath();
          ctx.arc(x, y, 3, 0, Math.PI * 2);
          ctx.fillStyle = `hsl(${200 + i * 3}, 70%, 60%)`;
          ctx.fill();
        }

        requestAnimationFrame(animateMixer);
      };

      animateMixer();
    }

    // Animar moléculas
    molecules.forEach((molecule, index) => {
      gsap.to(molecule, {
        duration: 2 + index * 0.5,
        y: -20,
        ease: "power2.inOut",
        repeat: -1,
        yoyo: true
      });
    });
  }

  // ============================================
  // SHOWROOM 360
  // ============================================
  async initShowroom360() {
    const canvas = document.getElementById('panoramaCanvas');
    const spheres = document.querySelectorAll('.color-sphere');
    
    if (canvas) {
      const ctx = canvas.getContext('2d');
      canvas.width = canvas.offsetWidth;
      canvas.height = canvas.offsetHeight;

      // Simular vista 360
      const animate360 = () => {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        const gradient = ctx.createLinearGradient(0, 0, canvas.width, canvas.height);
        gradient.addColorStop(0, '#003366');
        gradient.addColorStop(0.5, '#ffd700');
        gradient.addColorStop(1, '#003366');
        
        ctx.fillStyle = gradient;
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        requestAnimationFrame(animate360);
      };

      animate360();
    }

    // Animar esferas de color
    spheres.forEach((sphere, index) => {
      sphere.addEventListener('mouseenter', () => {
        gsap.to(sphere, {
          duration: 0.3,
          scale: 1.3,
          rotateY: 360,
          ease: "power2.out"
        });
      });

      sphere.addEventListener('mouseleave', () => {
        gsap.to(sphere, {
          duration: 0.3,
          scale: 1,
          rotateY: 0,
          ease: "power2.out"
        });
      });
    });
  }

  // ============================================
  // ANÁLISIS DE TENDENCIAS
  // ============================================
  async initTrendsAnalysis() {
    const canvas = document.getElementById('trendsChart');
    
    if (canvas) {
      const ctx = canvas.getContext('2d');
      canvas.width = canvas.offsetWidth;
      canvas.height = canvas.offsetHeight;

      const data = [];
      for (let i = 0; i < 12; i++) {
        data.push(Math.random() * 100);
      }

      const animateChart = () => {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        const barWidth = canvas.width / data.length;
        
        data.forEach((value, index) => {
          const x = index * barWidth;
          const height = (value / 100) * canvas.height;
          
          const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
          gradient.addColorStop(0, '#ffd700');
          gradient.addColorStop(1, '#003366');
          
          ctx.fillStyle = gradient;
          ctx.fillRect(x + 5, canvas.height - height, barWidth - 10, height);
        });

        requestAnimationFrame(animateChart);
      };

      animateChart();
    }
  }

  // ============================================
  // EFECTOS SHADER
  // ============================================
  async initShaderEffects() {
    const canvas = document.getElementById('shaderCanvas');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    const animateShader = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      
      const time = Date.now() * 0.001;
      
      // Crear efecto de ondas
      const imageData = ctx.createImageData(canvas.width, canvas.height);
      const data = imageData.data;
      
      for (let x = 0; x < canvas.width; x += 4) {
        for (let y = 0; y < canvas.height; y += 4) {
          const index = (y * canvas.width + x) * 4;
          
          const wave = Math.sin(x * 0.01 + time) * Math.cos(y * 0.01 + time);
          const intensity = Math.abs(wave) * 255;
          
          data[index] = intensity * 0.2;     // R
          data[index + 1] = intensity * 0.8; // G
          data[index + 2] = intensity;       // B
          data[index + 3] = 50;              // A
        }
      }
      
      ctx.putImageData(imageData, 0, 0);
      requestAnimationFrame(animateShader);
    };

    animateShader();
  }
}

// ============================================
// INICIALIZACIÓN
// ============================================
document.addEventListener('DOMContentLoaded', () => {
  const animationSystem = new PremiumAnimationSystem();
  
  // Efectos adicionales
  gsap.registerPlugin(ScrollTrigger);
  
  // Animaciones al scroll
  gsap.utils.toArray('.section-title').forEach(title => {
    gsap.from(title, {
      scrollTrigger: {
        trigger: title,
        start: "top 80%",
        end: "bottom 20%",
        scrub: true
      },
      y: 100,
      opacity: 0,
      duration: 1
    });
  });
  
  // Parallax effects
  gsap.utils.toArray('.morphing-card').forEach(card => {
    gsap.from(card, {
      scrollTrigger: {
        trigger: card,
        start: "top 90%",
        end: "bottom 10%",
        scrub: 1
      },
      y: 50,
      rotateX: 15,
      opacity: 0.8
    });
  });
});

// ============================================
// EASTER EGG - MODO ARCOÍRIS
// ============================================
let konamiCode = [];
const konamiSequence = [
  'ArrowUp', 'ArrowUp', 'ArrowDown', 'ArrowDown',
  'ArrowLeft', 'ArrowRight', 'ArrowLeft', 'ArrowRight',
  'KeyB', 'KeyA'
];

document.addEventListener('keydown', (e) => {
  konamiCode.push(e.code);
  if (konamiCode.length > konamiSequence.length) {
    konamiCode.shift();
  }
  
  if (konamiCode.join(',') === konamiSequence.join(',')) {
    activateRainbowMode();
  }
});

function activateRainbowMode() {
  document.body.style.animation = 'rainbow 2s infinite';
  
  const style = document.createElement('style');
  style.textContent = `
    @keyframes rainbow {
      0% { filter: hue-rotate(0deg); }
      100% { filter: hue-rotate(360deg); }
    }
  `;
  document.head.appendChild(style);
  
  setTimeout(() => {
    document.body.style.animation = '';
    document.head.removeChild(style);
  }, 10000);
}

// ============================================
// OPTIMIZACIONES DE PERFORMANCE
// ============================================
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('animate');
    }
  });
});

document.querySelectorAll('.morphing-card, .insight-card, .color-sphere').forEach(el => {
  observer.observe(el);
});

// Throttle para eventos de scroll
function throttle(func, limit) {
  let inThrottle;
  return function() {
    const args = arguments;
    const context = this;
    if (!inThrottle) {
      func.apply(context, args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  }
}

// Aplicar throttle a eventos costosos
window.addEventListener('scroll', throttle(() => {
  // Efectos de scroll optimizados
}, 16));

window.addEventListener('resize', throttle(() => {
  // Redimensionar canvas
  const canvases = document.querySelectorAll('canvas');
  canvases.forEach(canvas => {
    if (canvas.id === 'particleSystem' || canvas.id === 'fluidCanvas' || canvas.id === 'shaderCanvas') {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    }
  });
}, 250));

console.log('🎨 PINTURAS BAMBI - Sistema de Animaciones Ultra-Premium Activado');
