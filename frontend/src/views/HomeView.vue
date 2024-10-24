<script setup lang="ts">
import WorkingTimes from "@/components/workingTime/WorkingTimes.vue";
import { useAuthStore } from "@/stores/auth.store"

const authStore = useAuthStore()
</script>

<template>
  <h1 class="font-bold text-lg">Welcome {{authStore.user.username}}!</h1>

  <div>
    <h2 class="font-medium">Your working times</h2>
    <WorkingTimes/>
  </div>
</template>
