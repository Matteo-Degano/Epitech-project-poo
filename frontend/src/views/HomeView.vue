<script setup lang="ts">
import WorkingTimePreview from "@/components/homepage/WorkingTimePreview.vue";
import WorkingTimes from "@/components/workingTime/WorkingTimes.vue";
import { useAuthStore } from "@/stores/auth.store"

const authStore = useAuthStore()
</script>

<template>
  <h1 class="font-bold text-lg">Welcome {{authStore.user.username}}!</h1>

  <WorkingTimePreview/>
</template>
