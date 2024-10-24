<script setup lang="ts">
import { defineProps } from "vue"
import { LineChart as ChartLib } from "@/components/ui/chart-line"

// Accept props
const props = defineProps<{
  data: { day: string; time_worked: number }[]
}>()

const data = props.data
</script>

<template>
  <ChartLib
    :data="data"
    index="day"
    :categories="['time_worked']"
    :y-formatter="(tick) => `${tick} time_worked`"
  />
</template>
