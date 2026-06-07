<template>
  <div class="watermark-container">
    <canvas ref="watermarkCanvas" class="watermark-canvas"></canvas>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const watermarkCanvas = ref(null)

const drawWatermark = () => {
  const canvas = watermarkCanvas.value
  if (!canvas) return

  const ctx = canvas.getContext('2d')
  const width = window.innerWidth
  const height = window.innerHeight

  canvas.width = width
  canvas.height = height

  ctx.clearRect(0, 0, width, height)

  ctx.font = '16px Arial'
  ctx.fillStyle = 'rgba(0, 0, 0, 0.08)'
  ctx.textAlign = 'center'
  ctx.textBaseline = 'middle'

  const text = '请联系：731899023 215341380'
  const xGap = 350
  const yGap = 200

  ctx.save()
  ctx.rotate(-20 * Math.PI / 180)

  const startX = -height
  const endX = width + height
  const startY = -width
  const endY = height + width

  for (let x = startX; x < endX; x += xGap) {
    for (let y = startY; y < endY; y += yGap) {
      ctx.fillText(text, x, y)
    }
  }

  ctx.restore()
}

onMounted(() => {
  drawWatermark()
  window.addEventListener('resize', drawWatermark)
})
</script>

<style scoped>
.watermark-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 9999;
  overflow: hidden;
}

.watermark-canvas {
  width: 100%;
  height: 100%;
}
</style>
