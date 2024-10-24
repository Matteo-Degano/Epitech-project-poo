<script setup lang="ts">
import DayWorkedChart from "@/components/charts/DayWorkedChart.vue"
import HoursWorkedChart from "@/components/charts/HoursWorkedChart.vue"
// import NightChart from "@/components/charts/NightChart.vue"
import { fetchData } from "@/services/api"
import { useAuthStore } from "@/stores/auth.store"
import { onMounted, ref } from "vue"

const authStore = useAuthStore()

const workedDay = ref(null)
const dayTime = ref(null)
const nightTime = ref(null)
const isLoading = ref(true)
const error = ref(null)

onMounted(async () => {
  try {
    const response = await fetchData("GET", `/chartmanager/${authStore.userId}`)
    if (response.status === 200) {
      console.log(response.data)
      workedDay.value = response.data.chart_1.data
      dayTime.value = response.data.chart_2.data
      nightTime.value = response.data.chart_3.data
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
      <div class="col-span-1 row-span-1"><DayWorkedChart v-if="workedDay" :data="workedDay" /></div>
      <div class="col-span-1 row-span-1"><HoursWorkedChart v-if="dayTime" :data="dayTime" /></div>
      <!-- <div class="col-span-1 row-span-2"><NightChart v-if="nightTime" :data="nightTime" /></div> -->
    </div>
  </div>
</template>
