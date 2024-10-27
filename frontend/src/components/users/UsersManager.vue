<script setup lang="ts">
import { h, onMounted, ref } from "vue"
import DataTable from "@/components/data-table/DataTable.vue"
import type { ColumnDef } from "@tanstack/vue-table";
import UserModal from "@/components/users/UserModal.vue";
import { Button } from "../ui/button";
import { ArrowUpDown } from "lucide-vue-next";
import DeleteUserModal from "./DeleteUserModal.vue";
import { fetchData } from "@/services/api";
import Spinner from "../Spinner.vue";
import type { User } from "@/types/api.type"
import type { Team } from "@/types/api.type"
import { useAuthStore } from "@/stores/auth.store";

const isLoading = ref(true)

const usersData = ref<User[]>([])
const teamsData = ref<Team[]>([])
const authStore = useAuthStore()

async function fetchUsers() {
  try {
    const response = await fetchData("GET", "/users")
    usersData.value = response.data.map((user: User) => {
      return {
        ...user,
        role_string: idToStringRole(user.role_id),
        teams_string: user.teams.map((team) => team.name).join(", ")
      }
    })

    if(authStore.user.role_id === 3) {
      usersData.value = usersData.value.filter(user => user.role_id !== 4 && user.role_id !== 3 && user.id !== authStore.user.id)
    }
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
        h(UserModal, {
          mode: "update",
          data: row.original,
          teams: teamsData.value,
          onRefresh: fetchUsers
        }),
        h(DeleteUserModal, { id: row.original.id})
      ])
    }
  }
]

const filterColumns = [
  { column: "username", fieldName: "name" },
  { column: "email", fieldName: "email" },
  { column: "role_string", fieldName: "role" },
  { column: "teams_string", fieldName: "team" }
]
</script>

<template>
  <div class="flex flex-col gap-2 w-full">
    <div v-if="isLoading" class="flex justify-center items-center h-full">
        <Spinner/>
    </div>
    
    <DataTable 
      v-else
      :columns="columns"
      :data="usersData"
      :filters="filterColumns"
      :teams="teamsData"
      @refresh="fetchUsers"
    />
  </div>
</template>
