<script setup lang="ts">
import ChartDonut from "@/components/charts/ChartDonut.vue"
import LineChart from "@/components/charts/LineChart.vue"
import { fetchData } from "@/services/api"
import { useAuthStore } from "@/stores/auth.store"
import { onMounted, ref } from "vue"

const authStore = useAuthStore()

const donutData = ref(null)
const lineData = ref(null)
const isLoading = ref(true)
const error = ref(null)

onMounted(async () => {
  try {
    const response = await fetchData("GET", `/chartmanager/${authStore.userId}`)
    if (response.status === 200) {
      console.log(response.data)
      donutData.value = response.data.donut_chart
      lineData.value = response.data.line_chart.data
    }
  } catch (err: any) {
    error.value = err.message || "Error fetching data"
    console.error("Error fetching chart data", err)
  } finally {
    isLoading.value = false
  }
})
</script>

<template>
  <div>
    <p v-if="isLoading">Loading...</p>
    <p v-if="error">{{ error }}</p>
    <div v-if="!isLoading" class="grid grid-cols-2 grid-rows-2 gap-4">
      <div class="col-span-1 row-span-1"><ChartDonut v-if="donutData" :data="donutData" /></div>
      <div class="col-span-1 row-span-1"><LineChart v-if="lineData" :data="lineData" /></div>
      <div class="col-span-1 row-span-2"></div>
      <div class="col-span-1 row-span-2"></div>
    </div>
  </div>
</template>
