import axios from 'axios'
import { ElMessage } from 'element-plus'

// 使用环境变量或默认使用后端公网地址
const baseURL = import.meta.env.VITE_API_BASE_URL || 'https://attempt-rate-produced-moves.trycloudflare.com'

const request = axios.create({
  baseURL: baseURL,
  timeout: 10000
})

// 请求拦截器
request.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  response => {
    const res = response.data
    if (res.code !== 200) {
      ElMessage.error(res.message || '请求失败')
      // 只有在已登录状态下遇到401/403才跳转登录页
      // 登录接口返回的403（待审批/已拒绝）不应该跳转
      if (res.code === 401) {
        localStorage.removeItem('token')
        localStorage.removeItem('userInfo')
        window.location.href = '/login'
      }
      return Promise.reject(new Error(res.message || '请求失败'))
    }
    return res
  },
  error => {
    if (error.response && error.response.status === 401) {
      ElMessage.error('未授权，请重新登录')
      localStorage.removeItem('token')
      localStorage.removeItem('userInfo')
      window.location.href = '/login'
    } else {
      ElMessage.error(error.message || '网络错误')
    }
    return Promise.reject(error)
  }
)

export default request
