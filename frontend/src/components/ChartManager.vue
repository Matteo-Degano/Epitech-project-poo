<script setup lang="ts">
import { ref } from "vue"
import { useUserStore } from "@/stores/user"
import { Button } from "@/components/ui/button"

// Accessing the store
const userStore = useUserStore()

// Handle the chart type change
const selectedChartType = ref("bar") // Default to "bar"

function handleChartType() {
  console.log("Chart type selected:", selectedChartType.value)
}
</script>

<template>
  <div class="flex flex-col gap-6 p-6">
    <div class="flex flex-col">
      <h2>Working Time</h2>
      <p>User ID: {{ userStore.userId }}</p>

      <v-select
        v-model="selectedChartType"
        label="Chart type"
        :items="['bar', 'donut']"
        variant="outlined"
      />

      <Button @click="handleChartType">Change Chart Type</Button>
    </div>
  </div>
</template>
