import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      redirect: '/dashboard',
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('../views/AuthView.vue'),
      props: { mode: 'login' },
      meta: { requiresGuest: true },
    },
    {
      path: '/register',
      name: 'register',
      component: () => import('../views/AuthView.vue'),
      props: { mode: 'register' },
      meta: { requiresGuest: true },
    },
    {
      path: '/dashboard',
      name: 'dashboard',
      component: () => import('../views/DashboardView.vue'),
      meta: { requiresAuth: true },
    },
    {
      path: '/upload',
      name: 'upload',
      component: () => import('../views/UploadView.vue'),
      meta: { requiresAuth: true, requiresRole: 'mahasiswa' },
    },
    {
      path: '/result/:presentationId',
      name: 'result',
      component: () => import('../views/ResultView.vue'),
      meta: { requiresAuth: true },
    },
    {
      path: '/history',
      name: 'history',
      component: () => import('../views/HistoryView.vue'),
      meta: { requiresAuth: true, requiresRole: 'mahasiswa' },
    },
    {
      path: '/lecturer',
      name: 'lecturer',
      component: () => import('../views/LecturerView.vue'),
      meta: { requiresAuth: true, requiresRole: 'dosen' },
    },
    {
      path: '/:pathMatch(.*)*',
      redirect: '/dashboard',
    },
  ],
})

router.beforeEach((to, _from, next) => {
  const auth = useAuthStore()

  if (to.meta.requiresAuth && !auth.isAuthenticated) {
    return next('/login')
  }

  if (to.meta.requiresGuest && auth.isAuthenticated) {
    return next('/dashboard')
  }

  if (to.meta.requiresRole === 'dosen' && !auth.isDosen) {
    return next('/dashboard')
  }

  if (to.meta.requiresRole === 'mahasiswa' && !auth.isMahasiswa) {
    return next('/dashboard')
  }

  next()
})

export default router
