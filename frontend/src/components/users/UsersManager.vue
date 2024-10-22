<script setup lang="ts">
import { h, onMounted, ref } from "vue";
import DataTable from "@/components/data-table/DataTable.vue"
import type { ColumnDef } from "@tanstack/vue-table";
import UserModal from "@/components/users/UserModal.vue";
import { Button } from "../ui/button";
import { ArrowUpDown } from "lucide-vue-next";
import DeleteUserModal from "./DeleteUserModal.vue";
import { fetchData } from "@/services/api";

const isLoading = ref(true)

const usersData = ref<UserType[]>([])
const teamsData = ref<TeamType[]>([])

type UserType = {
    id: number
    username: string
    email: string
    role: string
}

type TeamType = {
    id: number
    name: string
}

function deleteUser(id: number) {
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

  try {
    // Fetch data when the component is mounted
    const response = await fetchData("GET", "/users")
    // console.log("Working times fetched successfully", response.data.data)
    usersData.value = response.data.data
    console.log("Users fetched successfully", usersData.value)
  } catch (error) {
    console.log(error)
  } finally {
    isLoading.value = false
  }
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

const columns: ColumnDef<UserType>[] = [
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
    accessorKey: 'role',
    header: ({ column }) => {
      return h(Button, {
        variant: 'ghost',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc'),
      }, () => ['Role', h(ArrowUpDown, { class: 'ml-2 h-4 w-4' })])
    },
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, idToStringRole(row.getValue('role'))),
  },
  // {
  //   accessorKey: 'team_id',
  //   header: ({ column }) => {
  //     return h(Button, {
  //       variant: 'ghost',
  //       onClick: () => column.toggleSorting(column.getIsSorted() === 'asc'),
  //     }, () => ['Teams', h(ArrowUpDown, { class: 'ml-2 h-4 w-4' })])
  //   },
  //   cell: ({ row }) => h('div', { class: 'text-left font-medium' }, (row.getValue('team_id') as string[]).join(", ")),
  // },
  {
    id: 'actions',
    enableHiding: false,
    cell: ({ row }) => {
      return h("div", { class: "flex gap-4" }, [
        h(UserModal, { mode: "update", data: row.original }),
        h(
          DeleteUserModal,
          { id: row.original.id, function: deleteUser }
        )
      ])
    }
  }
]

const filterColumns = [{column: 'username', fieldName: 'name'}, {column: 'email', fieldName: 'email'}, {column: 'role', fieldName: 'role'}]


</script>

<template>
  <div v-if="isLoading" class="flex justify-center items-center h-full">
      <p>Loading...</p>
  </div>
  
  <div v-else>
    <div class="flex justify-end mb-4">
      <UserModal mode="create" :data="{}" :teams="teamsData"/>
    </div>
    <DataTable :columns="columns" :data="usersData" :filters="filterColumns"/>
  </div>
  
</template>
