<script setup lang="ts">
import { defineProps, ref } from "vue"

const props = defineProps<{
  data: {
    data: [
      {
        name: string
        value: number
      }
    ]
    description: string
  }
}>()

const series = ref(
  props.data.data.filter((item) => item.name !== "Ratio").map((item) => item.value)
)
const labels = ref(props.data.data.filter((item) => item.name !== "Ratio").map((item) => item.name))

const chartOptions = ref({
  chart: {
    type: "pie"
  },
  plotOptions: {
    pie: {
      donut: {
        labels: {
          show: true
        }
      }
    }
  },
  labels: labels.value,
  legend: {
    position: "top"
  },
  title: {
    text: "Days worked",
    align: "center"
  },
  colors: ["#9c4ff5", "#808080"]
})
</script>

<template>
  <ApexChart height="100%" type="donut" :options="chartOptions" :series="series" />
</template>
