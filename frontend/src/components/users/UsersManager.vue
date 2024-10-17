<script setup lang="ts">
import { h, reactive } from "vue";
import DataTable from "@/components/data-table/DataTable.vue"
import type { ColumnDef } from "@tanstack/vue-table";
import UserModal from "@/components/users/UserModal.vue";

type UserType = {
    id: number
    username: string
    email: string
    role_id: number
    team_id: number[]
}

// Sample data
const data: UserType[] = reactive([
  {
    id: 1,
    username: "John Doe",
    email: "john.doe@mail.com",
    role_id: 1,
    team_id: [1, 2]
  },
  {
    id: 2,
    username: "Paul Dupont",
    email: "paul.dupont@mail.com",
    role_id: 2,
    team_id: [2]
  }
])

const columns: ColumnDef<UserType>[] = [
  {
    accessorKey: 'username',
    header: () => h('div', { class: 'text-left' }, 'Name'),
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, row.getValue('username')),
  },
  {
    accessorKey: 'email',
    header: () => h('div', { class: 'text-left' }, 'Email'),
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, row.getValue('email')),
  },
  {
    accessorKey: 'role_id',
    header: () => h('div', { class: 'text-left' }, 'Role'),
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, row.getValue('role_id')),
  },
  {
    accessorKey: 'team_id',
    header: () => h('div', { class: 'text-left' }, 'Teams'),
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, (row.getValue('team_id') as number[]).join(", ")),
  },
  {
    id: 'actions',
    enableHiding: false,
    cell: ({ row }) => {
      return h('div', { class: 'relative' }, h(UserModal, { data : row.original, mode: 'update' }))
    }
  }
]

</script>

<template>
  <h1>Users</h1>
    <DataTable :columns="columns" :data="data"/>
</template>
