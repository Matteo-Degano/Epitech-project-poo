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
  labels: labels.value,
  legend: {
    position: "bottom"
  },
  title: {
    text: props.data.description,
    align: "center"
  }
})
</script>

<template>
  <div class="flex justify-center items-center">
    <ApexChart type="pie" :options="chartOptions" :series="series" />
  </div>
</template>
