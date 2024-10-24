<script setup lang="ts">
import { h, onMounted, ref } from "vue";
import DataTable from "@/components/data-table/DataTable.vue"
import type { ColumnDef } from "@tanstack/vue-table";
import UserModal from "@/components/users/UserModal.vue";
import { Button } from "../ui/button";
import { ArrowUpDown } from "lucide-vue-next";
import DeleteUserModal from "./DeleteUserModal.vue";
import { fetchData } from "@/services/api";
import { toast } from "../ui/toast/use-toast";
import { teams } from "@/lib/formSchemas/signin.form";

const isLoading = ref(true)

const usersData = ref<User[]>([])
const teamsData = ref<Team[]>([])
const emit = defineEmits(["close", "refresh"])

type User = {
    id: number
    username: string
    email: string
    role_id: number
    teams: Team[]
}

type Team = {
    id: number
    name: string
}

async function fetchUsers(){
  try {
    const response = await fetchData("GET", "/users")
    usersData.value = response.data.map(user => {
      return {
        ...user,
        role_string: idToStringRole(user.role_id),
        teams_string: user.teams.map(team => team.name).join(', ')
      }
    })
  } catch (error) {
    console.log(error)
  } finally {
    isLoading.value = false
  }
}

onMounted(async () => {
  try {
    const response = await fetchData("GET", "/teams")
    teamsData.value = response.data.data
  } catch (error) {
    console.log(error)
  }
  
  await fetchUsers()
})

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

const columns: ColumnDef<User>[] = [
  {
    accessorKey: 'username',
    header: ({ column }) => {
      return h(Button, {
        variant: 'ghost',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc'),
      }, () => ['Name', h(ArrowUpDown, { class: 'ml-2 h-4 w-4' })])
    },
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, row.getValue('username')),
  },
  {
    accessorKey: 'email',
    header: ({ column }) => {
      return h(Button, {
        variant: 'ghost',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc'),
      }, () => ['Email', h(ArrowUpDown, { class: 'ml-2 h-4 w-4' })])
    },
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, row.getValue('email')),
  },
  {
    accessorKey: 'role_string',
    header: ({ column }) => {
      return h(Button, {
        variant: 'ghost',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc'),
      }, () => ['Role', h(ArrowUpDown, { class: 'ml-2 h-4 w-4' })])
    },
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, row.getValue('role_string')),
  },
  {
    accessorKey: 'teams_string',
    header: ({ column }) => {
      return h(Button, {
        variant: 'ghost',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc'),
      }, () => ['Teams', h(ArrowUpDown, { class: 'ml-2 h-4 w-4' })])
    },
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, row.getValue('teams_string')),
  },
  {
    id: 'actions',
    enableHiding: false,
    cell: ({ row }) => {
      return h("div", { class: "flex gap-4 float-right" }, [
        h(UserModal, { mode: "update", data: row.original, teams: teamsData.value , onRefresh: fetchUsers }),
        h(
          DeleteUserModal,
          { id: row.original.id, onRefresh: fetchUsers }
        )
      ])
    }
  }
]

const filterColumns = [{column: 'username', fieldName: 'name'}, {column: 'email', fieldName: 'email'}, {column: 'role_string', fieldName: 'role'}, {column: 'teams_string', fieldName: 'team'}]

</script>

<template>
  <div class="flex flex-col gap-2 w-full">
    <div v-if="isLoading" class="flex justify-center items-center h-full">
        <p>Loading...</p>
    </div>
    
    <DataTable 
      v-else
      :columns="columns"
      :data="usersData"
      :filters="filterColumns"
      :teams="teamsData"
    />
  </div>
</template>
