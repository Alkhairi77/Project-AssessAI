# AssessAI — AI-Based Presentation Assessment System

<div align="center">

![AssessAI Banner](https://img.shields.io/badge/AssessAI-AI%20Speech%20Evaluator-black?style=for-the-badge&logo=microphone)

[![NestJS](https://img.shields.io/badge/NestJS-v10-E0234E?style=flat-square&logo=nestjs)](https://nestjs.com/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.115-009688?style=flat-square&logo=fastapi)](https://fastapi.tiangolo.com/)
[![Vue.js](https://img.shields.io/badge/Vue.js-3.x-4FC08D?style=flat-square&logo=vue.js)](https://vuejs.org/)
[![TensorFlow](https://img.shields.io/badge/TensorFlow-2.20-FF6F00?style=flat-square&logo=tensorflow)](https://www.tensorflow.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=flat-square&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)

**Sistem penilaian presentasi mahasiswa berbasis kecerdasan buatan yang menganalisis rekaman audio secara otomatis menggunakan model CNN-LSTM, Whisper STT, dan analisis akustik.**

</div>

---

## 📋 Daftar Isi

- [Tentang Proyek](#-tentang-proyek)
- [Fitur Utama](#-fitur-utama)
- [Arsitektur Sistem](#-arsitektur-sistem)
- [Tech Stack](#-tech-stack)
- [Struktur Proyek](#-struktur-proyek)
- [Cara Instalasi](#-cara-instalasi)
- [Menjalankan Secara Lokal](#-menjalankan-secara-lokal)
- [Menjalankan dengan Docker](#-menjalankan-dengan-docker)
- [API Endpoints](#-api-endpoints)
- [Alur Analisis AI](#-alur-analisis-ai)
- [Model AI](#-model-ai)
- [Screenshot](#-screenshot)
- [Kontributor](#-kontributor)

---

## 🎯 Tentang Proyek

**AssessAI** adalah sistem penilaian presentasi akademik berbasis AI yang dirancang untuk membantu mahasiswa meningkatkan kemampuan public speaking mereka. Sistem ini:

- Menganalisis **emosi suara** menggunakan model deep learning CNN-LSTM
- Menilai **artikulasi** berdasarkan fitur akustik (RMS energy, zero-crossing rate, spectral centroid)
- Mengukur **intonasi** melalui analisis variasi pitch (fundamental frequency)
- Melakukan **transkripsi** rekaman ke teks menggunakan OpenAI Whisper (offline)
- Menganalisis **konten & sentimen** dari teks hasil transkripsi
- Menghasilkan **skor akhir** dan **feedback otomatis** dalam Bahasa Indonesia

### Pengguna Sistem

| Role | Hak Akses |
|------|-----------|
| **Mahasiswa** | Upload rekaman, lihat hasil analisis, lihat riwayat latihan |
| **Dosen** | Monitor semua presentasi mahasiswa, kelola kelas, lihat laporan |

---

## ✨ Fitur Utama

- 🎙️ **Upload & Analisis Audio** — Format .WAV dan .MP3, maks. 50 MB
- 📊 **Dashboard Personal** — Statistik latihan, skor rata-rata, grafik perkembangan
- 🧠 **Klasifikasi Emosi AI** — 5 kelas: Netral, Percaya Diri, Terkejut, Tidak Nyaman, Kecewa
- 📝 **Transkripsi Otomatis** — Speech-to-text Bahasa Indonesia dengan Whisper
- 🏫 **Manajemen Kelas** — Dosen buat & kelola kelas, filter presentasi per mata kuliah
- 👩‍🏫 **Monitor Mahasiswa** — Tabel riwayat semua presentasi + export CSV
- 👤 **Profil Pengguna** — Edit nama, NIM/NIP, upload foto avatar
- 🔐 **Autentikasi JWT** — Login, register, lupa password
- 🛡️ **Validasi File Ketat** — Magic bytes check, tolak file non-audio yang diubah ekstensi
- 🌐 **Landing Page** — Halaman publik untuk presentasi produk

---

## 🏗️ Arsitektur Sistem

```
┌─────────────────────────────────────────────────────────────┐
│                      BROWSER (Port 5173/80)                  │
│              Vue 3 + Pinia + Vue Router + Tailwind            │
└────────────────────────┬────────────────────────────────────┘
                         │ REST API (JWT Auth)
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                NestJS Backend API (Port 3000)                │
│         Prisma ORM ──► MySQL 8.0 (Port 3306)                 │
│         Multer (File Upload) + JWT + Role Guard              │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTP (multipart/form-data)
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                FastAPI AI Server (Port 8000)                 │
│  TensorFlow CNN-LSTM │ OpenAI Whisper │ Librosa │ Noisereduce│
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Tech Stack

### Frontend
| Teknologi | Versi | Fungsi |
|-----------|-------|--------|
| Vue.js | 3.x | UI Framework |
| Pinia | 2.x | State Management |
| Vue Router | 4.x | Client-side Routing |
| Tailwind CSS | 3.x | Styling |
| Axios | - | HTTP Client |
| Vite | 6.x | Build Tool |

### Backend (NestJS)
| Teknologi | Versi | Fungsi |
|-----------|-------|--------|
| NestJS | 10.x | REST API Framework |
| Prisma | 5.x | ORM / Database Toolkit |
| MySQL | 8.0 | Database |
| JWT + Bcrypt | - | Autentikasi |
| Multer | - | File Upload |
| Passport | - | Auth Strategy |

### AI Server (FastAPI)
| Teknologi | Versi | Fungsi |
|-----------|-------|--------|
| FastAPI | 0.115 | AI Inference API |
| TensorFlow / Keras | 2.20 | Model CNN-LSTM |
| OpenAI Whisper | 20240930 | Speech-to-Text |
| Librosa | 0.10.2 | Audio Feature Extraction |
| Noisereduce | 3.0.2 | Noise Reduction |
| NumPy / SciPy | - | Komputasi Numerik |

---

## 📁 Struktur Proyek

```
Project/
├── 📁 backend_nestjs/          # REST API utama
│   ├── src/
│   │   ├── auth/               # Login, Register, JWT
│   │   ├── users/              # Profil pengguna, avatar
│   │   ├── presentations/      # Upload & manajemen file audio
│   │   ├── evaluations/        # Hasil analisis AI
│   │   ├── courses/            # Manajemen kelas/mata kuliah
│   │   ├── rubrics/            # Bobot penilaian
│   │   └── prisma/             # Prisma ORM service
│   ├── prisma/
│   │   └── schema.prisma       # Database schema
│   └── Dockerfile
│
├── 📁 backend_api/             # AI Inference server
│   ├── app/
│   │   ├── main.py             # FastAPI app & endpoint /analyze
│   │   ├── config.py           # Parameter model & audio
│   │   └── services/
│   │       ├── audio_processing.py   # Load, denoise, MFCC, validasi
│   │       ├── model_inference.py    # CNN-LSTM prediction, scoring
│   │       └── stt_service.py        # Whisper STT, sentimen, feedback
│   ├── models/                 # File model .keras (tidak di-commit)
│   ├── requirements.txt
│   └── Dockerfile
│
├── 📁 frontend/                # Vue.js SPA
│   ├── src/
│   │   ├── views/              # Halaman aplikasi
│   │   │   ├── LandingView.vue
│   │   │   ├── AuthView.vue
│   │   │   ├── DashboardView.vue
│   │   │   ├── UploadView.vue
│   │   │   ├── ResultView.vue
│   │   │   ├── HistoryView.vue
│   │   │   ├── LecturerView.vue
│   │   │   ├── CoursesView.vue
│   │   │   └── ProfileView.vue
│   │   ├── components/         # Komponen reusable
│   │   │   ├── Navbar.vue      # Global navbar + search
│   │   │   ├── Sidebar.vue     # Navigasi samping
│   │   │   └── Waveform.vue    # Visualisasi audio
│   │   ├── stores/             # Pinia stores
│   │   ├── router/             # Vue Router config
│   │   └── services/           # Axios API service
│   └── Dockerfile
│
├── 📁 docs/                    # Dokumentasi
│   ├── DEVELOPER_GUIDE.md
│   └── SRS.md
├── docker-compose.yml
└── README.md
```

---

## 🚀 Cara Instalasi

### Prasyarat

- **Node.js** ≥ 20.x
- **Python** 3.11
- **MySQL** 8.0 (atau via XAMPP)
- **Git**

### 1. Clone Repository

```bash
git clone https://github.com/username/assessai.git
cd assessai
```

### 2. Setup Backend NestJS

```bash
cd backend_nestjs
npm install
```

Buat file `.env`:
```env
DATABASE_URL="mysql://root:password@localhost:3306/assessai"
JWT_SECRET="your-secret-key"
JWT_EXPIRES_IN="7d"
AI_SERVICE_URL="http://localhost:8000"
PORT=3000
```

Jalankan migrasi database:
```bash
npx prisma migrate dev
npx prisma generate
```

### 3. Setup FastAPI AI Server

```bash
cd backend_api
python -m venv venv311
# Windows:
venv311\Scripts\activate
# Linux/Mac:
source venv311/bin/activate

pip install -r requirements.txt
```

> ⚠️ **Catatan:** Letakkan file model `.keras` di folder `backend_api/models/`.
> File model tidak disertakan di repository karena ukurannya besar.

### 4. Setup Frontend

```bash
cd frontend
npm install
```

Buat file `.env`:
```env
VITE_API_URL=http://localhost:3000/api
```

---

## 💻 Menjalankan Secara Lokal

Jalankan ketiga service secara **bersamaan** di terminal terpisah:

```bash
# Terminal 1 — NestJS Backend
cd backend_nestjs
npm run start:dev

# Terminal 2 — FastAPI AI Server
cd backend_api
venv311\Scripts\activate
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

# Terminal 3 — Vue Frontend
cd frontend
npm run dev
```

Akses aplikasi di: **http://localhost:5173**

---

## 🐳 Menjalankan dengan Docker

```bash
# Build & jalankan semua service
docker-compose up --build

# Jalankan di background
docker-compose up -d
```

> ⚠️ Pastikan file model `.keras` sudah ada di `backend_api/models/` sebelum build Docker.

Akses aplikasi di: **http://localhost**

| Service | Port |
|---------|------|
| Frontend | `80` |
| NestJS API | `3000` |
| FastAPI AI | `8000` |
| MySQL | `3306` |

---

## 📡 API Endpoints

### Auth
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/auth/register` | Registrasi pengguna baru |
| POST | `/api/auth/login` | Login & dapatkan JWT token |
| GET | `/api/auth/profile` | Profil pengguna saat ini |
| POST | `/api/auth/forgot-password` | Reset password (mock) |

### Presentations
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/presentations` | Upload audio presentasi |
| GET | `/api/presentations` | Daftar presentasi user |
| GET | `/api/presentations/:id` | Detail presentasi |
| GET | `/api/presentations/dosen/all-students` | Semua presentasi (dosen) |

### Evaluations
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/evaluations/by-presentation/:id` | Hasil analisis per presentasi |
| GET | `/api/evaluations/history` | Riwayat latihan |
| GET | `/api/evaluations/dashboard-stats` | Statistik dashboard |

### Courses
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/courses` | Daftar kelas |
| POST | `/api/courses` | Buat kelas baru (dosen) |
| DELETE | `/api/courses/:id` | Hapus kelas (dosen) |
| GET | `/api/courses/:id/presentations` | Presentasi dalam kelas |

### Users
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/users/profile` | Profil lengkap |
| PUT | `/api/users/profile` | Update nama & NIM/NIP |
| POST | `/api/users/avatar` | Upload foto profil |

---

## 🤖 Alur Analisis AI

Saat pengguna mengunggah file audio, sistem melakukan analisis dalam **8 langkah** secara otomatis:

```
Audio File (.wav / .mp3)
        │
        ▼ [Validasi magic bytes — tolak file palsu]
        │
        ▼ [Preprocessing: resample 22kHz, denoise, normalisasi]
        │
        ▼ [Ekstraksi MFCC → tensor (1, 40, 216, 1)]
        │
        ▼ [CNN-LSTM model.predict() → 5 kelas emosi]
        │
        ├─► Skor Artikulasi (RMS energy + ZCR + Spectral Centroid)
        ├─► Skor Intonasi   (Variasi pitch / F0 dengan librosa pyin)
        ├─► Transkripsi     (Whisper "base", Bahasa Indonesia, offline)
        └─► Skor Sentimen   (Rule-based: kata positif / negatif / filler)
                │
                ▼
        Skor Akhir = Emosi×40% + Artikulasi×30% + Intonasi×20% + Sentimen×10%
                │
                ▼
        Feedback Otomatis (5 paragraf dalam Bahasa Indonesia)
```

### Kelas Emosi & Bobot Skor

| Emosi | Skor Presentasi | Interpretasi |
|-------|----------------|--------------|
| `happy` | 90 | Percaya Diri / Antusias ✅ |
| `surprise` | 75 | Spontan / Ekspresif |
| `neutral` | 70 | Netral — perlu ditingkatkan |
| `disgust` | 30 | Tidak Nyaman ⚠️ |
| `disappointed` | 25 | Kurang Semangat ❌ |

---

## 🧩 Model AI

Model yang digunakan adalah **CNN-LSTM** yang dilatih pada dataset audio presentasi akademik Bahasa Indonesia (IndoWave).

- **Arsitektur:** Convolutional Neural Network + Long Short-Term Memory
- **Input:** MFCC features — shape `(batch, 40, 216, 1)`
- **Output:** 5 kelas probabilitas emosi
- **Framework:** TensorFlow / Keras 2.20
- **File model:** `best_model_indowave_v2.keras`

> Model tidak disertakan dalam repository. Hubungi tim pengembang untuk mendapatkan file model.

---

## 🤝 Kontributor

Proyek ini dikembangkan sebagai **Capstone Project Semester 6**.

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan akademik. Hak cipta © 2026.
