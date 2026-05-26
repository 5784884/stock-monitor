<template>
  <div class="register-container">
    <div class="register-box">
      <div class="register-header">
        <div class="logo-circle">
          <el-icon :size="40"><UserFilled /></el-icon>
        </div>
        <h1 class="title">创建新账号</h1>
        <p class="subtitle">Join Stock Market Monitoring System</p>
      </div>

      <el-form :model="registerForm" :rules="rules" ref="registerFormRef" class="register-form">
        <el-form-item prop="username">
          <el-input
            v-model="registerForm.username"
            placeholder="请输入用户名"
            size="large"
            :prefix-icon="User"
          />
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            v-model="registerForm.password"
            type="password"
            placeholder="请输入密码（至少6位）"
            size="large"
            :prefix-icon="Lock"
            show-password
          />
        </el-form-item>
        <el-form-item prop="durationMonths">
          <el-input-number
            v-model="registerForm.durationMonths"
            :min="1"
            :max="12"
            :step="1"
            placeholder="请输入开通时长"
            size="large"
            controls-position="right"
            style="width: 100%"
          >
            <template #suffix>
              <span style="color: #909399; padding-right: 10px">个月</span>
            </template>
          </el-input-number>
        </el-form-item>
        <el-alert
          title="注册后需要等待管理员审批才能登录"
          type="info"
          :closable="false"
          show-icon
          style="margin-bottom: 20px"
        />
        <el-form-item>
          <el-button
            type="primary"
            @click="handleRegister"
            :loading="loading"
            size="large"
            class="register-btn"
          >
            <span v-if="!loading">注册</span>
            <span v-else>注册中...</span>
          </el-button>
        </el-form-item>
        <div class="login-link">
          <span>已有账号？</span>
          <el-link type="primary" @click="$router.push('/login')">立即登录</el-link>
        </div>
      </el-form>
    </div>

    <div class="background-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock, Calendar, UserFilled } from '@element-plus/icons-vue'
import request from '../utils/request'

const router = useRouter()
const registerFormRef = ref(null)
const loading = ref(false)

const registerForm = reactive({
  username: '',
  password: '',
  durationMonths: 1
})

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在3到20个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ],
  durationMonths: [
    { required: true, message: '请输入开通时长', trigger: 'blur' },
    { type: 'number', min: 1, max: 12, message: '开通时长必须在1到12个月之间', trigger: 'blur' }
  ]
}

const handleRegister = async () => {
  try {
    await registerFormRef.value.validate()
    loading.value = true

    await request.post('/api/auth/register', registerForm)

    ElMessage.success({
      message: '注册成功，请等待管理员审批后登录',
      duration: 3000
    })

    setTimeout(() => {
      router.push('/login')
    }, 1500)
  } catch (error) {
    console.error('注册失败:', error)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.register-container {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  overflow: hidden;
}

.background-decoration {
  position: absolute;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 0;
}

.circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  animation: float 20s infinite ease-in-out;
}

.circle-1 {
  width: 300px;
  height: 300px;
  top: -100px;
  right: -100px;
  animation-delay: 0s;
}

.circle-2 {
  width: 200px;
  height: 200px;
  bottom: -50px;
  left: 100px;
  animation-delay: 5s;
}

.circle-3 {
  width: 150px;
  height: 150px;
  top: 50%;
  left: -50px;
  animation-delay: 10s;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0) rotate(0deg);
  }
  50% {
    transform: translateY(-20px) rotate(180deg);
  }
}

.register-box {
  position: relative;
  z-index: 1;
  width: 460px;
  padding: 50px 40px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  animation: slideIn 0.5s ease-out;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.register-header {
  text-align: center;
  margin-bottom: 40px;
}

.logo-circle {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  color: white;
  margin-bottom: 20px;
  box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
}

.title {
  font-size: 28px;
  font-weight: 700;
  color: #2c3e50;
  margin: 0 0 8px 0;
  letter-spacing: 1px;
}

.subtitle {
  font-size: 14px;
  color: #7f8c8d;
  margin: 0;
  font-weight: 300;
  letter-spacing: 0.5px;
}

.register-form {
  margin-top: 30px;
}

.register-form :deep(.el-form-item) {
  margin-bottom: 24px;
}

.register-form :deep(.el-input__wrapper),
.register-form :deep(.el-select .el-input__wrapper),
.register-form :deep(.el-input-number .el-input__wrapper) {
  padding: 12px 15px;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s;
}

.register-form :deep(.el-input__wrapper:hover),
.register-form :deep(.el-select .el-input__wrapper:hover),
.register-form :deep(.el-input-number .el-input__wrapper:hover) {
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
}

.register-form :deep(.el-input__wrapper.is-focus),
.register-form :deep(.el-select .el-input__wrapper.is-focus),
.register-form :deep(.el-input-number .el-input__wrapper.is-focus) {
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.register-form :deep(.el-alert) {
  border-radius: 10px;
  background-color: #ecf5ff;
  border: 1px solid #d9ecff;
}

.register-btn {
  width: 100%;
  height: 48px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 10px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  transition: all 0.3s;
  letter-spacing: 1px;
}

.register-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
}

.register-btn:active {
  transform: translateY(0);
}

.login-link {
  text-align: center;
  margin-top: 20px;
  font-size: 14px;
  color: #7f8c8d;
}

.login-link span {
  margin-right: 8px;
}

.login-link :deep(.el-link) {
  font-weight: 600;
  font-size: 14px;
}
</style>
