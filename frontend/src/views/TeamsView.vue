<script setup lang="ts">
import TeamsManager from "@/components/teams/TeamsManager.vue"
import TeamMember from "@/components/teams/TeamMember.vue";
import { useAuthStore } from "@/stores/auth.store";

const authStore = useAuthStore()
</script>

<template>
    <TeamMember v-if="authStore.user.role_id === 2"/>
    <TeamsManager v-else />
</template>