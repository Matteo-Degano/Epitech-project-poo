<script setup lang="ts">
import { ref } from "vue"

const props = defineProps<{
  data: {
    data: [
      {
        day: string
        time_worked: number
      }
    ]
    description: string
  }
}>()

// Sort data by date in ascending order
const sortedData = props.data.data.sort(
  (a, b) => new Date(a.day).getTime() - new Date(b.day).getTime()
)
const description = props.data.description

function convertSecondsToHoursMinutes(seconds: number) {
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  return `${hours}h ${minutes}m`
}

const series = ref([
  {
    name: "Time Worked",
    data: sortedData.map((item) => parseFloat((item.time_worked / 3600).toFixed(2)))
  }
])

const chartOptions = ref({
  chart: {
    type: "area",
    height: "100%"
  },
  stroke: {
    curve: "smooth"
  },
  fill: {
    type: "gradient",
    gradient: {
      shadeIntensity: 1,
      opacityFrom: 0.5,
      opacityTo: 0.1,
      stops: [0, 100]
    }
  },
  dataLabels: {
    enabled: false
  },
  xaxis: {
    categories: sortedData.map((item) => {
      const [year, month, day] = item.day.split("-")
      return `${day}/${month}`
    }),
    labels: {
      rotate: -45
    }
  },
  yaxis: {
    title: {
      text: "Time Worked"
    },
    labels: {
      formatter: (val: number) => `${Math.floor(val)}h ${Math.round((val % 1) * 60)}m`
    }
  },
  title: {
    text: "Total Time Worked",
    align: "center"
  },
  tooltip: {
    y: {
      formatter: (val: number) => convertSecondsToHoursMinutes(val * 3600)
    }
  },
  colors: ["#9c4ff5"]
})
</script>

<template>
  <ApexChart
    height="100%"
    width="100%"
    type="area"
    :options="chartOptions"
    :series="series"
    class="h-full"
  />
</template>
