<template>
  <div class="flex min-h-screen bg-vox-offwhite">
    <Sidebar />
    <main class="flex-1 ml-64 p-8 animate-fade-in">
      <div class="page-header flex items-start justify-between">
        <div>
          <h1 class="page-title">Kelas / Mata Kuliah</h1>
          <p class="page-subtitle">Kelola kelas yang Anda ampu dan pantau presentasi mahasiswa</p>
        </div>
        <button
          v-if="authStore.isDosen"
          id="add-course-btn"
          class="btn-primary"
          @click="showAddModal = true"
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          Tambah Kelas
        </button>
      </div>

      <!-- Loading -->
      <div v-if="isLoading" class="flex justify-center py-16">
        <div class="spinner w-8 h-8"></div>
      </div>

      <!-- Empty state -->
      <div v-else-if="courses.length === 0" class="card text-center py-16">
        <div class="w-12 h-12 bg-vox-offwhite border border-vox-lightgray rounded-lg flex items-center justify-center mx-auto mb-4">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="1.5">
            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
          </svg>
        </div>
        <p class="font-semibold text-vox-black text-sm mb-1">Belum ada kelas</p>
        <p class="text-xs text-vox-midgray mb-4">{{ authStore.isDosen ? 'Buat kelas pertama Anda untuk mulai mengelola mahasiswa' : 'Belum ada kelas yang tersedia' }}</p>
        <button v-if="authStore.isDosen" class="btn-primary mx-auto" @click="showAddModal = true">Tambah Kelas</button>
      </div>

      <!-- Courses grid -->
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        <div
          v-for="course in courses"
          :key="course.id"
          class="card-shadow cursor-pointer hover:border-vox-black transition-all"
          @click="selectCourse(course)"
        >
          <div class="flex items-start justify-between mb-3">
            <div class="w-10 h-10 bg-vox-black rounded-lg flex items-center justify-center flex-shrink-0">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
              </svg>
            </div>
            <button
              v-if="authStore.isDosen"
              @click.stop="deleteCourse(course.id)"
              class="text-vox-midgray hover:text-red-500 transition-colors p-1"
              title="Hapus kelas"
            >
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/>
              </svg>
            </button>
          </div>
          <h3 class="font-semibold text-vox-black text-sm mb-1">{{ course.name }}</h3>
          <p class="text-xs text-vox-midgray">
            {{ authStore.isDosen ? `${course.presentationCount ?? 0} presentasi` : `Dosen: ${course.dosenName}` }}
          </p>
          <div class="mt-4 pt-3 border-t border-vox-lightgray flex justify-between items-center">
            <span class="text-xs text-vox-midgray">{{ formatDate(course.createdAt) }}</span>
            <span v-if="authStore.isDosen" class="text-xs text-vox-black font-medium hover:underline">Lihat Detail →</span>
          </div>
        </div>
      </div>

      <!-- Course Detail Modal -->
      <div v-if="selectedCourse" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-2xl max-h-[85vh] overflow-hidden flex flex-col m-4">
          <div class="flex items-center justify-between p-6 border-b border-vox-lightgray">
            <div>
              <h2 class="font-bold text-vox-black">{{ selectedCourse.name }}</h2>
              <p class="text-xs text-vox-midgray mt-0.5">{{ presentations.length }} presentasi</p>
            </div>
            <button @click="selectedCourse = null; presentations = []" class="text-vox-midgray hover:text-vox-black">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </button>
          </div>
          <div class="overflow-y-auto flex-1 p-6">
            <div v-if="loadingPresentations" class="flex justify-center py-8"><div class="spinner"></div></div>
            <div v-else-if="presentations.length === 0" class="text-center py-8 text-vox-midgray text-sm">Belum ada presentasi di kelas ini</div>
            <table v-else class="data-table w-full">
              <thead>
                <tr>
                  <th>Mahasiswa</th>
                  <th>Judul</th>
                  <th>Skor</th>
                  <th>Tanggal</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="p in presentations" :key="p.id">
                  <td>
                    <div class="font-medium text-vox-black">{{ p.student.name }}</div>
                    <div class="text-vox-midgray text-xs">{{ p.student.nimNip ?? '-' }}</div>
                  </td>
                  <td class="text-vox-black">{{ p.title }}</td>
                  <td>
                    <span v-if="p.evaluation" class="font-semibold">{{ p.evaluation.overallScore.toFixed(1) }}</span>
                    <span v-else class="text-vox-midgray text-xs">Belum dinilai</span>
                  </td>
                  <td class="text-vox-midgray text-xs">{{ formatDate(p.uploadedAt) }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Add Course Modal -->
      <div v-if="showAddModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-md p-6 m-4">
          <h2 class="font-bold text-vox-black mb-5">Tambah Kelas Baru</h2>
          <form @submit.prevent="handleAddCourse" class="space-y-4">
            <div>
              <label class="input-label">Nama Kelas / Mata Kuliah</label>
              <input
                id="course-name-input"
                v-model="newCourseName"
                type="text"
                class="input-field"
                placeholder="Contoh: Sistem Informasi Manajemen"
                required
              />
            </div>
            <div v-if="addError" class="text-xs text-red-600 bg-red-50 border border-red-200 rounded px-3 py-2">{{ addError }}</div>
            <div class="flex gap-3 pt-2">
              <button type="submit" class="btn-primary flex-1" :disabled="isAdding">
                <span v-if="isAdding" class="spinner w-4 h-4 border-white border-t-transparent" />
                {{ isAdding ? 'Membuat...' : 'Buat Kelas' }}
              </button>
              <button type="button" class="btn-outline" @click="showAddModal = false; newCourseName = ''">Batal</button>
            </div>
          </form>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import { useAuthStore } from '../stores/auth'
import api from '../services/api'

const authStore = useAuthStore()

const courses = ref<any[]>([])
const isLoading = ref(true)
const showAddModal = ref(false)
const newCourseName = ref('')
const isAdding = ref(false)
const addError = ref('')
const selectedCourse = ref<any>(null)
const presentations = ref<any[]>([])
const loadingPresentations = ref(false)

onMounted(async () => {
  await loadCourses()
})

async function loadCourses() {
  isLoading.value = true
  try {
    const res = await api.get('/courses')
    courses.value = res.data
  } catch {
    courses.value = []
  } finally {
    isLoading.value = false
  }
}

async function handleAddCourse() {
  if (!newCourseName.value.trim()) return
  addError.value = ''
  isAdding.value = true
  try {
    await api.post('/courses', { name: newCourseName.value.trim() })
    newCourseName.value = ''
    showAddModal.value = false
    await loadCourses()
  } catch (e: any) {
    addError.value = e.response?.data?.message || 'Gagal membuat kelas'
  } finally {
    isAdding.value = false
  }
}

async function deleteCourse(id: string) {
  if (!confirm('Hapus kelas ini? Semua data presentasi tetap tersimpan.')) return
  try {
    await api.delete(`/courses/${id}`)
    await loadCourses()
  } catch (e: any) {
    alert(e.response?.data?.message || 'Gagal menghapus kelas')
  }
}

async function selectCourse(course: any) {
  if (!authStore.isDosen) return
  selectedCourse.value = course
  loadingPresentations.value = true
  presentations.value = []
  try {
    const res = await api.get(`/courses/${course.id}/presentations`)
    presentations.value = res.data
  } catch {
    presentations.value = []
  } finally {
    loadingPresentations.value = false
  }
}

function formatDate(dateStr?: string) {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleDateString('id-ID', {
    day: 'numeric', month: 'short', year: 'numeric',
  })
}
</script>
