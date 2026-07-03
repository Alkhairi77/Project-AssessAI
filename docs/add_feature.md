#### 1. User Profile Management
- Endpoint: `GET/PUT /api/users/profile`
- Frontend: halaman `/profile` dengan form edit nama, NIM/NIP, foto profil
- Upload foto ke `uploads/avatars/`

#### 2. Manajemen Kelas/Mata Kuliah (Dosen)
- Tabel baru: `Courses` (id, name, dosenId) -> hubungkan dengan tabel presentations
- Endpoint CRUD: `/api/courses`
- Relasi: Dosen memiliki banyak Mata Kuliah
- Dosen dapat memfilter mahasiswa berdasarkan mata kuliah

#### 3. Upload (Mahasiswa)
- Mahasiswa dapat memilih kelas/mata kuliah saat upload file audio
- Dosen hanya melihat mahasiswa di kelas/mata kuliah miliknya

#### 4. Lupa Password
- Halaman `/forgot-password`
- Endpoint POST `/api/auth/forgot-password`
- Kirim email reset link (bisa mock dulu)

#### 5. Perbaiki Transkripsi audio
- perbaiki transkripsi audio agar teksnya akurat dengan audio bahasa indonesia