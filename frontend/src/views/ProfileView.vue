<template>
  <div class="flex min-h-screen bg-vox-offwhite">
    <Sidebar />
    <div class="flex-1 ml-50 flex flex-col">
      <Navbar />
      <main class="flex-1 p-8 animate-fade-in">
      <div class="page-header">
        <h1 class="page-title">Profil Saya</h1>
        <p class="page-subtitle">Kelola informasi akun dan foto profil Anda</p>
      </div>

      <div class="max-w-2xl space-y-6">
        <!-- Avatar Card -->
        <div class="card">
          <p class="text-xs font-semibold text-vox-gray uppercase tracking-wider mb-4">Foto Profil</p>
          <div class="flex items-center gap-6">
            <!-- Avatar display -->
            <div class="relative">
              <div class="w-20 h-20 rounded-full bg-vox-lightgray border border-vox-lightgray overflow-hidden flex items-center justify-center">
                <img
                  v-if="avatarPreview || user?.avatarUrl"
                  :src="avatarPreview || getAvatarUrl(user?.avatarUrl)"
                  alt="Avatar"
                  class="w-full h-full object-cover"
                />
                <span v-else class="text-2xl font-bold text-vox-midgray">
                  {{ user?.name?.charAt(0)?.toUpperCase() ?? '?' }}
                </span>
              </div>
              <label
                class="absolute bottom-0 right-0 w-6 h-6 bg-vox-black rounded-full flex items-center justify-center cursor-pointer hover:bg-vox-darkgray transition-colors"
                title="Ubah foto"
              >
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
                  <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                  <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                </svg>
                <input type="file" accept="image/*" class="hidden" @change="handleAvatarSelect" />
              </label>
            </div>
            <div class="flex-1">
              <p class="font-semibold text-vox-black text-sm">{{ user?.name }}</p>
              <p class="text-xs text-vox-midgray mt-1">{{ user?.role === 'dosen' ? 'Dosen' : 'Mahasiswa' }}</p>
              <p v-if="avatarFile" class="text-xs text-vox-gray mt-2">
                File dipilih: {{ avatarFile.name }}
                <button @click="uploadAvatar" :disabled="isUploadingAvatar" class="ml-2 text-vox-black underline font-medium hover:opacity-70">
                  {{ isUploadingAvatar ? 'Mengunggah...' : 'Simpan Foto' }}
                </button>
              </p>
              <p v-if="avatarSuccess" class="text-xs text-green-600 mt-2">✓ Foto profil berhasil diperbarui</p>
            </div>
          </div>
        </div>

        <!-- Profile Form Card -->
        <div class="card">
          <p class="text-xs font-semibold text-vox-gray uppercase tracking-wider mb-5">Informasi Akun</p>
          <form @submit.prevent="handleUpdate" class="space-y-5">
            <div>
              <label class="input-label">Nama Lengkap</label>
              <input
                id="profile-name"
                v-model="form.name"
                type="text"
                class="input-field"
                placeholder="Nama Lengkap"
                required
              />
            </div>
            <div>
              <label class="input-label">Email</label>
              <input
                type="email"
                :value="user?.email"
                class="input-field"
                disabled
                title="Email tidak dapat diubah"
              />
              <p class="text-xs text-vox-midgray mt-1">Email tidak dapat diubah</p>
            </div>
            <div>
              <label class="input-label">{{ user?.role === 'dosen' ? 'NIP' : 'NIM' }}</label>
              <input
                id="profile-nim"
                v-model="form.nimNip"
                type="text"
                class="input-field"
                :placeholder="user?.role === 'dosen' ? 'Nomor Induk Pegawai' : 'Nomor Induk Mahasiswa'"
              />
            </div>
            <div>
              <label class="input-label">Peran</label>
              <input
                type="text"
                :value="user?.role === 'dosen' ? 'Dosen' : 'Mahasiswa'"
                class="input-field"
                disabled
              />
            </div>

            <div v-if="updateError" class="text-xs text-red-600 bg-red-50 border border-red-200 rounded px-3 py-2">
              {{ updateError }}
            </div>
            <div v-if="updateSuccess" class="text-xs text-green-600 bg-green-50 border border-green-200 rounded px-3 py-2">
              ✓ Profil berhasil diperbarui
            </div>

            <div class="flex gap-3 pt-2">
              <button
                id="profile-save"
                type="submit"
                class="btn-primary"
                :disabled="isUpdating"
              >
                <span v-if="isUpdating" class="spinner w-4 h-4 border-white border-t-transparent" />
                {{ isUpdating ? 'Menyimpan...' : 'Simpan Perubahan' }}
              </button>
              <button type="button" class="btn-outline" @click="resetForm">Batal</button>
            </div>
          </form>
        </div>

        <!-- Info akun -->
        <div class="card">
          <p class="text-xs font-semibold text-vox-gray uppercase tracking-wider mb-3">Info Akun</p>
          <div class="space-y-3">
            <div class="flex justify-between text-sm">
              <span class="text-vox-gray">ID Pengguna</span>
              <span class="font-mono text-vox-black">#{{ user?.id }}</span>
            </div>
            <div class="flex justify-between text-sm">
              <span class="text-vox-gray">Terdaftar sejak</span>
              <span class="text-vox-black">{{ formatDate(user?.createdAt) }}</span>
            </div>
          </div>
        </div>
      </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import Navbar from '../components/Navbar.vue'
import { useAuthStore } from '../stores/auth'
import api from '../services/api'

const authStore = useAuthStore()
const user = ref<any>(null)
const isUpdating = ref(false)
const updateError = ref('')
const updateSuccess = ref(false)
const isUploadingAvatar = ref(false)
const avatarFile = ref<File | null>(null)
const avatarPreview = ref<string | null>(null)
const avatarSuccess = ref(false)

const form = reactive({ name: '', nimNip: '' })

onMounted(async () => {
  try {
    const response = await api.get('/users/profile')
    user.value = response.data
    form.name = response.data.name || ''
    form.nimNip = response.data.nimNip || ''
  } catch {
    user.value = authStore.user
    form.name = authStore.user?.name || ''
    form.nimNip = authStore.user?.nimNip || ''
  }
})

function resetForm() {
  form.name = user.value?.name || ''
  form.nimNip = user.value?.nimNip || ''
  updateError.value = ''
  updateSuccess.value = false
}

function handleAvatarSelect(event: Event) {
  const input = event.target as HTMLInputElement
  if (input.files?.length) {
    avatarFile.value = input.files[0]
    avatarPreview.value = URL.createObjectURL(input.files[0])
    avatarSuccess.value = false
  }
}

function getAvatarUrl(url?: string | null) {
  if (!url) return null
  if (url.startsWith('http')) return url
  return `http://localhost:3000${url}`
}

async function uploadAvatar() {
  if (!avatarFile.value) return
  isUploadingAvatar.value = true
  try {
    const fd = new FormData()
    fd.append('avatar', avatarFile.value)
    const res = await api.post('/users/avatar', fd, {
      headers: { 'Content-Type': 'multipart/form-data' },
    })
    user.value = { ...user.value, avatarUrl: res.data.avatarUrl }
    avatarFile.value = null
    avatarSuccess.value = true
    // Update store user
    authStore.setAuth(authStore.token!, { ...authStore.user!, avatarUrl: res.data.avatarUrl } as any)
  } catch (e: any) {
    updateError.value = e.response?.data?.message || 'Gagal mengunggah foto'
  } finally {
    isUploadingAvatar.value = false
  }
}

async function handleUpdate() {
  updateError.value = ''
  updateSuccess.value = false
  isUpdating.value = true
  try {
    const res = await api.put('/users/profile', {
      name: form.name,
      nimNip: form.nimNip || undefined,
    })
    user.value = { ...user.value, ...res.data }
    updateSuccess.value = true
    // Update auth store & localStorage
    authStore.setAuth(authStore.token!, { ...authStore.user!, name: form.name, nimNip: form.nimNip } as any)
  } catch (e: any) {
    updateError.value = e.response?.data?.message || 'Gagal menyimpan perubahan'
  } finally {
    isUpdating.value = false
  }
}

function formatDate(dateStr?: string) {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleDateString('id-ID', {
    day: 'numeric', month: 'long', year: 'numeric',
  })
}
</script>
