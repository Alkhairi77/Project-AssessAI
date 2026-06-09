## 📑 Panduan Tahap Implementasi Kode AssessAI

### Fase 1: Setup Lingkungan Kerja & Database

* **Inisialisasi Repositori:** Buat tiga folder terpisah sesuai dengan struktur `architecture.md` yang kita buat (frontend, backend-nestjs, backend-ai). (done)


* **Setup MySQL:** Jalankan database MySQL. Anda bisa menggunakan Docker Compose untuk instansiasi cepat atau menggunakan XAMPP/MySQL Installer lokal.


* **Buat Skema Database:** Di folder NestJS, instal **Prisma ORM**. Jalankan perintah `npx prisma init`, lalu salin struktur skema tabel (`users`, `presentations`, `evaluations`) ke dalam file `schema.prisma`. Lakukan migrasi pertama dengan `npx prisma migrate dev` untuk membuat tabel asli di MySQL.



### Fase 2: Membangun Mesin AI (Python FastAPI - Hari 3-7)

Mesin AI adalah "otak" dari sistem Anda. Selesaikan bagian ini agar backend NestJS memiliki tujuan saat menembak API.

* **Setup Virtual Environment:** Buat `venv` Python 3.11 dan instal `tensorflow`, `librosa`, serta `fastapi`.


* **Skrip Ekstraksi Fitur:** Buat fungsi di Python untuk menerima file audio, lalu ekstrak fitur MFCC-nya menggunakan Librosa. Pastikan fungsi ini mengembalikan bentuk matriks yang siap dibaca TensorFlow.


* **Load Model CNN-LSTM:** Buat skrip untuk memuat (*load*) file model `.keras` atau `.h5` Anda.

* **Bungkus dengan FastAPI:** Buat satu endpoint POST (misal: `/api/v1/analyze`) yang menerima *file upload* audio, mengekstrak MFCC, memasukkannya ke model, dan mengembalikan respon berupa JSON berisi skor emosi dan transkrip dummy terlebih dahulu. Test menggunakan Postman.

### Fase 3: Membangun Gateway & Logika Bisnis (NestJS - Hari 8-12)

NestJS akan bertindak sebagai pengatur lalu lintas data.

* **Modul Autentikasi (Auth):** Bangun fitur registrasi dan login menggunakan JWT dan bcrypt untuk mengamankan tabel `users`.


* **Modul Presentasi & Upload:** Buat endpoint untuk menerima unggahan file audio dari user, simpan file tersebut ke direktori server, dan catat lokasinya ke tabel `presentations`.


* **Integrasi Service:** Di dalam `evaluations.service.ts`, buat fungsi untuk menembak endpoint FastAPI Python menggunakan `HttpModule` (Axios) membawa file audio yang baru diunggah. Tangkap respon JSON dari Python, lalu simpan nilainya ke tabel `evaluations` dan `emotion_results` di MySQL.



### Fase 4: Membangun Antarmuka (Vue.js 3 Frontend - Hari 13-18)

Setelah semua API siap dan bisa ditest lewat Postman, saatnya membuat mukanya.

* **Setup Vite & Tailwind:** Instal Vue 3 menggunakan Vite, lalu konfigurasi Tailwind CSS dengan palet warna hitam, putih, dan abu-abu (grayscale) sesuai draf `design.md`.


* **Setup State & Routing:** Konfigurasi Vue Router untuk halaman Login, Dashboard, Upload, History, dan Result. Setup Pinia store untuk menyimpan token JWT setelah login.


* **Slicing UI & Hit API:** Buat komponen *dropzone* untuk unggah file, lalu tembak ke API NestJS. Ambil data hasil evaluasi dari backend dan tampilkan menggunakan pustaka grafik (seperti Chart.js) dengan tema monokrom.



### Fase 5: Dockerization & E2E Testing (Hari 19-20)

* Bungkus ketiga subsistem tersebut ke dalam Dockerfile masing-masing agar aplikasi Anda *portable* dan siap didemokan tanpa drama salah versi library saat sidang.