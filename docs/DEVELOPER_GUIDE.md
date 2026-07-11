# AssessAI — Developer Guide

> Dokumentasi teknis lengkap untuk pengembang. Versi: 1.0.0 | Terakhir diperbarui: Juni 2026

---

## Daftar Isi

1. [Gambaran Umum Sistem](#1-gambaran-umum-sistem)
2. [Arsitektur Sistem](#2-arsitektur-sistem)
3. [Struktur Proyek](#3-struktur-proyek)
4. [Alur Kerja Aplikasi](#4-alur-kerja-aplikasi)
5. [Backend NestJS (Port 3000)](#5-backend-nestjs-port-3000)
6. [Backend FastAPI AI (Port 8000)](#6-backend-fastapi-ai-port-8000)
7. [Frontend Vue 3 (Port 5173)](#7-frontend-vue-3-port-5173)
8. [Database & Schema](#8-database--schema)
9. [API Reference Lengkap](#9-api-reference-lengkap)
10. [Konfigurasi Environment](#10-konfigurasi-environment)
11. [Setup & Instalasi](#11-setup--instalasi)
12. [Panduan Testing API](#12-panduan-testing-api)
13. [Model AI](#13-model-ai)
14. [Troubleshooting Umum](#14-troubleshooting-umum)
15. [Rencana Pengembangan Selanjutnya](#15-rencana-pengembangan-selanjutnya)

---

## 1. Gambaran Umum Sistem

**AssessAI** adalah sistem penilaian presentasi mahasiswa berbasis kecerdasan buatan yang menganalisis rekaman audio presentasi secara otomatis. Sistem menghasilkan skor dan umpan balik berdasarkan:

- **Emosi suara** — Klasifikasi 5 emosi menggunakan model CNN-LSTM yang telah dilatih
- **Artikulasi** — Kejelasan pengucapan berdasarkan RMS energy dan zero-crossing rate
- **Intonasi** — Variasi nada suara menggunakan analisis pitch (F0)
- **Konten & Sentimen** — Analisis sentimen teks hasil transkripsi Whisper

### Pengguna

| Role | Hak Akses |
|------|-----------|
| **Mahasiswa** | Register, upload audio, lihat hasil, lihat riwayat |
| **Dosen** | Login, lihat statistik semua mahasiswa, kelola bobot rubrik |

---

## 2. Arsitektur Sistem

```
┌─────────────────────────────────────────────────────────────────┐
│                    CLIENT BROWSER                                │
│              Vue 3 + Pinia + Vue Router                          │
│                   http://localhost:5173                          │
└──────────────────────────┬──────────────────────────────────────┘
                           │ REST API (axios)
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│              BACKEND NESTJS (API Gateway)                        │
│              NestJS + Prisma + JWT + Multer                      │
│                   http://localhost:3000/api                      │
│                                                                  │
│  ┌──────────┐ ┌──────────────┐ ┌─────────────┐ ┌────────────┐  │
│  │   Auth   │ │Presentations │ │ Evaluations │ │  Rubrics   │  │
│  └──────────┘ └──────┬───────┘ └─────────────┘ └────────────┘  │
└─────────────────────-│──────────────────────────────────────────┘
                       │ multipart/form-data (no timeout)
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│              BACKEND FASTAPI (AI Inference)                      │
│    FastAPI + TensorFlow + OpenAI Whisper + Librosa               │
│                   http://localhost:8000                          │
│                                                                  │
│  1. Audio preprocessing (noise reduction, normalization)         │
│  2. MFCC extraction → CNN-LSTM → Emotion classification          │
│  3. Articulation + Intonation scoring                            │
│  4. Whisper transcription (numpy array, no FFmpeg needed)        │
│  5. Sentiment analysis (rule-based, Bahasa Indonesia)            │
│  6. Weighted score calculation + feedback generation             │
└────────────────────────┬────────────────────────────────────────┘
                         │
           ┌─────────────┴────────────┐
           ▼                          ▼
┌──────────────────┐      ┌──────────────────────┐
│   MySQL Database │      │  Whisper Model Cache  │
│   (XAMPP)        │      │  ~/.cache/whisper/    │
│   port: 3306     │      │  tiny.pt (39MB)       │
│   DB: assessai   │      └──────────────────────┘
└──────────────────┘
```

### Alur Data Utama

```
Audio File (.wav/.mp3)
       │
       ▼ (upload via frontend)
  NestJS saves file → uploads/
       │
       ▼ (fire-and-forget async call)
  FastAPI /api/v1/analyze
       │
       ├─→ librosa.load() → noise reduction → normalize
       ├─→ MFCC extraction → shape (1, 40, 216, 1)
       ├─→ CNN-LSTM model.predict() → emotion probabilities
       ├─→ compute_articulation_score() → RMS + ZCR + centroid
       ├─→ compute_intonation_score() → pitch F0 analysis
       ├─→ whisper.transcribe(numpy_array) → text
       ├─→ analyze_sentiment(text) → score 0-100
       └─→ compute_overall_score() → weighted final score
              │
              ▼ (JSON response back to NestJS)
  NestJS saves to MySQL:
       ├─→ evaluations table
       └─→ emotion_results table
```

---

## 3. Struktur Proyek

```
Project/
├── backend_api/                  # FastAPI AI Inference Server
│   ├── app/
│   │   ├── __init__.py
│   │   ├── config.py             # Konfigurasi model & audio parameters
│   │   ├── main.py               # FastAPI app, endpoints, startup preload
│   │   └── services/
│   │       ├── audio_processing.py   # Noise reduction, MFCC extraction, scoring
│   │       ├── model_inference.py    # CNN-LSTM load & predict
│   │       └── stt_service.py        # Whisper STT, sentiment, feedback
│   ├── models/
│   │   └── model_final_indowave.keras  # Trained CNN-LSTM model (Prisma 5 compat)
│   ├── inspect_model.py          # Utility: print model input/output shapes
│   ├── requirements.txt          # Python dependencies
│   ├── Dockerfile
│   └── venv311/                  # Python 3.11 virtual environment
│
├── backend_nestjs/               # NestJS REST API Backend
│   ├── src/
│   │   ├── main.ts               # Bootstrap, global prefix, CORS, validation pipe
│   │   ├── app.module.ts         # Root module, imports all feature modules
│   │   ├── app.controller.ts     # GET /api (info endpoint)
│   │   ├── auth/
│   │   │   ├── auth.controller.ts    # POST /api/auth/register|login, GET /profile
│   │   │   ├── auth.service.ts       # bcrypt hash, JWT sign, user sanitization
│   │   │   ├── auth.module.ts
│   │   │   ├── jwt.strategy.ts       # Passport JWT validation
│   │   │   └── dto/
│   │   │       ├── register.dto.ts   # Validation: name, email, password, role, nimNip
│   │   │       └── login.dto.ts      # Validation: email, password
│   │   ├── presentations/
│   │   │   ├── presentations.controller.ts  # POST /upload, GET /, GET /:id
│   │   │   ├── presentations.service.ts     # File validation, DB create, AI trigger
│   │   │   ├── presentations.module.ts
│   │   │   └── dto/
│   │   │       └── create-presentation.dto.ts
│   │   ├── evaluations/
│   │   │   ├── evaluations.controller.ts    # GET history, stats, by-presentation
│   │   │   ├── evaluations.service.ts       # AI call, DB save, stats computation
│   │   │   └── evaluations.module.ts
│   │   ├── rubrics/
│   │   │   ├── rubrics.controller.ts    # GET /, PATCH /:id
│   │   │   ├── rubrics.service.ts       # CRUD rubric weights
│   │   │   └── rubrics.module.ts
│   │   └── prisma/
│   │       ├── prisma.service.ts    # PrismaClient singleton with lifecycle hooks
│   │       └── prisma.module.ts
│   ├── prisma/
│   │   ├── schema.prisma         # Database schema (5 models, 2 enums)
│   │   ├── seed.ts               # Initial data: rubrics + test dosen account
│   │   └── migrations/           # Prisma migration history
│   ├── uploads/                  # Audio file storage (gitignored)
│   ├── .env                      # Environment variables (lihat bagian 10)
│   └── package.json
│
├── frontend/                     # Vue 3 SPA
│   ├── src/
│   │   ├── main.ts               # Vue app bootstrap, Pinia, Router mount
│   │   ├── App.vue               # Root component (router-view only)
│   │   ├── style.css             # Global CSS, design tokens, dark theme
│   │   ├── router/
│   │   │   └── index.ts          # Route definitions + auth guards
│   │   ├── stores/
│   │   │   ├── auth.ts           # Pinia: token, user, isAuthenticated, isDosen
│   │   │   └── evaluation.ts     # Pinia: current evaluation state
│   │   ├── services/
│   │   │   └── api.ts            # Axios instance + JWT interceptor + 401 handler
│   │   ├── views/
│   │   │   ├── AuthView.vue      # Login & Register (dual mode)
│   │   │   ├── DashboardView.vue # Stats cards + recent activity
│   │   │   ├── UploadView.vue    # Drag-drop audio upload + progress
│   │   │   ├── ResultView.vue    # Hasil analisis: skor, emosi, waveform, transkripsi
│   │   │   ├── HistoryView.vue   # Riwayat presentasi mahasiswa
│   │   │   └── LecturerView.vue  # Dashboard dosen: statistik semua mahasiswa
│   │   └── components/
│   │       ├── Sidebar.vue       # Navigation sidebar dengan role-based menu
│   │       └── Waveform.vue      # Audio waveform visualization
│   ├── index.html                # HTML entry, meta SEO, Google Fonts
│   ├── vite.config.ts
│   └── package.json
│
├── docs/
│   ├── DEVELOPER_GUIDE.md        # File ini
│   ├── SRS.md                    # Software Requirements Specification
│   ├── architecture.md           # Diagram arsitektur (text-based)
│   ├── design.md                 # Design system & UI guidelines
│   ├── walktrough.md             # Walkthrough implementasi
│   └── add_feature.md            # Fitur yang direncanakan
│
├── api-test.http                 # REST Client test file (VS Code extension)
├── docker-compose.yml            # Docker orchestration (all services)
└── .gitignore
```

---

## 4. Alur Kerja Aplikasi

### 4.1 Alur Registrasi & Login

```
Pengguna → /register → AuthView.vue
    → POST /api/auth/register {name, email, password, role, nimNip}
    → AuthService.register()
        → Cek email duplikat → bcrypt.hash(password, 12)
        → prisma.user.create() → generateToken() (JWT 7d)
    → Response: {token, user}
    → Simpan ke localStorage: assess_token, assess_user
    → Redirect ke /dashboard
```

### 4.2 Alur Upload & Analisis Audio

```
Mahasiswa → /upload → UploadView.vue
    → Drag & drop atau pilih file .wav/.mp3
    → POST /api/presentations (multipart/form-data)
        → Multer menyimpan file ke uploads/
        → prisma.presentation.create() → dapat ID
        → FIRE AND FORGET: analyzeAndSave(presentationId, filePath)
    → Response langsung: {presentationId, message: "analisis sedang berjalan"}
    → Frontend redirect ke /result/:presentationId
    → ResultView.vue polling GET /api/evaluations/by-presentation/:id
        → Jika 404: tampilkan "Sedang diproses..." + loading indicator
        → Jika 200: tampilkan hasil lengkap

[Background — NestJS ke FastAPI]
    → POST http://localhost:8000/api/v1/analyze (timeout: 0 / no timeout)
        → FastAPI: load audio → MFCC → CNN-LSTM → Whisper → scoring
        → Response: {emotion_label, emotion_probabilities, scores, transcription, feedback}
    → NestJS: prisma.evaluation.create() + emotionResult.createMany()
    → prisma.presentation.update({duration})
```

### 4.3 Alur Melihat Hasil

```
ResultView.vue → GET /api/evaluations/by-presentation/:presentationId
    → EvaluationsService.findByPresentationId()
    → prisma.evaluation.findUnique({include: emotionResults})
    → Response: {overallScore, articulationScore, intonationScore,
                 emotionResults[], transcription, feedback}
    → Tampilkan:
        - Score card (overall, articulation, intonation)
        - Emotion bar chart (5 emosi dengan probabilitas)
        - Waveform audio player
        - Transkripsi teks
        - Feedback otomatis (per kategori)
```

### 4.4 Alur Dashboard Dosen

```
Dosen → /lecturer → LecturerView.vue
    → GET /api/evaluations/dosen/stats
    → EvaluationsService.getDosenStats()
        → Ambil semua mahasiswa + presentasi + evaluasi
        → Hitung rata-rata skor per mahasiswa
    → Tampilkan tabel: nama, NIM, total latihan, rata-rata skor, skor terakhir
```

---

## 5. Backend NestJS (Port 3000)

### 5.1 Konfigurasi Global (`main.ts`)

| Konfigurasi | Nilai |
|-------------|-------|
| Global prefix | `/api` |
| CORS origins | `localhost:5173`, `localhost:3000` |
| Validation pipe | `whitelist: true`, `forbidNonWhitelisted: true`, `transform: true` |
| Upload directory | `./uploads` (dibuat otomatis) |
| JWT expiry | `7d` (dari `.env`) |

### 5.2 Guard & Middleware

- **`JwtAuthGuard`** — Semua endpoint privat menggunakan `@UseGuards(JwtAuthGuard)`
- **`JwtStrategy`** — Validasi token, lookup user di DB, inject ke `request.user`
- **`ValidationPipe`** — Auto-validasi semua DTO menggunakan `class-validator`

### 5.3 Password Hashing

```typescript
// Saat register
const hashedPassword = await bcrypt.hash(password, 12); // 12 salt rounds

// Saat login
const isValid = await bcrypt.compare(plainPassword, hashedPassword);
```

### 5.4 JWT Token Payload

```json
{
  "sub": "1",         // user ID (string)
  "email": "user@example.com",
  "role": "mahasiswa" // atau "dosen"
}
```

### 5.5 File Upload (Multer)

- **Lokasi**: `./uploads/` (relatif dari root `backend_nestjs/`)
- **Format diizinkan**: `.wav`, `.mp3`
- **MIME types**: `audio/wav`, `audio/mpeg`, `audio/mp3`, `audio/wave`, `audio/x-wav`
- **Max size**: 50MB (dari `.env: MAX_FILE_SIZE=52428800`)
- File **tidak dihapus** setelah diproses — dapat diakses kembali untuk keperluan lain

---

## 6. Backend FastAPI AI (Port 8000)

### 6.1 Startup Preloading

Saat server pertama kali dijalankan (`@app.on_event("startup")`), **dua model dimuat terlebih dahulu** ke memori sebelum menerima request:

```python
# Urutan preload (berjalan di ThreadPoolExecutor):
1. TensorFlow CNN-LSTM model  ← ~2-5 detik
2. OpenAI Whisper "tiny" model ← ~3-8 detik (jika sudah di cache)
```

**Catatan penting:** Whisper model diunduh otomatis saat pertama kali ke `~/.cache/whisper/tiny.pt` (39MB). Download hanya terjadi sekali.

### 6.2 Pipeline Analisis Audio

```python
def _run_analysis(tmp_path: str) -> dict:
    # 1. Load audio
    audio, sr, duration = load_and_preprocess(tmp_path)
    #    ↳ librosa.load(sr=22050) → noisereduce → normalize

    # 2. MFCC Extraction
    mfcc = extract_mfcc(audio, sr)
    #    ↳ librosa.feature.mfcc(n_mfcc=40, n_fft=2048, hop_length=512)
    #    ↳ Pad/truncate ke MAX_PAD_LEN=216 pada axis=1 (time axis)
    #    ↳ Normalize: (mfcc - mean) / (std + 1e-8)
    #    ↳ Reshape ke (1, 40, 216, 1)  ← WAJIB sesuai model input

    # 3. Emotion Classification
    emotion_result = predict_emotion(mfcc)
    #    ↳ model.predict() → softmax → 5 probabilitas
    #    ↳ Labels: neutral, happy, surprise, disgust, disappointed

    # 4. Articulation Score (0-100)
    art = compute_articulation_score(audio, sr)
    #    ↳ RMS energy consistency × 0.4
    #    ↳ Spectral centroid (brightness) × 0.4
    #    ↳ Zero-crossing rate (consonant clarity) × 0.2

    # 5. Intonation Score (0-100)
    into = compute_intonation_score(audio, sr)
    #    ↳ librosa.pyin() → fundamental frequency F0
    #    ↳ Coefficient of variation ideal: 0.1–0.3 → skor 85-100

    # 6. Transcription
    transcription = transcribe_audio(tmp_path)
    #    ↳ librosa.load(sr=16000) → numpy array → whisper.transcribe()
    #    ↳ NO FFmpeg needed (numpy array bypass)

    # 7. Sentiment Score (0-100)
    sentiment = analyze_sentiment(transcription)
    #    ↳ Rule-based: positive keywords, negative keywords, filler words

    # 8. Overall Score (weighted)
    overall = compute_overall_score(emotion_label, confidence, art, into, sentiment)
    #    ↳ emotion × 0.40 + articulation × 0.30 + intonation × 0.20 + sentiment × 0.10
```

### 6.3 Scoring Emosi

| Emosi | Skor Presentasi | Makna |
|-------|----------------|-------|
| `happy` | 90 | Percaya diri / antusias |
| `neutral` | 70 | Netral |
| `surprise` | 75 | Spontan |
| `disgust` | 30 | Tidak nyaman |
| `disappointed` | 25 | Kurang semangat |

Skor emosi final = `base_score × 0.7 + confidence × base_score × 0.3`

### 6.4 Thread Pool Executor

Semua pemrosesan berjalan di `ThreadPoolExecutor(max_workers=2)` untuk menghindari blocking asyncio event loop:

```python
result = await loop.run_in_executor(executor, _run_analysis, tmp_path)
```

---

## 7. Frontend Vue 3 (Port 5173)

### 7.1 Halaman & Routes

| Path | View | Role | Deskripsi |
|------|------|------|-----------|
| `/login` | `AuthView.vue` | Guest | Form login |
| `/register` | `AuthView.vue` | Guest | Form registrasi |
| `/dashboard` | `DashboardView.vue` | Auth | Stats & aktivitas terkini |
| `/upload` | `UploadView.vue` | Mahasiswa | Upload audio presentasi |
| `/result/:id` | `ResultView.vue` | Auth | Detail hasil analisis |
| `/history` | `HistoryView.vue` | Mahasiswa | Riwayat semua presentasi |
| `/lecturer` | `LecturerView.vue` | Dosen | Monitoring semua mahasiswa |

### 7.2 Route Guards

```typescript
// Di router/index.ts
router.beforeEach((to, _from, next) => {
  if (to.meta.requiresAuth && !auth.isAuthenticated) → redirect /login
  if (to.meta.requiresGuest && auth.isAuthenticated) → redirect /dashboard
  if (to.meta.requiresRole === 'dosen' && !auth.isDosen) → redirect /dashboard
  if (to.meta.requiresRole === 'mahasiswa' && !auth.isMahasiswa) → redirect /dashboard
})
```

### 7.3 Pinia Stores

**`auth.ts`**
```typescript
// State
token: string | null         // dari localStorage 'assess_token'
user: User | null            // dari localStorage 'assess_user'

// Computed
isAuthenticated: !!token && !!user
isDosen: user?.role === 'dosen'
isMahasiswa: user?.role === 'mahasiswa'

// Actions
register(data) / login(data) / fetchProfile() / setAuth(token, user) / logout()
```

**`evaluation.ts`**
```typescript
// State
currentEvaluation: EvaluationResult | null
isLoading: boolean
error: string | null

// Actions
fetchEvaluation(presentationId)   // GET /api/evaluations/by-presentation/:id
```

### 7.4 HTTP Client (api.ts)

```typescript
const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:3000/api',
  timeout: 30000,
})

// Auto-attach JWT
api.interceptors.request.use(config => {
  const token = localStorage.getItem('assess_token')
  if (token) config.headers.Authorization = `Bearer ${token}`
})

// Auto-logout pada 401
api.interceptors.response.use(null, error => {
  if (error.response?.status === 401) → localStorage clear + redirect /login
})
```

---

## 8. Database & Schema

### 8.1 Entity Relationship

```
users (1) ──────────── (*) presentations (1) ──────── (1) evaluations
                                                              │
                                                              └── (*) emotion_results

rubrics (standalone, no FK)
```

### 8.2 Tabel Detail

**`users`**
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INT AUTO_INCREMENT PK | — |
| `name` | VARCHAR(255) | — |
| `email` | VARCHAR(255) UNIQUE | — |
| `password` | VARCHAR(255) | bcrypt hash |
| `role` | ENUM('dosen','mahasiswa') | Default: mahasiswa |
| `nim_nip` | VARCHAR(20) NULL | NIM untuk mahasiswa, NIP untuk dosen |
| `created_at` | DATETIME | Auto |
| `updated_at` | DATETIME | Auto update |

**`presentations`**
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INT AUTO_INCREMENT PK | — |
| `user_id` | INT FK → users | CASCADE DELETE |
| `title` | VARCHAR(255) | Judul presentasi |
| `file_path` | VARCHAR(255) | Path relatif dari root nestjs |
| `duration` | INT NULL | Durasi detik (diisi setelah AI selesai) |
| `uploaded_at` | DATETIME | Auto |

**`evaluations`**
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INT AUTO_INCREMENT PK | — |
| `presentation_id` | INT FK UNIQUE → presentations | CASCADE DELETE |
| `overall_score` | FLOAT | Skor akhir 0–100 |
| `articulation_score` | FLOAT | Skor artikulasi 0–100 |
| `intonation_score` | FLOAT | Skor intonasi 0–100 |
| `transcription` | LONGTEXT NULL | Hasil Whisper |
| `feedback` | TEXT NULL | Feedback otomatis per kategori |
| `created_at` | DATETIME | Auto |

**`emotion_results`**
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INT AUTO_INCREMENT PK | — |
| `evaluation_id` | INT FK → evaluations | CASCADE DELETE |
| `emotion_label` | VARCHAR(50) | neutral / happy / surprise / disgust / disappointed |
| `confidence_score` | FLOAT | Probabilitas 0.0–1.0 |

**`rubrics`**
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INT AUTO_INCREMENT PK | — |
| `criteria_name` | VARCHAR(255) | Nama kriteria |
| `weight` | FLOAT | Bobot penilaian |
| `description` | TEXT NULL | Deskripsi kriteria |

### 8.3 Seed Data Default

Saat `npx ts-node prisma/seed.ts` dijalankan:

**Rubrik awal:**

| Kriteria | Bobot |
|----------|-------|
| Ekspresi Emosi | 40% |
| Artikulasi | 30% |
| Intonasi | 20% |
| Konten & Sentimen | 10% |

**Akun dosen test:**
- Email: `dosen@gmail.com`
- Password: `dosen123`
- Role: `dosen`

---

## 9. API Reference Lengkap

Base URL: `http://localhost:3000/api`

### Auth

#### `POST /auth/register`
Daftarkan pengguna baru.

**Request body:**
```json
{
  "name": "Budi Santoso",
  "email": "budi@student.ac.id",
  "password": "min8chars",
  "role": "mahasiswa",
  "nimNip": "2021001001"
}
```
**Response 201:**
```json
{
  "message": "Registrasi berhasil",
  "token": "eyJhbGci...",
  "user": { "id": "2", "name": "...", "email": "...", "role": "mahasiswa", "nimNip": "..." }
}
```

#### `POST /auth/login`
Login dan dapatkan JWT.

**Request body:**
```json
{ "email": "budi@student.ac.id", "password": "min8chars" }
```

#### `GET /auth/profile` 🔒
Dapatkan profil user yang sedang login.

**Header:** `Authorization: Bearer <token>`

---

### Presentations

#### `POST /presentations` 🔒 (Mahasiswa)
Upload audio presentasi untuk dianalisis.

**Headers:** `Authorization: Bearer <token>`, `Content-Type: multipart/form-data`

**Form fields:**
- `file` — file audio (.wav / .mp3)
- `title` — judul presentasi (string)

**Response 201:**
```json
{
  "message": "File berhasil diunggah, analisis sedang berjalan",
  "presentationId": "5",
  "title": "Presentasi Capstone",
  "filePath": "uploads/abc123.wav"
}
```

> ⚠️ Analisis AI berjalan secara asinkron di background. Gunakan endpoint evaluations untuk polling hasil.

#### `GET /presentations` 🔒
Ambil semua presentasi milik user yang login.

#### `GET /presentations/:id` 🔒
Ambil detail satu presentasi (termasuk evaluasi jika sudah ada).

#### `GET /presentations/dosen/all-students` 🔒 (Dosen)
Ambil ringkasan presentasi semua mahasiswa.

---

### Evaluations

#### `GET /evaluations/by-presentation/:presentationId` 🔒
Ambil hasil evaluasi AI untuk presentasi tertentu.

**Response 200:**
```json
{
  "id": "1",
  "overallScore": 74.5,
  "articulationScore": 68.2,
  "intonationScore": 81.0,
  "transcription": "Selamat pagi, perkenalkan saya...",
  "feedback": "• Ekspresi suara positif...\n• Artikulasi cukup baik...",
  "createdAt": "2026-06-17T03:43:09.776Z",
  "emotionResults": [
    { "id": "1", "emotionLabel": "happy", "confidenceScore": 0.7231 },
    { "id": "2", "emotionLabel": "neutral", "confidenceScore": 0.2103 }
  ]
}
```
**Response 404:** Evaluasi belum tersedia (masih diproses).

#### `GET /evaluations/history` 🔒 (Mahasiswa)
Riwayat semua evaluasi milik mahasiswa yang login.

#### `GET /evaluations/dashboard-stats` 🔒 (Mahasiswa)
Statistik dashboard: total latihan, rata-rata skor, peningkatan, 5 aktivitas terkini.

#### `GET /evaluations/dosen/stats` 🔒 (Dosen)
Statistik semua mahasiswa: nama, NIM, total latihan, rata-rata skor, skor terakhir.

---

### Rubrics

#### `GET /rubrics` 🔒
Ambil semua rubrik penilaian.

#### `PATCH /rubrics/:id` 🔒 (Dosen)
Update bobot rubrik.

**Request body:**
```json
{ "weight": 35, "description": "Deskripsi baru (opsional)" }
```

---

### FastAPI AI Server

Base URL: `http://localhost:8000`

#### `GET /`
Info server.

#### `GET /health`
Health check: `{"status": "ok", "service": "assessai"}`

#### `POST /api/v1/analyze`
Analisis audio file.

**Form data:**
- `file` — audio file (.wav / .mp3)

**Response 200:**
```json
{
  "emotion_label": "happy",
  "emotion_probabilities": {
    "neutral": 0.1203, "happy": 0.7231, "surprise": 0.0891,
    "disgust": 0.0412, "disappointed": 0.0263
  },
  "articulation_score": 68.24,
  "intonation_score": 81.0,
  "overall_score": 74.5,
  "transcription": "Selamat pagi...",
  "feedback": "• Ekspresi suara positif...",
  "duration": 45.3
}
```

> 📌 Swagger UI tersedia di `http://localhost:8000/docs`

---

## 10. Konfigurasi Environment

### `backend_nestjs/.env`

```env
# Database MySQL
DATABASE_URL="mysql://root:@localhost:3306/assessai"

# JWT
JWT_SECRET="assessai-super-secret-jwt-key-2024"
JWT_EXPIRES_IN="7d"

# FastAPI AI Server URL
AI_SERVICE_URL="http://localhost:8000"

# App
PORT=3000
NODE_ENV=development

# File Upload
UPLOAD_DIR="uploads"
MAX_FILE_SIZE=52428800   # 50MB dalam bytes
```

### `backend_api/app/config.py`

```python
# Audio processing (HARUS sesuai model training)
SAMPLE_RATE = 22050
N_MFCC = 40
N_FFT = 2048
HOP_LENGTH = 512
MAX_PAD_LEN = 216       # Jumlah time steps MFCC (axis=1, tidak di-transpose)

# Emotion labels (urutan harus sama dengan training)
EMOTION_LABELS = ["neutral", "happy", "surprise", "disgust", "disappointed"]

# Whisper STT
WHISPER_MODEL = "tiny"   # tiny=cepat, small/medium=lebih akurat tapi lambat
WHISPER_LANGUAGE = "id"  # Indonesian

# Scoring weights (total harus = 1.0)
WEIGHTS = {"emotion": 0.40, "articulation": 0.30, "intonation": 0.20, "sentiment": 0.10}
```

### `frontend/.env` (opsional, buat jika tidak ada)

```env
VITE_API_URL=http://localhost:3000/api
```

---

## 11. Setup & Instalasi

### Prasyarat

| Software | Versi | Keterangan |
|----------|-------|------------|
| Node.js | ≥ 18.x | Untuk NestJS & Vue |
| Python | 3.11.x | Untuk FastAPI (venv311) |
| XAMPP | — | MySQL server |
| Git | — | Version control |

### Langkah Setup Lengkap

#### Step 1 — Clone & Persiapan Database

```bash
# Pastikan XAMPP MySQL aktif
# Buat database di phpMyAdmin atau CLI:
mysql -u root -e "CREATE DATABASE IF NOT EXISTS assessai CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

#### Step 2 — Setup Backend NestJS

```bash
cd backend_nestjs

# Install dependencies
npm install

# Jalankan migrasi database
npx prisma migrate dev --name init_assessai_schema

# Generate Prisma client
npx prisma generate

# Seed data awal (rubrik + akun dosen test)
npx ts-node prisma/seed.ts

# Jalankan server development
npm run start:dev
# Server berjalan di: http://localhost:3000/api
```

#### Step 3 — Setup Backend FastAPI

```bash
cd backend_api

# Aktifkan virtual environment Python 3.11
.\venv311\Scripts\Activate.ps1   # Windows
# source venv311/bin/activate     # Linux/Mac

# Install semua dependencies
pip install -r requirements.txt
# (Catatan: download pertama ~600MB+ karena TensorFlow & PyTorch)

# Jalankan server
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
# Server berjalan di: http://localhost:8000
# Swagger docs: http://localhost:8000/docs
```

> **Catatan Whisper:** Saat pertama kali dijalankan, model Whisper `tiny` (~72MB) akan diunduh otomatis ke `~/.cache/whisper/`. Ini hanya terjadi sekali.

#### Step 4 — Setup Frontend

```bash
cd frontend

npm install
npm run dev
# Aplikasi berjalan di: http://localhost:5173
```

#### Step 5 — Login

Gunakan akun test yang sudah di-seed:
- **Dosen:** `dosen@gmail.com` / `dosen123`
- **Mahasiswa:** Daftar sendiri melalui `/register`

---

## 12. Panduan Testing API

File `api-test.http` di root project dapat digunakan dengan extension **REST Client** di VS Code.

### Testing dengan PowerShell

```powershell
# 1. Register mahasiswa
$reg = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/register" `
  -Method POST -ContentType "application/json" `
  -Body '{"name":"Test User","email":"test@example.com","password":"test123","role":"mahasiswa","nimNip":"2021001"}'

# 2. Login dan simpan token
$resp = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/login" `
  -Method POST -ContentType "application/json" `
  -Body '{"email":"dosen@gmail.com","password":"dosen123"}'
$token = $resp.token

# 3. Akses endpoint yang butuh auth
Invoke-RestMethod -Uri "http://localhost:3000/api/rubrics" `
  -Headers @{Authorization="Bearer $token"} | ConvertTo-Json

# 4. Cek health FastAPI
Invoke-RestMethod -Uri "http://localhost:8000/health" | ConvertTo-Json
```

### Urutan Test Fitur Upload

1. Login mahasiswa → dapat token
2. POST `/api/presentations` dengan file audio → dapat `presentationId`
3. Tunggu ~15-60 detik (AI memproses)
4. GET `/api/evaluations/by-presentation/{presentationId}` → hasil evaluasi

---

## 13. Model AI

### Spesifikasi Model

- **Nama file:** `model_final_indowave.keras`
- **Arsitektur:** CNN-LSTM Hybrid Sequential
- **Framework:** TensorFlow / Keras
- **Total parameter:** 1,264,145 (~4.82 MB)

### Arsitektur Layer

```
Input: (None, 40, 216, 1)   ← (batch, N_MFCC, time_steps, channels)
│
├─ Conv2D(32, 3×3, relu)    → (None, 40, 216, 32)
├─ BatchNormalization
├─ MaxPooling2D(2×2)         → (None, 20, 108, 32)
│
├─ Conv2D(64, 3×3, relu)    → (None, 20, 108, 64)
├─ BatchNormalization
├─ MaxPooling2D(2×2)         → (None, 10, 54, 64)
├─ Dropout(0.x)
│
├─ Reshape                   → (None, 54, 640)
├─ LSTM(128)                 → (None, 128)
├─ Dropout(0.x)
│
├─ Dense(64, relu)
└─ Dense(5, softmax)         → (None, 5)

Output: 5 probabilitas emosi
```

### MFCC Extraction yang Benar

```python
# WAJIB: dimensi harus sesuai model training
mfcc = librosa.feature.mfcc(y=audio, sr=22050, n_mfcc=40, n_fft=2048, hop_length=512)
# Output librosa: (40, T) — JANGAN di-transpose!
# Pad/truncate pada axis=1 (time axis) ke 216
mfcc = mfcc[:, :216]               # truncate jika T > 216
# atau
mfcc = np.pad(mfcc, ((0,0),(0,216-T)))   # pad jika T < 216
# Reshape final: (1, 40, 216, 1)
mfcc = mfcc.reshape(1, 40, 216, 1)
```

> ⚠️ **Jika model diganti:** Selalu jalankan `python inspect_model.py` untuk verifikasi input shape, lalu sesuaikan `config.py` (N_MFCC dan MAX_PAD_LEN).

---

## 14. Troubleshooting Umum

### `PrismaClientInitializationError`
**Penyebab:** Versi Prisma tidak kompatibel atau DATABASE_URL kosong.
**Solusi:**
```bash
# Pastikan menggunakan Prisma 5 (bukan 7)
npm list prisma   # harus 5.22.0
npx prisma generate
```

### `Cannot GET /api` (404)
**Penyebab:** Tidak ada route handler di root `/api`.
**Solusi:** Pastikan `AppController` terdaftar di `AppModule` dan handler `@Get()` ada.

### FastAPI `[WinError 2]` saat Whisper
**Penyebab:** FFmpeg tidak terinstall. Whisper mencoba decode audio via FFmpeg.
**Solusi:** Sudah diperbaiki — `transcribe_audio()` menggunakan `librosa.load()` + numpy array, bukan file path langsung.

### FastAPI timeout / analisis tidak selesai
**Penyebab:** Whisper model masih download (hanya pertama kali) atau NestJS timeout habis.
**Solusi:**
1. Biarkan download selesai terlebih dahulu
2. NestJS timeout sudah diset ke `0` (no timeout)
3. Pantau terminal FastAPI untuk progress

### `EADDRINUSE :3000`
**Penyebab:** Port 3000 sudah digunakan oleh proses lain.
**Solusi:**
```powershell
Stop-Process -Name "node" -Force
# Lalu jalankan ulang npm run start:dev
```

### Skor emosi tidak akurat
**Penyebab:** Audio terlalu pendek, terlalu berisik, atau format berbeda dari data training.
**Saran:**
- Gunakan audio minimal 5 detik
- Rekam di lingkungan dengan sedikit noise
- Format WAV 16-bit mono lebih direkomendasikan daripada MP3

---

## 15. Rencana Pengembangan Selanjutnya

Berdasarkan file `docs/add_feature.md`, fitur yang direncanakan:

### Fitur Prioritas Tinggi

#### 1. User Profile Management
- Endpoint: `GET/PUT /api/users/profile`
- Frontend: halaman `/profile` dengan form edit nama, NIM/NIP, foto profil
- Upload foto ke `uploads/avatars/`

#### 2. Manajemen Kelas/Mata Kuliah (Dosen)
- Tabel baru: `Courses` (id, name, dosenId) -> hubungkan dengan tabel presentations
- Endpoint CRUD: `/api/courses`
- Relasi: Dosen memiliki banyak Mata Kuliah
- dosen dapat memfilter mahasiswa berdasarkan mata kuliah

#### 3. Upload (Mahasiswa)
- Mahasiswa dapat memilih kelas/mata kuliah saat upload file audio
- Dosen hanya melihat mahasiswa di kelas/mata kuliah miliknya

#### 4. Lupa Password
- Halaman `/forgot-password`
- Endpoint POST `/api/auth/forgot-password`
- Kirim email reset link (bisa mock dulu)

#### 5. Perbaiki Transkripsi audio
- perbaiki transkripsi audio agar teksnya akurat dengan audio bahasa indonesia

### Peningkatan Teknis yang Direkomendasikan

| Area | Saran |
|------|-------|
| **Notifikasi real-time** | WebSocket atau Server-Sent Events untuk update hasil analisis tanpa polling |
| **Job Queue** | Bull/BullMQ untuk antrian analisis AI agar tidak blocking |
| **Model upgrade** | Whisper `small` atau `medium` untuk transkripsi lebih akurat (butuh GPU) |
| **Audio preprocessing** | Trim silence otomatis sebelum analisis |
| **Export PDF** | Laporan evaluasi bisa diexport sebagai PDF |
| **Notifikasi email** | Kirim hasil evaluasi ke email mahasiswa |
| **Role Dosen verifikasi** | Dosen perlu diverifikasi admin sebelum bisa akses dashboard |
| **Docker** | `docker-compose.yml` sudah ada, tinggal disesuaikan untuk production |

---

## Appendix: Teknologi yang Digunakan

| Layer | Teknologi | Versi |
|-------|-----------|-------|
| Frontend | Vue 3 + Vite | — |
| State Management | Pinia | — |
| HTTP Client | Axios | — |
| Routing | Vue Router 4 | — |
| Backend API | NestJS | — |
| ORM | Prisma | 5.22.0 |
| Database | MySQL (via XAMPP) | — |
| Auth | JWT + Bcrypt | — |
| File Upload | Multer | — |
| AI Server | FastAPI + Uvicorn | — |
| ML Framework | TensorFlow / Keras | 2.20.0 |
| Audio Processing | Librosa | 0.10.2 |
| Noise Reduction | Noisereduce | 3.0.2 |
| Speech-to-Text | OpenAI Whisper | 20240930 |
| Containerization | Docker | — |

---

## 16. Changelog & Riwayat Perubahan

### v1.2.0 — Juli 2026

#### ✅ Fitur Baru

##### User Profile Management
- **Endpoint:** `GET /api/users/profile`, `PUT /api/users/profile`, `POST /api/users/avatar`
- **Frontend:** Halaman `/profile` — form edit nama & NIM/NIP, upload foto avatar (maks 5MB)
- **Storage:** Avatar disimpan di `uploads/avatars/`, diakses via `GET /uploads/avatars/:filename` (static file)
- **Module:** `src/users/users.module.ts`, `users.service.ts`, `users.controller.ts`

##### Manajemen Kelas / Mata Kuliah (Dosen)
- **Endpoint:** `GET /api/courses`, `POST /api/courses`, `DELETE /api/courses/:id`, `GET /api/courses/:id/presentations`
- **Frontend:** Halaman `/courses` — dosen buat/hapus kelas, klik kelas untuk melihat tabel presentasi dengan tombol **Detail →**
- **DB:** Tabel baru `courses` (id, name, dosen_id, created_at)
- **Module:** `src/courses/courses.module.ts`, `courses.service.ts`, `courses.controller.ts`

##### Upload dengan Pilih Kelas (Mahasiswa)
- Form upload audio di `/upload` menampilkan **dropdown pilih kelas** (opsional)
- Kelas dipilih dikirim sebagai `courseId` ke endpoint `POST /api/presentations`
- DB: kolom `course_id` (nullable FK) ditambahkan ke tabel `presentations`
- Dosen dapat memfilter presentasi mahasiswa berdasarkan kelas di `/lecturer`

##### Lupa Password (Mock)
- **Endpoint:** `POST /api/auth/forgot-password` — validasi email, generate mock reset token
- **Frontend:** Halaman `/forgot-password` + link "Lupa password?" di halaman login
- Di produksi: ganti logic dengan kirim email via SMTP/Nodemailer

##### Riwayat Presentasi Dosen (Monitor Mahasiswa)
- Tabel di `/lecturer` diganti dari **rekap per mahasiswa** menjadi **daftar semua presentasi** (flat list)
- Kolom: Nama & NIM (ditumpuk), Kelas, Topik Presentasi, Skor, Tanggal, Tombol Detail
- Filter berdasarkan kelas dan pencarian nama/NIM
- Export CSV menyertakan kolom Artikulasi, Intonasi, Kelas

##### Navbar Global
- Komponen `Navbar.vue` ditambahkan di semua halaman authenticated
- Fitur: page title, dropdown profil (avatar + nama + role), link ke Profil & Kelas, tombol Keluar
- Profil tidak lagi di Sidebar; Sidebar hanya menampilkan navigasi + logout

#### ✅ Perbaikan

##### Akurasi Transkripsi Whisper
- Model `tiny` (39MB) → **`base`** (74MB) untuk akurasi lebih baik
- Ditambah `initial_prompt` berbahasa Indonesia: *"Berikut adalah rekaman presentasi akademik..."*
- Parameter tambahan: `temperature=0.0`, `no_speech_threshold=0.6`, `condition_on_previous_text=True`
- Post-processing: hapus pengulangan kata (hallucination), normalisasi spasi, kapitalisasi awal

##### Animasi Loading Analisis (Mahasiswa)
- Progress bar tidak lagi "langsung selesai" — menggunakan animasi smooth hingga ~88%
- Pesan status berganti setiap 8 detik: "Memuat model AI" → "Mengekstrak fitur" → dst.
- **Tidak ada time limit** — polling setiap 4 detik sampai hasil keluar
- Otomatis redirect ke `/result/:id` begitu analisis selesai (dengan delay 600ms untuk menampilkan 100%)

##### Static File Serving
- NestJS `main.ts` diupdate menggunakan `NestExpressApplication` + `app.useStaticAssets()`
- File avatar dapat diakses via `http://localhost:3000/uploads/avatars/:filename`
- `forbidNonWhitelisted: false` di ValidationPipe untuk toleransi field opsional

#### Migrasi Database
```sql
-- Migration: 20260703024019_add_course_avatar
ALTER TABLE users ADD COLUMN avatar_url VARCHAR(500);
CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  dosen_id INT NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  FOREIGN KEY (dosen_id) REFERENCES users(id) ON DELETE CASCADE
);
ALTER TABLE presentations ADD COLUMN course_id INT,
  ADD FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE SET NULL;
```

#### File yang Diubah / Dibuat

| File | Aksi | Keterangan |
|------|------|------------|
| `prisma/schema.prisma` | MODIFY | Tambah `avatarUrl`, model `Course`, `courseId` |
| `src/users/` (module) | NEW | Profile management module |
| `src/courses/` (module) | NEW | Course management module |
| `src/auth/auth.service.ts` | MODIFY | Tambah `forgotPassword()` |
| `src/auth/auth.controller.ts` | MODIFY | Tambah `POST /auth/forgot-password` |
| `src/presentations/presentations.service.ts` | MODIFY | `create()` terima `courseId`, `findAllForDosen()` flat list |
| `src/main.ts` | MODIFY | Static file serving untuk `/uploads` |
| `src/app.module.ts` | MODIFY | Register `UsersModule`, `CoursesModule` |
| `frontend/src/components/Navbar.vue` | NEW | Global navbar dengan profile dropdown |
| `frontend/src/views/ProfileView.vue` | NEW | Halaman profil pengguna |
| `frontend/src/views/CoursesView.vue` | NEW | Halaman kelas/mata kuliah |
| `frontend/src/views/ForgotPasswordView.vue` | NEW | Halaman lupa password |
| `frontend/src/views/LecturerView.vue` | MODIFY | Tabel riwayat presentasi + filter kelas + export CSV |
| `frontend/src/views/UploadView.vue` | MODIFY | Dropdown kelas + smooth loading animation |
| `frontend/src/views/DashboardView.vue` | MODIFY | Tambah Navbar |
| `frontend/src/views/HistoryView.vue` | MODIFY | Tambah Navbar |
| `frontend/src/views/ResultView.vue` | MODIFY | Tambah Navbar |
| `frontend/src/views/ProfileView.vue` | MODIFY | Tambah Navbar |
| `frontend/src/components/Sidebar.vue` | MODIFY | Hapus RouterLink profil, tambah menu Kelas |
| `frontend/src/stores/auth.ts` | MODIFY | Tambah `avatarUrl`, `createdAt` ke tipe User |
| `frontend/src/stores/evaluation.ts` | MODIFY | `uploadAudio()` terima `courseId` |
| `frontend/src/router/index.ts` | MODIFY | Tambah route `/profile`, `/courses`, `/forgot-password` |
| `backend_api/app/config.py` | MODIFY | `WHISPER_MODEL = "base"` |
| `backend_api/app/services/stt_service.py` | MODIFY | `initial_prompt`, `temperature=0`, post-processing |

---

*Dokumen ini dihasilkan dari analisis kode sumber AssessAI v1.2.0*
