<script setup lang="ts">
import { defineProps, computed } from "vue"
import { LineChart as ChartLib } from "@/components/ui/chart-line"

// Accept props
const props = defineProps<{
  data: { day: string; time_worked: number }[] // Props structure
}>()

// Function to format the day into DAY/MONTH format
const formatDay = (day: string) => {
  const date = new Date(day)
  return date.toLocaleDateString("fr-FR", { day: "2-digit", month: "2-digit" }) // Format to DD/MM
}

// Transform the data, prepend a fake value with 0 hours, and rename 'time_worked' to 'hours'
const transformedData = computed(() => {
  const fakeEntry = { day: "", hours: 0 } // Create a fake entry with 0 hours and no date

  const formattedData = props.data.map((item) => ({
    day: formatDay(item.day), // Format the day to DD/MM
    hours: item.time_worked // Rename 'time_worked' to 'hours'
  }))

  // Prepend the fake entry to the data
  return [fakeEntry, ...formattedData]
})
</script>

<template>
  <!-- Pass the transformed data to the actual LineChart library -->
  <ChartLib
    :data="transformedData"
    index="day"
    :categories="['hours']"
    :y-formatter="(tick) => `${tick} hours`"
  />
</template>
