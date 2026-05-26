<script setup>
</script>

<template>
  <router-view />
</template>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  width: 100%;
  height: 100%;
  overflow-x: hidden;
}

#app {
  font-family: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', Arial, sans-serif;
  width: 100%;
  min-height: 100vh;
}

/* 强制移除 Element Plus 容器的最大宽度限制 */
.el-container,
.el-main,
.el-header {
  max-width: 100% !important;
  width: 100% !important;
}
</style>
