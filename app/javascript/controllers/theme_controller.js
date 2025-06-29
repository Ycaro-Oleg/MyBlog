import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lightIcon", "darkIcon"]

  connect() {
    console.log("🎯 THEME CONTROLLER CONECTADO!");
    this.initializeTheme();
  }

  initializeTheme() {
    console.log("🔍 Inicializando tema...");
    
    // Verifica se já existe tema salvo
    const savedTheme = localStorage.getItem('color-theme');
    console.log("💾 Tema salvo:", savedTheme);
    
    if (savedTheme === 'dark') {
      console.log("🌙 Aplicando tema DARK");
      this.applyDarkTheme();
    } else {
      console.log("☀️ Aplicando tema LIGHT");
      this.applyLightTheme();
    }
  }

  toggleTheme() {
    console.log("🔄 BOTÃO CLICADO! Alternando tema...");
    
    const currentTheme = document.documentElement.classList.contains('dark') ? 'dark' : 'light';
    console.log("📊 Tema atual:", currentTheme);
    
    if (currentTheme === 'dark') {
      console.log("🌞 Mudando para LIGHT");
      this.applyLightTheme();
      localStorage.setItem('color-theme', 'light');
    } else {
      console.log("🌜 Mudando para DARK");
      this.applyDarkTheme();
      localStorage.setItem('color-theme', 'dark');
    }
  }

  applyDarkTheme() {
    console.log("🎨 Aplicando classes DARK...");
    document.documentElement.classList.add('dark');
    
    // Mostra ícone do sol (para voltar ao light)
    this.lightIconTarget.classList.remove('hidden');
    this.darkIconTarget.classList.add('hidden');
    
    console.log("✅ Classes do elemento HTML:", document.documentElement.className);
  }

  applyLightTheme() {
    console.log("🎨 Aplicando classes LIGHT...");
    document.documentElement.classList.remove('dark');
    
    // Mostra ícone da lua (para ir ao dark)
    this.lightIconTarget.classList.add('hidden');
    this.darkIconTarget.classList.remove('hidden');
    
    console.log("✅ Classes do elemento HTML:", document.documentElement.className);
  }
}