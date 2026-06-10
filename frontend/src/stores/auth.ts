import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import api from '../services/api'

interface User {
  id: string
  name: string
  email: string
  role: 'mahasiswa' | 'dosen'
  nimNip?: string
}

export const useAuthStore = defineStore('auth', () => {
  const token = ref<string | null>(localStorage.getItem('assess_token'))
  const user = ref<User | null>(
    JSON.parse(localStorage.getItem('assess_user') || 'null'),
  )

  const isAuthenticated = computed(() => !!token.value && !!user.value)
  const isMahasiswa = computed(() => user.value?.role === 'mahasiswa')
  const isDosen = computed(() => user.value?.role === 'dosen')

  async function register(data: {
    name: string
    email: string
    password: string
    role?: string
    nimNip?: string
  }) {
    const response = await api.post('/auth/register', data)
    setAuth(response.data.token, response.data.user)
    return response.data
  }

  async function login(email: string, password: string) {
    const response = await api.post('/auth/login', { email, password })
    setAuth(response.data.token, response.data.user)
    return response.data
  }

  async function fetchProfile() {
    const response = await api.get('/auth/profile')
    user.value = response.data
    localStorage.setItem('assess_user', JSON.stringify(response.data))
    return response.data
  }

  function setAuth(newToken: string, newUser: User) {
    token.value = newToken
    user.value = newUser
    localStorage.setItem('assess_token', newToken)
    localStorage.setItem('assess_user', JSON.stringify(newUser))
  }

  function logout() {
    token.value = null
    user.value = null
    localStorage.removeItem('assess_token')
    localStorage.removeItem('assess_user')
  }

  return {
    token,
    user,
    isAuthenticated,
    isMahasiswa,
    isDosen,
    register,
    login,
    fetchProfile,
    logout,
  }
})
