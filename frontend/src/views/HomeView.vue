<script setup lang="ts">
import UserComponent from "@/components/UserComponent.vue"
import ClockManager from "@/components/ClockManager.vue"
import WorkingTimes from "@/components/workingTime/WorkingTimes.vue"
</script>

<template>
  <main class="w-full h-screen">
    <div class="grid grid-cols-2 grid-rows-3 min-w-full min-h-full">
      <div class="row-span-1 border border-black"><UserComponent /></div>
      <div class="row-span-1 border border-black"><ClockManager /></div>
      <div class="row-span-2 col-span-2 border border-black"><WorkingTimes /></div>
    </div>
  </main>
</template>
