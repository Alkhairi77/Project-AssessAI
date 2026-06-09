import { defineStore } from 'pinia'
import { ref } from 'vue'
import api from '../services/api'

interface EmotionResult {
  id: string
  emotionLabel: string
  confidenceScore: number
}

interface Evaluation {
  id: string
  overallScore: number
  articulationScore: number
  intonationScore: number
  transcription: string
  feedback: string
  createdAt: string
  emotionResults: EmotionResult[]
}

interface PresentationRecord {
  presentationId: string
  title: string
  uploadedAt: string
  duration: number | null
  evaluation: Evaluation | null
}

export const useEvaluationStore = defineStore('evaluation', () => {
  const currentEvaluation = ref<Evaluation | null>(null)
  const currentPresentationId = ref<string | null>(null)
  const history = ref<PresentationRecord[]>([])
  const isProcessing = ref(false)
  const uploadProgress = ref(0)

  async function uploadAudio(file: File, title: string): Promise<string> {
    isProcessing.value = true
    uploadProgress.value = 0

    try {
      const formData = new FormData()
      formData.append('audio', file)
      formData.append('title', title)

      const response = await api.post('/presentations', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
        onUploadProgress: (progressEvent) => {
          if (progressEvent.total) {
            uploadProgress.value = Math.round(
              (progressEvent.loaded * 100) / progressEvent.total,
            )
          }
        },
        timeout: 180000,
      })

      currentPresentationId.value = response.data.presentationId
      return response.data.presentationId
    } finally {
      isProcessing.value = false
    }
  }

  async function fetchEvaluation(presentationId: string): Promise<Evaluation | null> {
    try {
      const response = await api.get(`/evaluations/by-presentation/${presentationId}`)
      currentEvaluation.value = response.data
      return response.data
    } catch {
      return null
    }
  }

  async function fetchHistory() {
    const response = await api.get('/evaluations/history')
    history.value = response.data
    return response.data
  }

  async function getDashboardStats() {
    const response = await api.get('/evaluations/dashboard-stats')
    return response.data
  }

  async function getDosenStats() {
    const response = await api.get('/evaluations/dosen/stats')
    return response.data
  }

  function clearCurrent() {
    currentEvaluation.value = null
    currentPresentationId.value = null
    uploadProgress.value = 0
  }

  return {
    currentEvaluation,
    currentPresentationId,
    history,
    isProcessing,
    uploadProgress,
    uploadAudio,
    fetchEvaluation,
    fetchHistory,
    getDashboardStats,
    getDosenStats,
    clearCurrent,
  }
})
