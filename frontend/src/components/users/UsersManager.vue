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

const isLoading = ref(true)

const usersData = ref<User[]>([])
const teamsData = ref<Team[]>([])

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

async function deleteUser(id: number) {
  try {
    const response = await fetchData("DELETE", `/users/${id}`)
    if (response.status === 200) {
      toast({
          description: `User successfully deleted !`
        })
    } else {
      toast({
          description: `Failed to delete user.`,
          variant: "destructive"
        })
    }
  } catch (error) {
    toast({
        description: `Error deleting user.`,
        variant: "destructive"
      })
    console.log(error)
  }
}

async function fetchUsers(){
  try {
    // Fetch data when the component is mounted
    const response = await fetchData("GET", "/users")
    // console.log("Working times fetched successfully", response.data.data)
    usersData.value = response.data
    console.log("Users fetched successfully", usersData.value)
  } catch (error) {
    console.log(error)
  } finally {
    isLoading.value = false
  }
}

onMounted(async () => {
  try {
    // Fetch data when the component is mounted
    const response = await fetchData("GET", "/teams")
    // console.log("Working times fetched successfully", response.data.data)
    teamsData.value = response.data.data
    console.log("Teams fetched successfully", teamsData.value)
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
    accessorKey: 'role_id',
    header: ({ column }) => {
      return h(Button, {
        variant: 'ghost',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc'),
      }, () => ['Role', h(ArrowUpDown, { class: 'ml-2 h-4 w-4' })])
    },
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, idToStringRole(row.getValue('role_id'))),
  },
  {
    accessorKey: 'teams',
    header: ({ column }) => {
      return h(Button, {
        variant: 'ghost',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc'),
      }, () => ['Teams', h(ArrowUpDown, { class: 'ml-2 h-4 w-4' })])
    },
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, (row.getValue('teams') as Team[]).map(team => team.name).join(', ')),
  },
  {
    id: 'actions',
    enableHiding: false,
    cell: ({ row }) => {
      return h("div", { class: "flex gap-4 float-right" }, [
        h(UserModal, { mode: "update", data: row.original, teams: teamsData.value , onRefresh: fetchUsers }),
        h(
          DeleteUserModal,
          { id: row.original.id, function: deleteUser }
        )
      ])
    }
  }
]

const filterColumns = [{column: 'username', fieldName: 'name'}, {column: 'email', fieldName: 'email'}, {column: 'role_id', fieldName: 'role'}, {column: 'teams', fieldName: 'teams'}]


</script>

<template>
  <div v-if="isLoading" class="flex justify-center items-center h-full">
      <p>Loading...</p>
  </div>
  
  <div v-else>
    <div class="flex justify-end mb-4">
      <UserModal mode="create" :data="{}" :teams="teamsData" @refresh="fetchUsers"/>
    </div>
    <DataTable 
      :columns="columns" 
      :data="usersData" 
      :filters="filterColumns"
    />
  </div>
  
</template>
