<script setup lang="ts">
import { computed } from "vue"
import { useUserStore } from "@/stores/user"

const userStore = useUserStore()

// Chart options
const options = {
  chart: {
    id: "working-time"
  },
  xaxis: {
    categories: ["1/01"]
  }
}

// Use a computed property to update the series dynamically
const series = computed(() => [
  {
    name: userStore.userId || "default user",
    data: [7.3]
  }
])
</script>

<template>
  <div class="flex flex-col gap-6 p-6">
    <div class="flex flex-col">
      <h2>Working Time</h2>
      <p>User ID: {{ userStore.userId }}</p>
    </div>
    <div class="">
      <apexchart width="100%" type="bar" :options="options" :series="series"></apexchart>
    </div>
  </div>
</template>
