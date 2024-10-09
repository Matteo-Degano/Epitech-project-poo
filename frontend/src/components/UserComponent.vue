<script setup>
import { ref } from 'vue'

const count = ref(0)

const user = ref({
    name: 'John Doe',
    email: 'johndoe@gmail.com',
})

</script>

<template>
  <div class="bg-slate-800 p-2 rounded-md">
    <h1 class="font-bold">Current user you are connected on </h1>
    <p>Username : {{ user.name }}</p>
    <p>Email : {{ user.email }}</p>
  </div>
</template>