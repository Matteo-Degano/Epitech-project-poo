<script setup lang="ts">
import WorkingTimes from "@/components/charts/WorkingTimes.vue";

const userId: string = "1";
</script>

<template>
  <main>
    <WorkingTimes :userId="userId" />
  </main>
</template>
