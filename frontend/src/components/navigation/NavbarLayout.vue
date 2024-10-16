<script setup lang="ts">
import Navbar from "./NavbarComponent.vue"
</script>
<template>
  <div class="h-screen w-screen">
    <Navbar />
    <main>
      <router-view />
    </main>
  </div>
</template>
