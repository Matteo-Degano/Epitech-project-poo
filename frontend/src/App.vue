<script setup lang="ts">
import { RouterLink, RouterView } from "vue-router";
import UserComponent from "./components/UserComponent.vue";
</script>

<template>
  <header></header>
  <UserComponent />
  <RouterView />
</template>
