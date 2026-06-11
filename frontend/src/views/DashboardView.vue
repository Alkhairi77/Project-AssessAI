<template>
  <div class="flex min-h-screen bg-vox-offwhite">
    <Sidebar />

    <main class="flex-1 ml-64 p-8 animate-fade-in">
      <!-- Page header -->
      <div class="page-header flex items-center justify-between">
        <div>
          <h1 class="page-title">
            Selamat datang, {{ authStore.user?.name?.split(' ')[0] }} 👋
          </h1>
          <p class="page-subtitle">{{ greeting }}</p>
        </div>
        <router-link
          v-if="authStore.isMahasiswa"
          to="/upload"
          class="btn-primary"
          id="fab-new-practice"
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <line x1="12" y1="5" x2="12" y2="19"/>
            <line x1="5" y1="12" x2="19" y2="12"/>
          </svg>
          Latihan Baru
        </router-link>
      </div>

      <!-- Loading state -->
      <div v-if="isLoading" class="flex items-center justify-center h-64">
        <div class="spinner" />
      </div>

      <!-- Mahasiswa Dashboard -->
      <div v-else-if="authStore.isMahasiswa">
        <!-- Stats cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-5 mb-8">
          <div class="stat-card">
            <div class="stat-label">Total Latihan</div>
            <div class="stat-number">{{ stats.totalPractices ?? 0 }}</div>
            <div class="text-xs text-vox-midgray mt-1">sesi selesai</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">Rata-rata Skor</div>
            <div class="stat-number">{{ stats.averageScore ?? '—' }}</div>
            <div class="text-xs text-vox-midgray mt-1">dari 100</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">Peningkatan Terakhir</div>
            <div class="flex items-baseline gap-1">
              <div
                class="stat-number"
                :class="{
                  'text-green-600': stats.improvement > 0,
                  'text-red-500': stats.improvement < 0,
                }"
              >
                {{ stats.improvement !== null
                  ? (stats.improvement > 0 ? '+' : '') + stats.improvement.toFixed(1)
                  : '—' }}
              </div>
            </div>
            <div class="text-xs text-vox-midgray mt-1">vs sesi sebelumnya</div>
          </div>
        </div>

        <!-- Recent activity -->
        <div class="card">
          <div class="flex items-center justify-between mb-5">
            <h2 class="font-semibold text-vox-black">Aktivitas Terkini</h2>
            <router-link to="/history" class="text-xs text-vox-gray hover:text-vox-black font-medium transition-colors">
              Lihat semua →
            </router-link>
          </div>

          <div v-if="!stats.recentActivity?.length" class="py-12 text-center">
            <div class="text-vox-lightgray text-4xl mb-3">◻</div>
            <p class="text-vox-midgray text-sm">Belum ada latihan. Mulai latihan pertamamu!</p>
            <router-link to="/upload" class="btn-primary inline-flex mt-4 text-xs">
              Mulai Latihan
            </router-link>
          </div>

          <table v-else class="data-table">
            <thead>
              <tr>
                <th>Judul</th>
                <th>Tanggal</th>
                <th>Skor</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in stats.recentActivity" :key="item.id">
                <td class="font-medium">{{ item.title }}</td>
                <td class="text-vox-gray">{{ formatDate(item.uploadedAt) }}</td>
                <td>
                  <span v-if="item.score !== null" class="font-bold">
                    {{ item.score.toFixed(1) }}
                  </span>
                  <span v-else class="text-vox-midgray text-xs">Memproses...</span>
                </td>
                <td>
                  <router-link
                    v-if="item.score !== null"
                    :to="`/result/${item.id}`"
                    class="text-xs font-medium text-vox-gray hover:text-vox-black border border-vox-lightgray rounded px-2 py-1 transition-colors"
                  >
                    Lihat
                  </router-link>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Dosen Dashboard -->
      <div v-else>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-5 mb-8">
          <div class="stat-card">
            <div class="stat-label">Total Mahasiswa</div>
            <div class="stat-number">{{ dosenStats.length }}</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">Rata-rata Kelas</div>
            <div class="stat-number">{{ classAverage }}</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">Total Sesi</div>
            <div class="stat-number">{{ totalSessions }}</div>
          </div>
        </div>

        <div class="card">
          <div class="flex items-center justify-between mb-5">
            <h2 class="font-semibold text-vox-black">Rekap Mahasiswa</h2>
            <router-link to="/lecturer" class="text-xs text-vox-gray hover:text-vox-black font-medium transition-colors">
              Lihat detail →
            </router-link>
          </div>

          <table class="data-table">
            <thead>
              <tr>
                <th>Nama</th>
                <th>NIM</th>
                <th>Total Latihan</th>
                <th>Skor Terakhir</th>
                <th>Rata-rata</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="s in dosenStats.slice(0, 8)" :key="s.id">
                <td class="font-medium">{{ s.name }}</td>
                <td class="text-vox-gray">{{ s.nimNip || '—' }}</td>
                <td>{{ s.totalPractices }}</td>
                <td>
                  <span v-if="s.latestScore !== null" class="font-bold">{{ s.latestScore.toFixed(1) }}</span>
                  <span v-else class="text-vox-midgray">—</span>
                </td>
                <td>
                  <span v-if="s.averageScore !== null">{{ s.averageScore }}</span>
                  <span v-else class="text-vox-midgray">—</span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import { useAuthStore } from '../stores/auth'
import { useEvaluationStore } from '../stores/evaluation'

const authStore = useAuthStore()
const evaluationStore = useEvaluationStore()

const isLoading = ref(true)
const stats = ref<any>({})
const dosenStats = ref<any[]>([])

const greeting = computed(() => {
  const h = new Date().getHours()
  if (h < 12) return 'Selamat pagi! Semangat berlatih hari ini.'
  if (h < 17) return 'Selamat siang! Terus tingkatkan kemampuan presentasimu.'
  return 'Selamat malam! Review hasil latihanmu hari ini.'
})

const classAverage = computed(() => {
  const scores = dosenStats.value
    .map((s) => s.averageScore)
    .filter((s) => s !== null)
  if (!scores.length) return '—'
  return (scores.reduce((a: number, b: number) => a + b, 0) / scores.length).toFixed(1)
})

const totalSessions = computed(() =>
  dosenStats.value.reduce((sum, s) => sum + s.totalPractices, 0)
)

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('id-ID', {
    day: 'numeric', month: 'short', year: 'numeric',
  })
}

onMounted(async () => {
  try {
    if (authStore.isMahasiswa) {
      stats.value = await evaluationStore.getDashboardStats()
    } else {
      dosenStats.value = await evaluationStore.getDosenStats()
    }
  } catch (e) {
    console.error(e)
  } finally {
    isLoading.value = false
  }
})
</script>
