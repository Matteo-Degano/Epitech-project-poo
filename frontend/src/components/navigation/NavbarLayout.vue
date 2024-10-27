<script setup lang="ts">
import Navbar from "./NavbarComponent.vue"
</script>
<template>
  <div class="h-screen w-screen">
    <Navbar />
    <main class="max-w-full p-2">
      <router-view />
    </main>
  </div>
</template>
