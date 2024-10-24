<!-- <script setup lang="ts">
import { defineProps } from "vue"
import { LineChart as ChartLib } from "@/components/ui/chart-line"

// Accept props
const props = defineProps<{
  data: { end_date: string; start_date: string; total_night_seconds: number }[]
}>()

const data = props.data
import { computed } from "vue"
import { format, differenceInMinutes } from "date-fns"

const formattedData = computed(() => {
  return data.map((item) => {
    const startDate = new Date(item.start_date)
    const endDate = new Date(item.end_date)
    const formattedStartDate = format(startDate, "MM/dd")
    const formattedEndDate = format(endDate, "MM/dd")
    const totalNightHours = Math.floor(item.total_night_seconds / 3600)
    const totalNightMinutes = Math.floor((item.total_night_seconds % 3600) / 60)
    const totalNightFormatted = `${totalNightHours}h ${totalNightMinutes}m`
    const totalWorkMinutes = differenceInMinutes(endDate, startDate)
    const totalWorkHours = Math.floor(totalWorkMinutes / 60)
    const totalWorkFormatted = `${totalWorkHours}h ${totalWorkMinutes % 60}m`

    return {
      ...item,
      formattedStartDate,
      formattedEndDate,
      totalNightFormatted,
      totalWorkFormatted
    }
  })
})
</script>

<template>
  <ChartLib
    :data="formattedData"
    index="formattedStartDate"
    :categories="['time_worked']"
    :y-formatter="(tick) => `${tick} time_worked`"
  />
</template> -->
