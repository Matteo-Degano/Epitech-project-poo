<script setup lang="ts">
import LoginComponent from "@/components/authentification/LoginComponent.vue"
import logo from "@/assets/logo.png"
</script>

<template>
  <main class="w-screen h-screen">
    <div class="flex flex-col w-full h-full items-center gap-10 mt-14">
      <div>
        <img :src="logo" alt="App Logo" class="w-96 my-auto" />
      </div>
      <LoginComponent />
    </div>
  </main>
</template>
