<script setup lang="ts">
import { ref } from "vue"
import UserComponent from "@/components/UserComponent.vue"
import ClockManager from "@/components/ClockManager.vue"
import WorkingTimes from "@/components/charts/WorkingTimes.vue"

const user = ref({ id: 0, username: "null", email: "null" })

const setUserId = (id: number) => {
  user.value.id = id
}
</script>

<template>
  <main>
    <p>{{ user.id }}</p>
    <WorkingTimes :userId="user.id" />
    <UserComponent :setUserId="setUserId" />
    <ClockManager />
  </main>
</template>
