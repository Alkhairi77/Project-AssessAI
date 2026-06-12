<template>
  <div class="flex min-h-screen bg-vox-offwhite">
    <Sidebar />
    <main class="flex-1 ml-64 p-8 animate-fade-in">
      <!-- Loading -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center h-64 gap-4">
        <div class="spinner" style="width: 32px; height: 32px;" />
        <p class="text-vox-gray text-sm">Memuat hasil analisis...</p>
      </div>

      <!-- Not found -->
      <div v-else-if="!evaluation" class="flex flex-col items-center justify-center h-64 gap-4">
        <div class="text-4xl text-vox-lightgray">◻</div>
        <p class="text-vox-gray">Hasil analisis belum tersedia atau masih diproses.</p>
        <router-link to="/history" class="btn-outline text-sm">Lihat Riwayat</router-link>
      </div>

      <!-- Result content -->
      <div v-else class="max-w-4xl">
        <!-- Header -->
        <div class="page-header flex items-start justify-between">
          <div>
            <h1 class="page-title">Hasil Analisis AI</h1>
            <p class="page-subtitle">{{ formatDate(evaluation.createdAt) }}</p>
          </div>
          <router-link to="/upload" class="btn-primary text-sm">
            Latihan Lagi
          </router-link>
        </div>

        <!-- Score hero -->
        <div class="card mb-6 text-center py-10">
          <p class="text-xs font-semibold text-vox-gray uppercase tracking-wider mb-3">Skor Akhir</p>
          <div class="score-display justify-center mb-4">
            <span class="score-value">{{ Math.round(evaluation.overallScore) }}</span>
            <span class="score-max">/100</span>
          </div>
          <div class="flex items-center justify-center gap-2">
            <span
              class="badge"
              :class="getScoreBadgeClass(evaluation.overallScore)"
            >
              {{ getScoreLabel(evaluation.overallScore) }}
            </span>
          </div>
        </div>

        <!-- Sub scores grid -->
        <div class="grid grid-cols-2 gap-5 mb-6">
          <div class="card">
            <div class="flex items-center justify-between mb-3">
              <span class="text-xs font-semibold text-vox-gray uppercase tracking-wider">Artikulasi</span>
              <span class="font-bold text-lg">{{ Math.round(evaluation.articulationScore) }}</span>
            </div>
            <div class="progress-bar-track">
              <div class="progress-bar-fill" :style="{ width: evaluation.articulationScore + '%' }" />
            </div>
          </div>
          <div class="card">
            <div class="flex items-center justify-between mb-3">
              <span class="text-xs font-semibold text-vox-gray uppercase tracking-wider">Intonasi</span>
              <span class="font-bold text-lg">{{ Math.round(evaluation.intonationScore) }}</span>
            </div>
            <div class="progress-bar-track">
              <div class="progress-bar-fill" :style="{ width: evaluation.intonationScore + '%' }" />
            </div>
          </div>
        </div>

        <!-- Main analysis grid -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
          <!-- Emotion chart -->
          <div class="card">
            <h2 class="font-semibold text-vox-black mb-5">Deteksi Emosi Suara</h2>
            <div class="space-y-3">
              <div
                v-for="emotion in sortedEmotions"
                :key="emotion.emotionLabel"
                class="flex items-center gap-3"
              >
                <div class="text-xs text-vox-gray w-28 text-right capitalize shrink-0">
                  {{ emotionDisplay[emotion.emotionLabel] || emotion.emotionLabel }}
                </div>
                <div class="flex-1 progress-bar-track h-5 relative">
                  <div
                    class="progress-bar-fill h-full"
                    :style="{
                      width: (emotion.confidenceScore * 100) + '%',
                      backgroundColor: emotion.emotionLabel === dominantEmotion ? '#000000' : '#D1D5DB',
                    }"
                  />
                </div>
                <div class="text-xs font-semibold text-vox-black w-10 shrink-0">
                  {{ (emotion.confidenceScore * 100).toFixed(1) }}%
                </div>
              </div>
            </div>
          </div>

          <!-- Waveform & transcription -->
          <div class="card">
            <h2 class="font-semibold text-vox-black mb-4">Visualisasi Audio</h2>
            <Waveform :height="80" class="rounded mb-4" />
            <div class="mt-2">
              <p class="text-xs font-semibold text-vox-gray uppercase tracking-wider mb-2">Transkripsi</p>
              <div class="bg-vox-offwhite rounded p-3 text-sm text-vox-black leading-relaxed max-h-36 overflow-y-auto">
                {{ evaluation.transcription || 'Transkripsi tidak tersedia.' }}
              </div>
            </div>
          </div>
        </div>

        <!-- AI Feedback -->
        <div class="card">
          <h2 class="font-semibold text-vox-black mb-4">Saran Perbaikan dari AI</h2>
          <div class="bg-vox-offwhite rounded-lg p-5">
            <div
              v-for="(line, i) in feedbackLines"
              :key="i"
              class="flex items-start gap-2 mb-2 last:mb-0"
            >
              <span class="text-vox-midgray text-sm shrink-0">•</span>
              <p class="text-sm text-vox-black leading-relaxed">{{ line.replace(/^•\s*/, '') }}</p>
            </div>
          </div>
        </div>

        <!-- Navigation -->
        <div class="mt-6 flex gap-3">
          <router-link to="/history" class="btn-outline text-sm">← Riwayat</router-link>
          <router-link to="/upload" class="btn-primary text-sm">Latihan Lagi</router-link>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import Sidebar from '../components/Sidebar.vue'
import Waveform from '../components/Waveform.vue'
import { useEvaluationStore } from '../stores/evaluation'

const route = useRoute()
const evaluationStore = useEvaluationStore()

const isLoading = ref(true)
const evaluation = ref<any>(null)

const emotionDisplay: Record<string, string> = {
  neutral: 'Netral',
  happy: 'Antusias',
  surprise: 'Terkejut',
  disgust: 'Tidak Nyaman',
  disappointed: 'Kecewa',
}

const sortedEmotions = computed(() => {
  if (!evaluation.value?.emotionResults) return []
  return [...evaluation.value.emotionResults].sort(
    (a, b) => b.confidenceScore - a.confidenceScore
  )
})

const dominantEmotion = computed(() => sortedEmotions.value[0]?.emotionLabel)

const feedbackLines = computed(() => {
  if (!evaluation.value?.feedback) return []
  return evaluation.value.feedback.split('\n').filter((l: string) => l.trim())
})

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('id-ID', {
    weekday: 'long', day: 'numeric', month: 'long', year: 'numeric',
    hour: '2-digit', minute: '2-digit',
  })
}

function getScoreLabel(score: number) {
  if (score >= 85) return 'Sangat Baik'
  if (score >= 70) return 'Baik'
  if (score >= 55) return 'Cukup'
  return 'Perlu Perbaikan'
}

function getScoreBadgeClass(score: number) {
  if (score >= 85) return 'badge-black'
  if (score >= 70) return 'badge bg-vox-darkgray text-white'
  if (score >= 55) return 'badge bg-vox-lightgray text-vox-gray'
  return 'badge bg-red-100 text-red-700'
}

onMounted(async () => {
  const presentationId = route.params.presentationId as string
  try {
    evaluation.value = await evaluationStore.fetchEvaluation(presentationId)
  } catch (e) {
    console.error(e)
  } finally {
    isLoading.value = false
  }
})
</script>
