<template>
  <div class="min-h-screen bg-vox-offwhite flex items-center justify-center p-4">
    <div class="w-full max-w-md animate-fade-in">
      <!-- Logo -->
      <div class="text-center mb-10">
        <div class="inline-flex items-center justify-center w-14 h-14 bg-vox-black rounded-lg mb-4">
          <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
            <path d="M5 16 L16 5 L27 16 L16 27 Z" fill="white" opacity="0.9"/>
            <circle cx="16" cy="16" r="5" fill="white"/>
            <circle cx="16" cy="16" r="2" fill="black"/>
          </svg>
        </div>
        <h1 class="text-2xl font-bold text-vox-black tracking-tight">VoxGrade</h1>
        <p class="text-vox-gray text-sm mt-1">AI Speech Evaluation System</p>
      </div>

      <!-- Card -->
      <div class="card shadow-sm">
        <!-- Tab switcher -->
        <div class="flex mb-8 border-b border-vox-lightgray -mx-6 px-6">
          <button
            class="pb-3 px-1 text-sm font-semibold mr-6 border-b-2 transition-colors"
            :class="currentMode === 'login'
              ? 'border-vox-black text-vox-black'
              : 'border-transparent text-vox-gray hover:text-vox-black'"
            @click="currentMode = 'login'"
          >
            Masuk
          </button>
          <button
            class="pb-3 px-1 text-sm font-semibold border-b-2 transition-colors"
            :class="currentMode === 'register'
              ? 'border-vox-black text-vox-black'
              : 'border-transparent text-vox-gray hover:text-vox-black'"
            @click="currentMode = 'register'"
          >
            Daftar
          </button>
        </div>

        <!-- Login Form -->
        <form v-if="currentMode === 'login'" @submit.prevent="handleLogin" class="space-y-5">
          <div>
            <label class="input-label">Email</label>
            <input
              id="login-email"
              v-model="loginForm.email"
              type="email"
              class="input-field"
              placeholder="email@kampus.ac.id"
              autocomplete="email"
              required
            />
          </div>
          <div>
            <label class="input-label">Password</label>
            <input
              id="login-password"
              v-model="loginForm.password"
              type="password"
              class="input-field"
              placeholder="••••••••"
              autocomplete="current-password"
              required
            />
          </div>

          <div v-if="error" class="text-xs text-red-600 bg-red-50 border border-red-200 rounded px-3 py-2">
            {{ error }}
          </div>

          <button
            id="login-submit"
            type="submit"
            class="btn-primary w-full"
            :disabled="isLoading"
          >
            <span v-if="isLoading" class="spinner w-4 h-4 border-white border-t-transparent" />
            <span>{{ isLoading ? 'Masuk...' : 'Masuk' }}</span>
          </button>
        </form>

        <!-- Register Form -->
        <form v-else @submit.prevent="handleRegister" class="space-y-5">
          <div>
            <label class="input-label">Nama Lengkap</label>
            <input
              id="register-name"
              v-model="registerForm.name"
              type="text"
              class="input-field"
              placeholder="Nama Lengkap"
              required
            />
          </div>
          <div>
            <label class="input-label">Email</label>
            <input
              id="register-email"
              v-model="registerForm.email"
              type="email"
              class="input-field"
              placeholder="email@kampus.ac.id"
              required
            />
          </div>
          <div>
            <label class="input-label">NIM / NIP</label>
            <input
              id="register-nim"
              v-model="registerForm.nimNip"
              type="text"
              class="input-field"
              placeholder="NIM atau NIP"
            />
          </div>
          <div>
            <label class="input-label">Peran</label>
            <select id="register-role" v-model="registerForm.role" class="input-field">
              <option value="mahasiswa">Mahasiswa</option>
              <option value="dosen">Dosen</option>
            </select>
          </div>
          <div>
            <label class="input-label">Password</label>
            <input
              id="register-password"
              v-model="registerForm.password"
              type="password"
              class="input-field"
              placeholder="Minimal 6 karakter"
              required
              minlength="6"
            />
          </div>

          <div v-if="error" class="text-xs text-red-600 bg-red-50 border border-red-200 rounded px-3 py-2">
            {{ error }}
          </div>

          <button
            id="register-submit"
            type="submit"
            class="btn-primary w-full"
            :disabled="isLoading"
          >
            <span v-if="isLoading" class="spinner w-4 h-4 border-white border-t-transparent" />
            <span>{{ isLoading ? 'Mendaftarkan...' : 'Daftar Sekarang' }}</span>
          </button>
        </form>
      </div>

      <p class="text-center text-xs text-vox-midgray mt-6">
        VoxGrade &copy; 2024 — AI-Based Presentation Assessment
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const props = defineProps<{ mode?: string }>()

const router = useRouter()
const authStore = useAuthStore()

const currentMode = ref(props.mode || 'login')
const isLoading = ref(false)
const error = ref('')

const loginForm = reactive({ email: '', password: '' })
const registerForm = reactive({
  name: '',
  email: '',
  password: '',
  nimNip: '',
  role: 'mahasiswa',
})

async function handleLogin() {
  error.value = ''
  isLoading.value = true
  try {
    await authStore.login(loginForm.email, loginForm.password)
    router.push('/dashboard')
  } catch (e: any) {
    error.value = e.response?.data?.message || 'Login gagal. Periksa email dan password.'
  } finally {
    isLoading.value = false
  }
}

async function handleRegister() {
  error.value = ''
  isLoading.value = true
  try {
    await authStore.register({
      name: registerForm.name,
      email: registerForm.email,
      password: registerForm.password,
      nimNip: registerForm.nimNip,
      role: registerForm.role,
    })
    router.push('/dashboard')
  } catch (e: any) {
    error.value = e.response?.data?.message || 'Registrasi gagal. Coba lagi.'
  } finally {
    isLoading.value = false
  }
}
</script>
