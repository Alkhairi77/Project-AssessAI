<template>
  <header class="h-14 bg-white border-b border-vox-lightgray flex items-center px-6 gap-4 sticky top-0 z-30 shadow-sm">
    <!-- Page title -->
    <div class="flex-1 min-w-0">
      <slot>
        <span class="text-sm font-semibold text-vox-black">{{ currentPageTitle }}</span>
      </slot>
    </div>

    <!-- Search bar -->
    <div class="relative hidden md:flex items-center" ref="searchRef">
      <div class="relative">
        <svg
          class="absolute left-3 top-1/2 -translate-y-1/2 text-vox-midgray pointer-events-none"
          width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
        >
          <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
        </svg>
        <input
          id="navbar-search"
          v-model="searchQuery"
          type="text"
          placeholder="Cari..."
          class="w-56 pl-9 pr-4 py-1.5 text-sm bg-vox-offwhite border border-vox-lightgray rounded-lg
                 placeholder:text-vox-midgray text-vox-black
                 focus:outline-none focus:ring-1 focus:ring-vox-black focus:border-vox-black focus:w-72
                 transition-all duration-300"
          @focus="showResults = true"
          @keydown.escape="closeSearch"
          @keydown.enter="goToFirstResult"
        />
        <kbd
          v-if="!searchQuery"
          class="absolute right-2.5 top-1/2 -translate-y-1/2 text-vox-midgray text-xs
                 bg-vox-lightgray rounded px-1.5 py-0.5 font-mono pointer-events-none"
        >/</kbd>
      </div>

      <!-- Search results dropdown -->
      <div
        v-if="showResults && searchQuery.length > 0"
        class="absolute top-10 left-0 w-80 bg-white border border-vox-lightgray rounded-xl shadow-xl py-2 z-50 animate-fade-in"
      >
        <div v-if="filteredResults.length === 0" class="px-4 py-3 text-sm text-vox-midgray text-center">
          Tidak ada hasil untuk "<strong>{{ searchQuery }}</strong>"
        </div>
        <template v-else>
          <div v-for="group in filteredResults" :key="group.category">
            <div class="px-4 py-1.5 text-xs font-semibold text-vox-midgray uppercase tracking-wider border-b border-vox-lightgray">
              {{ group.category }}
            </div>
            <RouterLink
              v-for="item in group.items"
              :key="item.path"
              :to="item.path"
              class="flex items-center gap-3 px-4 py-2.5 hover:bg-vox-offwhite transition-colors"
              @click="closeSearch"
            >
              <span class="text-vox-midgray" v-html="item.icon"></span>
              <div class="flex-1 min-w-0">
                <div class="text-sm font-medium text-vox-black">{{ item.label }}</div>
                <div class="text-xs text-vox-midgray truncate">{{ item.description }}</div>
              </div>
            </RouterLink>
          </div>
        </template>
      </div>
    </div>

    <!-- Right side -->
    <div class="flex items-center gap-2">
      <!-- Notification bell -->
      <button
        class="w-8 h-8 rounded-full hover:bg-vox-offwhite transition-colors flex items-center justify-center text-vox-midgray"
        title="Notifikasi"
      >
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
          <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
        </svg>
      </button>

      <!-- Profile dropdown -->
      <div class="relative" ref="dropdownRef">
        <button
          id="navbar-profile-btn"
          @click="showDropdown = !showDropdown"
          class="flex items-center gap-2.5 h-9 px-2.5 rounded-lg hover:bg-vox-offwhite transition-colors"
        >
          <div class="w-7 h-7 rounded-full overflow-hidden bg-vox-lightgray flex items-center justify-center text-xs font-bold text-vox-gray flex-shrink-0">
            <img
              v-if="authStore.user?.avatarUrl"
              :src="getAvatarUrl(authStore.user.avatarUrl)"
              alt="avatar"
              class="w-full h-full object-cover"
            />
            <span v-else>{{ userInitial }}</span>
          </div>
          <div class="text-left hidden sm:block">
            <div class="text-xs font-semibold text-vox-black leading-tight">{{ authStore.user?.name }}</div>
            <div class="text-xs text-vox-midgray capitalize leading-tight">{{ authStore.user?.role }}</div>
          </div>
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" class="text-vox-midgray">
            <polyline points="6 9 12 15 18 9"/>
          </svg>
        </button>

        <!-- Dropdown menu -->
        <div
          v-if="showDropdown"
          class="absolute right-0 top-11 w-52 bg-white border border-vox-lightgray rounded-xl shadow-lg py-1.5 animate-fade-in z-50"
        >
          <div class="px-4 py-2.5 border-b border-vox-lightgray mb-1">
            <div class="text-xs font-semibold text-vox-black truncate">{{ authStore.user?.name }}</div>
            <div class="text-xs text-vox-midgray truncate">{{ authStore.user?.email }}</div>
          </div>
          <RouterLink
            to="/profile"
            class="flex items-center gap-2.5 px-4 py-2 text-sm text-vox-gray hover:text-vox-black hover:bg-vox-offwhite transition-colors"
            @click="showDropdown = false"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
            </svg>
            Profil Saya
          </RouterLink>
          <RouterLink
            to="/courses"
            class="flex items-center gap-2.5 px-4 py-2 text-sm text-vox-gray hover:text-vox-black hover:bg-vox-offwhite transition-colors"
            @click="showDropdown = false"
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
              <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
            </svg>
            {{ authStore.isDosen ? 'Kelas Saya' : 'Kelas' }}
          </RouterLink>
          <div class="border-t border-vox-lightgray mt-1 pt-1">
            <button
              @click="handleLogout"
              class="w-full flex items-center gap-2.5 px-4 py-2 text-sm text-red-500 hover:text-red-700 hover:bg-red-50 transition-colors"
            >
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                <polyline points="16 17 21 12 16 7"/>
                <line x1="21" y1="12" x2="9" y2="12"/>
              </svg>
              Keluar
            </button>
          </div>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()
const router = useRouter()
const route = useRoute()

const showDropdown = ref(false)
const dropdownRef = ref<HTMLElement | null>(null)
const searchRef = ref<HTMLElement | null>(null)
const searchQuery = ref('')
const showResults = ref(false)

const routeTitles: Record<string, string> = {
  '/dashboard': 'Dashboard',
  '/upload': 'Latihan Baru',
  '/history': 'Riwayat Latihan',
  '/lecturer': 'Monitor Mahasiswa',
  '/profile': 'Profil Saya',
  '/courses': 'Kelas & Mata Kuliah',
}

const currentPageTitle = computed(() => routeTitles[route.path] ?? 'AssessAI')

const userInitial = computed(() =>
  authStore.user?.name?.charAt(0).toUpperCase() ?? 'U'
)

// Search items — role-aware
const allNavItems = computed(() => {
  const base = [
    {
      category: 'Halaman',
      items: [
        { label: 'Dashboard', path: '/dashboard', description: 'Ringkasan & statistik', icon: '⊞' },
        { label: 'Profil Saya', path: '/profile', description: 'Edit nama, NIM, foto profil', icon: '○' },
        { label: 'Kelas', path: '/courses', description: 'Daftar kelas & mata kuliah', icon: '◫' },
      ],
    },
  ]

  if (authStore.isMahasiswa) {
    base[0].items.push(
      { label: 'Latihan Baru', path: '/upload', description: 'Upload rekaman presentasi', icon: '↑' },
      { label: 'Riwayat Latihan', path: '/history', description: 'Semua sesi yang pernah dilakukan', icon: '≡' },
    )
  }

  if (authStore.isDosen) {
    base[0].items.push(
      { label: 'Monitor Mahasiswa', path: '/lecturer', description: 'Riwayat presentasi semua mahasiswa', icon: '◈' },
    )
  }

  return base
})

const filteredResults = computed(() => {
  if (!searchQuery.value.trim()) return []
  const q = searchQuery.value.toLowerCase()
  return allNavItems.value
    .map((group) => ({
      ...group,
      items: group.items.filter(
        (item) =>
          item.label.toLowerCase().includes(q) ||
          item.description.toLowerCase().includes(q)
      ),
    }))
    .filter((group) => group.items.length > 0)
})

function closeSearch() {
  showResults.value = false
  searchQuery.value = ''
}

function goToFirstResult() {
  const first = filteredResults.value[0]?.items[0]
  if (first) {
    router.push(first.path)
    closeSearch()
  }
}

function getAvatarUrl(url?: string | null): string | undefined {
  if (!url) return undefined
  if (url.startsWith('http')) return url
  return `http://localhost:3000${url}`
}

function handleLogout() {
  authStore.logout()
  showDropdown.value = false
  router.push('/login')
}

// Close dropdown/search on outside click
function handleOutsideClick(e: MouseEvent) {
  if (dropdownRef.value && !dropdownRef.value.contains(e.target as Node)) {
    showDropdown.value = false
  }
  if (searchRef.value && !searchRef.value.contains(e.target as Node)) {
    showResults.value = false
  }
}

// Keyboard shortcut: "/" opens search
function handleKeydown(e: KeyboardEvent) {
  if (e.key === '/' && !(e.target instanceof HTMLInputElement) && !(e.target instanceof HTMLTextAreaElement)) {
    e.preventDefault()
    const input = document.getElementById('navbar-search') as HTMLInputElement | null
    input?.focus()
    showResults.value = true
  }
  if (e.key === 'Escape') {
    closeSearch()
    showDropdown.value = false
  }
}

onMounted(() => {
  document.addEventListener('mousedown', handleOutsideClick)
  document.addEventListener('keydown', handleKeydown)
})
onUnmounted(() => {
  document.removeEventListener('mousedown', handleOutsideClick)
  document.removeEventListener('keydown', handleKeydown)
})
</script>
