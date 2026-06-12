<template>
  <aside class="fixed left-0 top-0 h-screen w-64 bg-vox-black flex flex-col z-40">
    <!-- Logo -->
    <div class="px-6 pt-8 pb-6 border-b border-white/10">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 bg-white flex items-center justify-center rounded-sm">
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
            <path d="M3 10 L10 3 L17 10 L10 17 Z" fill="black"/>
            <circle cx="10" cy="10" r="3" fill="white"/>
          </svg>
        </div>
        <div>
          <div class="text-white font-bold text-sm tracking-widest uppercase">AssessAI</div>
          <div class="text-gray-500 text-xs">AI Speech Evaluator</div>
        </div>
      </div>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 px-3 py-6 space-y-1 overflow-y-auto">
      <router-link
        v-for="item in navItems"
        :key="item.to"
        :to="item.to"
        class="nav-item"
        :class="{ active: isActive(item.to) }"
      >
        <span class="text-base" v-html="item.icon"></span>
        <span>{{ item.label }}</span>
      </router-link>
    </nav>

    <!-- User info -->
    <div class="px-4 py-4 border-t border-white/10">
      <div class="flex items-center gap-3 px-2 py-2 rounded hover:bg-white/5 transition-colors cursor-pointer">
        <div class="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center text-white text-xs font-bold">
          {{ userInitial }}
        </div>
        <div class="flex-1 min-w-0">
          <div class="text-white text-xs font-medium truncate">{{ authStore.user?.name }}</div>
          <div class="text-gray-500 text-xs capitalize">{{ authStore.user?.role }}</div>
        </div>
        <button @click="handleLogout" class="text-gray-500 hover:text-white transition-colors p-1" title="Logout">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
            <polyline points="16 17 21 12 16 7"/>
            <line x1="21" y1="12" x2="9" y2="12"/>
          </svg>
        </button>
      </div>
    </div>
  </aside>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const mahasiswaNav = [
  { to: '/dashboard', label: 'Dashboard', icon: '⊞' },
  { to: '/upload', label: 'Latihan Baru', icon: '↑' },
  { to: '/history', label: 'Riwayat', icon: '≡' },
]

const dosenNav = [
  { to: '/dashboard', label: 'Dashboard', icon: '⊞' },
  { to: '/lecturer', label: 'Monitor Mahasiswa', icon: '◈' },
]

const navItems = computed(() =>
  authStore.isDosen ? dosenNav : mahasiswaNav
)

const userInitial = computed(() =>
  authStore.user?.name?.charAt(0).toUpperCase() ?? 'U'
)

function isActive(path: string) {
  return route.path === path || route.path.startsWith(path + '/')
}

function handleLogout() {
  authStore.logout()
  router.push('/login')
}
</script>
