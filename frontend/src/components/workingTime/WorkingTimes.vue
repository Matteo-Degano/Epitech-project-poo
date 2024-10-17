<script setup lang="ts">
import { h, ref, onMounted, reactive } from "vue"
import {
  createColumnHelper,
  getCoreRowModel,
  useVueTable,
  getSortedRowModel,
  type ColumnDef
} from "@tanstack/vue-table"
import { Button } from "@/components/ui/button"
import { fetchData } from "@/services/api"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from "@/components/ui/table"
import WorkingTime from "./WorkingTime.vue"
import DeleteWorkingTimeModal from "./DeleteWorkingTimeModal.vue"
import DataTable from "@/components/data-table/DataTable.vue"
import { useAuthStore } from "@/stores/auth.store"

const authStore = useAuthStore()
const workingTimeData = ref<WorkingTimeType[]>([]) // Ensure it's an array
const isLoading = ref(true)
const error = ref(null)

// Define the structure of your working time
type WorkingTimeType = {
  id: number
  start: string
  end: string
  user_id: number
}

// Define the columns
const columns: ColumnDef<WorkingTimeType>[] = [
  {
    accessorKey: 'user_id',
    header: () => h('div', { class: 'text-left' }, 'User'),
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, row.getValue('user_id')),
  },
  {
    accessorKey: 'start',
    header: () => h('div', { class: 'text-left' }, 'Start Time'),
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, row.getValue('start')),
  },
  {
    accessorKey: 'end',
    header: () => h('div', { class: 'text-left' }, 'End Time'),
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, row.getValue('end')),
  },
  {
    id: 'actions',
    enableHiding: false,
    cell: ({ row }) => {
      return h("div", { class: "flex gap-2" }, [
        h(WorkingTime, { mode: "update", data: row.original }),
        h(
          DeleteWorkingTimeModal,
          { workingTime: row.original, function: deleteWorkingTime }
        )
      ])
    }
  }
]

// Sample data
const data: WorkingTimeType[] = reactive([
  {
    id: 3,
    start: "2024-10-11T09:30:00",
    end: "2024-10-11T17:30:00",
    user_id: 1
  },
  {
    id: 28,
    start: "2024-10-11T09:30:00",
    end: "2024-10-11T17:30:00",
    user_id: 2
  }
])

const filterColumns = [{column: 'start', fieldName: 'start time'}, {column: 'end', fieldName: 'end time'}]

// Function to handle working time deletion
async function deleteWorkingTime(id: number) {
  try {
    const response = await fetchData("DELETE", `/workingtime/${id}`)
    if (response.status === 200) {
      console.log("Working time deleted successfully")
      const index = workingTimeData.value.findIndex((item) => item.id === id)
      if (index !== -1) workingTimeData.value.splice(index, 1)
    } else {
      console.error("Failed to delete working time")
    }
  } catch (error) {
    console.error("Error deleting working time", error)
  }
}

onMounted(async () => {
  try {
    // Fetch data when the component is mounted
    const response = await fetchData("GET", `/workingtime/${authStore.user.id}`)
    console.log("Working times fetched successfully", response.data.data)
    workingTimeData.value = response.data.data
    console.log("Working times fetched successfully", workingTimeData.value)
  } catch (err) {
    error.value = err.message || "Error fetching data"
  } finally {
    isLoading.value = false
  }
})
</script>

<template>
  <div class="w-full">
    <!-- Add Create button at the top -->
    <div class="flex justify-end mb-4">
      <WorkingTime :mode="'create'" :workingTimeData="null" />
    </div>

    <DataTable :columns="columns" :data="data" :filters="filterColumns"/>
  </div>
</template>
