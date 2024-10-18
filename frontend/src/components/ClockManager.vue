<script setup lang="ts">
import { ref, onBeforeUnmount } from "vue"
import { fetchData } from "@/services/api"
import Button from "@/components/ui/button/Button.vue"
import { useAuthStore } from "@/stores/auth.store"

const authStore = useAuthStore()
const time = ref("00:00:00")
const clockIn = ref(false)
let startTime: string
let endTime: string
let interval: ReturnType<typeof setInterval> | null = null
let pausedTime = 0

async function refresh() {
  endTime = new Date().toISOString()
  await fetchData("POST", `/workingtime/${authStore.userId}`, { start: startTime, end: endTime })
  clockIn.value = false

  if (interval) {
    clearInterval(interval)
    interval = null
  }

  time.value = "00:00:00"
  pausedTime = 0

  const dateNow = new Date().toISOString()
  await fetchData("POST", `/clocks/${authStore.userId}`, { time: dateNow, status: clockIn.value })
}

async function clock() {
  clockIn.value = true

  const startDateTime = new Date().getTime() - pausedTime
  startTime = new Date().toISOString()

  await fetchData("POST", `/clocks/${authStore.userId}`, { time: startTime, status: clockIn.value })

  interval = setInterval(() => {
    const currentTime = new Date().getTime()
    const elapsedTime = currentTime - startDateTime

    const hours = Math.floor(elapsedTime / (1000 * 60 * 60))
    const minutes = Math.floor((elapsedTime % (1000 * 60 * 60)) / (1000 * 60))
    const seconds = Math.floor((elapsedTime % (1000 * 60)) / 1000)

    time.value = `${String(hours).padStart(2, "0")}:${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`
    pausedTime = elapsedTime
  }, 1000)
}

function pause() {
  if (interval) {
    clearInterval(interval)
    interval = null
    clockIn.value = false
  }
}

onBeforeUnmount(() => {
  if (interval) {
    clearInterval(interval)
  }
})
</script>

<template>
  <div class="flex items-center gap-2">
    <Button v-if="!clockIn" @click="clock" class="bg-green-600 hover:bg-green-500 w-16">
      Start
    </Button>
    <Button v-if="clockIn" @click="pause" class="bg-orange-500 hover:bg-orange-400 w-16">
      Pause
    </Button>
    <p class="text-xl text-center text-gray-800 w-24">{{ time }}</p>
    <Button @click="refresh" class="bg-red-600 hover:bg-red-500 w-16"> Stop </Button>
  </div>
</template>
