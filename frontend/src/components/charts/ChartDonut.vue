<script setup lang="ts">
import { DonutChart } from "@/components/ui/chart-donut"
import { defineProps, computed } from "vue"

const props = defineProps<{
  data: {
    days_worked: { name: string; value: number; description: string }
    days_not_worked: { name: string; value: number; description: string }
    ratio: { name: string; value: number; description: string }
  }
}>()

// Transform the data inside the component
const transformedData = computed(() => [
  {
    name: props.data.days_worked.name,
    total: props.data.days_worked.value,
    description: props.data.days_worked.description,
    color: "#22C55E"
  },
  {
    name: props.data.days_not_worked.name,
    total: props.data.days_not_worked.value,
    description: props.data.days_not_worked.description,
    color: "#EF4444"
  }
])

const colors = computed(() => transformedData.value.map((d) => d.color))
</script>

<template>
  <DonutChart
    :data="transformedData"
    index="name"
    category="total"
    :colors="colors"
    :showLegend="true"
  />
</template>
