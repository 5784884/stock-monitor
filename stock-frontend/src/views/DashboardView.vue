<template>
  <div class="dashboard-container">
    <Watermark />
    <el-container>
      <el-header>
        <div class="header-content">
          <h2>股票市场监控系统</h2>
          <div class="user-info">
            <span>欢迎，{{ userInfo.username }}</span>
            <span class="expire-time">账号有效期至：{{ userInfo.expireTime }}</span>
            <el-button @click="handleLogout" type="danger" size="small">退出登录</el-button>
          </div>
        </div>
      </el-header>
      <el-main>
        <div class="refresh-button-container">
          <el-button @click="loadData" :loading="loading" type="primary" size="default">
            刷新数据
          </el-button>
          <el-button @click="showHistory" type="success" size="default">
            查看历史记录
          </el-button>
        </div>

        <div v-if="loading" class="loading-container">
          <el-icon class="is-loading" :size="50"><Loading /></el-icon>
          <p>加载中...</p>
        </div>

        <div v-else-if="!marketData || Object.keys(marketData).length === 0" class="empty-container">
          <el-empty description="暂无数据" />
        </div>

        <div v-else class="table-view">
          <!-- 一进二板块 -->
          <div v-if="marketData.FirstToSecondBoard && marketData.FirstToSecondBoard.length > 0" class="board-section">
            <h3 class="board-title">一进二 ({{ marketData.FirstToSecondBoard.length }} 只股票)</h3>
            <div class="table-container">
              <table class="stock-table">
                <thead>
                  <tr>
                    <th>代码</th>
                    <th>名称</th>
                    <th>涨幅(%)</th>
                    <th>量能</th>
                    <th>强度</th>
                    <th>近比</th>
                    <th>主力净额</th>
                    <th>昨主力净额</th>
                    <th>自由市值</th>
                    <th>涨停原因</th>
                    <th>个股概念</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(stock, index) in marketData.FirstToSecondBoard" :key="index">
                    <td>{{ stock.CODE }}</td>
                    <td class="stock-name">{{ stock.NAME }}</td>
                    <td :class="['price-change', parseFloat(stock.ZF) >= 0 ? 'positive' : 'negative']">{{ stock.ZF }}</td>
                    <td>{{ stock.LN }}</td>
                    <td>{{ stock.QD }}</td>
                    <td>{{ stock.JQB }}</td>
                    <td>{{ stock.ZLJE }}</td>
                    <td>{{ stock.ZZLJE }}</td>
                    <td>{{ stock.ZYSZ }}</td>
                    <td class="reason-cell">{{ stock.ZTYY || '-' }}</td>
                    <td class="concept-cell">{{ stock.GGGN }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- 二板 -->
          <div v-if="marketData.SecondBoard && marketData.SecondBoard.length > 0" class="board-section">
            <h3 class="board-title">二板 ({{ marketData.SecondBoard.length }} 只股票)</h3>
            <div class="table-container">
              <table class="stock-table">
                <thead>
                  <tr>
                    <th>代码</th>
                    <th>名称</th>
                    <th>涨幅(%)</th>
                    <th>封板强度</th>
                    <th>封单量</th>
                    <th>封单额</th>
                    <th>自由市值</th>
                    <th>涨停原因</th>
                    <th>个股概念</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(stock, index) in marketData.SecondBoard" :key="index">
                    <td>{{ stock.CODE }}</td>
                    <td class="stock-name">{{ stock.NAME }}</td>
                    <td :class="['price-change', parseFloat(stock.ZF) >= 0 ? 'positive' : 'negative']">{{ stock.ZF }}</td>
                    <td>{{ stock.FBQD }}</td>
                    <td>{{ stock.FDL }}</td>
                    <td>{{ stock.FDE }}</td>
                    <td>{{ stock.ZYSZ }}</td>
                    <td class="reason-cell">{{ stock.ZTYY || '-' }}</td>
                    <td class="concept-cell">{{ stock.GGGN }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- 三板 -->
          <div v-if="marketData.ThirdBoard && marketData.ThirdBoard.length > 0" class="board-section">
            <h3 class="board-title">三板 ({{ marketData.ThirdBoard.length }} 只股票)</h3>
            <div class="table-container">
              <table class="stock-table">
                <thead>
                  <tr>
                    <th>代码</th>
                    <th>名称</th>
                    <th>涨幅(%)</th>
                    <th>封板强度</th>
                    <th>封单量</th>
                    <th>封单额</th>
                    <th>自由市值</th>
                    <th>涨停原因</th>
                    <th>个股概念</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(stock, index) in marketData.ThirdBoard" :key="index">
                    <td>{{ stock.CODE }}</td>
                    <td class="stock-name">{{ stock.NAME }}</td>
                    <td :class="['price-change', parseFloat(stock.ZF) >= 0 ? 'positive' : 'negative']">{{ stock.ZF }}</td>
                    <td>{{ stock.FBQD }}</td>
                    <td>{{ stock.FDL }}</td>
                    <td>{{ stock.FDE }}</td>
                    <td>{{ stock.ZYSZ }}</td>
                    <td class="reason-cell">{{ stock.ZTYY || '-' }}</td>
                    <td class="concept-cell">{{ stock.GGGN }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- 昨三板 -->
          <div v-if="marketData.YesterdayThirdBoard && marketData.YesterdayThirdBoard.length > 0" class="board-section">
            <h3 class="board-title">昨三板 ({{ marketData.YesterdayThirdBoard.length }} 只股票)</h3>
            <div class="table-container">
              <table class="stock-table">
                <thead>
                  <tr>
                    <th>代码</th>
                    <th>名称</th>
                    <th>涨幅(%)</th>
                    <th>自由市值</th>
                    <th>涨停原因</th>
                    <th>个股概念</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(stock, index) in marketData.YesterdayThirdBoard" :key="index">
                    <td>{{ stock.CODE }}</td>
                    <td class="stock-name">{{ stock.NAME }}</td>
                    <td :class="['price-change', parseFloat(stock.ZF) >= 0 ? 'positive' : 'negative']">{{ stock.ZF }}</td>
                    <td>{{ stock.ZYSZ }}</td>
                    <td class="reason-cell">{{ stock.ZTYY || '-' }}</td>
                    <td class="concept-cell">{{ stock.GGGN }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- 首板 -->
          <div v-if="marketData.FirstBoard && marketData.FirstBoard.length > 0" class="board-section">
            <h3 class="board-title">首板 ({{ marketData.FirstBoard.length }} 只股票)</h3>
            <div class="table-container">
              <table class="stock-table">
                <thead>
                  <tr>
                    <th>代码</th>
                    <th>名称</th>
                    <th>涨幅(%)</th>
                    <th>封板强度</th>
                    <th>封单量</th>
                    <th>封单额</th>
                    <th>自由市值</th>
                    <th>个股概念</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(stock, index) in marketData.FirstBoard" :key="index">
                    <td>{{ stock.CODE }}</td>
                    <td class="stock-name">{{ stock.NAME }}</td>
                    <td :class="['price-change', parseFloat(stock.ZF) >= 0 ? 'positive' : 'negative']">{{ stock.ZF }}</td>
                    <td>{{ stock.FBQD }}</td>
                    <td>{{ stock.FDL }}</td>
                    <td>{{ stock.FDE }}</td>
                    <td>{{ stock.ZYSZ }}</td>
                    <td class="concept-cell">{{ stock.GGGN }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </el-main>
    </el-container>

    <!-- 历史记录对话框 -->
    <el-dialog v-model="historyDialogVisible" title="历史记录" width="80%" :close-on-click-modal="false">
      <el-table :data="historyList" style="width: 100%" v-loading="historyLoading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="title" label="标题" width="200" />
        <el-table-column prop="createTime" label="保存时间" width="180" />
        <el-table-column prop="clickTimes" label="点击次数" width="120" />
        <el-table-column label="操作" width="200">
          <template #default="scope">
            <el-button size="small" @click="viewHistoryDetail(scope.row)">查看详情</el-button>
            <el-button size="small" type="danger" @click="deleteHistoryItem(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>

    <!-- 历史详情对话框 -->
    <el-dialog v-model="detailDialogVisible" title="历史数据详情" width="90%" :close-on-click-modal="false">
      <div v-if="currentHistoryData" class="table-view">
        <!-- 一进二板块 -->
        <div v-if="currentHistoryData.FirstToSecondBoard && currentHistoryData.FirstToSecondBoard.length > 0" class="board-section">
          <h3 class="board-title">一进二 ({{ currentHistoryData.FirstToSecondBoard.length }} 只股票)</h3>
          <div class="table-container">
            <table class="stock-table">
              <thead>
                <tr>
                  <th>代码</th>
                  <th>名称</th>
                  <th>涨幅(%)</th>
                  <th>量能</th>
                  <th>强度</th>
                  <th>近比</th>
                  <th>主力净额</th>
                  <th>昨主力净额</th>
                  <th>自由市值</th>
                  <th>涨停原因</th>
                  <th>个股概念</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(stock, index) in currentHistoryData.FirstToSecondBoard" :key="index">
                  <td>{{ stock.CODE }}</td>
                  <td class="stock-name">{{ stock.NAME }}</td>
                  <td :class="['price-change', parseFloat(stock.ZF) >= 0 ? 'positive' : 'negative']">{{ stock.ZF }}</td>
                  <td>{{ stock.LN }}</td>
                  <td>{{ stock.QD }}</td>
                  <td>{{ stock.JQB }}</td>
                  <td>{{ stock.ZLJE }}</td>
                  <td>{{ stock.ZZLJE }}</td>
                  <td>{{ stock.ZYSZ }}</td>
                  <td class="reason-cell">{{ stock.ZTYY || '-' }}</td>
                  <td class="concept-cell">{{ stock.GGGN }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- 二板 -->
        <div v-if="currentHistoryData.SecondBoard && currentHistoryData.SecondBoard.length > 0" class="board-section">
          <h3 class="board-title">二板 ({{ currentHistoryData.SecondBoard.length }} 只股票)</h3>
          <div class="table-container">
            <table class="stock-table">
              <thead>
                <tr>
                  <th>代码</th>
                  <th>名称</th>
                  <th>涨幅(%)</th>
                  <th>封板强度</th>
                  <th>封单量</th>
                  <th>封单额</th>
                  <th>自由市值</th>
                  <th>涨停原因</th>
                  <th>个股概念</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(stock, index) in currentHistoryData.SecondBoard" :key="index">
                  <td>{{ stock.CODE }}</td>
                  <td class="stock-name">{{ stock.NAME }}</td>
                  <td :class="['price-change', parseFloat(stock.ZF) >= 0 ? 'positive' : 'negative']">{{ stock.ZF }}</td>
                  <td>{{ stock.FBQD }}</td>
                  <td>{{ stock.FDL }}</td>
                  <td>{{ stock.FDE }}</td>
                  <td>{{ stock.ZYSZ }}</td>
                  <td class="reason-cell">{{ stock.ZTYY || '-' }}</td>
                  <td class="concept-cell">{{ stock.GGGN }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- 三板 -->
        <div v-if="currentHistoryData.ThirdBoard && currentHistoryData.ThirdBoard.length > 0" class="board-section">
          <h3 class="board-title">三板 ({{ currentHistoryData.ThirdBoard.length }} 只股票)</h3>
          <div class="table-container">
            <table class="stock-table">
              <thead>
                <tr>
                  <th>代码</th>
                  <th>名称</th>
                  <th>涨幅(%)</th>
                  <th>封板强度</th>
                  <th>封单量</th>
                  <th>封单额</th>
                  <th>自由市值</th>
                  <th>涨停原因</th>
                  <th>个股概念</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(stock, index) in currentHistoryData.ThirdBoard" :key="index">
                  <td>{{ stock.CODE }}</td>
                  <td class="stock-name">{{ stock.NAME }}</td>
                  <td :class="['price-change', parseFloat(stock.ZF) >= 0 ? 'positive' : 'negative']">{{ stock.ZF }}</td>
                  <td>{{ stock.FBQD }}</td>
                  <td>{{ stock.FDL }}</td>
                  <td>{{ stock.FDE }}</td>
                  <td>{{ stock.ZYSZ }}</td>
                  <td class="reason-cell">{{ stock.ZTYY || '-' }}</td>
                  <td class="concept-cell">{{ stock.GGGN }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- 昨三板 -->
        <div v-if="currentHistoryData.YesterdayThirdBoard && currentHistoryData.YesterdayThirdBoard.length > 0" class="board-section">
          <h3 class="board-title">昨三板 ({{ currentHistoryData.YesterdayThirdBoard.length }} 只股票)</h3>
          <div class="table-container">
            <table class="stock-table">
              <thead>
                <tr>
                  <th>代码</th>
                  <th>名称</th>
                  <th>涨幅(%)</th>
                  <th>自由市值</th>
                  <th>涨停原因</th>
                  <th>个股概念</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(stock, index) in currentHistoryData.YesterdayThirdBoard" :key="index">
                  <td>{{ stock.CODE }}</td>
                  <td class="stock-name">{{ stock.NAME }}</td>
                  <td :class="['price-change', parseFloat(stock.ZF) >= 0 ? 'positive' : 'negative']">{{ stock.ZF }}</td>
                  <td>{{ stock.ZYSZ }}</td>
                  <td class="reason-cell">{{ stock.ZTYY || '-' }}</td>
                  <td class="concept-cell">{{ stock.GGGN }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- 首板 -->
        <div v-if="currentHistoryData.FirstBoard && currentHistoryData.FirstBoard.length > 0" class="board-section">
          <h3 class="board-title">首板 ({{ currentHistoryData.FirstBoard.length }} 只股票)</h3>
          <div class="table-container">
            <table class="stock-table">
              <thead>
                <tr>
                  <th>代码</th>
                  <th>名称</th>
                  <th>涨幅(%)</th>
                  <th>封板强度</th>
                  <th>封单量</th>
                  <th>封单额</th>
                  <th>自由市值</th>
                  <th>个股概念</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(stock, index) in currentHistoryData.FirstBoard" :key="index">
                  <td>{{ stock.CODE }}</td>
                  <td class="stock-name">{{ stock.NAME }}</td>
                  <td :class="['price-change', parseFloat(stock.ZF) >= 0 ? 'positive' : 'negative']">{{ stock.ZF }}</td>
                  <td>{{ stock.FBQD }}</td>
                  <td>{{ stock.FDL }}</td>
                  <td>{{ stock.FDE }}</td>
                  <td>{{ stock.ZYSZ }}</td>
                  <td class="concept-cell">{{ stock.GGGN }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Loading } from '@element-plus/icons-vue'
import request from '../utils/request'
import Watermark from '../components/Watermark.vue'

const router = useRouter()
const loading = ref(false)
const marketData = ref(null)
const historyDialogVisible = ref(false)
const detailDialogVisible = ref(false)
const historyList = ref([])
const historyLoading = ref(false)
const currentHistoryData = ref(null)

const userInfo = reactive(JSON.parse(localStorage.getItem('userInfo') || '{}'))

const loadData = async () => {
  try {
    loading.value = true
    const res = await request.get('/api/data/latest-market')

    console.log('API响应:', res)

    // 直接使用返回的 jsonData
    if (res.data && res.data.jsonData) {
      marketData.value = res.data.jsonData
      // 自动保存历史数据
      await saveMarketData(res.data)
    } else if (res.data) {
      marketData.value = res.data
      await saveMarketData(res.data)
    } else {
      marketData.value = null
      ElMessage.warning('暂无数据')
    }
  } catch (error) {
    console.error('加载数据失败:', error)
    ElMessage.error('加载数据失败: ' + (error.message || '未知错误'))
    marketData.value = null
  } finally {
    loading.value = false
  }
}

const saveMarketData = async (data) => {
  try {
    await request.post('/api/data/save-market', data)
    console.log('历史数据已保存')
  } catch (error) {
    console.error('保存历史数据失败:', error)
  }
}

const showHistory = async () => {
  historyDialogVisible.value = true
  await loadHistoryList()
}

const loadHistoryList = async () => {
  try {
    historyLoading.value = true
    const res = await request.get('/api/data/history-list')
    historyList.value = res.data || []
  } catch (error) {
    console.error('加载历史记录失败:', error)
    ElMessage.error('加载历史记录失败: ' + (error.message || '未知错误'))
  } finally {
    historyLoading.value = false
  }
}

const viewHistoryDetail = async (row) => {
  try {
    const res = await request.get(`/api/data/history/${row.id}`)
    if (res.data && res.data.jsonData) {
      currentHistoryData.value = JSON.parse(res.data.jsonData)
      detailDialogVisible.value = true
    }
  } catch (error) {
    console.error('加载历史详情失败:', error)
    ElMessage.error('加载历史详情失败: ' + (error.message || '未知错误'))
  }
}

const deleteHistoryItem = async (id) => {
  try {
    await ElMessageBox.confirm('确定要删除这条历史记录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await request.delete(`/api/data/history/${id}`)
    ElMessage.success('删除成功')
    await loadHistoryList()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error('删除失败: ' + (error.message || '未知错误'))
    }
  }
}

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('userInfo')
  ElMessage.success('已退出登录')
  router.push('/login')
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.dashboard-container {
  min-height: 100vh;
  background: #f5f7fa;
  width: 100%;
}

.el-container {
  width: 100%;
  max-width: 100%;
}

.el-header {
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  color: #333;
  display: flex;
  align-items: center;
  position: sticky;
  top: 0;
  z-index: 100;
  width: 100%;
  max-width: 100%;
}

.header-content {
  width: 100%;
  max-width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
}

.header-content h2 {
  color: #1890ff;
  font-size: 20px;
  font-weight: 600;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 15px;
  font-size: 14px;
  color: #666;
}

.expire-time {
  color: #1890ff;
  font-weight: 500;
  padding: 4px 12px;
  background: #e6f7ff;
  border-radius: 4px;
}

.loading-container,
.empty-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  min-height: 400px;
  color: #666;
}

.el-main {
  padding: 0 !important;
  width: 100%;
  max-width: 100% !important;
}

.refresh-button-container {
  padding: 20px;
  background: white;
  border-bottom: 1px solid #f0f0f0;
  display: flex;
  gap: 10px;
}

.table-view {
  padding: 10px 20px;
  width: 100%;
  max-width: 1600px;
  margin: 0 auto;
  box-sizing: border-box;
}

.board-section {
  margin-bottom: 16px;
  background: white;
  border-radius: 4px;
  padding: 0;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.board-title {
  font-size: 16px;
  font-weight: 600;
  color: #1890ff;
  margin: 0;
  padding: 12px 16px;
  border-bottom: 1px solid #f0f0f0;
  background: #fafafa;
}

.table-container {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

.stock-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
  min-width: 1200px;
  table-layout: auto;
}

.stock-table thead {
  background: #fafafa;
}

.stock-table th {
  padding: 10px 12px;
  text-align: center;
  font-weight: 600;
  color: #666;
  border-bottom: 1px solid #f0f0f0;
  white-space: nowrap;
  font-size: 12px;
}

.stock-table td {
  padding: 10px 12px;
  border-bottom: 1px solid #f5f5f5;
  color: #333;
  text-align: center;
}

.stock-table tbody tr:hover {
  background: #f5f7fa;
}

.stock-table tbody tr:last-child td {
  border-bottom: none;
}

.stock-name {
  font-weight: 600;
  color: #1890ff;
  white-space: nowrap;
}

.price-change {
  color: #ff4d4f;
  font-weight: 600;
  white-space: nowrap;
}

.price-change.positive {
  color: #ff4d4f;
}

.price-change.negative {
  color: #52c41a;
}

.reason-cell {
  max-width: 250px;
  min-width: 150px;
  overflow: hidden;
  text-overflow: ellipsis;
  color: #666;
  font-size: 12px;
  text-align: center;
  padding: 10px 12px;
  white-space: normal;
  line-height: 1.5;
}

.concept-cell {
  max-width: 400px;
  min-width: 200px;
  overflow: hidden;
  text-overflow: ellipsis;
  color: #999;
  font-size: 12px;
  text-align: center;
  padding: 10px 12px;
  white-space: normal;
  line-height: 1.5;
}

/* 手机端适配 */
@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    gap: 10px;
    padding: 10px;
    align-items: stretch;
  }

  .header-content h2 {
    font-size: 16px;
    text-align: center;
  }

  .user-info {
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    gap: 8px;
    width: 100%;
    font-size: 12px;
  }

  .user-info span:first-child {
    display: none;
  }

  .expire-time {
    font-size: 11px;
    padding: 4px 8px;
    flex: 1;
  }

  .refresh-button-container {
    padding: 10px;
  }

  .refresh-button-container .el-button {
    width: 100%;
  }

  .table-view {
    padding: 10px;
  }

  .board-section {
    margin-bottom: 16px;
    border-radius: 8px;
  }

  .board-title {
    font-size: 14px;
    padding: 12px 16px;
  }

  .stock-table {
    font-size: 11px;
    min-width: 600px;
  }

  .stock-table th,
  .stock-table td {
    padding: 8px 10px;
    font-size: 11px;
  }

  .reason-cell {
    max-width: 120px;
    padding-left: 10px;
  }

  .concept-cell {
    max-width: 150px;
    padding-left: 10px;
  }

  /* 手机端表格滚动提示 */
  .table-container::after {
    content: '← 左右滑动查看更多 →';
    display: block;
    text-align: center;
    padding: 8px;
    font-size: 11px;
    color: #999;
    background: #fafafa;
  }
}

/* 平板适配 */
@media (min-width: 769px) and (max-width: 1024px) {
  .table-view {
    padding: 16px;
  }

  .stock-table {
    font-size: 12px;
  }
}

/* 大屏适配 */
@media (min-width: 1400px) {
  .table-view {
    max-width: 1400px;
  }
}
</style>
