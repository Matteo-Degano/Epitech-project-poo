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
    <div class="border-primary border-2 rounded p-4 w-1/3">
        <p>User : {{authStore.user.username}}</p>
        <p>Email : {{authStore.user.email}}</p>
        <p>Role : {{idToStringRole(authStore.user.role_id)}}</p>
        <p v-if="authStore.user.teams.length">Teams : {{ authStore.user.teams.map(team => team.name).join(', ') }}</p>
    </div>
</template>