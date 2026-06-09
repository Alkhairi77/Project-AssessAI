Software Requirement Specification (SRS)

Project: AssessAI - AI-Based Speech Evaluation System

1. Introduction

1.1 Purpose

[cite_start]Dokumen SRS ini bertujuan untuk mendefinisikan seluruh kebutuhan fungsional dan non-fungsional dalam pengembangan sistem otomatis penilaian presentasi mahasiswa[cite: 2, 15]. [cite_start]Sistem ini mengintegrasikan teknologi Speech Recognition (STT) dan Sentiment Analysis dengan arsitektur Hybrid Deep Learning CNN-LSTM[cite: 15, 16]. Dokumen ini akan digunakan sebagai spesifikasi acuan bagi AI Agent untuk menghasilkan basis kode aplikasi yang lengkap.

1.2 Scope

[cite_start]Aplikasi ini dikembangkan untuk memfasilitasi penilaian presentasi mahasiswa secara objektif dan mandiri[cite: 19, 106]. Sistem ini mencakup:

[cite_start]Ekstraksi fitur akustik audio menggunakan parameter MFCC melalui pustaka Librosa[cite: 17, 189].

[cite_start]Klasifikasi emosi suara pembicara dan analisis sentimen teks menggunakan kombinasi jaringan saraf CNN dan LSTM[cite: 16, 18, 108].

[cite_start]Dashboard manajemen, pengunggahan data, pengolahan riwayat, dan manajemen rubrik penilaian akademik[cite: 177, 178, 213].

1.3 Definitions and Acronyms

[cite_start]SER: Speech Emotion Recognition[cite: 92].

[cite_start]STT: Speech-to-Text / Speech Recognition[cite: 96, 145].

[cite_start]MFCC: Mel-Frequency Cepstral Coefficients[cite: 17, 148].

[cite_start]CNN: Convolutional Neural Network[cite: 16, 152].

[cite_start]LSTM: Long Short-Term Memory[cite: 16, 156].

2. Overall Description

2.1 Product Perspective

AssessAI merupakan sistem berbasis web dengan arsitektur yang terpisah (decoupled):

[cite_start]Frontend: Aplikasi SPA dibangun menggunakan Vue.js 3 dengan Vite dan Pinia[cite: 204, 352, 357, 358].

[cite_start]Backend / API Gateway: Server logika bisnis dibangun menggunakan Node.js dengan NestJS[cite: 204, 360].

[cite_start]AI Inference Server: Layanan pemrosesan audio dan eksekusi model TensorFlow/PyTorch dibangun menggunakan Python dengan FastAPI[cite: 202, 347, 349].

[cite_start]Database: Penyimpanan data relasional dikelola oleh MySQL[cite: 194, 363].

2.2 User Classes and Characteristics

Mahasiswa:

[cite_start]Melakukan simulasi presentasi secara mandiri[cite: 19].

[cite_start]Mengunggah file audio dan menerima laporan visual umpan balik (feedback) hasil analisis AI[cite: 19, 109, 177].

Dosen:

[cite_start]Memantau rekapitulasi nilai dan grafik perkembangan kompetensi mahasiswa[cite: 177, 213].

[cite_start]Mengonfigurasi bobot kriteria pada rubrik penilaian akademik perguruan tinggi[cite: 103, 178].

2.3 Design and Implementation Constraints

Gaya Desain (UI Style): Desain antarmuka wajib menerapkan konsep Wireframe Monochrome Minimalist. Hanya menggunakan variasi warna hitam, putih, dan abu-abu (grayscale) untuk memastikan fokus pengguna tertuju pada data numerik dan visualisasi analisis [from prompt].

[cite_start]Batasan Audio: Sistem hanya menerima format file audio .wav atau .mp3 dalam Bahasa Indonesia dengan durasi tertentu[cite: 113, 213].

3. Specific Requirements

3.1 Functional Requirements

3.1.1 Modul Autentikasi & Manajemen Pengguna

[cite_start]REQ-01: Sistem harus menyediakan fungsi registrasi bagi pengguna baru dengan peran Mahasiswa[cite: 213].

REQ-02: Sistem harus memvalidasi kredensial pengguna (login) menggunakan strategi JWT (JSON Web Token).

[cite_start]REQ-03: Sistem harus memisahkan hak akses halaman dashboard berdasarkan peran pengguna (Role-Based Access Control)[cite: 176].

3.1.2 Modul Latihan & Pengunggahan Audio (Mahasiswa)

[cite_start]REQ-04: Mahasiswa dapat mengunggah file rekaman presentasi dengan batasan format .wav atau .mp3[cite: 213].

[cite_start]REQ-05: Sistem harus mengirimkan file audio yang valid ke server AI FastAPI untuk diproses[cite: 205, 207].

REQ-06: Sistem harus menampilkan bilah progres (progress bar) grayscale saat proses inferensi model AI sedang berjalan.

3.1.3 Modul Pemrosesan AI & Analisis (FastAPI Service)

[cite_start]REQ-07: Layanan AI harus melakukan pembersihan bising (noise reduction) dan normalisasi amplitudo sinyal audio pembicara[cite: 120, 189].

[cite_start]REQ-08: Layanan AI harus mengekstraksi koefisien MFCC menggunakan library Librosa[cite: 17, 189].

[cite_start]REQ-09: Model hibrida CNN-LSTM harus melakukan klasifikasi emosi dasar (seperti Confident, Nervous, Neutral) berdasarkan spektrogram dan dependensi temporal[cite: 16, 18, 95].

[cite_start]REQ-10: Sistem harus mengonversi ucapan menjadi teks (Speech-to-Text) dan melakukan analisis sentimen teks untuk menilai profesionalitas pilihan kata[cite: 96, 108, 164].

3.1.4 Modul Laporan & Riwayat Penilaian

[cite_start]REQ-11: Sistem harus menampilkan skor akhir numerik berbasis skala 100 berdasarkan rubrik akademik yang berlaku[cite: 103, 179].

[cite_start]REQ-12: Dashboard hasil harus menyertakan visualisasi berupa grafik batang grayscale untuk probabilitas emosi, visualisasi garis waveform suara, transkripsi teks, dan teks saran perbaikan otomatis[cite: 109].

[cite_start]REQ-13: Sistem harus menyimpan setiap riwayat latihan mahasiswa ke dalam database MySQL dan menampilkannya di halaman History[cite: 194, 213].

3.1.5 Modul Monitoring & Konfigurasi (Dosen)

[cite_start]REQ-14: Dosen dapat melihat rekapitulasi statistik progres nilai mahasiswa berdasarkan kelas yang dipilih[cite: 177, 213].

[cite_start]REQ-15: Dosen dapat mengunduh laporan rekapitulasi performa mahasiswa dalam format dokumen cetak (PDF/Excel)[cite: 213].

[cite_start]REQ-16: Dosen dapat mengubah bobot persentase parameter kriteria pada tabel rubrik penilaian melalui antarmuka admin[cite: 178].

3.2 Database Requirements (MySQL Schema)

[cite_start]AI Agent harus mengonfigurasi skema database relasional MySQL dengan struktur tipe data sebagai berikut[cite: 194, 272]:

Tabel users:

[cite_start]id: BIGINT (Primary Key, Auto Increment)[cite: 277].

[cite_start]name: VARCHAR(255)[cite: 277].

[cite_start]email: VARCHAR(255) (Unique)[cite: 277].

[cite_start]password: VARCHAR(255) (Hashed)[cite: 277].

[cite_start]role: ENUM('dosen', 'mahasiswa')[cite: 277].

[cite_start]nim_nip: VARCHAR(20)[cite: 277].

Tabel presentations:

id: BIGINT (Primary Key, Auto Increment).

user_id: BIGINT (Foreign Key ke users.id).

title: VARCHAR(255).

file_path: VARCHAR(255) (Lokasi penyimpanan berkas audio di server).

duration: INT (Durasi dalam satuan detik).

uploaded_at: DATETIME.

Tabel evaluations:

id: BIGINT (Primary Key, Auto Increment).

presentation_id: BIGINT (Foreign Key ke presentations.id).

overall_score: FLOAT.

articulation_score: FLOAT.

intonation_score: FLOAT.

transcription: LONGTEXT.

feedback: TEXT.

Tabel emotion_results:

id: BIGINT (Primary Key, Auto Increment).

evaluation_id: BIGINT (Foreign Key ke evaluations.id).

emotion_label: VARCHAR(50).

confidence_score: FLOAT (Nilai probabilitas keluaran lapisan Softmax).

Tabel rubrics:

id: BIGINT (Primary Key, Auto Increment).

criteria_name: VARCHAR(255).

weight: FLOAT.

description: TEXT.

4. Non-functional Requirements

4.1 Performance Requirements

[cite_start]Inference Time: Waktu pemrosesan ekstraksi MFCC dan eksekusi model CNN-LSTM tidak boleh melebihi 15 detik untuk berkas audio berdurasi maksimal 5 menit[cite: 120, 137, 189].

[cite_start]Frontend Speed: Aplikasi web harus menggunakan Vite sebagai bundler untuk memastikan initial page load time berada di bawah 2 detik[cite: 358].

4.2 Security Requirements

[cite_start]Password Security: Kata sandi pengguna wajib disandikan menggunakan algoritma enkripsi satu arah yang kuat (seperti bcrypt) sebelum disimpan ke tabel users[cite: 277].

[cite_start]API Security: Seluruh rute API pada NestJS dilindungi oleh middleware otentikasi JWT, kecuali untuk rute registrasi dan login[cite: 213].

4.3 Deployment and Portability

[cite_start]Containerization: Seluruh subsistem (Vue.js, NestJS, FastAPI, MySQL) wajib dikemas ke dalam kontainer terisolasi menggunakan Docker untuk menjamin portabilitas lingkungan produksi[cite: 219, 396].