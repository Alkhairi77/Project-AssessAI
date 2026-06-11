<template>
  <div class="flex min-h-screen bg-vox-offwhite">
    <Sidebar />
    <main class="flex-1 ml-64 p-8 animate-fade-in">
      <div class="page-header flex items-center justify-between">
        <div>
          <h1 class="page-title">Riwayat Latihan</h1>
          <p class="page-subtitle">Semua sesi presentasi yang pernah Anda lakukan</p>
        </div>
      </div>

      <!-- Loading -->
      <div v-if="isLoading" class="flex items-center justify-center h-64">
        <div class="spinner" />
      </div>

      <!-- Empty state -->
      <div v-else-if="!history.length" class="card text-center py-16">
        <div class="text-4xl text-vox-lightgray mb-4">◻</div>
        <p class="text-vox-midgray mb-4">Belum ada riwayat latihan</p>
        <router-link to="/upload" class="btn-primary inline-flex">Mulai Latihan Pertama</router-link>
      </div>

      <!-- History table -->
      <div v-else class="card">
        <div class="flex items-center justify-between mb-5">
          <p class="text-sm text-vox-gray">{{ history.length }} sesi ditemukan</p>
          <div class="relative">
            <input
              v-model="search"
              type="text"
              placeholder="Cari judul..."
              class="input-field w-48 text-xs py-2"
            />
          </div>
        </div>

        <table class="data-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Judul Presentasi</th>
              <th>Tanggal</th>
              <th>Durasi</th>
              <th>Skor</th>
              <th>Artikulasi</th>
              <th>Intonasi</th>
              <th>Emosi Dominan</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, i) in filteredHistory" :key="item.presentationId">
              <td class="text-vox-midgray text-xs">{{ i + 1 }}</td>
              <td class="font-medium max-w-[180px] truncate">{{ item.title }}</td>
              <td class="text-vox-gray text-xs">{{ formatDate(item.uploadedAt) }}</td>
              <td class="text-vox-gray text-xs">
                {{ item.duration ? formatDuration(item.duration) : '—' }}
              </td>
              <td>
                <span v-if="item.evaluation" class="font-bold">
                  {{ Math.round(item.evaluation.overallScore) }}
                </span>
                <span v-else class="text-vox-midgray text-xs">...</span>
              </td>
              <td class="text-xs">
                {{ item.evaluation ? Math.round(item.evaluation.articulationScore) : '—' }}
              </td>
              <td class="text-xs">
                {{ item.evaluation ? Math.round(item.evaluation.intonationScore) : '—' }}
              </td>
              <td>
                <span v-if="item.evaluation?.emotionResults?.length" class="badge-gray capitalize text-xs">
                  {{ getTopEmotion(item.evaluation.emotionResults) }}
                </span>
              </td>
              <td>
                <router-link
                  v-if="item.evaluation"
                  :to="`/result/${item.presentationId}`"
                  class="text-xs font-medium border border-vox-lightgray rounded px-2 py-1 text-vox-gray hover:text-vox-black hover:border-vox-black transition-colors"
                >
                  Detail
                </router-link>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import { useEvaluationStore } from '../stores/evaluation'

const evaluationStore = useEvaluationStore()
const isLoading = ref(true)
const history = ref<any[]>([])
const search = ref('')

const filteredHistory = computed(() =>
  history.value.filter((h) =>
    h.title.toLowerCase().includes(search.value.toLowerCase()),
  ),
)

function formatDate(d: string) {
  return new Date(d).toLocaleDateString('id-ID', {
    day: 'numeric', month: 'short', year: 'numeric',
  })
}

function formatDuration(seconds: number) {
  const m = Math.floor(seconds / 60)
  const s = seconds % 60
  return `${m}:${s.toString().padStart(2, '0')}`
}

function getTopEmotion(emotionResults: any[]) {
  const top = emotionResults.reduce((a, b) =>
    a.confidenceScore > b.confidenceScore ? a : b, emotionResults[0]
  )
  const displayMap: Record<string, string> = {
    neutral: 'Netral', happy: 'Antusias',
    surprise: 'Terkejut', disgust: 'Tdk Nyaman', disappointed: 'Kecewa',
  }
  return displayMap[top.emotionLabel] || top.emotionLabel
}

onMounted(async () => {
  try {
    history.value = await evaluationStore.fetchHistory()
  } finally {
    isLoading.value = false
  }
})
</script>
