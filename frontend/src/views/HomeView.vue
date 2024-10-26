<script setup lang="ts">
import HomePageCharts from "@/components/homepage/HomePageCharts.vue";
import UserInfo from "@/components/homepage/UserInfo.vue";
import WorkingTimePreview from "@/components/homepage/WorkingTimePreview.vue";
import { useAuthStore } from "@/stores/auth.store"

const authStore = useAuthStore()

const currentDate = new Date()
const lastFiveDays = new Date()
lastFiveDays.setDate(lastFiveDays.getDate() - 7);

</script>

<template>
  <h1 class="font-bold text-lg">Welcome {{authStore.user.username}} !</h1>
  <div class="flex">
    <UserInfo/>
    <WorkingTimePreview :startTime="lastFiveDays.toISOString()" :endTime="currentDate.toISOString()"/>
  </div>
  <HomePageCharts :startTime="lastFiveDays.toISOString()" :endTime="currentDate.toISOString()"/>
</template>
