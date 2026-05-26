import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    host: '0.0.0.0', // 允许外部访问
    port: 5176,
    allowedHosts: [
      '.trycloudflare.com', // 允许所有 Cloudflare 隧道域名
      'localhost',
      '10.32.196.115'
    ]
  }
})
