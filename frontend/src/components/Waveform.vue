<template>
  <div class="relative">
    <canvas ref="canvasRef" :width="width" :height="height" class="w-full" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch, nextTick } from 'vue'

const props = defineProps<{
  audioUrl?: string
  waveformData?: number[]
  width?: number
  height?: number
  color?: string
}>()

const canvasRef = ref<HTMLCanvasElement | null>(null)

const drawWaveform = (data: number[]) => {
  const canvas = canvasRef.value
  if (!canvas) return
  const ctx = canvas.getContext('2d')
  if (!ctx) return

  const w = canvas.width
  const h = canvas.height
  const color = props.color || '#000000'

  ctx.clearRect(0, 0, w, h)

  // Background
  ctx.fillStyle = '#F9FAFB'
  ctx.fillRect(0, 0, w, h)

  if (!data || data.length === 0) {
    // Draw empty waveform placeholder
    ctx.strokeStyle = '#E5E7EB'
    ctx.lineWidth = 1
    ctx.beginPath()
    ctx.moveTo(0, h / 2)
    ctx.lineTo(w, h / 2)
    ctx.stroke()
    return
  }

  // Draw waveform
  ctx.strokeStyle = color
  ctx.lineWidth = 1.5
  ctx.lineJoin = 'round'
  ctx.beginPath()

  const sliceWidth = w / data.length
  let x = 0

  for (let i = 0; i < data.length; i++) {
    const v = data[i]
    const y = (1 - v) * (h / 2) + (h / 4)
    if (i === 0) ctx.moveTo(x, y)
    else ctx.lineTo(x, y)
    x += sliceWidth
  }

  ctx.stroke()

  // Mirror below center
  ctx.globalAlpha = 0.3
  ctx.beginPath()
  x = 0
  for (let i = 0; i < data.length; i++) {
    const v = data[i]
    const y = h - ((1 - v) * (h / 2) + (h / 4))
    if (i === 0) ctx.moveTo(x, y)
    else ctx.lineTo(x, y)
    x += sliceWidth
  }
  ctx.stroke()
  ctx.globalAlpha = 1

  // Center line
  ctx.strokeStyle = '#E5E7EB'
  ctx.lineWidth = 0.5
  ctx.beginPath()
  ctx.moveTo(0, h / 2)
  ctx.lineTo(w, h / 2)
  ctx.stroke()
}

// Generate mock waveform for display if no real data
const generateMockWaveform = (count = 200) => {
  const data: number[] = []
  for (let i = 0; i < count; i++) {
    const envelope = Math.sin((i / count) * Math.PI)
    const wave = Math.random() * 0.8 + 0.1
    data.push(envelope * wave)
  }
  return data
}

onMounted(async () => {
  await nextTick()
  const data = props.waveformData?.length
    ? props.waveformData
    : generateMockWaveform()
  drawWaveform(data)
})

watch(
  () => props.waveformData,
  (newData) => {
    drawWaveform(newData || generateMockWaveform())
  },
)
</script>
