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

const data = props.data.data
const description = props.data.description

// Helper function to convert seconds to "HH:mm" format
function convertSecondsToHoursMinutes(seconds: number) {
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  return `${hours}h ${minutes}m`
}

// Prepare the series and categories
const series = ref([
  {
    name: "Time Worked",
    data: data.map((item) => parseFloat((item.time_worked / 3600).toFixed(2)))
  }
])

const chartOptions = ref({
  chart: {
    type: "bar",
    height: "100%"
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
            color: "#007bff"
          }
        ]
      }
    }
  },
  dataLabels: {
    enabled: false
  },
  xaxis: {
    categories: data.map((item) => {
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const [year, month, day] = item.day.split("-")
      return `${day}/${month}`
    }),
    labels: {
      rotate: -45
    },
    title: {
      text: "Date"
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
    text: description,
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
  <div class="h-full">
    <!-- <ApexChart type="bar" :options="chartOptions" :series="series" class="h-full" /> -->
    <div class="bg-black min-h-full w-full">o</div>
  </div>
</template>
