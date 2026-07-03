<template>
  <div class="flex min-h-screen bg-vox-offwhite">
    <Sidebar />
    <div class="flex-1 ml-64 flex flex-col">
      <!-- Navbar -->
      <Navbar />

      <main class="flex-1 p-8 animate-fade-in">
        <div class="page-header flex items-center justify-between">
          <div>
            <h1 class="page-title">Monitor Mahasiswa</h1>
            <p class="page-subtitle">Riwayat presentasi seluruh mahasiswa</p>
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
            <div class="stat-label">Total Presentasi</div>
            <div class="stat-number">{{ allPresentations.length }}</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">Rata-rata Skor Kelas</div>
            <div class="stat-number">{{ classAvg }}</div>
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
                    type="number" v-model.number="rubric.weight"
                    min="0" max="100" class="input-field w-20 py-1.5 text-xs"
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

        <!-- Presentations table -->
        <div class="card">
          <div class="flex items-center justify-between mb-4 flex-wrap gap-3">
            <h2 class="font-semibold text-vox-black">Riwayat Presentasi Mahasiswa</h2>
            <div class="flex items-center gap-3">
              <!-- Filter by class -->
              <select v-model="filterCourse" class="input-field text-xs py-2 w-44">
                <option value="">Semua Kelas</option>
                <option v-for="c in courseOptions" :key="c.id" :value="c.id">{{ c.name }}</option>
              </select>
              <!-- Search -->
              <input
                v-model="search"
                type="text"
                placeholder="Cari nama / NIM..."
                class="input-field w-44 text-xs py-2"
              />
            </div>
          </div>

          <div v-if="isLoading" class="flex justify-center py-8">
            <div class="spinner" />
          </div>

          <div v-else-if="!filteredPresentations.length" class="py-10 text-center text-vox-midgray text-sm">
            Tidak ada presentasi ditemukan.
          </div>

          <table v-else class="data-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Mahasiswa</th>
                <th>Kelas</th>
                <th>Topik Presentasi</th>
                <th>Skor</th>
                <th>Tanggal</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(p, i) in filteredPresentations" :key="p.presentationId">
                <td class="text-vox-midgray text-xs">{{ i + 1 }}</td>
                <td>
                  <div class="font-medium text-sm">{{ p.studentName }}</div>
                  <div class="text-vox-midgray text-xs">{{ p.nimNip || '—' }}</div>
                </td>
                <td>
                  <span class="badge-gray text-xs">{{ p.courseName || '—' }}</span>
                </td>
                <td class="max-w-[180px]">
                  <div class="truncate text-sm font-medium">{{ p.title }}</div>
                </td>
                <td>
                  <span v-if="p.score !== null" class="font-bold text-base">{{ p.score.toFixed(1) }}</span>
                  <span v-else class="text-vox-midgray text-xs">—</span>
                </td>
                <td class="text-vox-gray text-xs">{{ formatDate(p.uploadedAt) }}</td>
                <td>
                  <router-link
                    v-if="p.score !== null"
                    :to="`/result/${p.presentationId}`"
                    class="text-xs font-medium border border-vox-lightgray rounded px-2 py-1 text-vox-gray hover:text-vox-black hover:border-vox-black transition-colors whitespace-nowrap"
                  >
                    Detail →
                  </router-link>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import Navbar from '../components/Navbar.vue'
import api from '../services/api'

const isLoading = ref(true)
const isLoadingRubrics = ref(true)
const isSavingRubrics = ref(false)
const students = ref<any[]>([])
const allPresentations = ref<any[]>([])
const rubrics = ref<any[]>([])
const courses = ref<any[]>([])
const search = ref('')
const filterCourse = ref('')

const courseOptions = computed(() => {
  const map = new Map<string, string>()
  allPresentations.value.forEach((p) => {
    if (p.courseId && p.courseName) map.set(p.courseId, p.courseName)
  })
  return Array.from(map.entries()).map(([id, name]) => ({ id, name }))
})

const filteredPresentations = computed(() => {
  return allPresentations.value.filter((p) => {
    const matchSearch =
      p.studentName.toLowerCase().includes(search.value.toLowerCase()) ||
      (p.nimNip || '').toLowerCase().includes(search.value.toLowerCase())
    const matchCourse = !filterCourse.value || p.courseId === filterCourse.value
    return matchSearch && matchCourse
  })
})

const classAvg = computed(() => {
  const scores = allPresentations.value
    .filter((p) => p.score !== null)
    .map((p) => p.score)
  if (!scores.length) return '—'
  return (scores.reduce((a: number, b: number) => a + b, 0) / scores.length).toFixed(1)
})

const totalWeight = computed(() =>
  rubrics.value.reduce((sum, r) => sum + Number(r.weight), 0)
)

async function saveRubrics() {
  if (totalWeight.value !== 100) return
  isSavingRubrics.value = true
  try {
    await Promise.all(
      rubrics.value.map((r) => api.patch(`/rubrics/${r.id}`, { weight: r.weight }))
    )
  } finally {
    isSavingRubrics.value = false
  }
}

function exportCSV() {
  const headers = ['Nama', 'NIM', 'Kelas', 'Topik Presentasi', 'Skor', 'Artikulasi', 'Intonasi', 'Tanggal']
  const rows = filteredPresentations.value.map((p) => [
    p.studentName,
    p.nimNip || '',
    p.courseName || '',
    p.title,
    p.score ?? '',
    p.articulationScore ?? '',
    p.intonationScore ?? '',
    new Date(p.uploadedAt).toLocaleDateString('id-ID'),
  ])
  const csv = [headers, ...rows].map((r) => r.map(v => `"${v}"`).join(',')).join('\n')
  const blob = new Blob(['\uFEFF' + csv], { type: 'text/csv;charset=utf-8;' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `riwayat-presentasi-${new Date().toISOString().split('T')[0]}.csv`
  a.click()
  URL.revokeObjectURL(url)
}

function formatDate(d: string) {
  return new Date(d).toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' })
}

onMounted(async () => {
  try {
    const [allRes, rubricsData, coursesData] = await Promise.all([
      api.get('/presentations/dosen/all-students').catch(() => ({ data: [] })),
      api.get('/rubrics').then(r => r.data),
      api.get('/courses').then(r => r.data),
    ])

    rubrics.value = rubricsData.map((r: any) => ({ ...r, id: String(r.id) }))
    courses.value = coursesData

    const courseMap = new Map(coursesData.map((c: any) => [String(c.id), c.name]))
    const rawList = Array.isArray(allRes.data) ? allRes.data : []

    // Collect unique students for stats
    const studentSet = new Map<string, any>()
    const presentations: any[] = []

    for (const p of rawList) {
      const sid = p.user?.id ?? p.id
      if (!studentSet.has(String(sid))) {
        studentSet.set(String(sid), p.user)
      }
      presentations.push({
        presentationId: p.presentationId ?? p.id,
        studentName: p.user?.name ?? '—',
        nimNip: p.user?.nimNip ?? '',
        courseId: p.courseId ? String(p.courseId) : null,
        courseName: p.courseId ? (courseMap.get(String(p.courseId)) ?? '—') : null,
        title: p.title,
        uploadedAt: p.uploadedAt,
        score: p.evaluation?.overallScore ?? null,
        articulationScore: p.evaluation?.articulationScore ?? null,
        intonationScore: p.evaluation?.intonationScore ?? null,
      })
    }

    students.value = Array.from(studentSet.values())
    allPresentations.value = presentations
  } finally {
    isLoading.value = false
    isLoadingRubrics.value = false
  }
})
</script>
