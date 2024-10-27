<script setup lang="ts">
import UserInfo from "@/components/homepage/UserInfo.vue";
import WorkingTimePreview from "@/components/homepage/WorkingTimePreview.vue";
import Separator from "@/components/ui/separator/Separator.vue";
import { useToast } from "@/components/ui/toast/use-toast";
import { useAuthStore } from "@/stores/auth.store";
import { onMounted, ref } from "vue";
import { fetchData } from "@/services/api";
import HoursWorkedChart from "@/components/charts/HoursWorkedChart.vue";
import Spinner from "@/components/Spinner.vue";

const authStore = useAuthStore()
const isLoading = ref(true)
const { toast } = useToast()
const error = ref(null)
const workingTimeData = ref(null)
const dayTime = ref(null)
const currentDate = new Date()
const lastWeek = new Date()
lastWeek.setDate(lastWeek.getDate() - 7);

const fetchWorkingTimes = async () => {
  try {
    const response = await fetchData("GET", `/workingtime/${authStore.user.id}?start=${lastWeek.toISOString()}&end=${currentDate.toISOString()}`)
    workingTimeData.value = response.data
  } catch (err: any) {
    console.log(err)
  }
}

const fetchChart = async () => {
  try {
    const response = await fetchData("GET", `/chartmanager/${authStore.user.id}?start=${lastWeek.toISOString()}&end=${currentDate.toISOString()}`)
    dayTime.value = response.data.chart_2
  } catch (err) {
    error.value = err.message || "Error fetching data"
    toast({ variant: "destructive", description: error.value })
  } finally {
    isLoading.value = false
  }
}

onMounted(async () => {
  await fetchWorkingTimes()
  await fetchChart()
  isLoading.value = false
  console.log(workingTimeData.value)
  console.log(dayTime.value)
})

</script>

<template>
  <div v-if="isLoading" class="flex justify-center items-center h-full">
    <Spinner/>
  </div>
  <div v-else class="flex flex-col justify-around h-full gap-10">
    <div class="flex gap-8">
      <UserInfo/>
      <WorkingTimePreview :data="workingTimeData"/>
    </div>
    <Separator/>
    <div>
      <HoursWorkedChart v-if="dayTime" :data="dayTime" class="w-full h-72"/>
    </div>
  </div>
</template>
