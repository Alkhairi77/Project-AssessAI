<template>
  <div class="min-h-screen bg-vox-offwhite flex items-center justify-center p-4">
    <div class="w-full max-w-md animate-fade-in">
      <!-- Logo -->
      <div class="text-center mb-3">
        <div class="inline-flex items-center justify-center">
          <img src="../assets/logo.png" alt="logo" width="75" height="75" style="border-radius: 16px;">
        </div>
        <h1 class="text-2xl font-bold text-vox-black tracking-tight">AssessAI</h1>
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
            <div class="relative">
              <input
                id="login-password"
                v-model="loginForm.password"
                :type="showLoginPassword ? 'text' : 'password'"
                class="input-field pr-11"
                placeholder="••••••••"
                autocomplete="current-password"
                required
              />
              <button
                type="button"
                tabindex="-1"
                @click="showLoginPassword = !showLoginPassword"
                class="absolute right-3 top-1/2 -translate-y-1/2 text-vox-midgray hover:text-vox-black transition-colors"
                :title="showLoginPassword ? 'Sembunyikan password' : 'Tampilkan password'"
              >
                <!-- Eye icon (password visible) -->
                <svg v-if="showLoginPassword" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                  <circle cx="12" cy="12" r="3"/>
                </svg>
                <!-- Eye-off icon (password hidden) -->
                <svg v-else width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/>
                  <path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/>
                  <line x1="1" y1="1" x2="23" y2="23"/>
                </svg>
              </button>
            </div>
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
          <div class="text-center">
            <RouterLink to="/forgot-password" class="text-xs text-vox-midgray hover:text-vox-black transition-colors">
              Lupa password?
            </RouterLink>
          </div>
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
            <label class="input-label">Status</label>
            <select id="register-role" v-model="registerForm.role" class="input-field">
              <option value="mahasiswa">Mahasiswa</option>
              <option value="dosen">Dosen</option>
            </select>
          </div>
          <div>
            <label class="input-label">Password</label>
            <div class="relative">
              <input
                id="register-password"
                v-model="registerForm.password"
                :type="showRegisterPassword ? 'text' : 'password'"
                class="input-field pr-11"
                placeholder="Minimal 6 karakter"
                required
                minlength="6"
              />
              <button
                type="button"
                tabindex="-1"
                @click="showRegisterPassword = !showRegisterPassword"
                class="absolute right-3 top-1/2 -translate-y-1/2 text-vox-midgray hover:text-vox-black transition-colors"
                :title="showRegisterPassword ? 'Sembunyikan password' : 'Tampilkan password'"
              >
                <svg v-if="showRegisterPassword" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                  <circle cx="12" cy="12" r="3"/>
                </svg>
                <svg v-else width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/>
                  <path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/>
                  <line x1="1" y1="1" x2="23" y2="23"/>
                </svg>
              </button>
            </div>
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
        AssessAI &copy; 2026 — AI-Based Presentation Assessment
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
const showLoginPassword = ref(false)
const showRegisterPassword = ref(false)

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
