<script setup lang="ts">
import { DonutChart } from "@/components/ui/chart-donut"
import { defineProps } from "vue"

const props = defineProps<{
  data: {
    name: string
    value: number
  }[]
}>()

const filteredData = props.data.filter((item) => item.name !== "Ratio")
console.log(filteredData)
</script>

<template>
  <div class="flex justify-center items-center">
    <DonutChart index="name" :category="'value'" :data="filteredData" />
  </div>
</template>
