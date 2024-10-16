<script setup lang="ts">
import { ref } from "vue"
import { Button } from "@/components/ui/button"
// Handle the chart type change
const selectedChartType = ref("bar") // Default to "bar"

function handleChartType() {
  console.log("Chart type selected:", selectedChartType.value)
}
</script>

<template>
  <Button @click="handleChartType">Change Chart Type</Button>
</template>
