# Dokumentasi Struktur Aplikasi (AssessAI)
## Sistem Otomatis Penilaian Presentasi Mahasiswa Berbasis AI

Dokumen ini menjelaskan arsitektur perangkat lunak, struktur direktori, komponen fitur, dan pembagian teknologi yang digunakan dalam sistem AssessAI. Sistem ini menggunakan arsitektur *decoupled* yang memisahkan antarmuka pengguna (*frontend*) dengan logika bisnis dan mesin kecerdasan buatan (*backend*).

---

## 1. STRUKTUR FRONTEND (Vue.js Application)

Aplikasi *frontend* dibangun menggunakan **Vue.js 3 (Composition API)** dengan **Vite** sebagai *build tool* utama dan **Pinia** untuk manajemen *state* global. Seluruh antarmuka menerapkan tema *Monochrome Minimalist* (Hitam, Putih, Abu-abu) untuk menjaga fokus pada data evaluasi akademik.

### 1.1 Struktur Direktori Frontend
```text
AssessAI-frontend/
├── public/
├── src/
│   ├── assets/             # Aset statis (logo, ikon monokrom)
│   ├── components/         # Komponen UI yang dapat digunakan kembali (Reusable Components)
│   │   ├── BaseButton.vue  # Tombol standar (Solid Black / Outline)
│   │   ├── BaseInput.vue   # Input field dengan border 1px solid black
│   │   ├── Sidebar.vue     # Navigasi utama aplikasi
│   │   └── Waveform.vue    # Visualisasi baris gelombang audio
│   ├── composables/        # Logika stateful/hooks kustom
│   ├── router/             # Konfigurasi Vue Router (Routing Halaman)
│   │   └── index.ts
│   ├── stores/             # Pinia Stores (State Management)
│   │   ├── auth.ts         # Menyimpan token JWT dan role user
│   │   └── evaluation.ts   # Menyimpan data skor sementara dari AI
│   ├── views/              # Halaman Utama Aplikasi (Page Views)
│   │   ├── AuthView.vue    # Halaman Login & Registrasi
│   │   ├── DashboardView.vue # Dashboard Mahasiswa / Dosen
│   │   ├── UploadView.vue   # Area dropzone unggah audio (.wav/.mp3)
│   │   ├── ResultView.vue   # Tampilan grafik emosi & skor akhir AI
│   │   └── HistoryView.vue  # Arsip riwayat latihan mahasiswa
│   ├── App.vue             # Komponen Akar (Root Component)
│   └── main.ts             # Entry point aplikasi Vue.js
├── index.html
├── package.json
├── vite.config.ts
└── tailwind.config.js      # Konfigurasi utility-first CSS Grayscale

## 2. Struktur Backend (NestJS Application)
AssessAI-backend-nestjs/
├── src/
│   ├── auth/               # Modul Otentikasi (JWT & Bcrypt)
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   └── jwt.strategy.ts
│   ├── users/              # Modul Manajemen User (Dosen/Mahasiswa)
│   │   ├── dto/            # Data Transfer Object untuk validasi input
│   │   ├── users.entity.ts # Mapping ke tabel 'users' MySQL
│   │   └── users.service.ts
│   ├── presentations/      # Modul Manajemen Unggahan File Audio
│   │   ├── presentations.controller.ts
│   │   └── presentations.service.ts
│   ├── evaluations/        # Modul Sinkronisasi Skor & Panggilan ke FastAPI
│   │   ├── evaluations.controller.ts
│   │   └── evaluations.service.ts
│   ├── prisma/             # Konfigurasi Skema Basis Data Relasional
│   │   └── schema.prisma   # Definisi tipe data MySQL (BIGINT, VARCHAR, TEXT)
│   ├── app.module.ts       # Registrasi seluruh modul backend
│   └── main.ts             # Entry point server NestJS (Port 3000)
├── prisma/
│   └── migrations/         # Log riwayat migrasi struktur database
├── package.json
└── tsconfig.json

## 3. Struktur Backend (Python FastAPI Application)
AssessAI-backend-ai/
├── app/
│   ├── models/
│   │   └── model_final_indowave.keras  # Berkas model hybrid AI yang sudah di-freeze
│   ├── services/
│   │   ├── audio_processing.py # Pembersihan noise & ekstraksi MFCC (Librosa)
│   │   └── model_inference.py  # Pemuatan model & komputasi lapisan Softmax
│   ├── main.py                # Endpoint API FastAPI (Port 8000)
│   └── config.py
├── datasets_sample/           # Sampel audio RAVDESS / Data Primer Kampus
├── requirements.txt           # Daftar dependensi Python (TensorFlow, Librosa)
└── Dockerfile                 # Konfigurasi container khusus lingkungan AI