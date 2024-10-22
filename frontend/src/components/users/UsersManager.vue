<script setup lang="ts">
import { h, onMounted, reactive, ref } from "vue";
import DataTable from "@/components/data-table/DataTable.vue"
import type { ColumnDef } from "@tanstack/vue-table";
import UserModal from "@/components/users/UserModal.vue";
import { Button } from "../ui/button";
import { ArrowUpDown } from "lucide-vue-next";
import DeleteUserModal from "./DeleteUserModal.vue";
import { fetchData } from "@/services/api";

const isLoading = ref(true)

const usersData = ref<UserType[]>([])
const teamsData = ref<Object[]>([])

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

// Sample data
// const data: UserType[] = reactive([
//   {
//     id: 1,
//     username: "John Doe",
//     email: "john.doe@hotmail.com",
//     role_id: "Manager",
//     team_id: ["team A", "team B"]
//   },
//   {
//     id: 2,
//     username: "Paul Dupont",
//     email: "paul.dupont@gmail.com",
//     role_id: "Employee",
//     team_id: ["team A"]
//   },
//   {
//     id: 3,
//     username: "Alice Smith",
//     email: "alice.smith@outlook.com",
//     role_id: "Manager",
//     team_id: ["team C"]
//   },
//   {
//     id: 4,
//     username: "Liu Wei",
//     email: "liu.wei@yahoo.com",
//     role_id: "Employee",
//     team_id: ["team B", "team C"]
//   },
//   {
//     id: 5,
//     username: "Maria Rossi",
//     email: "maria.rossi@gmail.com",
//     role_id: "Manager",
//     team_id: ["team A"]
//   },
//   {
//     id: 6,
//     username: "Carlos Sanchez",
//     email: "carlos.sanchez@aol.com",
//     role_id: "Employee",
//     team_id: ["team D"]
//   },
//   {
//     id: 7,
//     username: "Emma Johnson",
//     email: "emma.johnson@hotmail.com",
//     role_id: "Employee",
//     team_id: ["team B", "team D"]
//   },
//   {
//     id: 8,
//     username: "Ahmed Ali",
//     email: "ahmed.ali@gmail.com",
//     role_id: "Manager",
//     team_id: ["team C"]
//   },
//   {
//     id: 9,
//     username: "Sophia Williams",
//     email: "sophia.williams@outlook.com",
//     role_id: "Employee",
//     team_id: ["team A", "team D"]
//   },
//   {
//     id: 10,
//     username: "David Brown",
//     email: "david.brown@gmail.com",
//     role_id: "Employee",
//     team_id: ["team B"]
//   },
//   {
//     id: 11,
//     username: "Laura Müller",
//     email: "laura.mueller@yahoo.com",
//     role_id: "Manager",
//     team_id: ["team A"]
//   },
//   {
//     id: 12,
//     username: "Mohamed Youssef",
//     email: "mohamed.youssef@outlook.com",
//     role_id: "Employee",
//     team_id: ["team C", "team D"]
//   },
//   {
//     id: 13,
//     username: "Isabella Martinez",
//     email: "isabella.martinez@gmail.com",
//     role_id: "Employee",
//     team_id: ["team A"]
//   },
//   {
//     id: 14,
//     username: "Pierre Dubois",
//     email: "pierre.dubois@hotmail.com",
//     role_id: "Manager",
//     team_id: ["team B"]
//   },
//   {
//     id: 15,
//     username: "Nina Petrova",
//     email: "nina.petrova@gmail.com",
//     role_id: "Employee",
//     team_id: ["team C"]
//   },
//   {
//     id: 16,
//     username: "Hiroshi Tanaka",
//     email: "hiroshi.tanaka@yahoo.com",
//     role_id: "Manager",
//     team_id: ["team A", "team D"]
//   },
//   {
//     id: 17,
//     username: "Emily Davis",
//     email: "emily.davis@outlook.com",
//     role_id: "Employee",
//     team_id: ["team B", "team D"]
//   },
//   {
//     id: 18,
//     username: "Lucas Gonzalez",
//     email: "lucas.gonzalez@gmail.com",
//     role_id: "Employee",
//     team_id: ["team C"]
//   },
//   {
//     id: 19,
//     username: "Giulia Bianchi",
//     email: "giulia.bianchi@hotmail.com",
//     role_id: "Manager",
//     team_id: ["team A"]
//   },
//   {
//     id: 20,
//     username: "Aiden Evans",
//     email: "aiden.evans@yahoo.com",
//     role_id: "Employee",
//     team_id: ["team D"]
//   },
//   {
//     id: 21,
//     username: "Sophie Lefevre",
//     email: "sophie.lefevre@gmail.com",
//     role_id: "Employee",
//     team_id: ["team A", "team C"]
//   },
//   {
//     id: 22,
//     username: "Oliver Wilson",
//     email: "oliver.wilson@hotmail.com",
//     role_id: "Manager",
//     team_id: ["team B", "team C"]
//   },
//   {
//     id: 23,
//     username: "Ananya Sharma",
//     email: "ananya.sharma@yahoo.com",
//     role_id: "Employee",
//     team_id: ["team D"]
//   },
//   {
//     id: 24,
//     username: "Thomas Johnson",
//     email: "thomas.johnson@gmail.com",
//     role_id: "Employee",
//     team_id: ["team A"]
//   },
//   {
//     id: 25,
//     username: "Sara Novak",
//     email: "sara.novak@hotmail.com",
//     role_id: "Manager",
//     team_id: ["team B"]
//   },
//   {
//     id: 26,
//     username: "Luis Hernandez",
//     email: "luis.hernandez@yahoo.com",
//     role_id: "Employee",
//     team_id: ["team C", "team D"]
//   },
//   {
//     id: 27,
//     username: "Anna Ivanova",
//     email: "anna.ivanova@gmail.com",
//     role_id: "Employee",
//     team_id: ["team A"]
//   },
//   {
//     id: 28,
//     username: "Michael Clark",
//     email: "michael.clark@outlook.com",
//     role_id: "Manager",
//     team_id: ["team B"]
//   },
//   {
//     id: 29,
//     username: "Julia Garcia",
//     email: "julia.garcia@gmail.com",
//     role_id: "Employee",
//     team_id: ["team D"]
//   },
//   {
//     id: 30,
//     username: "Henry Lee",
//     email: "henry.lee@hotmail.com",
//     role_id: "Employee",
//     team_id: ["team C"]
//   },
//   {
//     id: 31,
//     username: "Mia Taylor",
//     email: "mia.taylor@yahoo.com",
//     role_id: "Manager",
//     team_id: ["team A", "team B"]
//   },
//   {
//     id: 32,
//     username: "Hassan Al-Farsi",
//     email: "hassan.alfarsi@gmail.com",
//     role_id: "Employee",
//     team_id: ["team D"]
//   },
//   {
//     id: 33,
//     username: "Victoria Brown",
//     email: "victoria.brown@outlook.com",
//     role_id: "Employee",
//     team_id: ["team A"]
//   },
//   {
//     id: 34,
//     username: "Jacob Smith",
//     email: "jacob.smith@hotmail.com",
//     role_id: "Manager",
//     team_id: ["team B", "team C"]
//   },
//   {
//     id: 35,
//     username: "Carla Pereira",
//     email: "carla.pereira@gmail.com",
//     role_id: "Employee",
//     team_id: ["team D"]
//   },
//   {
//     id: 36,
//     username: "Noah Walker",
//     email: "noah.walker@yahoo.com",
//     role_id: "Employee",
//     team_id: ["team A"]
//   },
//   {
//     id: 37,
//     username: "Elena Martinez",
//     email: "elena.martinez@gmail.com",
//     role_id: "Manager",
//     team_id: ["team C"]
//   },
//   {
//     id: 38,
//     username: "Oscar White",
//     email: "oscar.white@outlook.com",
//     role_id: "Employee",
//     team_id: ["team B"]
//   },
//   {
//     id: 39,
//     username: "Hannah Kim",
//     email: "hannah.kim@hotmail.com",
//     role_id: "Employee",
//     team_id: ["team D"]
//   },
//   {
//     id: 40,
//     username: "Xiao Zhang",
//     email: "xiao.zhang@yahoo.com",
//     role_id: "Manager",
//     team_id: ["team A", "team C"]
//   },
//   {
//     id: 41,
//     username: "Sophia Taylor",
//     email: "sophia.taylor@gmail.com",
//     role_id: "Employee",
//     team_id: ["team D"]
//   },
//   {
//     id: 42,
//     username: "Liam Scott",
//     email: "liam.scott@outlook.com",
//     role_id: "Employee",
//     team_id: ["team B", "team D"]
//   },
//   {
//     id: 43,
//     username: "Maya Wilson",
//     email: "maya.wilson@hotmail.com",
//     role_id: "Manager",
//     team_id: ["team A"]
//   },
//   {
//     id: 44,
//     username: "Alejandro Lopez",
//     email: "alejandro.lopez@gmail.com",
//     role_id: "Employee",
//     team_id: ["team C"]
//   },
//   {
//     id: 45,
//     username: "Lily Cooper",
//     email: "lily.cooper@yahoo.com",
//     role_id: "Employee",
//     team_id: ["team B"]
//   },
//   {
//     id: 46,
//     username: "Ethan Baker",
//     email: "ethan.baker@hotmail.com",
//     role_id: "Manager",
//     team_id: ["team D"]
//   },
//   {
//     id: 47,
//     username: "Lucas Fisher",
//     email: "lucas.fisher@gmail.com",
//     role_id: "Employee",
//     team_id: ["team A", "team C"]
//   },
//   {
//     id: 48,
//     username: "Olivia Morgan",
//     email: "olivia.morgan@outlook.com",
//     role_id: "Employee",
//     team_id: ["team B", "team D"]
//   },
//   {
//     id: 49,
//     username: "Aaron Cook",
//     email: "aaron.cook@gmail.com",
//     role_id: "Manager",
//     team_id: ["team C"]
//   },
//   {
//     id: 50,
//     username: "Ava Sanders",
//     email: "ava.sanders@hotmail.com",
//     role_id: "Employee",
//     team_id: ["team A"]
//   }
// ]
// )

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
