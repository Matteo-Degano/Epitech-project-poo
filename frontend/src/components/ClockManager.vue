<script setup lang="ts">
import { ref, onBeforeUnmount } from 'vue';

const time = ref("00:00:00");
const clockIn = ref(false);
let interval: ReturnType<typeof setInterval> | null = null;
const lastRecord = ref("00:00:00");
let pausedTime = 0;

function refresh() {
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
}

function clock() {
  if (clockIn.value) return;
  clockIn.value = true;
  const startDateTime = new Date().getTime() - pausedTime; 

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
  <div id="clock" class="greetings">
    <div class="clock-content">
      <h1>{{ time }}</h1>
      <p class="last-record">Last record: {{ lastRecord }}</p>
    </div>
    <div class="button-content">
      <button v-if="!clockIn" @click="clock" class="button-clock button-start-pause">Start</button>
      <button v-if="clockIn" @click="pause" class="button-clock button-start-pause">Pause</button>
      <button @click="refresh" class="button-clock button-stop">Stop</button>
    </div>
  </div>
</template>


<style scoped>

#clock{
  display: flex;
  flex-direction: column;
}

.button-clock{
  color: #fff;
  width: 80px;
  height: 80px;
  border-radius: 80px;
  border: 2px solid #00ffcc;
  box-shadow: 
    0 0 5px rgba(0, 255, 204, 0.5),  
    0 0 15px rgba(0, 255, 204, 0.3), 
    0 0 30px rgba(0, 255, 204, 0.1);
  transition: box-shadow 0.3s ease-in-out, border 0.3s ease-in-out;
  background-color: #222;
}

.button-start-pause {
  border: 2px solid #00ffcc;
  box-shadow: 
    0 0 10px rgba(0, 255, 204, 0.5), 
    0 0 25px rgba(0, 255, 204, 0.3), 
    0 0 50px rgba(0, 255, 204, 0.1);
}

.button-start-pause:hover {
 box-shadow: 
    0 0 10px rgba(0, 255, 204, 0.7), 
    0 0 25px rgba(0, 255, 204, 0.5), 
    0 0 50px rgba(0, 255, 204, 0.3);
}

.button-stop {
  border: 2px solid #ff0044;
  box-shadow: 
    0 0 5px rgba(255, 0, 68, 0.5),  
    0 0 15px rgba(255, 0, 68, 0.3), 
    0 0 30px rgba(255, 0, 68, 0.1);
}

.button-stop:hover {
  box-shadow: 
    0 0 10px rgba(255, 0, 68, 0.7), 
    0 0 20px rgba(255, 0, 68, 0.5), 
    0 0 40px rgba(255, 0, 68, 0.3);
}

.clock-content{
  width: 250px;
  height: 250px;
  border-radius: 250px;
  border: 2px solid #00ffcc;
  box-shadow: 
    0 0 10px rgba(0, 255, 204, 0.5), 
    0 0 25px rgba(0, 255, 204, 0.3), 
    0 0 50px rgba(0, 255, 204, 0.1);
  transition: box-shadow 0.3s ease-in-out;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  background-color: #222;
}

h1 {
  font-size: 24pt;
  color: #fff;
}

.button-content{
  width: 250px;
  display: flex;
  justify-content: space-around;
  margin-top: -40px;
}

.last-record {
  font-size: 12pt;
  color: #fff;
}

.button-content{
  width: 250px;
  display: flex;
  justify-content: space-around;
  margin-top: -50px;
}

.greetings h1 {
  text-align: center;
}

@media (min-width: 1024px) {
  .greetings h1 {
    text-align: left;
  }
}
</style>