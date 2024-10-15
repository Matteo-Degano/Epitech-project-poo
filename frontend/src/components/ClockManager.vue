<script setup lang="ts">
import { ref, onBeforeUnmount } from 'vue';
import { fetchData } from "@/services/api"
import { useUserStore } from "@/stores/user"

const time = ref("00:00:00");
const clockIn = ref(false);
let startTime: string;
let endTime: string;
let interval: ReturnType<typeof setInterval> | null = null;
let pausedTime = 0;

async function refresh() {
  const userStore = useUserStore();
  endTime = new Date().toISOString();
  await fetchData("POST", `/workingtime/${userStore.userId}`, {start: startTime, end: endTime});
  clockIn.value = false;

  if (interval) {
    clearInterval(interval);
    interval = null;
  }
  
  time.value = "00:00:00";
  pausedTime = 0;

  const dateNow = new Date().toISOString();
  await fetchData("POST", `/clocks/${userStore.userId}`, {time: dateNow, status: clockIn.value});
}

async function clock() {
  const userStore = useUserStore();
  if (clockIn.value || userStore.userId === 0) return;
  clockIn.value = true;
  
  const startDateTime = new Date().getTime() - pausedTime;
  startTime = new Date().toISOString();

  await fetchData("POST", `/clocks/${userStore.userId}`, {time: startTime, status: clockIn.value});

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
</script>

<template>
  <div class="flex items-center p-4">
    <p class="text-xl text-gray-800">{{ time }}</p>
    <div class="ml-4">
      <button 
        v-if="!clockIn" 
        @click="clock"
        class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
        Start
      </button>
      <button 
        v-if="clockIn" 
        @click="pause"
        class="px-4 py-2 bg-yellow-500 text-white rounded hover:bg-yellow-600">
        Pause
      </button>
      <button 
        @click="refresh"
        class="px-4 py-2 ml-2 bg-red-500 text-white rounded hover:bg-red-600">
        Stop
      </button>
    </div>
  </div>
</template>

<style scoped>
/* Vous pouvez ajouter du style ici si besoin */
</style>
