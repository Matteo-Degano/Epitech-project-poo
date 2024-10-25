<script setup lang="ts">
import DayWorkedChart from "@/components/charts/DayWorkedChart.vue"
import HoursWorkedChart from "@/components/charts/HoursWorkedChart.vue"
import NightChart from "@/components/charts/NightChart.vue"
import { fetchData } from "@/services/api"
import { useAuthStore } from "@/stores/auth.store"
import { onMounted, ref } from "vue"
import Separator from "@/components/ui/separator/Separator.vue"

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
      workedDay.value = response.data.chart_1
      dayTime.value = response.data.chart_2
      nightTime.value = response.data.chart_3
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
  <p v-if="isLoading">Loading...</p>
  <p v-if="error">{{ error }}</p>
  <div v-if="!isLoading" class="flex flex-col h-full gap-8">
    <div class="w-full h-1/4"><DayWorkedChart v-if="workedDay" :data="workedDay" /></div>
    <Separator />
    <div class="w-full h-1/4"><HoursWorkedChart v-if="dayTime" :data="dayTime" /></div>
    <Separator />
    <div class="w-full h-1/4"><NightChart v-if="nightTime" :data="nightTime" /></div>
  </div>
</template>
