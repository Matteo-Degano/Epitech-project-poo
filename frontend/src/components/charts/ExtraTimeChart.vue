<script setup lang="ts">
import { ref } from "vue"

const props = defineProps<{
  data: {
    data: [
      {
        value: number
        date: string
      }
    ]
    description: string
  }
}>()

const sortedData = props.data.data.sort(
  (a, b) => new Date(a.date).getTime() - new Date(b.date).getTime()
)
const description = props.data.description

function convertSecondsToHoursMinutes(seconds: number) {
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  return `${hours}h ${minutes}m`
}

const series = ref([
  {
    name: "Extra Hours",
    data: sortedData.map((item) => parseFloat((item.value / 3600).toFixed(2)))
  }
])

const chartOptions = ref({
  chart: {
    type: "bar"
  },
  plotOptions: {
    bar: {
      columnWidth: "50%",
      distributed: false,
      colors: {
        ranges: [
          {
            from: 0,
            to: Number.MAX_VALUE,
            color: "#9c4ff5"
          }
        ]
      }
    }
  },
  dataLabels: {
    enabled: false
  },
  xaxis: {
    categories: sortedData.map((item) => {
      const date = new Date(item.date)
      const day = String(date.getDate()).padStart(2, "0")
      const month = String(date.getMonth() + 1).padStart(2, "0")
      return `${day}/${month}`
    }),
    labels: {
      rotate: -45
    }
  },
  yaxis: {
    title: {
      text: "Extra Time"
    },
    labels: {
      formatter: (val: number) => `${Math.floor(val)}h ${Math.round((val % 1) * 60)}m`
    }
  },
  title: {
    text: "Extra Time",
    align: "center"
  },
  tooltip: {
    y: {
      formatter: (val: number) => convertSecondsToHoursMinutes(val * 3600)
    }
  }
})
</script>

<template>
  <ApexChart height="100%" width="100%" type="bar" :options="chartOptions" :series="series" />
</template>
