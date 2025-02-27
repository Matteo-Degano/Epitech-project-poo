<script setup lang="ts">
import { ref, onBeforeUnmount, onMounted } from "vue"
import { fetchData } from "@/services/api"
import Button from "@/components/ui/button/Button.vue"
import { useAuthStore } from "@/stores/auth.store"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger
} from "@/components/ui/dialog"
import { AlarmClockOff, AlarmClockCheck } from "lucide-vue-next"

const authStore = useAuthStore()
const isLoading = ref(true)
const time = ref("00:00:00")
const isClockRunning = ref(false)
const clockIn = ref(false)
let interval: ReturnType<typeof setInterval> | null = null
let pausedTime = 0

// Get the current time in the French timezone in ISO format
function frenchDate() {
  const currentDate = new Date()
  const offset = currentDate.getTimezoneOffset() * 60000
  const parisTime = new Date(currentDate.getTime() - offset)
  return parisTime.toISOString()
}

// Start the clock
async function startClock() {
  clockIn.value = true
  isClockRunning.value = true

  const startDateTime = new Date().getTime() - pausedTime
  await fetchData("POST", `/clocks/${authStore.userId}`, {
    time: frenchDate(),
    status: clockIn.value
  })

  interval = setInterval(() => {
    const elapsedTime = new Date().getTime() - startDateTime
    updateTimeDisplay(elapsedTime)
  }, 1000)
}

// Stop the clock
async function stopClock() {
  clockIn.value = false
  isClockRunning.value = false

  if (interval) {
    clearInterval(interval)
    interval = null
  }

  time.value = "00:00:00"
  pausedTime = 0

  await fetchData("POST", `/clocks/${authStore.userId}`, {
    time: frenchDate(),
    status: clockIn.value
  })
}

// Get the clock's current state
async function getClock() {
  try {
    const response = await fetchData("GET", `/clocks/${authStore.userId}`)
    if (response.status === 200) {
      const sortedClocks = response.data.clocks.sort(
        (a: { time: string }, b: { time: string }) =>
          new Date(b.time).getTime() - new Date(a.time).getTime()
      )
      const lastClock = sortedClocks[0]
      if (lastClock.status === true) {
        clockIn.value = true
        isClockRunning.value = true
        const clockStartTime = new Date(lastClock.time).getTime()
        const elapsedTime = new Date().getTime() - clockStartTime
        pausedTime = elapsedTime
        updateTimeDisplay(elapsedTime)

        interval = setInterval(() => {
          const newElapsedTime = new Date().getTime() - clockStartTime
          updateTimeDisplay(newElapsedTime)
        }, 1000)
      }
      isLoading.value = false
    }
  } catch (error) {
    isLoading.value = false
  }
}

// Update the time display in HH:MM:SS format
function updateTimeDisplay(elapsedTime: number) {
  const hours = Math.floor(elapsedTime / (1000 * 60 * 60))
  const minutes = Math.floor((elapsedTime % (1000 * 60 * 60)) / (1000 * 60))
  const seconds = Math.floor((elapsedTime % (1000 * 60)) / 1000)
  time.value = `${String(hours).padStart(2, "0")}:${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`
}

onMounted(() => {
  getClock()
})

onBeforeUnmount(() => {
  if (interval) {
    clearInterval(interval)
  }
})
</script>

<template>
  <div class="flex items-center gap-2">
    <Button
      v-if="!isClockRunning && !isLoading"
      @click="startClock"
      variant="ghost"
      class="ring-1 ring-red-500 hover:bg-green-500 hover:text-background hover:ring-0 w-32 flex justify-between group"
    >
      {{ time }} <AlarmClockOff :size="18" class="text-red-500 group-hover:text-background" />
    </Button>
    <Dialog>
      <DialogTrigger as-child>
        <Button
          v-if="isClockRunning && !isLoading"
          variant="ghost"
          class="ring-1 ring-green-500 hover:bg-red-500 hover:text-background hover:ring-0 w-32 flex justify-between group"
        >
          {{ time }}
          <AlarmClockCheck :size="18" class="text-green-500 group-hover:text-background" />
        </Button>
      </DialogTrigger>
      <DialogContent class="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>Clock out</DialogTitle>
          <DialogDescription> Are you sure you want to clock out? </DialogDescription>
        </DialogHeader>
        <DialogFooter>
          <DialogClose as-child>
            <Button type="button" variant="secondary"> Close </Button>
          </DialogClose>
          <DialogClose as-child>
            <Button @click="stopClock" class="bg-green-600 hover:bg-green-500"> Yes </Button>
          </DialogClose>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  </div>
</template>
