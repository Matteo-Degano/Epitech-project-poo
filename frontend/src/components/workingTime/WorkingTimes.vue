<script setup lang="ts">
import { h, ref, onMounted, reactive } from "vue"
import { type ColumnDef } from "@tanstack/vue-table"
import { ArrowUpDown, ChevronDown } from 'lucide-vue-next'
import { Button } from "@/components/ui/button"
import { fetchData } from "@/services/api"
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

// Function to format date and time
function formatDate(dateString: string | number | Date) {
  const options = { year: 'numeric', month: '2-digit', day: 'numeric'};
  return new Date(dateString).toLocaleDateString(undefined, options);
}

function formatTime(timeString: string | number | Date) {
  const options = { hour: '2-digit', minute: '2-digit' };
  return new Date(timeString).toLocaleTimeString(undefined, options);
}

// Define the columns
const columns: ColumnDef<WorkingTimeType>[] = [
  {
    accessorKey: 'user_id',
    header: ({ column }) => {
      return h(Button, {
        variant: 'ghost',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc'),
      }, () => ['User', h(ArrowUpDown, { class: 'ml-2 h-4 w-4' })])
    },
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, row.getValue('user_id')),
  },
  {
    accessorKey: 'start',
    header: ({ column }) => {
      return h(Button, {
        variant: 'ghost',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc'),
      }, () => ['Date', h(ArrowUpDown, { class: 'ml-2 h-4 w-4' })])
    },
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, formatDate(row.getValue('start')),),
  },
  {
    accessorKey: 'start',
    header: ({ column }) => {
      return h(Button, {
        variant: 'ghost',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc'),
      }, () => ['Start Time', h(ArrowUpDown, { class: 'ml-2 h-4 w-4' })])
    },
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, formatTime(row.getValue('start'))),
  },
  {
    accessorKey: 'end',
    header: ({ column }) => {
      return h(Button, {
        variant: 'ghost',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc'),
      }, () => ['End Time', h(ArrowUpDown, { class: 'ml-2 h-4 w-4' })])
    },
    cell: ({ row }) => h('div', { class: 'text-left font-medium' }, formatTime(row.getValue('end'))),
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

    <div v-if="isLoading" class="flex justify-center items-center h-full">
      <p>Loading...</p>
    </div>
    <DataTable v-else :columns="columns" :data="workingTimeData" :filters="filterColumns"/>
  </div>
</template>
