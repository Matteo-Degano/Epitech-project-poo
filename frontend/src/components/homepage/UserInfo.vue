<script setup lang="ts">
import { useAuthStore } from "@/stores/auth.store"

const authStore = useAuthStore()

function idToStringRole(id: number) {
    switch (id) {
        case 1:
        return "Employee"
        case 2:
        return "Manager"
        case 3:
        return "General manager"
        case 4:
        return "Admin"
        default:
        return "Unknown"
    }
}

console.log(authStore.user)
</script>

<template>
    <div class="border-primary border-4 rounded p-4 w-1/3 flex flex-col justify-between gap-10 bg-[#faf6ff]">
        <p>Welcome <span class="font-bold">{{ authStore.user.username }}</span> !</p>
        <p><span class="font-bold">Email :</span> {{authStore.user.email}}</p>
        <p><span class="font-bold">Role :</span> {{idToStringRole(authStore.user.role_id)}}</p>
        <p v-if="authStore.user.teams.length"><span class="font-bold">Teams :</span> {{ authStore.user.teams.map(team => team.name).join(', ') }}</p>
    </div>
</template>