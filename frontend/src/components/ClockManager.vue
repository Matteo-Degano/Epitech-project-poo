<script setup lang="ts">
import { ref, onBeforeUnmount, onMounted } from "vue"
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



function frenchDate(){

  const frenchDate = new Date();

  const frenchOffset = frenchDate.getTimezoneOffset() * 60000; 
  const parisDate = new Date(frenchDate.getTime() - frenchOffset); 

  const startTimeFrench = parisDate.toISOString();
  
  return startTimeFrench
}


async function startClock() {

  clockIn.value = true

  const startDateTime = new Date().getTime() - pausedTime

  await fetchData("POST", `/clocks/${authStore.userId}`, { time: frenchDate(), status: clockIn.value })

  interval = setInterval(() => {
    const currentTime = new Date().getTime()
    const elapsedTime = currentTime - startDateTime

    const seconds = Math.floor((elapsedTime % (1000 * 60)) / 1000)
    const minutes = Math.floor((elapsedTime % (1000 * 60 * 60)) / (1000 * 60))
    const hours = Math.floor(elapsedTime / (1000 * 60 * 60))

    time.value = `${String(hours).padStart(2, "0")}:${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`
    pausedTime = elapsedTime
  }, 1000)
}


async function stopClock() {

endTime = new Date().toISOString()

//await fetchData("POST", `/workingtime/${authStore.userId}`, { start: startTime, end: endTime })
clockIn.value = false

if (interval) {
  clearInterval(interval)
  interval = null
}

time.value = "00:00:00"
pausedTime = 0

const dateNow = new Date().toISOString()

 await fetchData("POST", `/clocks/${authStore.userId}`, { time: frenchDate(), status: clockIn.value }) 

}



async function getClock() {

  try {
    const response = await fetchData("GET", `/clocks/${authStore.userId}`);

    if (response.data && Array.isArray(response.data.data) && response.data.data.length > 0) {

      const sortedClocks = response.data.data.sort((a, b) => {
        const timeA = new Date(a.time).getTime();
        const timeB = new Date(b.time).getTime();
        return timeB - timeA; 
      });

      const firstClock = sortedClocks[0];
   
      if (firstClock.status === true) {

        const clockTime = new Date(firstClock.time).getTime(); 
        const currentTime = new Date().getTime(); 

        let elapsedTime = currentTime - clockTime; 
        pausedTime = elapsedTime;

        updateTimeDisplay(elapsedTime); 

        interval = setInterval(() => {
          const newCurrentTime = new Date().getTime();
          elapsedTime = newCurrentTime - clockTime; 

          updateTimeDisplay(elapsedTime);
        }, 1000);

        clockIn.value = true;
      }
    } else {
      console.log("No clocks found or data format is incorrect.");
    }
  } catch (error) {
    console.error("Error fetching clocks:", error); 
  }
}

function updateTimeDisplay(elapsedTime: number) {

  const hours = Math.floor(elapsedTime / (1000 * 60 * 60));
  const minutes = Math.floor((elapsedTime % (1000 * 60 * 60)) / (1000 * 60));
  const seconds = Math.floor((elapsedTime % (1000 * 60)) / 1000);

  time.value = `${String(hours).padStart(2, "0")}:${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`;
}


async function pause() {
  if (interval) {
    clearInterval(interval)
    interval = null
    clockIn.value = false

    await fetchData("POST", `/clocks/${authStore.userId}`, { time: frenchDate(), status: true }) 
  }
}


onMounted(() => {
  getClock();
});

onBeforeUnmount(() => {
  if (interval) {
    clearInterval(interval)
  }
})
</script>

<template>
<div class="flex items-center gap-2">
  <!-- Start button (disabled when clockIn is true) -->
  <Button 
    :disabled="clockIn" 
    @click="startClock" 
    class="bg-green-600 hover:bg-green-500 w-16"
  >
    Start
  </Button>

  <!-- Display the time -->
  <p class="text-xl text-center text-gray-800 w-24">{{ time }}</p>

  <!-- Stop button (disabled when clockIn is false) -->
  <Button 
    :disabled="!clockIn" 
    @click="stopClock" 
    class="bg-red-600 hover:bg-red-500 w-16"
  >
    Stop
  </Button>
</div>

</template>
