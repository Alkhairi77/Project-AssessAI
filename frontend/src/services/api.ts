import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:3000/api',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Request interceptor: attach JWT token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('assess_token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => Promise.reject(error),
)

// Response interceptor: handle 401 (session expired)
api.interceptors.response.use(
  (response) => response,
  (error) => {
    const isAuthEndpoint =
      error.config?.url?.includes('/auth/login') ||
      error.config?.url?.includes('/auth/register')

    // Only redirect if token exists (session expired) and NOT on login/register
    if (error.response?.status === 401 && !isAuthEndpoint) {
      const hasToken = !!localStorage.getItem('assess_token')
      if (hasToken) {
        localStorage.removeItem('assess_token')
        localStorage.removeItem('assess_user')
        window.location.href = '/login'
      }
    }
    return Promise.reject(error)
  },
)

export default api
