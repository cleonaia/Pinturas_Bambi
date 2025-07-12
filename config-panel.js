// ============================================
// PINTURAS BAMBI - PANEL DE CONFIGURACIÓN PREMIUM
// ============================================

class PremiumConfigPanel {
  constructor() {
    this.settings = {
      particles: {
        enabled: true,
        count: 100,
        speed: 1,
        color: '#ffd700'
      },
      effects: {
        hologram: true,
        glitch: true,
        neon: true,
        morphing: true
      },
      performance: {
        quality: 'high', // high, medium, low
        fps: 60,
        webgl: true
      },
      audio: {
        enabled: true,
        volume: 0.5,
        haptics: true
      },
      accessibility: {
        reducedMotion: false,
        highContrast: false
      }
    };
    
    this.init();
  }

  init() {
    this.loadSettings();
    this.createPanel();
    this.bindEvents();
    this.applySettings();
  }

  createPanel() {
    const panel = document.createElement('div');
    panel.id = 'premium-config-panel';
    panel.className = 'config-panel glass-effect';
    panel.innerHTML = `
      <div class="config-header">
        <h3>🎨 Configuración Premium</h3>
        <button class="toggle-panel" id="togglePanel">⚙️</button>
      </div>
      
      <div class="config-content">
        <div class="config-section">
          <h4>🌟 Partículas</h4>
          <div class="config-group">
            <label>
              <input type="checkbox" id="particlesEnabled" ${this.settings.particles.enabled ? 'checked' : ''}>
              Activar Partículas
            </label>
            <label>
              Cantidad: <span id="particleCountValue">${this.settings.particles.count}</span>
              <input type="range" id="particleCount" min="20" max="200" value="${this.settings.particles.count}">
            </label>
            <label>
              Velocidad: <span id="particleSpeedValue">${this.settings.particles.speed}</span>
              <input type="range" id="particleSpeed" min="0.1" max="3" step="0.1" value="${this.settings.particles.speed}">
            </label>
          </div>
        </div>

        <div class="config-section">
          <h4>✨ Efectos Visuales</h4>
          <div class="config-group">
            <label>
              <input type="checkbox" id="hologramEnabled" ${this.settings.effects.hologram ? 'checked' : ''}>
              Hologramas
            </label>
            <label>
              <input type="checkbox" id="glitchEnabled" ${this.settings.effects.glitch ? 'checked' : ''}>
              Efectos Glitch
            </label>
            <label>
              <input type="checkbox" id="neonEnabled" ${this.settings.effects.neon ? 'checked' : ''}>
              Luces Neón
            </label>
            <label>
              <input type="checkbox" id="morphingEnabled" ${this.settings.effects.morphing ? 'checked' : ''}>
              Morphing
            </label>
          </div>
        </div>

        <div class="config-section">
          <h4>⚡ Performance</h4>
          <div class="config-group">
            <label>
              Calidad:
              <select id="qualitySelect">
                <option value="high" ${this.settings.performance.quality === 'high' ? 'selected' : ''}>Alta</option>
                <option value="medium" ${this.settings.performance.quality === 'medium' ? 'selected' : ''}>Media</option>
                <option value="low" ${this.settings.performance.quality === 'low' ? 'selected' : ''}>Baja</option>
              </select>
            </label>
            <label>
              FPS Target: <span id="fpsValue">${this.settings.performance.fps}</span>
              <input type="range" id="fpsTarget" min="30" max="120" value="${this.settings.performance.fps}">
            </label>
            <label>
              <input type="checkbox" id="webglEnabled" ${this.settings.performance.webgl ? 'checked' : ''}>
              Aceleración WebGL
            </label>
          </div>
        </div>

        <div class="config-section">
          <h4>🔊 Audio & Hápticos</h4>
          <div class="config-group">
            <label>
              <input type="checkbox" id="audioEnabled" ${this.settings.audio.enabled ? 'checked' : ''}>
              Efectos de Audio
            </label>
            <label>
              Volumen: <span id="volumeValue">${Math.round(this.settings.audio.volume * 100)}%</span>
              <input type="range" id="volumeSlider" min="0" max="1" step="0.1" value="${this.settings.audio.volume}">
            </label>
            <label>
              <input type="checkbox" id="hapticsEnabled" ${this.settings.audio.haptics ? 'checked' : ''}>
              Vibración Háptica
            </label>
          </div>
        </div>

        <div class="config-section">
          <h4>♿ Accesibilidad</h4>
          <div class="config-group">
            <label>
              <input type="checkbox" id="reducedMotionEnabled" ${this.settings.accessibility.reducedMotion ? 'checked' : ''}>
              Reducir Movimiento
            </label>
            <label>
              <input type="checkbox" id="highContrastEnabled" ${this.settings.accessibility.highContrast ? 'checked' : ''}>
              Alto Contraste
            </label>
          </div>
        </div>

        <div class="config-actions">
          <button class="btn-reset" id="resetSettings">🔄 Restablecer</button>
          <button class="btn-save" id="saveSettings">💾 Guardar</button>
          <button class="btn-export" id="exportSettings">📤 Exportar</button>
        </div>
      </div>
    `;
    
    document.body.appendChild(panel);
  }

  bindEvents() {
    // Toggle panel
    document.getElementById('togglePanel').addEventListener('click', () => {
      const panel = document.getElementById('premium-config-panel');
      panel.classList.toggle('expanded');
    });

    // Particles
    document.getElementById('particlesEnabled').addEventListener('change', (e) => {
      this.settings.particles.enabled = e.target.checked;
      this.applySettings();
    });

    document.getElementById('particleCount').addEventListener('input', (e) => {
      this.settings.particles.count = parseInt(e.target.value);
      document.getElementById('particleCountValue').textContent = e.target.value;
      this.applySettings();
    });

    document.getElementById('particleSpeed').addEventListener('input', (e) => {
      this.settings.particles.speed = parseFloat(e.target.value);
      document.getElementById('particleSpeedValue').textContent = e.target.value;
      this.applySettings();
    });

    // Effects
    ['hologram', 'glitch', 'neon', 'morphing'].forEach(effect => {
      document.getElementById(`${effect}Enabled`).addEventListener('change', (e) => {
        this.settings.effects[effect] = e.target.checked;
        this.applySettings();
      });
    });

    // Performance
    document.getElementById('qualitySelect').addEventListener('change', (e) => {
      this.settings.performance.quality = e.target.value;
      this.applySettings();
    });

    document.getElementById('fpsTarget').addEventListener('input', (e) => {
      this.settings.performance.fps = parseInt(e.target.value);
      document.getElementById('fpsValue').textContent = e.target.value;
      this.applySettings();
    });

    document.getElementById('webglEnabled').addEventListener('change', (e) => {
      this.settings.performance.webgl = e.target.checked;
      this.applySettings();
    });

    // Audio
    document.getElementById('audioEnabled').addEventListener('change', (e) => {
      this.settings.audio.enabled = e.target.checked;
      this.applySettings();
    });

    document.getElementById('volumeSlider').addEventListener('input', (e) => {
      this.settings.audio.volume = parseFloat(e.target.value);
      document.getElementById('volumeValue').textContent = Math.round(e.target.value * 100) + '%';
      this.applySettings();
    });

    document.getElementById('hapticsEnabled').addEventListener('change', (e) => {
      this.settings.audio.haptics = e.target.checked;
      this.applySettings();
    });

    // Accessibility
    document.getElementById('reducedMotionEnabled').addEventListener('change', (e) => {
      this.settings.accessibility.reducedMotion = e.target.checked;
      this.applySettings();
    });

    document.getElementById('highContrastEnabled').addEventListener('change', (e) => {
      this.settings.accessibility.highContrast = e.target.checked;
      this.applySettings();
    });

    // Actions
    document.getElementById('resetSettings').addEventListener('click', () => {
      this.resetSettings();
    });

    document.getElementById('saveSettings').addEventListener('click', () => {
      this.saveSettings();
    });

    document.getElementById('exportSettings').addEventListener('click', () => {
      this.exportSettings();
    });
  }

  applySettings() {
    // Apply particle settings
    if (window.animationSystem) {
      window.animationSystem.updateParticles(this.settings.particles);
    }

    // Apply effect settings
    document.querySelectorAll('.hologram-line').forEach(line => {
      line.style.display = this.settings.effects.hologram ? 'block' : 'none';
    });

    document.querySelectorAll('.glitch-text').forEach(text => {
      text.style.animation = this.settings.effects.glitch ? 'glitch1 2s infinite' : 'none';
    });

    document.querySelectorAll('.neon-text').forEach(text => {
      text.style.animation = this.settings.effects.neon ? 'neonFlicker 2s ease-in-out infinite' : 'none';
    });

    // Apply performance settings
    const quality = this.settings.performance.quality;
    document.documentElement.style.setProperty('--performance-quality', quality);
    
    if (quality === 'low') {
      document.querySelectorAll('canvas').forEach(canvas => {
        canvas.style.opacity = '0.5';
      });
    } else {
      document.querySelectorAll('canvas').forEach(canvas => {
        canvas.style.opacity = '1';
      });
    }

    // Apply accessibility settings
    if (this.settings.accessibility.reducedMotion) {
      document.body.classList.add('reduced-motion');
    } else {
      document.body.classList.remove('reduced-motion');
    }

    if (this.settings.accessibility.highContrast) {
      document.body.classList.add('high-contrast');
    } else {
      document.body.classList.remove('high-contrast');
    }
  }

  loadSettings() {
    const saved = localStorage.getItem('bambiPremiumSettings');
    if (saved) {
      this.settings = { ...this.settings, ...JSON.parse(saved) };
    }
  }

  saveSettings() {
    localStorage.setItem('bambiPremiumSettings', JSON.stringify(this.settings));
    this.showNotification('✅ Configuración guardada');
  }

  resetSettings() {
    this.settings = {
      particles: { enabled: true, count: 100, speed: 1, color: '#ffd700' },
      effects: { hologram: true, glitch: true, neon: true, morphing: true },
      performance: { quality: 'high', fps: 60, webgl: true },
      audio: { enabled: true, volume: 0.5, haptics: true },
      accessibility: { reducedMotion: false, highContrast: false }
    };
    
    this.updatePanel();
    this.applySettings();
    this.showNotification('🔄 Configuración restablecida');
  }

  exportSettings() {
    const dataStr = JSON.stringify(this.settings, null, 2);
    const dataUri = 'data:application/json;charset=utf-8,'+ encodeURIComponent(dataStr);
    
    const exportFileDefaultName = 'bambi-premium-settings.json';
    
    const linkElement = document.createElement('a');
    linkElement.setAttribute('href', dataUri);
    linkElement.setAttribute('download', exportFileDefaultName);
    linkElement.click();
    
    this.showNotification('📤 Configuración exportada');
  }

  updatePanel() {
    // Update all form values
    document.getElementById('particlesEnabled').checked = this.settings.particles.enabled;
    document.getElementById('particleCount').value = this.settings.particles.count;
    document.getElementById('particleCountValue').textContent = this.settings.particles.count;
    document.getElementById('particleSpeed').value = this.settings.particles.speed;
    document.getElementById('particleSpeedValue').textContent = this.settings.particles.speed;
    
    // Update effects
    Object.keys(this.settings.effects).forEach(effect => {
      document.getElementById(`${effect}Enabled`).checked = this.settings.effects[effect];
    });
    
    // Update performance
    document.getElementById('qualitySelect').value = this.settings.performance.quality;
    document.getElementById('fpsTarget').value = this.settings.performance.fps;
    document.getElementById('fpsValue').textContent = this.settings.performance.fps;
    document.getElementById('webglEnabled').checked = this.settings.performance.webgl;
    
    // Update audio
    document.getElementById('audioEnabled').checked = this.settings.audio.enabled;
    document.getElementById('volumeSlider').value = this.settings.audio.volume;
    document.getElementById('volumeValue').textContent = Math.round(this.settings.audio.volume * 100) + '%';
    document.getElementById('hapticsEnabled').checked = this.settings.audio.haptics;
    
    // Update accessibility
    document.getElementById('reducedMotionEnabled').checked = this.settings.accessibility.reducedMotion;
    document.getElementById('highContrastEnabled').checked = this.settings.accessibility.highContrast;
  }

  showNotification(message) {
    const notification = document.createElement('div');
    notification.className = 'premium-notification';
    notification.textContent = message;
    notification.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      background: linear-gradient(45deg, #003366, #ffd700);
      color: white;
      padding: 12px 24px;
      border-radius: 25px;
      font-weight: bold;
      z-index: 10000;
      transform: translateX(300px);
      transition: transform 0.3s ease;
      box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
      notification.style.transform = 'translateX(0)';
    }, 100);
    
    setTimeout(() => {
      notification.style.transform = 'translateX(300px)';
      setTimeout(() => {
        document.body.removeChild(notification);
      }, 300);
    }, 3000);
  }
}

// CSS para el panel de configuración
const configPanelCSS = `
.config-panel {
  position: fixed;
  top: 20px;
  right: 20px;
  width: 320px;
  background: rgba(0, 51, 102, 0.95);
  backdrop-filter: blur(15px);
  border-radius: 20px;
  border: 1px solid rgba(255, 215, 0, 0.3);
  color: white;
  font-family: 'Montserrat', sans-serif;
  z-index: 9999;
  transform: translateX(280px);
  transition: transform 0.3s ease;
  box-shadow: 0 20px 40px rgba(0,0,0,0.3);
}

.config-panel.expanded {
  transform: translateX(0);
}

.config-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid rgba(255, 215, 0, 0.2);
}

.config-header h3 {
  margin: 0;
  font-size: 1.2rem;
  background: linear-gradient(45deg, #ffd700, #ffed4e);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.toggle-panel {
  background: linear-gradient(45deg, #ffd700, #ffed4e);
  border: none;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  font-size: 1.2rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.toggle-panel:hover {
  transform: scale(1.1) rotate(90deg);
}

.config-content {
  padding: 20px;
  max-height: 400px;
  overflow-y: auto;
}

.config-section {
  margin-bottom: 20px;
}

.config-section h4 {
  margin: 0 0 10px 0;
  font-size: 1rem;
  color: #ffd700;
}

.config-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.config-group label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.9rem;
  cursor: pointer;
}

.config-group input[type="checkbox"] {
  accent-color: #ffd700;
}

.config-group input[type="range"] {
  flex: 1;
  margin-left: 10px;
}

.config-group select {
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 215, 0, 0.3);
  border-radius: 5px;
  color: white;
  padding: 5px;
}

.config-actions {
  display: flex;
  gap: 10px;
  margin-top: 20px;
}

.config-actions button {
  flex: 1;
  padding: 10px;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  font-weight: bold;
  transition: all 0.3s ease;
}

.btn-reset {
  background: linear-gradient(45deg, #ff6b6b, #ff8e8e);
  color: white;
}

.btn-save {
  background: linear-gradient(45deg, #4ecdc4, #44a08d);
  color: white;
}

.btn-export {
  background: linear-gradient(45deg, #ffd700, #ffed4e);
  color: #003366;
}

.config-actions button:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0,0,0,0.3);
}

/* Reduced Motion */
.reduced-motion * {
  animation-duration: 0.01ms !important;
  animation-iteration-count: 1 !important;
  transition-duration: 0.01ms !important;
}

/* High Contrast */
.high-contrast {
  filter: contrast(150%) brightness(120%);
}

.high-contrast .config-panel {
  background: rgba(0, 0, 0, 0.95);
  border: 2px solid #ffd700;
}

/* Scrollbar styling */
.config-content::-webkit-scrollbar {
  width: 6px;
}

.config-content::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 3px;
}

.config-content::-webkit-scrollbar-thumb {
  background: #ffd700;
  border-radius: 3px;
}

.config-content::-webkit-scrollbar-thumb:hover {
  background: #ffed4e;
}

@media (max-width: 768px) {
  .config-panel {
    width: 280px;
    transform: translateX(240px);
  }
  
  .config-content {
    max-height: 300px;
  }
}
`;

// Insertar CSS
const style = document.createElement('style');
style.textContent = configPanelCSS;
document.head.appendChild(style);

// Inicializar panel de configuración
document.addEventListener('DOMContentLoaded', () => {
  window.premiumConfig = new PremiumConfigPanel();
});

export default PremiumConfigPanel;
