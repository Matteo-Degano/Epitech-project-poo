<script setup lang="ts">
import HomePageCharts from "@/components/homepage/HomePageCharts.vue";
import WorkingTimePreview from "@/components/homepage/WorkingTimePreview.vue";
import { useAuthStore } from "@/stores/auth.store"

const authStore = useAuthStore()

</script>

<template>
  <h1 class="font-bold text-lg">Welcome {{authStore.user.username}} !</h1>
  <HomePageCharts/>
  <WorkingTimePreview/>
</template>
