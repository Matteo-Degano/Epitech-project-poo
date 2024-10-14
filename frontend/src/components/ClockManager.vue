<script setup lang="ts">
import { ref, onBeforeUnmount } from 'vue';
import { fetchData } from "@/services/api"
import { useUserStore } from "@/stores/user"

const time = ref("00:00:00");
const clockIn = ref(false);
let startTime: string;
let endTime: string;
let interval: ReturnType<typeof setInterval> | null = null;
const lastRecord = ref("00:00:00");
let pausedTime = 0;

async function refresh() {
  const userStore = useUserStore()
  endTime = new Date().toISOString();
  await fetchData("POST", `/workingtime/${userStore.userId}`, {start: startTime, end: endTime})
  clockIn.value = false;

  if (interval) {
    clearInterval(interval);
    interval = null;
  }
  if(time.value !== "00:00:00") {
    lastRecord.value = time.value;
  }
  time.value = "00:00:00";
  clockIn.value = false;
  pausedTime = 0;

  const dateNow = new Date().toISOString();
  await fetchData("POST", `/clocks/${userStore.userId}`, {time: dateNow, status: clockIn.value})
}

async function clock() {
  const userStore = useUserStore()
  if (clockIn.value) return;
  if(userStore.userId === 0) return;
  clockIn.value = true;
  const startDateTime = new Date().getTime() - pausedTime; 
  const dateNow = new Date().toISOString();
  startTime = new Date().toISOString();
  await fetchData("POST", `/clocks/${userStore.userId}`, {time: dateNow, status: clockIn.value})

  interval = setInterval(() => {
    const currentTime = new Date().getTime();
    const elapsedTime = currentTime - startDateTime;

    const hours = Math.floor(elapsedTime / (1000 * 60 * 60));
    const minutes = Math.floor((elapsedTime % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((elapsedTime % (1000 * 60)) / 1000);

    time.value = `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
    pausedTime = elapsedTime;
  }, 1000);
}

function pause() {
  if (interval) {
    clearInterval(interval);
    interval = null;
    clockIn.value = false;
  }
}

onBeforeUnmount(() => {
  if (interval) {
    clearInterval(interval);
  }
});

function formatDate(timestamp: number): string {
  const date = new Date(timestamp);
  const day = String(date.getDate()).padStart(2, '0');
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const year = date.getFullYear();
  return `${day}/${month}/${year}`;
}
</script>

<template>
  <div class="flex flex-col justify-center items-center p-2.5">
    <div :class="['w-64 h-64 rounded-full flex flex-col justify-center items-center bg-gray-100 transition-all duration-300', {'custom-border shadow-md-custom': clockIn, 'border-2 border-gray-400 shadow-md': !clockIn}]">
      <p class="text-gray-800">{{ formatDate(Date.now()) }}</p>
      <h1 class="text-3xl text-gray-800">{{ time }}</h1>
      <p class="text-lg text-gray-800">Last record: {{ lastRecord }}</p>
    </div>
    <div class="flex justify-around w-64" style="margin-top: -50px;">
      <button 
        v-if="!clockIn" 
        @click="clock"
        class="w-20 h-20 rounded-full border-2 border-gray-400 bg-gray-100 shadow-md transition-shadow duration-300 hover:bg-gray-300 hover:shadow-lg text-gray-800 cursor-pointer">
        Start
      </button>
      <button 
        v-if="clockIn" 
        @click="pause"
        :class="['w-20 h-20 rounded-full bg-gray-100 text-gray-800 cursor-pointer hover:bg-gray-300', clockIn ? 'custom-border shadow-md-custom' : 'border-gray-400 shadow-md hover:shadow-lg']">
        Pause
      </button>
      <button 
        @click="refresh"
        :class="['w-20 h-20 rounded-full bg-gray-100 text-gray-800 cursor-pointer hover:bg-gray-300', clockIn ? 'custom-border shadow-md-custom' : 'border-2 border-gray-400 shadow-md hover:shadow-lg']">
        Stop
      </button>
    </div>
  </div>
</template>

<style>
.shadow-md-custom {
  box-shadow: 
    0 0 10px rgba(0, 204, 255, 0.5), 
    0 0 25px rgba(0, 204, 255, 0.3), 
    0 0 50px rgba(0, 204, 255, 0.1); 
}

.custom-border {
  border: 2px solid #00ccff;
}
</style>