<template>
  <div class="landing-root">
    <!-- Navbar -->
    <nav class="landing-nav" :class="{ 'nav-scrolled': scrolled }">
      <div class="nav-inner">
        <a href="/" class="nav-logo">
          <div class="logo-icon">
            <svg width="20" height="20" viewBox="0 0 32 32" fill="none">
              <path d="M5 16 L16 5 L27 16 L16 27 Z" fill="white" opacity="0.9"/>
              <circle cx="16" cy="16" r="5" fill="white"/>
              <circle cx="16" cy="16" r="2" fill="black"/>
            </svg>
          </div>
          <span class="logo-text">AssessAI</span>
        </a>
        <div class="nav-links">
          <a href="#features" class="nav-link">Fitur</a>
          <a href="#how-it-works" class="nav-link">Cara Kerja</a>
          <a href="#technology" class="nav-link">Teknologi</a>
        </div>
        <div class="nav-actions">
          <RouterLink to="/login" class="btn-nav-outline">Masuk</RouterLink>
          <RouterLink to="/register" class="btn-nav-primary">Mulai Gratis</RouterLink>
        </div>
        <!-- Mobile menu toggle -->
        <button class="mobile-menu-btn" @click="mobileMenuOpen = !mobileMenuOpen">
          <span></span><span></span><span></span>
        </button>
      </div>
      <!-- Mobile menu -->
      <div class="mobile-menu" :class="{ open: mobileMenuOpen }">
        <a href="#features" class="mobile-link" @click="mobileMenuOpen = false">Fitur</a>
        <a href="#how-it-works" class="mobile-link" @click="mobileMenuOpen = false">Cara Kerja</a>
        <a href="#technology" class="mobile-link" @click="mobileMenuOpen = false">Teknologi</a>
        <RouterLink to="/login" class="mobile-link" @click="mobileMenuOpen = false">Masuk</RouterLink>
        <RouterLink to="/register" class="btn-nav-primary w-full text-center mt-2" @click="mobileMenuOpen = false">Mulai Gratis</RouterLink>
      </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
      <div class="hero-bg-grid"></div>
      <div class="hero-bg-gradient"></div>

      <div class="hero-content">
        <div class="hero-badge">
          <span class="badge-dot"></span>
          Didukung AI · CNN-LSTM + Whisper STT
        </div>

        <h1 class="hero-title">
          Nilai Presentasi<br>
          <span class="hero-title-accent">Lebih Cerdas</span><br>
          dengan AI
        </h1>

        <p class="hero-subtitle">
          AssessAI menganalisis rekaman audio presentasi mahasiswa secara otomatis —
          menilai emosi suara, artikulasi, intonasi, dan transkripsi menggunakan
          kecerdasan buatan mutakhir.
        </p>

        <div class="hero-actions">
          <RouterLink to="/register" class="btn-hero-primary">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
              <path d="M3 8h10M9 4l4 4-4 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            Mulai Sekarang — Gratis
          </RouterLink>
          <a href="#how-it-works" class="btn-hero-secondary">
            Lihat Cara Kerja
          </a>
        </div>

        <div class="hero-stats">
          <div class="hero-stat">
            <span class="hero-stat-num">5</span>
            <span class="hero-stat-label">Kelas Emosi</span>
          </div>
          <div class="hero-stat-divider"></div>
          <div class="hero-stat">
            <span class="hero-stat-num">4</span>
            <span class="hero-stat-label">Aspek Penilaian</span>
          </div>
          <div class="hero-stat-divider"></div>
          <div class="hero-stat">
            <span class="hero-stat-num">&lt;60s</span>
            <span class="hero-stat-label">Waktu Analisis</span>
          </div>
        </div>
      </div>

      <!-- Hero mockup card -->
      <div class="hero-mockup" ref="heroMockup">
        <div class="mockup-card">
          <div class="mockup-header">
            <div class="mockup-dots">
              <span></span><span></span><span></span>
            </div>
            <span class="mockup-title">Hasil Analisis</span>
          </div>
          <div class="mockup-body">
            <div class="mockup-score-row">
              <span class="mockup-score-label">Skor Keseluruhan</span>
              <span class="mockup-score-value">82.4</span>
            </div>
            <div class="mockup-bars">
              <div class="mockup-bar-item" v-for="item in mockupBars" :key="item.label">
                <div class="mockup-bar-label">
                  <span>{{ item.label }}</span>
                  <span>{{ item.value }}%</span>
                </div>
                <div class="mockup-bar-track">
                  <div
                    class="mockup-bar-fill"
                    :style="{ width: animateBars ? item.value + '%' : '0%', background: item.color }"
                  ></div>
                </div>
              </div>
            </div>
            <div class="mockup-emotion-row">
              <span class="mockup-emotion-label">Emosi Terdeteksi</span>
              <span class="mockup-emotion-badge">Percaya Diri</span>
            </div>
            <div class="mockup-transcription">
              <span class="mockup-trans-label">Transkripsi</span>
              <p class="mockup-trans-text">"Selamat pagi, perkenalkan saya akan mempresentasikan hasil penelitian mengenai..."</p>
            </div>
          </div>
        </div>
        <!-- Floating badges -->
        <div class="float-badge float-badge-1">
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><circle cx="7" cy="7" r="7" fill="#22C55E"/><path d="M4 7l2 2 4-4" stroke="white" stroke-width="1.5" stroke-linecap="round"/></svg>
          Analisis Selesai
        </div>
        <div class="float-badge float-badge-2">
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M7 1l1.8 3.6L13 5.5l-3 2.9.7 4.1L7 10.5 3.3 12.5l.7-4.1L1 5.5l4.2-.9L7 1z" fill="#F59E0B"/></svg>
          Skor Tinggi
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="features-section">
      <div class="section-container">
        <div class="section-header">
          <span class="section-tag">Fitur Utama</span>
          <h2 class="section-title">Semua yang Anda Butuhkan<br>untuk Evaluasi Presentasi</h2>
          <p class="section-subtitle">
            Platform lengkap untuk mahasiswa berlatih dan dosen memantau perkembangan.
          </p>
        </div>

        <div class="features-grid">
          <div class="feature-card" v-for="feature in features" :key="feature.title">
            <div class="feature-icon" :style="{ background: feature.iconBg }">
              <span v-html="feature.icon"></span>
            </div>
            <h3 class="feature-title">{{ feature.title }}</h3>
            <p class="feature-desc">{{ feature.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- How It Works Section -->
    <section id="how-it-works" class="how-section">
      <div class="section-container">
        <div class="section-header">
          <span class="section-tag">Cara Kerja</span>
          <h2 class="section-title">Tiga Langkah Menuju<br>Presentasi yang Lebih Baik</h2>
        </div>

        <div class="steps-container">
          <div class="step-item" v-for="(step, i) in steps" :key="i">
            <div class="step-number">{{ String(i + 1).padStart(2, '0') }}</div>
            <div class="step-content">
              <h3 class="step-title">{{ step.title }}</h3>
              <p class="step-desc">{{ step.desc }}</p>
            </div>
            <div class="step-visual" v-html="step.visual"></div>
            <div class="step-connector" v-if="i < steps.length - 1"></div>
          </div>
        </div>
      </div>
    </section>

    <!-- Technology Section -->
    <section id="technology" class="tech-section">
      <div class="section-container">
        <div class="section-header">
          <span class="section-tag">Teknologi</span>
          <h2 class="section-title">Dibangun dengan Teknologi<br>AI Terdepan</h2>
          <p class="section-subtitle">
            Kombinasi model deep learning CNN-LSTM untuk klasifikasi emosi dan Whisper untuk transkripsi akurat.
          </p>
        </div>

        <div class="tech-grid">
          <div class="tech-card" v-for="tech in techStack" :key="tech.name">
            <div class="tech-icon">{{ tech.emoji }}</div>
            <div class="tech-info">
              <span class="tech-name">{{ tech.name }}</span>
              <span class="tech-role">{{ tech.role }}</span>
            </div>
          </div>
        </div>

        <!-- Model pipeline visual -->
        <div class="pipeline-card">
          <div class="pipeline-title">Pipeline Analisis AI</div>
          <div class="pipeline-steps">
            <div class="pipe-step" v-for="(p, i) in pipeline" :key="i">
              <div class="pipe-icon">{{ p.icon }}</div>
              <div class="pipe-label">{{ p.label }}</div>
              <div class="pipe-arrow" v-if="i < pipeline.length - 1">→</div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Role Section -->
    <section class="role-section">
      <div class="section-container">
        <div class="roles-grid">
          <div class="role-card role-mahasiswa">
            <div class="role-icon">🎓</div>
            <h3 class="role-title">Untuk Mahasiswa</h3>
            <ul class="role-features">
              <li v-for="f in mahasiswaFeatures" :key="f">
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><circle cx="7" cy="7" r="7" fill="black"/><path d="M4 7l2 2 4-4" stroke="white" stroke-width="1.5" stroke-linecap="round"/></svg>
                {{ f }}
              </li>
            </ul>
            <RouterLink to="/register" class="btn-role">Daftar sebagai Mahasiswa</RouterLink>
          </div>

          <div class="role-card role-dosen">
            <div class="role-icon">👨‍🏫</div>
            <h3 class="role-title">Untuk Dosen</h3>
            <ul class="role-features">
              <li v-for="f in dosenFeatures" :key="f">
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><circle cx="7" cy="7" r="7" fill="white"/><path d="M4 7l2 2 4-4" stroke="black" stroke-width="1.5" stroke-linecap="round"/></svg>
                {{ f }}
              </li>
            </ul>
            <RouterLink to="/login" class="btn-role-outline">Masuk sebagai Dosen</RouterLink>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
      <div class="cta-grid-bg"></div>
      <div class="cta-content">
        <h2 class="cta-title">Siap Meningkatkan Kualitas<br>Presentasi Anda?</h2>
        <p class="cta-subtitle">
          Bergabunglah dan mulai evaluasi presentasi berbasis AI secara gratis.
        </p>
        <div class="cta-actions">
          <RouterLink to="/register" class="btn-cta-primary">
            Mulai Sekarang — Gratis
          </RouterLink>
          <RouterLink to="/login" class="btn-cta-secondary">
            Sudah punya akun? Masuk
          </RouterLink>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="landing-footer">
      <div class="footer-inner">
        <div class="footer-brand">
          <div class="footer-logo">
            <div class="logo-icon logo-icon-sm">
              <svg width="14" height="14" viewBox="0 0 32 32" fill="none">
                <path d="M5 16 L16 5 L27 16 L16 27 Z" fill="white" opacity="0.9"/>
                <circle cx="16" cy="16" r="5" fill="white"/>
                <circle cx="16" cy="16" r="2" fill="black"/>
              </svg>
            </div>
            <span>AssessAI</span>
          </div>
          <p class="footer-tagline">AI-Based Student Presentation Assessment</p>
        </div>
        <div class="footer-links">
          <a href="#features">Fitur</a>
          <a href="#how-it-works">Cara Kerja</a>
          <a href="#technology">Teknologi</a>
          <RouterLink to="/login">Masuk</RouterLink>
          <RouterLink to="/register">Daftar</RouterLink>
        </div>
        <p class="footer-copy">© 2026 AssessAI. Capstone Project.</p>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { RouterLink } from 'vue-router'

const scrolled = ref(false)
const mobileMenuOpen = ref(false)
const animateBars = ref(false)

function handleScroll() {
  scrolled.value = window.scrollY > 20
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
  // Trigger bar animation after mount
  setTimeout(() => { animateBars.value = true }, 600)

  // Intersection Observer for scroll animations
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach(el => el.target.classList.add('in-view'))
    },
    { threshold: 0.1 }
  )
  document.querySelectorAll('.feature-card, .step-item, .tech-card, .role-card').forEach(el => {
    observer.observe(el)
  })
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})

const mockupBars = [
  { label: 'Emosi Suara', value: 88, color: '#111111' },
  { label: 'Artikulasi', value: 76, color: '#4B5563' },
  { label: 'Intonasi', value: 85, color: '#9CA3AF' },
  { label: 'Sentimen', value: 72, color: '#D1D5DB' },
]

const features = [
  {
    icon: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z"/><path d="M19 10v2a7 7 0 0 1-14 0v-2M12 19v4M8 23h8"/></svg>`,
    iconBg: '#F9FAFB',
    title: 'Deteksi Emosi Suara',
    desc: 'Model CNN-LSTM yang dilatih khusus mengklasifikasikan 5 kelas emosi: netral, percaya diri, terkejut, tidak nyaman, dan kecewa.',
  },
  {
    icon: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>`,
    iconBg: '#F9FAFB',
    title: 'Penilaian Artikulasi',
    desc: 'Menganalisis kejelasan pengucapan kata berdasarkan RMS energy, zero-crossing rate, dan spectral centroid.',
  },
  {
    icon: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M3 18v-6a9 9 0 0 1 18 0v6"/><path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/></svg>`,
    iconBg: '#F9FAFB',
    title: 'Analisis Intonasi',
    desc: 'Mengukur variasi nada suara menggunakan analisis pitch (F0) untuk menilai dinamika presentasi.',
  },
  {
    icon: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>`,
    iconBg: '#F9FAFB',
    title: 'Transkripsi Otomatis',
    desc: 'Whisper AI mengubah ucapan menjadi teks secara akurat dalam Bahasa Indonesia tanpa koneksi internet.',
  },
  {
    icon: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18M9 21V9"/></svg>`,
    iconBg: '#F9FAFB',
    title: 'Dashboard Real-time',
    desc: 'Pantau perkembangan skor dari waktu ke waktu. Lihat tren peningkatan dan identifikasi area yang perlu dilatih.',
  },
  {
    icon: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>`,
    iconBg: '#F9FAFB',
    title: 'Monitoring Dosen',
    desc: 'Dosen dapat memantau statistik seluruh mahasiswa, rata-rata skor, dan perkembangan setiap individu.',
  },
]

const steps = [
  {
    title: 'Upload Audio Presentasi',
    desc: 'Rekam presentasi Anda dan upload file .wav atau .mp3 melalui antarmuka drag-and-drop yang mudah digunakan.',
    visual: `<svg width="48" height="48" viewBox="0 0 48 48" fill="none"><rect width="48" height="48" rx="12" fill="#F9FAFB"/><path d="M24 14v12M18 20l6-6 6 6" stroke="#111" stroke-width="2" stroke-linecap="round"/><path d="M14 34h20" stroke="#111" stroke-width="2" stroke-linecap="round"/></svg>`,
  },
  {
    title: 'AI Menganalisis Secara Otomatis',
    desc: 'Model CNN-LSTM mengekstrak fitur MFCC dari audio dan Whisper mentranskripsikan ucapan menjadi teks.',
    visual: `<svg width="48" height="48" viewBox="0 0 48 48" fill="none"><rect width="48" height="48" rx="12" fill="#F9FAFB"/><circle cx="24" cy="24" r="8" stroke="#111" stroke-width="2"/><path d="M24 16v-4M24 36v-4M16 24h-4M36 24h-4" stroke="#111" stroke-width="2" stroke-linecap="round"/></svg>`,
  },
  {
    title: 'Terima Hasil & Umpan Balik',
    desc: 'Lihat skor detail per aspek, grafik emosi, dan umpan balik otomatis dalam Bahasa Indonesia untuk perbaikan.',
    visual: `<svg width="48" height="48" viewBox="0 0 48 48" fill="none"><rect width="48" height="48" rx="12" fill="#F9FAFB"/><path d="M14 32l6-8 5 5 5-10 4 6" stroke="#111" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>`,
  },
]

const techStack = [
  { emoji: '', name: 'CNN-LSTM', role: 'Klasifikasi Emosi Suara' },
  { emoji: '', name: 'Whisper AI', role: 'Speech-to-Text Bahasa Indonesia' },
  { emoji: '', name: 'Librosa', role: 'Ekstraksi Fitur MFCC Audio' },
  { emoji: '', name: 'FastAPI', role: 'AI Inference Server' },
  { emoji: '', name: 'NestJS', role: 'REST API Backend' },
  { emoji: '', name: 'Vue 3', role: 'Frontend Framework' },
]

const pipeline = [
  { icon: '', label: 'Audio Input' },
  { icon: '', label: 'Noise Reduction' },
  { icon: '', label: 'MFCC Extraction' },
  { icon: '', label: 'CNN-LSTM' },
  { icon: '', label: 'Whisper STT' },
  { icon: '', label: 'Hasil & Skor' },
]

const mahasiswaFeatures = [
  'Upload audio .wav / .mp3',
  'Skor otomatis 0–100',
  'Deteksi 5 kelas emosi',
  'Transkripsi teks otomatis',
  'Umpan balik per aspek',
  'Riwayat semua latihan',
]

const dosenFeatures = [
  'Monitoring semua mahasiswa',
  'Rata-rata skor tiap mahasiswa',
  'Perbandingan antar mahasiswa',
  'Kelola bobot rubrik penilaian',
  'Akses dashboard statistik',
  'Ekspor data (coming soon)',
]
</script>

<style scoped>
/* =====================
   ROOT & NAV
   ===================== */
.landing-root {
  font-family: 'Inter', sans-serif;
  color: #111111;
  background: #ffffff;
  overflow-x: hidden;
}

.landing-nav {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  transition: all 0.3s ease;
  border-bottom: 1px solid transparent;
}

.nav-scrolled {
  background: rgba(255,255,255,0.92);
  backdrop-filter: blur(12px);
  border-color: #E5E7EB;
  box-shadow: 0 1px 8px rgba(0,0,0,0.06);
}

.nav-inner {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
  height: 64px;
  display: flex;
  align-items: center;
  gap: 32px;
}

.nav-logo {
  display: flex;
  align-items: center;
  gap: 10px;
  text-decoration: none;
  font-weight: 700;
  font-size: 16px;
  color: #111111;
  flex-shrink: 0;
}

.logo-icon {
  width: 34px;
  height: 34px;
  background: #111111;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.logo-icon-sm {
  width: 26px;
  height: 26px;
  border-radius: 6px;
}

.logo-text { letter-spacing: -0.02em; }

.nav-links {
  display: flex;
  gap: 4px;
  flex: 1;
}

.nav-link {
  padding: 6px 14px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  color: #4B5563;
  text-decoration: none;
  transition: all 0.2s;
}
.nav-link:hover { color: #111111; background: #F9FAFB; }

.nav-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.btn-nav-outline {
  padding: 7px 16px;
  border: 1px solid #E5E7EB;
  border-radius: 7px;
  font-size: 14px;
  font-weight: 500;
  color: #111111;
  text-decoration: none;
  transition: all 0.2s;
  background: transparent;
}
.btn-nav-outline:hover { border-color: #111111; background: #F9FAFB; }

.btn-nav-primary {
  padding: 7px 16px;
  background: #111111;
  color: #ffffff;
  border-radius: 7px;
  font-size: 14px;
  font-weight: 500;
  text-decoration: none;
  transition: all 0.2s;
  border: 1px solid #111111;
}
.btn-nav-primary:hover { background: #000000; transform: translateY(-1px); }

.mobile-menu-btn {
  display: none;
  flex-direction: column;
  gap: 4px;
  padding: 8px;
  background: none;
  border: none;
  cursor: pointer;
  margin-left: auto;
}
.mobile-menu-btn span {
  display: block;
  width: 22px;
  height: 2px;
  background: #111111;
  border-radius: 2px;
  transition: all 0.2s;
}

.mobile-menu {
  display: none;
  flex-direction: column;
  gap: 4px;
  padding: 12px 24px 20px;
  background: white;
  border-top: 1px solid #E5E7EB;
}
.mobile-menu.open { display: flex; }
.mobile-link {
  padding: 10px 14px;
  font-size: 15px;
  font-weight: 500;
  color: #4B5563;
  text-decoration: none;
  border-radius: 8px;
  transition: all 0.2s;
}
.mobile-link:hover { color: #111; background: #F9FAFB; }

/* =====================
   HERO
   ===================== */
.hero-section {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  padding: 120px 24px 80px;
  overflow: hidden;
  text-align: center;
}

.hero-bg-grid {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(0,0,0,0.04) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0,0,0,0.04) 1px, transparent 1px);
  background-size: 48px 48px;
  mask-image: radial-gradient(ellipse 80% 80% at 50% 50%, black 40%, transparent 100%);
}

.hero-bg-gradient {
  position: absolute;
  inset: 0;
  background: radial-gradient(ellipse 60% 50% at 50% 0%, rgba(0,0,0,0.04) 0%, transparent 70%);
}

.hero-content {
  position: relative;
  z-index: 2;
  max-width: 720px;
  margin: 0 auto;
  animation: fadeInUp 0.8s ease-out;
}

.hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 6px 14px;
  background: #F9FAFB;
  border: 1px solid #E5E7EB;
  border-radius: 100px;
  font-size: 12px;
  font-weight: 500;
  color: #4B5563;
  margin-bottom: 28px;
}

.badge-dot {
  width: 7px;
  height: 7px;
  background: #22C55E;
  border-radius: 50%;
  animation: pulse-dot 2s infinite;
}

@keyframes pulse-dot {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.6; transform: scale(0.8); }
}

.hero-title {
  font-size: clamp(44px, 7vw, 80px);
  font-weight: 900;
  line-height: 1.05;
  letter-spacing: -0.04em;
  color: #111111;
  margin-bottom: 24px;
}

.hero-title-accent {
  background: linear-gradient(135deg, #111111 0%, #4B5563 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  position: relative;
}

.hero-subtitle {
  font-size: 17px;
  line-height: 1.7;
  color: #4B5563;
  max-width: 540px;
  margin: 0 auto 36px;
}

.hero-actions {
  display: flex;
  gap: 12px;
  justify-content: center;
  flex-wrap: wrap;
  margin-bottom: 52px;
}

.btn-hero-primary {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 13px 24px;
  background: #111111;
  color: white;
  border-radius: 10px;
  font-size: 15px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.25s;
  box-shadow: 0 4px 14px rgba(0,0,0,0.15);
}
.btn-hero-primary:hover {
  background: #000000;
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.2);
}

.btn-hero-secondary {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 13px 24px;
  background: transparent;
  color: #4B5563;
  border: 1px solid #E5E7EB;
  border-radius: 10px;
  font-size: 15px;
  font-weight: 500;
  text-decoration: none;
  transition: all 0.25s;
}
.btn-hero-secondary:hover { border-color: #111111; color: #111111; background: #F9FAFB; }

.hero-stats {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 32px;
}

.hero-stat { text-align: center; }
.hero-stat-num {
  display: block;
  font-size: 28px;
  font-weight: 800;
  letter-spacing: -0.04em;
  color: #111111;
}
.hero-stat-label {
  display: block;
  font-size: 12px;
  font-weight: 500;
  color: #9CA3AF;
  margin-top: 2px;
}

.hero-stat-divider {
  width: 1px;
  height: 40px;
  background: #E5E7EB;
}

/* Hero mockup */
.hero-mockup {
  position: relative;
  margin-top: 64px;
  z-index: 2;
  animation: fadeInUp 0.8s ease-out 0.3s both;
}

.mockup-card {
  background: white;
  border: 1px solid #E5E7EB;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.1), 0 4px 16px rgba(0,0,0,0.06);
  width: min(460px, 90vw);
  overflow: hidden;
}

.mockup-header {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 20px;
  border-bottom: 1px solid #F3F4F6;
  background: #F9FAFB;
}

.mockup-dots {
  display: flex;
  gap: 6px;
}
.mockup-dots span {
  width: 10px; height: 10px;
  border-radius: 50%;
  background: #E5E7EB;
}
.mockup-dots span:nth-child(1) { background: #FC5C65; }
.mockup-dots span:nth-child(2) { background: #FED330; }
.mockup-dots span:nth-child(3) { background: #26de81; }

.mockup-title { font-size: 13px; font-weight: 600; color: #4B5563; }

.mockup-body { padding: 20px; display: flex; flex-direction: column; gap: 16px; }

.mockup-score-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.mockup-score-label { font-size: 13px; font-weight: 600; color: #4B5563; }
.mockup-score-value { font-size: 32px; font-weight: 900; letter-spacing: -0.04em; color: #111111; }

.mockup-bars { display: flex; flex-direction: column; gap: 10px; }
.mockup-bar-item { display: flex; flex-direction: column; gap: 4px; }
.mockup-bar-label { display: flex; justify-content: space-between; font-size: 12px; color: #4B5563; font-weight: 500; }
.mockup-bar-track { height: 6px; background: #F3F4F6; border-radius: 100px; overflow: hidden; }
.mockup-bar-fill { height: 100%; border-radius: 100px; transition: width 1.2s cubic-bezier(0.4, 0, 0.2, 1); }

.mockup-emotion-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 12px;
  background: #F9FAFB;
  border-radius: 8px;
}
.mockup-emotion-label { font-size: 12px; color: #4B5563; font-weight: 500; }
.mockup-emotion-badge {
  font-size: 12px;
  font-weight: 600;
  color: #111111;
  background: #ECFDF5;
  padding: 3px 10px;
  border-radius: 100px;
  border: 1px solid #D1FAE5;
}

.mockup-transcription { padding: 12px; background: #F9FAFB; border-radius: 8px; }
.mockup-trans-label { font-size: 10px; font-weight: 700; color: #9CA3AF; text-transform: uppercase; letter-spacing: 0.08em; display: block; margin-bottom: 6px; }
.mockup-trans-text { font-size: 12px; color: #4B5563; line-height: 1.6; margin: 0; font-style: italic; }

.float-badge {
  position: absolute;
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 14px;
  background: white;
  border: 1px solid #E5E7EB;
  border-radius: 100px;
  font-size: 12px;
  font-weight: 600;
  color: #111111;
  box-shadow: 0 4px 16px rgba(0,0,0,0.1);
}

.float-badge-1 {
  top: -16px;
  right: -24px;
  animation: float1 3s ease-in-out infinite;
}
.float-badge-2 {
  bottom: 40px;
  left: -24px;
  animation: float2 3.5s ease-in-out infinite;
}

@keyframes float1 {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-8px); }
}
@keyframes float2 {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(6px); }
}

/* =====================
   SECTIONS COMMON
   ===================== */
.section-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 100px 24px;
}

.section-header {
  text-align: center;
  margin-bottom: 64px;
}

.section-tag {
  display: inline-block;
  padding: 4px 14px;
  background: #F9FAFB;
  border: 1px solid #E5E7EB;
  border-radius: 100px;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #4B5563;
  margin-bottom: 16px;
}

.section-title {
  font-size: clamp(28px, 4vw, 44px);
  font-weight: 800;
  letter-spacing: -0.03em;
  color: #111111;
  margin-bottom: 16px;
  line-height: 1.15;
}

.section-subtitle {
  font-size: 16px;
  color: #4B5563;
  line-height: 1.7;
  max-width: 520px;
  margin: 0 auto;
}

/* =====================
   FEATURES
   ===================== */
.features-section { background: #F9FAFB; }

.features-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.feature-card {
  background: white;
  border: 1px solid #E5E7EB;
  border-radius: 14px;
  padding: 28px;
  transition: all 0.3s ease;
  opacity: 0;
  transform: translateY(20px);
}
.feature-card.in-view { opacity: 1; transform: translateY(0); }
.feature-card:hover {
  border-color: #111111;
  box-shadow: 0 8px 32px rgba(0,0,0,0.08);
  transform: translateY(-4px);
}

.feature-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16px;
  border: 1px solid #E5E7EB;
  color: #111111;
}

.feature-title {
  font-size: 16px;
  font-weight: 700;
  color: #111111;
  margin-bottom: 8px;
  letter-spacing: -0.02em;
}

.feature-desc {
  font-size: 14px;
  color: #4B5563;
  line-height: 1.65;
}

/* =====================
   HOW IT WORKS
   ===================== */
.how-section { background: white; }

.steps-container {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.step-item {
  display: grid;
  grid-template-columns: 80px 1fr auto;
  align-items: start;
  gap: 24px;
  padding: 40px 0;
  border-bottom: 1px solid #F3F4F6;
  position: relative;
  opacity: 0;
  transform: translateX(-16px);
  transition: all 0.4s ease;
}
.step-item.in-view { opacity: 1; transform: translateX(0); }
.step-item:last-child { border-bottom: none; }

.step-number {
  font-size: 48px;
  font-weight: 900;
  letter-spacing: -0.05em;
  color: #E5E7EB;
  line-height: 1;
  padding-top: 4px;
}

.step-content { padding-top: 4px; }
.step-title {
  font-size: 20px;
  font-weight: 700;
  color: #111111;
  margin-bottom: 8px;
  letter-spacing: -0.02em;
}
.step-desc { font-size: 14px; color: #4B5563; line-height: 1.7; }

.step-visual { flex-shrink: 0; }

/* =====================
   TECHNOLOGY
   ===================== */
.tech-section { background: #F9FAFB; }

.tech-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 40px;
}

.tech-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px;
  background: white;
  border: 1px solid #E5E7EB;
  border-radius: 12px;
  transition: all 0.25s;
  opacity: 0;
  transform: translateY(16px);
}
.tech-card.in-view { opacity: 1; transform: translateY(0); }
.tech-card:hover { border-color: #111111; transform: translateY(-3px); }

.tech-icon { font-size: 28px; flex-shrink: 0; }
.tech-info { display: flex; flex-direction: column; gap: 2px; }
.tech-name { font-size: 15px; font-weight: 700; color: #111111; }
.tech-role { font-size: 12px; color: #9CA3AF; font-weight: 500; }

.pipeline-card {
  background: #111111;
  border-radius: 14px;
  padding: 28px 32px;
  color: white;
}

.pipeline-title {
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #9CA3AF;
  margin-bottom: 24px;
}

.pipeline-steps {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.pipe-step {
  display: flex;
  align-items: center;
  gap: 8px;
}

.pipe-icon { font-size: 20px; }
.pipe-label {
  font-size: 13px;
  font-weight: 600;
  color: #E5E7EB;
  white-space: nowrap;
}
.pipe-arrow {
  font-size: 18px;
  color: #4B5563;
  margin: 0 4px;
}

/* =====================
   ROLES
   ===================== */
.role-section { background: white; }

.roles-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
  max-width: 900px;
  margin: 0 auto;
}

.role-card {
  border-radius: 16px;
  padding: 36px;
  opacity: 0;
  transform: translateY(20px);
  transition: all 0.4s ease;
}
.role-card.in-view { opacity: 1; transform: translateY(0); }

.role-mahasiswa {
  background: #F9FAFB;
  border: 1px solid #E5E7EB;
}

.role-dosen {
  background: #111111;
  border: 1px solid #111111;
  color: white;
}

.role-icon { font-size: 36px; margin-bottom: 16px; display: block; }

.role-title {
  font-size: 20px;
  font-weight: 800;
  letter-spacing: -0.02em;
  margin-bottom: 20px;
}
.role-dosen .role-title { color: white; }

.role-features {
  list-style: none;
  padding: 0;
  margin: 0 0 28px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.role-features li {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  font-weight: 500;
  color: #4B5563;
}
.role-dosen .role-features li { color: #D1D5DB; }

.btn-role {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 11px 20px;
  background: #111111;
  color: white;
  border-radius: 9px;
  font-size: 14px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.2s;
  width: 100%;
}
.btn-role:hover { background: #000000; transform: translateY(-1px); }

.btn-role-outline {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 11px 20px;
  background: transparent;
  color: white;
  border: 1px solid rgba(255,255,255,0.3);
  border-radius: 9px;
  font-size: 14px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.2s;
  width: 100%;
}
.btn-role-outline:hover { border-color: white; background: rgba(255,255,255,0.1); }

/* =====================
   CTA
   ===================== */
.cta-section {
  position: relative;
  overflow: hidden;
  background: #111111;
  text-align: center;
  padding: 100px 24px;
}

.cta-grid-bg {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(255,255,255,0.04) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255,255,255,0.04) 1px, transparent 1px);
  background-size: 48px 48px;
}

.cta-content {
  position: relative;
  z-index: 1;
  max-width: 600px;
  margin: 0 auto;
}

.cta-title {
  font-size: clamp(28px, 4vw, 44px);
  font-weight: 900;
  letter-spacing: -0.04em;
  color: white;
  margin-bottom: 16px;
  line-height: 1.15;
}

.cta-subtitle {
  font-size: 16px;
  color: #9CA3AF;
  margin-bottom: 36px;
  line-height: 1.65;
}

.cta-actions {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.btn-cta-primary {
  display: inline-flex;
  align-items: center;
  padding: 14px 32px;
  background: white;
  color: #111111;
  border-radius: 10px;
  font-size: 15px;
  font-weight: 700;
  text-decoration: none;
  transition: all 0.25s;
  box-shadow: 0 4px 20px rgba(255,255,255,0.15);
}
.btn-cta-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 30px rgba(255,255,255,0.2); }

.btn-cta-secondary {
  font-size: 14px;
  color: #9CA3AF;
  text-decoration: none;
  transition: color 0.2s;
}
.btn-cta-secondary:hover { color: white; }

/* =====================
   FOOTER
   ===================== */
.landing-footer {
  background: #000000;
  padding: 32px 24px;
}

.footer-inner {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 32px;
  flex-wrap: wrap;
}

.footer-brand { display: flex; flex-direction: column; gap: 6px; }
.footer-logo {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
  font-weight: 700;
  color: white;
}
.footer-tagline { font-size: 12px; color: #6B7280; }

.footer-links {
  display: flex;
  gap: 20px;
  flex: 1;
  flex-wrap: wrap;
}
.footer-links a {
  font-size: 13px;
  color: #6B7280;
  text-decoration: none;
  transition: color 0.2s;
}
.footer-links a:hover { color: white; }

.footer-copy { font-size: 12px; color: #4B5563; margin-left: auto; }

/* =====================
   ANIMATIONS
   ===================== */
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(24px); }
  to { opacity: 1; transform: translateY(0); }
}

/* =====================
   RESPONSIVE
   ===================== */
@media (max-width: 1024px) {
  .features-grid { grid-template-columns: repeat(2, 1fr); }
  .tech-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 768px) {
  .nav-links, .nav-actions { display: none; }
  .mobile-menu-btn { display: flex; }

  .hero-section { padding: 96px 20px 60px; }
  .hero-stats { gap: 20px; }

  .features-grid { grid-template-columns: 1fr; }
  .tech-grid { grid-template-columns: 1fr 1fr; }
  .roles-grid { grid-template-columns: 1fr; }

  .step-item { grid-template-columns: 60px 1fr; }
  .step-visual { display: none; }

  .pipeline-steps { gap: 6px; }
  .pipe-label { font-size: 11px; }

  .float-badge-1, .float-badge-2 { display: none; }

  .footer-inner { flex-direction: column; align-items: flex-start; }
  .footer-copy { margin-left: 0; }
}

@media (max-width: 480px) {
  .hero-stats { flex-direction: column; gap: 16px; }
  .hero-stat-divider { width: 40px; height: 1px; }
  .tech-grid { grid-template-columns: 1fr; }
  .pipeline-steps { flex-direction: column; align-items: flex-start; }
  .pipe-arrow { transform: rotate(90deg); }
}
</style>
