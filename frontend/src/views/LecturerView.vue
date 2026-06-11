<template>
  <div class="flex min-h-screen bg-vox-offwhite">
    <Sidebar />
    <main class="flex-1 ml-64 p-8 animate-fade-in">
      <div class="page-header flex items-center justify-between">
        <div>
          <h1 class="page-title">Monitor Mahasiswa</h1>
          <p class="page-subtitle">Rekapitulasi performa seluruh mahasiswa</p>
        </div>
        <button @click="exportCSV" class="btn-outline text-sm">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
            <polyline points="7 10 12 15 17 10"/>
            <line x1="12" y1="15" x2="12" y2="3"/>
          </svg>
          Export CSV
        </button>
      </div>

      <!-- Summary stats -->
      <div class="grid grid-cols-3 gap-5 mb-8">
        <div class="stat-card">
          <div class="stat-label">Total Mahasiswa</div>
          <div class="stat-number">{{ students.length }}</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Rata-rata Kelas</div>
          <div class="stat-number">{{ classAvg }}</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Total Sesi Latihan</div>
          <div class="stat-number">{{ totalSessions }}</div>
        </div>
      </div>

      <!-- Rubric weights -->
      <div class="card mb-6">
        <div class="flex items-center justify-between mb-4">
          <h2 class="font-semibold text-vox-black">Bobot Rubrik Penilaian</h2>
          <button @click="saveRubrics" class="btn-primary text-xs py-1.5 px-3" :disabled="isSavingRubrics">
            {{ isSavingRubrics ? 'Menyimpan...' : 'Simpan Perubahan' }}
          </button>
        </div>
        <div v-if="isLoadingRubrics" class="flex justify-center py-4">
          <div class="spinner" />
        </div>
        <table v-else class="data-table">
          <thead>
            <tr>
              <th>Kriteria</th>
              <th>Bobot (%)</th>
              <th>Deskripsi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="rubric in rubrics" :key="rubric.id">
              <td class="font-medium">{{ rubric.criteriaName }}</td>
              <td>
                <input
                  type="number"
                  v-model.number="rubric.weight"
                  min="0" max="100"
                  class="input-field w-20 py-1.5 text-xs"
                />
              </td>
              <td class="text-vox-gray text-xs">{{ rubric.description }}</td>
            </tr>
          </tbody>
        </table>
        <p class="text-xs text-vox-midgray mt-3">
          Total bobot: <strong>{{ totalWeight }}%</strong>
          <span v-if="totalWeight !== 100" class="text-red-500 ml-2">⚠ Harus 100%</span>
        </p>
      </div>

      <!-- Students table -->
      <div class="card">
        <div class="flex items-center justify-between mb-4">
          <h2 class="font-semibold text-vox-black">Daftar Mahasiswa</h2>
          <input
            v-model="search"
            type="text"
            placeholder="Cari nama/NIM..."
            class="input-field w-48 text-xs py-2"
          />
        </div>

        <div v-if="isLoading" class="flex justify-center py-8">
          <div class="spinner" />
        </div>

        <table v-else class="data-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Nama Mahasiswa</th>
              <th>NIM</th>
              <th>Email</th>
              <th>Total Latihan</th>
              <th>Skor Terakhir</th>
              <th>Rata-rata</th>
              <th>Tren</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(s, i) in filteredStudents" :key="s.id">
              <td class="text-vox-midgray text-xs">{{ i + 1 }}</td>
              <td class="font-medium">{{ s.name }}</td>
              <td class="text-vox-gray text-xs">{{ s.nimNip || '—' }}</td>
              <td class="text-vox-gray text-xs">{{ s.email }}</td>
              <td>{{ s.totalPractices }}</td>
              <td>
                <span v-if="s.latestScore !== null" class="font-bold">
                  {{ s.latestScore.toFixed(1) }}
                </span>
                <span v-else class="text-vox-midgray text-xs">—</span>
              </td>
              <td>
                <span v-if="s.averageScore !== null">{{ s.averageScore }}</span>
                <span v-else class="text-vox-midgray text-xs">—</span>
              </td>
              <td>
                <span v-if="s.latestScore !== null && s.averageScore !== null">
                  <span v-if="s.latestScore > s.averageScore" class="text-green-600 font-bold text-base">↑</span>
                  <span v-else-if="s.latestScore < s.averageScore" class="text-red-500 font-bold text-base">↓</span>
                  <span v-else class="text-vox-midgray font-bold text-base">→</span>
                </span>
                <span v-else class="text-vox-midgray text-xs">—</span>
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
import api from '../services/api'

const evaluationStore = useEvaluationStore()
const isLoading = ref(true)
const isLoadingRubrics = ref(true)
const isSavingRubrics = ref(false)
const students = ref<any[]>([])
const rubrics = ref<any[]>([])
const search = ref('')

const filteredStudents = computed(() =>
  students.value.filter(
    (s) =>
      s.name.toLowerCase().includes(search.value.toLowerCase()) ||
      (s.nimNip || '').toLowerCase().includes(search.value.toLowerCase()),
  ),
)

const classAvg = computed(() => {
  const scores = students.value.map((s) => s.averageScore).filter((s) => s !== null)
  if (!scores.length) return '—'
  return (scores.reduce((a: number, b: number) => a + b, 0) / scores.length).toFixed(1)
})

const totalSessions = computed(() =>
  students.value.reduce((sum, s) => sum + s.totalPractices, 0)
)

const totalWeight = computed(() =>
  rubrics.value.reduce((sum, r) => sum + Number(r.weight), 0)
)

async function saveRubrics() {
  if (totalWeight.value !== 100) return
  isSavingRubrics.value = true
  try {
    await Promise.all(
      rubrics.value.map((r) =>
        api.patch(`/rubrics/${r.id}`, { weight: r.weight })
      )
    )
  } finally {
    isSavingRubrics.value = false
  }
}

function exportCSV() {
  const headers = ['Nama', 'NIM', 'Email', 'Total Latihan', 'Skor Terakhir', 'Rata-rata']
  const rows = students.value.map((s) => [
    s.name, s.nimNip || '', s.email,
    s.totalPractices, s.latestScore ?? '', s.averageScore ?? '',
  ])
  const csv = [headers, ...rows].map((r) => r.join(',')).join('\n')
  const blob = new Blob([csv], { type: 'text/csv' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `rekap-mahasiswa-${new Date().toISOString().split('T')[0]}.csv`
  a.click()
  URL.revokeObjectURL(url)
}

onMounted(async () => {
  try {
    const [studentsData, rubricsData] = await Promise.all([
      evaluationStore.getDosenStats(),
      api.get('/rubrics').then((r) => r.data),
    ])
    students.value = studentsData
    rubrics.value = rubricsData.map((r: any) => ({
      ...r,
      id: typeof r.id === 'bigint' ? r.id.toString() : r.id,
    }))
  } finally {
    isLoading.value = false
    isLoadingRubrics.value = false
  }
})
</script>
