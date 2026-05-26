<template>
  <div class="admin-container">
    <!-- 顶部导航栏 -->
    <div class="top-navbar">
      <div class="navbar-content">
        <div class="navbar-left">
          <div class="logo">
            <svg class="logo-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M2 17L12 22L22 17" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M2 12L12 17L22 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span class="logo-text">用户管理中心</span>
          </div>
        </div>
        <div class="navbar-right">
          <div class="user-badge">
            <div class="user-avatar">{{ userInfo.username?.charAt(0).toUpperCase() }}</div>
            <span class="user-name">{{ userInfo.username }}</span>
          </div>
          <el-button @click="$router.push('/dashboard')" class="nav-btn" plain>
            <svg class="btn-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <rect x="3" y="3" width="7" height="7" stroke="currentColor" stroke-width="2"/>
              <rect x="14" y="3" width="7" height="7" stroke="currentColor" stroke-width="2"/>
              <rect x="3" y="14" width="7" height="7" stroke="currentColor" stroke-width="2"/>
              <rect x="14" y="14" width="7" height="7" stroke="currentColor" stroke-width="2"/>
            </svg>
            数据大盘
          </el-button>
          <el-button @click="handleLogout" class="nav-btn logout-btn" plain>
            <svg class="btn-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M9 21H5C4.46957 21 3.96086 20.7893 3.58579 20.4142C3.21071 20.0391 3 19.5304 3 19V5C3 4.46957 3.21071 3.96086 3.58579 3.58579C3.96086 3.21071 4.46957 3 5 3H9" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M16 17L21 12L16 7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M21 12H9" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            退出
          </el-button>
        </div>
      </div>
    </div>

    <!-- 主内容区 -->
    <div class="main-content">
      <!-- 统计卡片 -->
      <div class="stats-cards">
        <div class="stat-card">
          <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M17 21V19C17 17.9391 16.5786 16.9217 15.8284 16.1716C15.0783 15.4214 14.0609 15 13 15H5C3.93913 15 2.92172 15.4214 2.17157 16.1716C1.42143 16.9217 1 17.9391 1 19V21" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M9 11C11.2091 11 13 9.20914 13 7C13 4.79086 11.2091 3 9 3C6.79086 3 5 4.79086 5 7C5 9.20914 6.79086 11 9 11Z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M23 21V19C22.9993 18.1137 22.7044 17.2528 22.1614 16.5523C21.6184 15.8519 20.8581 15.3516 20 15.13" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M16 3.13C16.8604 3.35031 17.623 3.85071 18.1676 4.55232C18.7122 5.25392 19.0078 6.11683 19.0078 7.005C19.0078 7.89318 18.7122 8.75608 18.1676 9.45769C17.623 10.1593 16.8604 10.6597 16 10.88" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ users.length }}</div>
            <div class="stat-label">总用户数</div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22Z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M12 6V12L16 14" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ users.filter(u => u.approved === 0).length }}</div>
            <div class="stat-label">待审批</div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M22 11.08V12C21.9988 14.1564 21.3005 16.2547 20.0093 17.9818C18.7182 19.7088 16.9033 20.9725 14.8354 21.5839C12.7674 22.1953 10.5573 22.1219 8.53447 21.3746C6.51168 20.6273 4.78465 19.2461 3.61096 17.4371C2.43727 15.628 1.87979 13.4881 2.02168 11.3363C2.16356 9.18455 2.99721 7.13631 4.39828 5.49706C5.79935 3.85781 7.69279 2.71537 9.79619 2.24013C11.8996 1.76489 14.1003 1.98232 16.07 2.86" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M22 4L12 14.01L9 11.01" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ users.filter(u => u.approved === 1).length }}</div>
            <div class="stat-label">已审批</div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-icon" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M10.29 3.86L1.82 18C1.64537 18.3024 1.55296 18.6453 1.55199 18.9945C1.55101 19.3437 1.64151 19.6871 1.81445 19.9905C1.98738 20.2939 2.23675 20.5467 2.53773 20.7239C2.83871 20.9011 3.18082 20.9962 3.53 21H20.47C20.8192 20.9962 21.1613 20.9011 21.4623 20.7239C21.7633 20.5467 22.0126 20.2939 22.1856 19.9905C22.3585 19.6871 22.449 19.3437 22.448 18.9945C22.447 18.6453 22.3546 18.3024 22.18 18L13.71 3.86C13.5317 3.56611 13.2807 3.32312 12.9812 3.15448C12.6817 2.98585 12.3437 2.89725 12 2.89725C11.6563 2.89725 11.3183 2.98585 11.0188 3.15448C10.7193 3.32312 10.4683 3.56611 10.29 3.86Z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M12 9V13" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M12 17H12.01" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ users.filter(u => isExpired(u.expireTime)).length }}</div>
            <div class="stat-label">已过期</div>
          </div>
        </div>
      </div>

      <!-- 操作栏 -->
      <div class="action-bar">
        <div class="search-box">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索用户名或ID"
            size="large"
            clearable
            class="search-input"
          >
            <template #prefix>
              <svg class="search-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="2"/>
                <path d="M21 21L16.65 16.65" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
            </template>
          </el-input>
        </div>
        <el-button @click="showCreateDialog" type="primary" size="large" class="add-user-btn">
          <svg class="btn-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M16 21V19C16 17.9391 15.5786 16.9217 14.8284 16.1716C14.0783 15.4214 13.0609 15 12 15H5C3.93913 15 2.92172 15.4214 2.17157 16.1716C1.42143 16.9217 1 17.9391 1 19V21" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M8.5 11C10.7091 11 12.5 9.20914 12.5 7C12.5 4.79086 10.7091 3 8.5 3C6.29086 3 4.5 4.79086 4.5 7C4.5 9.20914 6.29086 11 8.5 11Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M20 8V14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M23 11H17" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          添加用户
        </el-button>
      </div>

      <!-- 用户表格 - 桌面端 -->
      <div class="table-container desktop-table">
        <el-table :data="filteredUsers" style="width: 100%" v-loading="loading" class="modern-table">
          <el-table-column prop="id" label="ID" width="80" align="center" />
          <el-table-column prop="username" label="用户名" width="150">
            <template #default="{ row }">
              <div class="username-cell">
                <div class="user-avatar-small">{{ row.username?.charAt(0).toUpperCase() }}</div>
                <span>{{ row.username }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="role" label="角色" width="120" align="center">
            <template #default="{ row }">
              <el-tag :type="row.role === 'ADMIN' ? 'danger' : 'primary'" effect="plain">
                {{ row.role === 'ADMIN' ? '管理员' : '普通用户' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="approved" label="审批状态" width="120" align="center">
            <template #default="{ row }">
              <el-tag v-if="row.approved === 0" type="warning" effect="dark">待审批</el-tag>
              <el-tag v-else-if="row.approved === 1" type="success" effect="dark">已审批</el-tag>
              <el-tag v-else-if="row.approved === 2" type="danger" effect="dark">已拒绝</el-tag>
              <el-tag v-else type="info" effect="dark">未知</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="expireTime" label="到期时间" width="180" align="center">
            <template #default="{ row }">
              <div class="expire-cell">
                <svg v-if="isExpired(row.expireTime)" class="expire-icon expired" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
                  <path d="M12 6V12L16 14" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                </svg>
                <svg v-else class="expire-icon active" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M22 11.08V12C21.9988 14.1564 21.3005 16.2547 20.0093 17.9818C18.7182 19.7088 16.9033 20.9725 14.8354 21.5839C12.7674 22.1953 10.5573 22.1219 8.53447 21.3746C6.51168 20.6273 4.78465 19.2461 3.61096 17.4371C2.43727 15.628 1.87979 13.4881 2.02168 11.3363C2.16356 9.18455 2.99721 7.13631 4.39828 5.49706C5.79935 3.85781 7.69279 2.71537 9.79619 2.24013C11.8996 1.76489 14.1003 1.98232 16.07 2.86" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  <path d="M22 4L12 14.01L9 11.01" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <span :class="{ 'expired-text': isExpired(row.expireTime), 'active-text': !isExpired(row.expireTime) }">
                  {{ formatTime(row.expireTime) }}
                </span>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="createTime" label="注册时间" width="180" align="center">
            <template #default="{ row }">
              {{ formatTime(row.createTime) }}
            </template>
          </el-table-column>
          <el-table-column label="操作" fixed="right" width="400" align="center">
            <template #default="{ row }">
              <div class="action-buttons">
                <el-button v-if="row.approved === 0" size="small" type="success" plain @click="handleApprove(row)">
                  通过
                </el-button>
                <el-button v-if="row.approved === 0" size="small" type="warning" plain @click="handleReject(row)">
                  拒绝
                </el-button>
                <el-button size="small" type="primary" plain @click="showExpireDialog(row)">续期</el-button>
                <el-button size="small" type="info" plain @click="showPasswordDialog(row)">改密</el-button>
                <el-button size="small" type="danger" plain @click="handleDelete(row)">删除</el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 用户卡片 - 移动端 -->
      <div class="mobile-cards">
        <div v-for="user in filteredUsers" :key="user.id" class="user-card">
          <div class="user-card-header">
            <div class="user-info-row">
              <div class="user-avatar-large">{{ user.username?.charAt(0).toUpperCase() }}</div>
              <div class="user-basic-info">
                <div class="user-name-row">
                  <span class="username-text">{{ user.username }}</span>
                  <el-tag :type="user.role === 'ADMIN' ? 'danger' : 'primary'" size="small" effect="plain">
                    {{ user.role === 'ADMIN' ? '管理员' : '用户' }}
                  </el-tag>
                </div>
                <div class="user-id">ID: {{ user.id }}</div>
              </div>
            </div>
            <el-tag v-if="user.approved === 0" type="warning" effect="dark" size="small">待审批</el-tag>
            <el-tag v-else-if="user.approved === 1" type="success" effect="dark" size="small">已审批</el-tag>
            <el-tag v-else-if="user.approved === 2" type="danger" effect="dark" size="small">已拒绝</el-tag>
          </div>

          <div class="user-card-body">
            <div class="info-item">
              <span class="info-label">到期时间</span>
              <span :class="['info-value', { 'expired-text': isExpired(user.expireTime), 'active-text': !isExpired(user.expireTime) }]">
                {{ formatTime(user.expireTime) }}
              </span>
            </div>
            <div class="info-item">
              <span class="info-label">注册时间</span>
              <span class="info-value">{{ formatTime(user.createTime) }}</span>
            </div>
          </div>

          <div class="user-card-footer">
            <el-button v-if="user.approved === 0" size="small" type="success" @click="handleApprove(user)">通过</el-button>
            <el-button v-if="user.approved === 0" size="small" type="warning" @click="handleReject(user)">拒绝</el-button>
            <el-button size="small" type="primary" @click="showExpireDialog(user)">续期</el-button>
            <el-button size="small" type="info" @click="showPasswordDialog(user)">改密</el-button>
            <el-button size="small" type="danger" @click="handleDelete(user)">删除</el-button>
          </div>
        </div>
      </div>

      <!-- 续期对话框 -->
      <el-dialog v-model="expireDialogVisible" title="用户续期" width="450px" class="modern-dialog">
        <el-form :model="expireForm" label-width="100px" class="dialog-form">
          <el-form-item label="用户名">
            <el-input v-model="currentUser.username" disabled />
          </el-form-item>
          <el-form-item label="延长时长">
            <el-input-number
              v-model="expireForm.durationMonths"
              :min="1"
              :max="12"
              :step="1"
              controls-position="right"
              style="width: 100%"
            >
              <template #suffix>
                <span style="color: #909399; padding-right: 10px">个月</span>
              </template>
            </el-input-number>
          </el-form-item>
        </el-form>
        <template #footer>
          <div class="dialog-footer">
            <el-button @click="expireDialogVisible = false" size="large">取消</el-button>
            <el-button type="primary" @click="handleExpire" size="large">确定续期</el-button>
          </div>
        </template>
      </el-dialog>

      <!-- 改密对话框 -->
      <el-dialog v-model="passwordDialogVisible" title="重置密码" width="450px" class="modern-dialog">
        <el-form :model="passwordForm" label-width="100px" class="dialog-form">
          <el-form-item label="用户名">
            <el-input v-model="currentUser.username" disabled />
          </el-form-item>
          <el-form-item label="新密码">
            <el-input v-model="passwordForm.newPassword" type="password" placeholder="请输入新密码" show-password />
          </el-form-item>
        </el-form>
        <template #footer>
          <div class="dialog-footer">
            <el-button @click="passwordDialogVisible = false" size="large">取消</el-button>
            <el-button type="primary" @click="handleResetPassword" size="large">确定修改</el-button>
          </div>
        </template>
      </el-dialog>

      <!-- 添加用户对话框 -->
      <el-dialog v-model="createDialogVisible" title="添加新用户" width="500px" class="modern-dialog">
        <el-form :model="createForm" label-width="100px" class="dialog-form">
          <el-form-item label="用户名">
            <el-input v-model="createForm.username" placeholder="请输入用户名" />
          </el-form-item>
          <el-form-item label="密码">
            <el-input v-model="createForm.password" type="password" placeholder="请输入密码" show-password />
          </el-form-item>
          <el-form-item label="角色">
            <el-select v-model="createForm.role" placeholder="请选择角色" style="width: 100%">
              <el-option label="普通用户" value="USER" />
              <el-option label="管理员" value="ADMIN" />
            </el-select>
          </el-form-item>
          <el-form-item label="有效期">
            <el-input-number
              v-model="createForm.durationMonths"
              :min="1"
              :max="12"
              :step="1"
              controls-position="right"
              style="width: 100%"
            >
              <template #suffix>
                <span style="color: #909399; padding-right: 10px">个月</span>
              </template>
            </el-input-number>
          </el-form-item>
        </el-form>
        <template #footer>
          <div class="dialog-footer">
            <el-button @click="createDialogVisible = false" size="large">取消</el-button>
            <el-button type="primary" @click="handleCreate" size="large">确定添加</el-button>
          </div>
        </template>
      </el-dialog>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../utils/request'

const router = useRouter()
const loading = ref(false)
const users = ref([])
const searchKeyword = ref('')

const userInfo = reactive(JSON.parse(localStorage.getItem('userInfo') || '{}'))

// 过滤用户列表
const filteredUsers = computed(() => {
  if (!searchKeyword.value) {
    return users.value
  }
  const keyword = searchKeyword.value.toLowerCase().trim()
  return users.value.filter(user => {
    return user.username?.toLowerCase().includes(keyword) ||
           user.id?.toString().includes(keyword)
  })
})

const expireDialogVisible = ref(false)
const passwordDialogVisible = ref(false)
const createDialogVisible = ref(false)

const currentUser = reactive({})
const expireForm = reactive({ durationMonths: 1 })
const passwordForm = reactive({ newPassword: '' })
const createForm = reactive({
  username: '',
  password: '',
  role: 'USER',
  durationMonths: 1
})

const loadUsers = async () => {
  try {
    loading.value = true
    const res = await request.get('/api/admin/users')
    users.value = res.data
  } catch (error) {
    console.error('加载用户列表失败:', error)
  } finally {
    loading.value = false
  }
}

const showExpireDialog = (user) => {
  Object.assign(currentUser, user)
  expireForm.durationMonths = 1
  expireDialogVisible.value = true
}

const showPasswordDialog = (user) => {
  Object.assign(currentUser, user)
  passwordForm.newPassword = ''
  passwordDialogVisible.value = true
}

const showCreateDialog = () => {
  createForm.username = ''
  createForm.password = ''
  createForm.role = 'USER'
  createForm.durationMonths = 1
  createDialogVisible.value = true
}

const handleExpire = async () => {
  try {
    await request.put(`/api/admin/users/${currentUser.id}/expire`, expireForm)
    ElMessage.success('续期成功')
    expireDialogVisible.value = false
    loadUsers()
  } catch (error) {
    console.error('续期失败:', error)
  }
}

const handleResetPassword = async () => {
  if (!passwordForm.newPassword) {
    ElMessage.warning('请输入新密码')
    return
  }

  try {
    await request.put(`/api/admin/users/${currentUser.id}/password`, passwordForm)
    ElMessage.success('密码重置成功')
    passwordDialogVisible.value = false
  } catch (error) {
    console.error('密码重置失败:', error)
  }
}

const handleCreate = async () => {
  if (!createForm.username || !createForm.password) {
    ElMessage.warning('请填写完整信息')
    return
  }

  try {
    await request.post('/api/admin/users', createForm)
    ElMessage.success('用户创建成功')
    createDialogVisible.value = false
    loadUsers()
  } catch (error) {
    console.error('创建用户失败:', error)
  }
}

const handleDelete = async (user) => {
  try {
    await ElMessageBox.confirm(`确定要删除用户 ${user.username} 吗？`, '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })

    await request.delete(`/api/admin/users/${user.id}`)
    ElMessage.success('删除成功')
    loadUsers()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
    }
  }
}

const handleApprove = async (user) => {
  try {
    await request.put(`/api/admin/users/${user.id}/approve`)
    ElMessage.success('审批通过')
    loadUsers()
  } catch (error) {
    console.error('审批失败:', error)
  }
}

const handleReject = async (user) => {
  try {
    await ElMessageBox.confirm(`确定要拒绝用户 ${user.username} 的注册申请吗？`, '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })

    await request.put(`/api/admin/users/${user.id}/reject`)
    ElMessage.success('已拒绝')
    loadUsers()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('拒绝失败:', error)
    }
  }
}

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('userInfo')
  ElMessage.success('已退出登录')
  router.push('/login')
}

const formatTime = (time) => {
  if (!time) return '永久'
  return time.replace('T', ' ')
}

const isExpired = (time) => {
  if (!time) return false
  return new Date(time) < new Date()
}

onMounted(() => {
  loadUsers()
})
</script>

<style scoped>
.admin-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding-bottom: 40px;
}

/* 顶部导航栏 */
.top-navbar {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

.navbar-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 30px;
  height: 70px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.navbar-left {
  display: flex;
  align-items: center;
}

.logo {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-icon {
  width: 32px;
  height: 32px;
  color: #667eea;
}

.logo-text {
  font-size: 20px;
  font-weight: 700;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.navbar-right {
  display: flex;
  align-items: center;
  gap: 15px;
}

.user-badge {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 16px;
  background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
  border-radius: 50px;
}

.user-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 16px;
}

.user-name {
  font-weight: 600;
  color: #333;
}

.nav-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  border-radius: 8px;
  font-weight: 500;
  transition: all 0.3s;
}

.nav-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.logout-btn:hover {
  box-shadow: 0 4px 12px rgba(245, 87, 108, 0.3);
}

.btn-icon {
  width: 18px;
  height: 18px;
}

/* 主内容区 */
.main-content {
  max-width: 1400px;
  margin: 30px auto;
  padding: 0 30px;
}

/* 统计卡片 */
.stats-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.stat-card {
  background: white;
  border-radius: 16px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 20px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.3s;
  cursor: pointer;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.stat-icon svg {
  width: 30px;
  height: 30px;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  color: #333;
  line-height: 1;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

/* 操作栏 */
.action-bar {
  margin-bottom: 20px;
  display: flex;
  gap: 16px;
  align-items: center;
}

.search-box {
  flex: 1;
  max-width: 400px;
}

.search-input :deep(.el-input__wrapper) {
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s;
}

.search-input :deep(.el-input__wrapper:hover) {
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
}

.search-input :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.search-icon {
  width: 18px;
  height: 18px;
  color: #909399;
}

.add-user-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  border-radius: 10px;
  padding: 12px 24px;
  font-weight: 600;
  box-shadow: 0 4px 15px rgba(64, 158, 255, 0.3);
  transition: all 0.3s;
}

.add-user-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(64, 158, 255, 0.4);
}

/* 表格容器 */
.table-container {
  background: white;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.desktop-table {
  display: block;
}

.mobile-cards {
  display: none;
}

.modern-table {
  border-radius: 12px;
  overflow: hidden;
}

.modern-table :deep(.el-table__header) {
  background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
}

.modern-table :deep(.el-table__header th) {
  background: transparent;
  color: #333;
  font-weight: 600;
  font-size: 14px;
}

.modern-table :deep(.el-table__row) {
  transition: all 0.3s;
}

.modern-table :deep(.el-table__row:hover) {
  background: #f8f9ff !important;
}

/* 移动端用户卡片 */
.user-card {
  background: white;
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s;
}

.user-card:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

.user-card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
  padding-bottom: 16px;
  border-bottom: 1px solid #f0f0f0;
}

.user-info-row {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
}

.user-avatar-large {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 20px;
  flex-shrink: 0;
}

.user-basic-info {
  flex: 1;
  min-width: 0;
}

.user-name-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}

.username-text {
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.user-id {
  font-size: 12px;
  color: #999;
}

.user-card-body {
  margin-bottom: 16px;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
}

.info-label {
  font-size: 13px;
  color: #666;
  font-weight: 500;
}

.info-value {
  font-size: 13px;
  color: #333;
  font-weight: 600;
}

.user-card-footer {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.user-card-footer .el-button {
  flex: 1;
  min-width: calc(50% - 4px);
}

.username-cell {
  display: flex;
  align-items: center;
  gap: 10px;
}

.user-avatar-small {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 14px;
  flex-shrink: 0;
}

.expire-cell {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.expire-icon {
  width: 18px;
  height: 18px;
  flex-shrink: 0;
}

.expire-icon.expired {
  color: #f56c6c;
}

.expire-icon.active {
  color: #67c23a;
}

.expired-text {
  color: #f56c6c;
  font-weight: 600;
}

.active-text {
  color: #67c23a;
  font-weight: 600;
}

.action-buttons {
  display: flex;
  gap: 8px;
  justify-content: center;
  flex-wrap: wrap;
}

/* 对话框样式 */
.modern-dialog :deep(.el-dialog) {
  border-radius: 16px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.modern-dialog :deep(.el-dialog__header) {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px 24px;
  border-radius: 16px 16px 0 0;
}

.modern-dialog :deep(.el-dialog__title) {
  color: white;
  font-weight: 600;
  font-size: 18px;
}

.modern-dialog :deep(.el-dialog__headerbtn .el-dialog__close) {
  color: white;
  font-size: 20px;
}

.modern-dialog :deep(.el-dialog__body) {
  padding: 30px 24px;
}

.dialog-form {
  padding: 10px 0;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 0 24px 24px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .navbar-content {
    padding: 0 15px;
    height: 60px;
  }

  .logo-text {
    font-size: 16px;
  }

  .user-name {
    display: none;
  }

  .nav-btn {
    padding: 8px 12px;
    font-size: 13px;
  }

  .btn-icon {
    width: 16px;
    height: 16px;
  }

  .main-content {
    padding: 0 15px;
    margin: 20px auto;
  }

  .stats-cards {
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
  }

  .stat-card {
    padding: 16px;
    flex-direction: column;
    text-align: center;
  }

  .stat-icon {
    width: 50px;
    height: 50px;
  }

  .stat-icon svg {
    width: 24px;
    height: 24px;
  }

  .stat-value {
    font-size: 24px;
  }

  .stat-label {
    font-size: 12px;
  }

  .action-bar {
    margin-bottom: 16px;
    flex-direction: column;
    gap: 12px;
  }

  .search-box {
    max-width: 100%;
    width: 100%;
  }

  .add-user-btn {
    width: 100%;
    justify-content: center;
  }

  /* 隐藏桌面表格，显示移动卡片 */
  .desktop-table {
    display: none;
  }

  .mobile-cards {
    display: block;
  }

  .table-container {
    padding: 0;
    background: transparent;
    box-shadow: none;
  }

  /* 对话框适配 */
  .modern-dialog :deep(.el-dialog) {
    width: 90% !important;
    margin: 0 auto;
  }

  .dialog-footer {
    flex-direction: column;
  }

  .dialog-footer .el-button {
    width: 100%;
  }
}

/* 平板适配 */
@media (min-width: 769px) and (max-width: 1024px) {
  .stats-cards {
    grid-template-columns: repeat(2, 1fr);
  }

  .action-buttons {
    flex-wrap: wrap;
  }

  .action-buttons .el-button {
    flex: 1;
    min-width: calc(33.33% - 6px);
  }
}
</style>
