# VoxGrade — Walkthrough Implementasi Lengkap

## Apa yang Telah Dibangun

Sistem **VoxGrade** — AI-Based Student Presentation Assessment — telah diimplementasikan secara penuh mencakup 3 subsistem:

---

## Struktur Akhir Proyek

```
Project/
├── backend_nestjs/          ← NestJS API Gateway (Port 3000)
│   ├── src/
│   │   ├── auth/            ← JWT + bcrypt auth module
│   │   ├── presentations/   ← Audio upload module (Multer)
│   │   ├── evaluations/     ← AI integration + skor module
│   │   ├── rubrics/         ← Rubrik penilaian module
│   │   └── prisma/          ← PrismaService global
│   ├── prisma/
│   │   ├── schema.prisma    ← MySQL schema (5 tabel)
│   │   └── seed.ts          ← Default rubrics + test dosen
│   ├── setup_database.bat   ← Helper migration script
│   └── .env                 ← DATABASE_URL, JWT_SECRET, AI_URL
│
├── backend_api/             ← FastAPI AI Server (Port 8000)
│   ├── app/
│   │   ├── main.py          ← POST /api/v1/analyze endpoint
│   │   ├── config.py        ← Model path, MFCC params, emotion labels
│   │   └── services/
│   │       ├── audio_processing.py   ← Noise reduction + MFCC
│   │       ├── model_inference.py    ← CNN-LSTM inference
│   │       └── stt_service.py        ← Whisper STT + sentiment
│   ├── models/
│   │   └── best_model_indowave.keras ← Model AI terlatih (5 kelas)
│   └── requirements.txt
│
├── frontend/                ← Vue.js 3 SPA (Port 5173)
│   ├── src/
│   │   ├── views/           ← Auth, Dashboard, Upload, Result, History, Lecturer
│   │   ├── components/      ← Sidebar, Waveform
│   │   ├── stores/          ← Pinia: auth, evaluation
│   │   ├── router/          ← Vue Router + RBAC guards
│   │   └── services/        ← Axios API client
│   └── tailwind.config.js   ← Monochrome grayscale palette
│
├── docker-compose.yml       ← Orchestrate semua services
└── docs/                    ← SRS, architecture, design, TODO
```

---

## 🚀 Cara Menjalankan (Development Mode)

### Step 1 — Jalankan MySQL
Buka XAMPP Control Panel → Start **MySQL**

Pastikan database `voxgrade` ada (buat manual jika belum):
```sql
CREATE DATABASE IF NOT EXISTS voxgrade CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Step 2 — Setup Database NestJS
```powershell
cd backend_nestjs

# Jalankan migrasi (buat tabel)
npx prisma migrate dev --name init_voxgrade_schema

# Seed data default (rubrik + akun dosen test)
npx ts-node prisma/seed.ts
```

**Atau jalankan `setup_database.bat`** dengan klik 2x.

### Step 3 — Jalankan NestJS Backend
```powershell
cd backend_nestjs
npm run start:dev
```
✅ Server berjalan di: `http://localhost:3000/api`

### Step 4 — Setup & Jalankan FastAPI AI Server
```powershell
cd backend_api

# Buat virtual environment Python 3.11
python -m venv venv
.\venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Jalankan server
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```
✅ AI server berjalan di: `http://localhost:8000`
✅ Docs: `http://localhost:8000/docs`

### Step 5 — Jalankan Frontend
```powershell
cd frontend
npm run dev
```
✅ Aplikasi berjalan di: `http://localhost:5173`

---

## API Endpoints NestJS

| Method | Endpoint | Auth | Deskripsi |
|--------|----------|------|-----------|
| POST | `/api/auth/register` | ❌ | Registrasi user baru |
| POST | `/api/auth/login` | ❌ | Login, dapat JWT token |
| GET | `/api/auth/profile` | ✅ | Profil user login |
| POST | `/api/presentations` | ✅ | Upload audio + trigger AI |
| GET | `/api/presentations` | ✅ | Daftar presentasi user |
| GET | `/api/presentations/:id` | ✅ | Detail presentasi + evaluasi |
| GET | `/api/evaluations/history` | ✅ | Riwayat lengkap dengan evaluasi |
| GET | `/api/evaluations/dashboard-stats` | ✅ | Statistik dashboard mahasiswa |
| GET | `/api/evaluations/dosen/stats` | ✅ | Rekap statistik semua mahasiswa |
| GET | `/api/evaluations/by-presentation/:id` | ✅ | Hasil evaluasi per presentasi |
| GET | `/api/rubrics` | ✅ | Daftar rubrik penilaian |
| PATCH | `/api/rubrics/:id` | ✅ | Update bobot rubrik (Dosen) |

## FastAPI AI Endpoint

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/v1/analyze` | Analisis audio → skor + emosi + transkripsi |
| GET | `/health` | Health check |

**Response JSON dari `/api/v1/analyze`:**
```json
{
  "emotion_label": "happy",
  "emotion_probabilities": {
    "neutral": 0.12, "happy": 0.65, "surprise": 0.13,
    "disgust": 0.06, "disappointed": 0.04
  },
  "articulation_score": 78.5,
  "intonation_score": 72.3,
  "overall_score": 81.2,
  "transcription": "Selamat pagi, hari ini saya akan mempresentasikan...",
  "feedback": "• Ekspresi suara Anda positif...\n• Artikulasi sudah baik...",
  "duration": 185.4
}
```

---

## Akun Test

Setelah seed dijalankan:
| Role | Email | Password |
|------|-------|----------|
| Dosen | dosen@voxgrade.ac.id | dosen123 |

Daftarkan akun Mahasiswa sendiri melalui halaman `/register`.

---

## Fitur Lengkap

### Mahasiswa
- ✅ Register & Login
- ✅ Upload audio `.wav` / `.mp3` dengan dropzone drag-and-drop
- ✅ Progress bar saat AI sedang menganalisis
- ✅ Hasil lengkap: skor (0-100), emotion bar chart, waveform, transkripsi, saran AI
- ✅ Riwayat semua sesi latihan (searchable)
- ✅ Dashboard dengan stats: total latihan, rata-rata skor, peningkatan

### Dosen
- ✅ Monitor semua mahasiswa (nama, NIM, skor terakhir, rata-rata, tren)
- ✅ Edit bobot rubrik penilaian (Emosi 40%, Artikulasi 30%, Intonasi 20%, Sentimen 10%)
- ✅ Export data mahasiswa ke CSV

### AI Pipeline
- ✅ Noise reduction & normalisasi amplitudo (noisereduce)
- ✅ Ekstraksi MFCC 40 koefisien (librosa)
- ✅ Klasifikasi emosi 5 kelas CNN-LSTM: neutral, happy, surprise, disgust, disappointed
- ✅ Scoring artikulasi dari RMS energy + spectral centroid + ZCR
- ✅ Scoring intonasi dari fundamental frequency (F0) variation
- ✅ Transkripsi Bahasa Indonesia offline (OpenAI Whisper `small`)
- ✅ Sentiment analysis berbasis kata kunci Bahasa Indonesia
- ✅ Feedback otomatis dalam Bahasa Indonesia

---

## Docker (Opsional — Untuk Demo/Produksi)

```powershell
# Dari root Project/
docker-compose up --build
```

Akses: `http://localhost` (frontend via Nginx)

> [!NOTE]
> Untuk Docker, pastikan model `best_model_indowave.keras` ada di `backend_api/models/`.

---

## Hal yang Perlu Dilakukan Setelah Init

1. **Jalankan `npx prisma migrate dev`** setelah MySQL aktif
2. **Install Python requirements** di virtual environment
3. **Verifikasi model .keras** terbaca dengan benar oleh TensorFlow
4. **Test endpoint** menggunakan file audio .wav Bahasa Indonesia
