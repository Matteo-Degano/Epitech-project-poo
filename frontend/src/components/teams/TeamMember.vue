<script setup lang="ts">
import { fetchData } from '@/services/api';
import { h, defineEmits, ref, onMounted } from 'vue';
import type { User } from "@/types/api.type"
import Spinner from '../Spinner.vue';
import DataTable from "@/components/data-table/DataTable.vue"
import type { ColumnDef } from "@tanstack/vue-table";
import { Button } from '../ui/button';
import { ArrowUpDown } from 'lucide-vue-next';
import { useAuthStore } from "@/stores/auth.store";
import RemoveFromTeam from './RemoveFromTeam.vue';


const isLoading = ref(true)
const authStore = useAuthStore()
const teamMembers = ref<User[]>([])
const emit = defineEmits(["close", "refresh"])

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

async function fetchUsers() {
    try {
        const response = await fetchData("GET", "/users");

        const teamMembersMap = authStore.user.teams.reduce((acc, team) => {
            acc[team.id] = {id: team.id, name: team.name, members: [] };
            return acc;
        }, {} as Record<number, { name: string, members: User[] }>);

        response.data.forEach((user: User) => {
            const isMemberOfTeam = authStore.user.teams.some(authTeam =>
                user.teams.some(userTeam => userTeam.id === authTeam.id) && user.role_id === 1
            );

            if (isMemberOfTeam) {
                user.role_string = idToStringRole(user.role_id);
                user.teams_string = user.teams.map((team) => team.name).join(", ");

                user.teams.forEach(team => {
                    if (teamMembersMap[team.id]) {
                        teamMembersMap[team.id].members.push(user);
                    }
                });
            }
        });

        teamMembers.value = Object.values(teamMembersMap);
    } catch (error) {
        console.log("Error fetching users:", error);
    }
}

onMounted (async () => {
    await fetchUsers()
    isLoading.value = false
})

const columns = (id): ColumnDef<User>[] => [
    {
        accessorKey: "username",
        header: ({ column }) => {
            return h(
            Button,
            {
                variant: "ghost",
                onClick: () => column.toggleSorting(column.getIsSorted() === "asc")
            },
            () => ["Name", h(ArrowUpDown, { class: "ml-2 h-4 w-4" })]
            )
        },
        cell: ({ row }) => h("div", { class: "text-left font-medium" }, row.getValue("username"))
    },
    {
        accessorKey: "email",
        header: ({ column }) => {
            return h(
            Button,
            {
                variant: "ghost",
                onClick: () => column.toggleSorting(column.getIsSorted() === "asc")
            },
            () => ["Email", h(ArrowUpDown, { class: "ml-2 h-4 w-4" })]
            )
        },
        cell: ({ row }) => h("div", { class: "text-left font-medium" }, row.getValue("email"))
    },
    {
        accessorKey: "role_string",
        header: ({ column }) => {
            return h(
            Button,
            {
                variant: "ghost",
                onClick: () => column.toggleSorting(column.getIsSorted() === "asc")
            },
            () => ["Role", h(ArrowUpDown, { class: "ml-2 h-4 w-4" })]
            )
        },
        cell: ({ row }) => h("div", { class: "text-left font-medium" }, row.getValue("role_string"))
    },
    {
        accessorKey: "teams_string",
        header: ({ column }) => {
            return h(
            Button,
            {
                variant: "ghost",
                onClick: () => column.toggleSorting(column.getIsSorted() === "asc")
            },
            () => ["Teams", h(ArrowUpDown, { class: "ml-2 h-4 w-4" })]
            )
        },
        cell: ({ row }) => h("div", { class: "text-left font-medium" }, row.getValue("teams_string"))
    },
    {
        id: "actions",
        enableHiding: false,
        cell: ({ row }) => {
            return h("div", { class: "flex gap-4 float-right" }, [
                h(RemoveFromTeam, { teamId: id, user: row.original, onRefresh: fetchUsers })
            ]);
        }
    }
]
    
const filterColumns = [
    { column: "username", fieldName: "Name" }, 
    { column: "email", fieldName: "Email" }, 
    { column: "role_string", fieldName: "Role" }
]

    console.log(teamMembers)
</script>

<template>
    <div @refresh="fetchUsers">
        <div v-if="isLoading" class="flex justify-center items-center h-full">
            <Spinner />
        </div>

        <div v-else class="flex flex-col gap-4 w-full">
            <div v-for="team in teamMembers" :key="team.name" class="flex flex-col gap-2 w-full">
                <h2 class="text-xl font-semibold mb-4">{{ team.name }} Team</h2>
                <DataTable :columns="columns(team.id)" :data="team.members" :filters="filterColumns" @refresh="fetchUsers" :teamId="team.id"/>
            </div>
        </div>
    </div>
</template>