<template>
  <div class="min-h-screen bg-vox-offwhite flex items-center justify-center p-4">
    <div class="w-full max-w-md animate-fade-in">
      <!-- Logo -->
      <div class="text-center mb-10">
        <RouterLink to="/" class="inline-flex items-center justify-center w-14 h-14 bg-vox-black rounded-lg mb-4">
          <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
            <path d="M5 16 L16 5 L27 16 L16 27 Z" fill="white" opacity="0.9"/>
            <circle cx="16" cy="16" r="5" fill="white"/>
            <circle cx="16" cy="16" r="2" fill="black"/>
          </svg>
        </RouterLink>
        <h1 class="text-2xl font-bold text-vox-black tracking-tight">AssessAI</h1>
        <p class="text-vox-gray text-sm mt-1">Reset Password</p>
      </div>

      <!-- Card -->
      <div class="card shadow-sm">
        <!-- Success state -->
        <div v-if="success" class="text-center py-4">
          <div class="w-14 h-14 bg-green-50 border border-green-200 rounded-full flex items-center justify-center mx-auto mb-4">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#16a34a" stroke-width="2">
              <polyline points="20 6 9 17 4 12"/>
            </svg>
          </div>
          <h2 class="font-bold text-vox-black mb-2">Email Terkirim!</h2>
          <p class="text-sm text-vox-gray mb-1">Link reset password telah dikirim ke:</p>
          <p class="font-semibold text-vox-black text-sm mb-4">{{ sentEmail }}</p>
          <p class="text-xs text-vox-midgray mb-6">
            <strong>Mode Demo:</strong> Cek konsol browser atau terminal untuk melihat reset token.
            Di produksi, link akan dikirim via email.
          </p>
          <RouterLink to="/login" class="btn-primary w-full justify-center">
            Kembali ke Halaman Masuk
          </RouterLink>
        </div>

        <!-- Form state -->
        <div v-else>
          <div class="mb-6">
            <h2 class="font-bold text-vox-black text-lg mb-1">Lupa Password?</h2>
            <p class="text-sm text-vox-gray">
              Masukkan email yang terdaftar. Kami akan mengirim link untuk mereset password Anda.
            </p>
          </div>

          <form @submit.prevent="handleSubmit" class="space-y-5">
            <div>
              <label class="input-label">Email Terdaftar</label>
              <input
                id="forgot-email"
                v-model="email"
                type="email"
                class="input-field"
                placeholder="email@kampus.ac.id"
                autocomplete="email"
                required
              />
            </div>

            <div v-if="error" class="text-xs text-red-600 bg-red-50 border border-red-200 rounded px-3 py-2">
              {{ error }}
            </div>

            <button
              id="forgot-submit"
              type="submit"
              class="btn-primary w-full"
              :disabled="isLoading"
            >
              <span v-if="isLoading" class="spinner w-4 h-4 border-white border-t-transparent" />
              {{ isLoading ? 'Mengirim...' : 'Kirim Link Reset' }}
            </button>
          </form>

          <div class="mt-5 pt-5 border-t border-vox-lightgray text-center">
            <p class="text-xs text-vox-midgray">
              Ingat password?
              <RouterLink to="/login" class="text-vox-black font-semibold hover:underline ml-1">Masuk</RouterLink>
            </p>
          </div>
        </div>
      </div>

      <p class="text-center text-xs text-vox-midgray mt-6">
        AssessAI © 2026 — AI-Based Presentation Assessment
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { RouterLink } from 'vue-router'
import api from '../services/api'

const email = ref('')
const isLoading = ref(false)
const error = ref('')
const success = ref(false)
const sentEmail = ref('')

async function handleSubmit() {
  error.value = ''
  isLoading.value = true
  try {
    await api.post('/auth/forgot-password', { email: email.value })
    sentEmail.value = email.value
    success.value = true
  } catch (e: any) {
    error.value = e.response?.data?.message || 'Gagal mengirim email. Periksa kembali alamat email Anda.'
  } finally {
    isLoading.value = false
  }
}
</script>
