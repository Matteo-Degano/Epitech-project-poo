<script setup lang="ts">
import { defineProps } from "vue"

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
</script>

<template>
  <div></div>
</template>
