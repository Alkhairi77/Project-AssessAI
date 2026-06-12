<template>
  <div class="flex min-h-screen bg-vox-offwhite">
    <Sidebar />
    <main class="flex-1 ml-64 p-8 animate-fade-in">
      <div class="page-header">
        <h1 class="page-title">Latihan Baru</h1>
        <p class="page-subtitle">Unggah rekaman presentasi Anda untuk dianalisis oleh AI</p>
      </div>

      <div class="max-w-2xl">
        <!-- Title input -->
        <div class="card mb-5">
          <label class="input-label">Judul Presentasi</label>
          <input
            id="presentation-title"
            v-model="title"
            type="text"
            class="input-field"
            placeholder="Contoh: Presentasi Tugas Besar Kelompok 3"
            :disabled="isUploading || isAnalyzing"
          />
        </div>

        <!-- Dropzone -->
        <div
          id="audio-dropzone"
          class="card border-2 border-dashed transition-all duration-200 cursor-pointer"
          :class="{
            'border-vox-black bg-vox-offwhite': isDragOver,
            'border-vox-lightgray': !isDragOver && !selectedFile,
            'border-vox-black': selectedFile && !isUploading,
          }"
          @dragover.prevent="isDragOver = true"
          @dragleave="isDragOver = false"
          @drop.prevent="handleDrop"
          @click="!selectedFile && !isUploading ? fileInput?.click() : null"
        >
          <input
            ref="fileInput"
            type="file"
            accept=".wav,.mp3,audio/wav,audio/mpeg"
            class="hidden"
            @change="handleFileSelect"
          />

          <!-- Empty state -->
          <div v-if="!selectedFile && !isUploading" class="py-12 text-center">
            <div class="mb-4">
              <svg class="mx-auto text-vox-lightgray" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                <polyline points="17 8 12 3 7 8"/>
                <line x1="12" y1="3" x2="12" y2="15"/>
              </svg>
            </div>
            <p class="font-semibold text-vox-black mb-1">Seret file ke sini atau klik untuk memilih</p>
            <p class="text-xs text-vox-midgray">Format yang didukung: .WAV, .MP3 — Maks. 50 MB</p>
          </div>

          <!-- File selected -->
          <div v-else-if="selectedFile && !isUploading && !isAnalyzing" class="py-6">
            <div class="flex items-center gap-4">
              <div class="w-12 h-12 bg-vox-offwhite border border-vox-lightgray rounded flex items-center justify-center text-vox-gray">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <path d="M12 2a3 3 0 0 0-3 3v7a3 3 0 0 0 6 0V5a3 3 0 0 0-3-3z"/>
                  <path d="M19 10v2a7 7 0 0 1-14 0v-2"/>
                  <line x1="12" y1="19" x2="12" y2="23"/>
                  <line x1="8" y1="23" x2="16" y2="23"/>
                </svg>
              </div>
              <div class="flex-1 min-w-0">
                <p class="font-medium text-vox-black truncate text-sm">{{ selectedFile.name }}</p>
                <p class="text-xs text-vox-midgray">{{ formatFileSize(selectedFile.size) }}</p>
              </div>
              <button
                @click.stop="clearFile"
                class="text-vox-midgray hover:text-vox-black transition-colors p-1"
              >
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <line x1="18" y1="6" x2="6" y2="18"/>
                  <line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
              </button>
            </div>
          </div>

          <!-- Processing state -->
          <div v-else class="py-8 text-center">
            <div class="mb-4">
              <div class="spinner mx-auto" style="width: 32px; height: 32px;" />
            </div>
            <p class="font-semibold text-vox-black mb-1">
              {{ isUploading ? 'Mengunggah file...' : 'AI sedang menganalisis presentasi Anda...' }}
            </p>
            <p class="text-xs text-vox-midgray mb-4">
              {{ isUploading ? 'Mohon tunggu' : 'Proses ini membutuhkan waktu 15-60 detik' }}
            </p>

            <!-- Progress bar -->
            <div class="max-w-xs mx-auto">
              <div class="progress-bar-track">
                <div
                  class="progress-bar-fill progress-pulse"
                  :style="{ width: isUploading ? uploadProgress + '%' : '100%' }"
                />
              </div>
              <p class="text-xs text-vox-midgray mt-2">
                {{ isUploading ? `${uploadProgress}%` : 'Memproses...' }}
              </p>
            </div>
          </div>
        </div>

        <!-- Error message -->
        <div v-if="errorMessage" class="mt-4 px-4 py-3 bg-red-50 border border-red-200 rounded text-sm text-red-700">
          {{ errorMessage }}
        </div>

        <!-- Actions -->
        <div v-if="selectedFile && !isUploading && !isAnalyzing" class="mt-5 flex gap-3">
          <button
            id="submit-audio"
            class="btn-primary flex-1"
            @click="handleSubmit"
            :disabled="!selectedFile"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="12" cy="12" r="10"/>
              <polygon points="10 8 16 12 10 16 10 8"/>
            </svg>
            Analisis Presentasi
          </button>
          <button class="btn-outline" @click="clearFile">Batal</button>
        </div>

        <!-- Info box -->
        <div class="mt-6 px-4 py-4 bg-vox-white border border-vox-lightgray rounded">
          <p class="text-xs font-semibold text-vox-gray uppercase tracking-wider mb-2">Panduan</p>
          <ul class="space-y-1 text-xs text-vox-gray">
            <li>• Rekam presentasi dengan audio yang jelas dan minim kebisingan</li>
            <li>• Durasi optimal: 2-5 menit untuk hasil analisis terbaik</li>
            <li>• Format yang didukung: .WAV (direkomendasikan) atau .MP3</li>
            <li>• Hindari suara latar yang terlalu keras</li>
          </ul>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '../components/Sidebar.vue'
import { useEvaluationStore } from '../stores/evaluation'

const router = useRouter()
const evaluationStore = useEvaluationStore()

const title = ref('Latihan Presentasi')
const selectedFile = ref<File | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)
const isDragOver = ref(false)
const isUploading = ref(false)
const isAnalyzing = ref(false)
const errorMessage = ref('')

const uploadProgress = ref(0)

watch(() => evaluationStore.uploadProgress, (val) => {
  uploadProgress.value = val
})

function handleFileSelect(event: Event) {
  const input = event.target as HTMLInputElement
  if (input.files?.length) {
    validateAndSet(input.files[0])
  }
}

function handleDrop(event: DragEvent) {
  isDragOver.value = false
  const files = event.dataTransfer?.files
  if (files?.length) {
    validateAndSet(files[0])
  }
}

function validateAndSet(file: File) {
  errorMessage.value = ''
  const isValidType = /\.(wav|mp3)$/i.test(file.name)
  if (!isValidType) {
    errorMessage.value = 'Hanya format .WAV dan .MP3 yang didukung.'
    return
  }
  if (file.size > 52428800) {
    errorMessage.value = 'Ukuran file maksimal 50 MB.'
    return
  }
  selectedFile.value = file
}

function clearFile() {
  selectedFile.value = null
  errorMessage.value = ''
  if (fileInput.value) fileInput.value.value = ''
  evaluationStore.clearCurrent()
}

function formatFileSize(bytes: number) {
  if (bytes < 1024) return bytes + ' B'
  if (bytes < 1048576) return (bytes / 1024).toFixed(1) + ' KB'
  return (bytes / 1048576).toFixed(1) + ' MB'
}

async function handleSubmit() {
  if (!selectedFile.value) return
  errorMessage.value = ''
  isUploading.value = true

  try {
    const presentationId = await evaluationStore.uploadAudio(
      selectedFile.value,
      title.value || 'Latihan Presentasi',
    )
    isUploading.value = false
    isAnalyzing.value = true

    // Poll for evaluation result
    let attempts = 0
    const maxAttempts = 60
    const poll = setInterval(async () => {
      attempts++
      const result = await evaluationStore.fetchEvaluation(presentationId)
      if (result || attempts >= maxAttempts) {
        clearInterval(poll)
        isAnalyzing.value = false
        router.push(`/result/${presentationId}`)
      }
    }, 3000)
  } catch (e: any) {
    isUploading.value = false
    isAnalyzing.value = false
    errorMessage.value = e.response?.data?.message || 'Upload gagal. Coba lagi.'
  }
}
</script>
