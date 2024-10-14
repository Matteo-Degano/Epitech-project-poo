
<script setup lang="ts">
import { ref } from 'vue';
import ClockManager from "@/components/ClockManager.vue"

const dropdownOpen = ref(false);

function toggleMenu() {
  dropdownOpen.value = !dropdownOpen.value;
}
</script>

<template>
  <div class="relative flex justify-between items-center p-4 bg-gray-100">
    <ul class="flex space-x-4">
      <li>
        <a href="/" class="text-gray-700 hover:text-gray-900">Accueil</a>
      </li>
      <li>
        <a href="/about" class="text-gray-700 hover:text-gray-900">À propos</a>
      </li>
      <li>
        <a href="/services" class="text-gray-700 hover:text-gray-900">Services</a>
      </li>
    </ul>

    <div class="relative flex space-x-4">
      <ClockManager />
      <button
        @click="toggleMenu"
        class="flex items-center text-gray-700 hover:text-gray-900 focus:outline-none"
      >
        Mon Compte <span class="ml-1">▼</span>
      </button>
      <div
        v-if="dropdownOpen"
        class="absolute right-0 mt-15 w-48 bg-white shadow-lg rounded-lg z-10"
      >
        <ul class="py-2">
          <li>
            <a
              href="/login"
              class="block px-4 py-2 text-gray-700 hover:bg-gray-100"
            >
              Se connecter
            </a>
          </li>
          <li>
            <a
              href="/register"
              class="block px-4 py-2 text-gray-700 hover:bg-gray-100"
            >
              S'inscrire
            </a>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
