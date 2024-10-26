<script setup lang="ts">
import HomePageCharts from "@/components/homepage/HomePageCharts.vue";
import UserInfo from "@/components/homepage/UserInfo.vue";
import WorkingTimePreview from "@/components/homepage/WorkingTimePreview.vue";

const currentDate = new Date()
const lastWeek = new Date()
lastWeek.setDate(lastWeek.getDate() - 7);

</script>

<template>
  <div class="flex flex-col justify-between h-full gap-8">
    <div class="flex gap-8">
      <UserInfo/>
      <WorkingTimePreview :startTime="lastWeek.toISOString()" :endTime="currentDate.toISOString()"/>
    </div>
    <HomePageCharts :startTime="lastWeek.toISOString()" :endTime="currentDate.toISOString()"/>
  </div>
</template>
