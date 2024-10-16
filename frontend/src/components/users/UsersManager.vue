<script setup lang="ts">
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from "@/components/ui/table"
import { reactive } from "vue";
import UserModal from "@/components/users/UserModal.vue"


type UserType = {
    id: number
    username: string
    email: string
    role: string
    teams: string[]
}

// Sample data
const data: UserType[] = reactive([
  {
    id: 1,
    username: "John Doe",
    email: "john.doe@mail.com",
    role: "Admin",
    teams: ["Team A", "Team B"]
  },
  {
    id: 2,
    username: "Paul Dupont",
    email: "paul.dupont@mail.com",
    role: "Employee",
    teams: ["Team B"]
  }
])

</script>

<template>
  <h1>Users</h1>
    <Table>
        <TableHeader>
            <TableRow>
                <TableHead>Username</TableHead>
                <TableHead>Email</TableHead>
                <TableHead>Role</TableHead>
                <TableHead>Teams</TableHead>
                <TableHead>Actions</TableHead>
            </TableRow>
        </TableHeader>
        <TableBody>
            <TableRow v-for="user in data" :key="user.id">
                <TableCell>{{ user.username }}</TableCell>
                <TableCell>{{ user.email }}</TableCell>
                <TableCell>{{ user.role }}</TableCell>
                <TableCell>{{ user.teams.join(", ") }}</TableCell>
                <TableCell>
                    <UserModal mode="update" :data="user"/>
                </TableCell>
            </TableRow>
        </TableBody>
    </Table>
</template>
