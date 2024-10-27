<script setup lang="ts">
import { ref, onMounted, onUnmounted } from "vue"

const dateOptions: Intl.DateTimeFormatOptions = {
  weekday: "long",
  day: "numeric",
  month: "long"
}

const timeOptions: Intl.DateTimeFormatOptions = {
  hour: "2-digit",
  minute: "2-digit",
  hour12: false
}

const dateTime = ref<string>("")

// Function to update the current date and time
const updateDateTime = () => {
  const now = new Date()
  const datePart = new Intl.DateTimeFormat("en-GB", dateOptions).format(now)
  const timePart = new Intl.DateTimeFormat("en-GB", timeOptions).format(now)
  dateTime.value = `${datePart} - ${timePart}`
}

onMounted(() => {
  updateDateTime()
  const interval = setInterval(updateDateTime, 10000)
  onUnmounted(() => clearInterval(interval))
})
</script>

<template>
  <div>{{ dateTime }}</div>
</template>
